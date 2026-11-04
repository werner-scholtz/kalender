// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// Records a snapshot of the package's usage for today's UTC date in usage.json.
//
// Usage: dart run tool/usage_metrics.dart <path to usage.json>
//
// Reads the pub.dev score, the GitHub repository and its open issue and pull request counts. With TRAFFIC_TOKEN set it
// also reads the GitHub views and clones of the last 14 days, which need a token with push access. GITHUB_TOKEN, when
// set, authenticates the other GitHub requests.
//
// A snapshot replaces the fields of one already recorded for the same day, and traffic is merged by day, the latest
// read winning. A source that cannot be read is left out and keeps what an earlier run that day recorded. The script
// fails only when no source could be read. A missing or empty file starts an empty history.
//
// The file has this shape:
//
//   {
//     "snapshots": [
//       {
//         "date": "2026-11-04",
//         "pub": {"likes": 189, "points": 160, "maxPoints": 160, "downloads30Days": 21944},
//         "github": {"stars": 185, "forks": 71, "watchers": 4, "openIssues": 11, "openPullRequests": 4}
//       }
//     ],
//     "traffic": {
//       "views": {"2026-11-03": {"count": 31, "uniques": 25}},
//       "clones": {"2026-11-03": {"count": 12, "uniques": 8}}
//     }
//   }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

const _repository = 'werner-scholtz/kalender';

const _trafficKinds = ['views', 'clones'];

/// The usage history in [content], or an empty one when [content] is blank.
Map<String, Object?> parseUsage(String content) {
  final json = content.trim().isEmpty ? const <String, Object?>{} : jsonDecode(content) as Map<String, Object?>;
  final traffic = (json['traffic'] as Map<String, Object?>?) ?? const {};
  return {
    'snapshots': [...(json['snapshots'] as List<Object?>?) ?? const []],
    'traffic': {for (final kind in traffic.keys) kind: Map<String, Object?>.of(traffic[kind]! as Map<String, Object?>)},
  };
}

/// [usage] as written to usage.json.
String encodeUsage(Map<String, Object?> usage) => '${const JsonEncoder.withIndent('  ').convert(usage)}\n';

/// The `YYYY-MM-DD` date of [time] in UTC.
String utcDate(DateTime time) => time.toUtc().toIso8601String().substring(0, 10);

/// The `pub` fields of a snapshot from the response of `pub.dev/api/packages/<name>/score`.
Map<String, int> parseScore(Object? json) {
  if (json case {
    'likeCount': final int likes,
    'grantedPoints': final int points,
    'maxPoints': final int maxPoints,
    'downloadCount30Days': final int downloads,
  }) {
    return {'likes': likes, 'points': points, 'maxPoints': maxPoints, 'downloads30Days': downloads};
  }
  throw FormatException('Unexpected pub.dev score: $json');
}

/// The `stars`, `forks` and `watchers` fields of a snapshot from the response of `api.github.com/repos/<repo>`.
Map<String, int> parseRepository(Object? json) {
  if (json case {
    'stargazers_count': final int stars,
    'forks_count': final int forks,
    'subscribers_count': final int watchers,
  }) {
    return {'stars': stars, 'forks': forks, 'watchers': watchers};
  }
  throw FormatException('Unexpected GitHub repository: $json');
}

/// The number of results in a response of the GitHub search API.
int parseSearchCount(Object? json) {
  if (json case {'total_count': final int count}) return count;
  throw FormatException('Unexpected GitHub search result: $json');
}

/// The days in a response of `traffic/views` or `traffic/clones`, keyed by UTC date.
Map<String, Map<String, int>> parseTraffic(Object? json, String kind) {
  final days = json is Map<String, Object?> ? json[kind] : null;
  if (days is! List<Object?>) throw FormatException('Unexpected GitHub $kind: $json');
  return Map.fromEntries(
    days.map(
      (day) => switch (day) {
        {'timestamp': final String timestamp, 'count': final int count, 'uniques': final int uniques} => MapEntry(
          utcDate(DateTime.parse(timestamp)),
          {'count': count, 'uniques': uniques},
        ),
        _ => throw FormatException('Unexpected GitHub $kind day: $day'),
      },
    ),
  );
}

/// A snapshot for [date] holding the sources that were read, or null when none was.
Map<String, Object?>? snapshot(
  String date, {
  Map<String, int>? pub,
  Map<String, int>? repository,
  int? openIssues,
  int? openPullRequests,
}) {
  final github = {
    ...?repository,
    if (openIssues != null) 'openIssues': openIssues,
    if (openPullRequests != null) 'openPullRequests': openPullRequests,
  };
  if (pub == null && github.isEmpty) return null;
  return {'date': date, if (pub != null) 'pub': pub, if (github.isNotEmpty) 'github': github};
}

/// [usage] with [entry] added in date order, its fields replacing those of a snapshot for the same date.
Map<String, Object?> withSnapshot(Map<String, Object?> usage, Map<String, Object?> entry) {
  final snapshots = [...(usage['snapshots']! as List<Object?>).cast<Map<String, Object?>>()];
  final index = snapshots.indexWhere((s) => s['date'] == entry['date']);
  if (index == -1) {
    snapshots
      ..add(entry)
      ..sort((a, b) => (a['date']! as String).compareTo(b['date']! as String));
  } else {
    final merged = Map<String, Object?>.of(snapshots[index]);
    entry.forEach((key, value) {
      final old = merged[key];
      merged[key] = old is Map<String, Object?> && value is Map<String, Object?> ? {...old, ...value} : value;
    });
    snapshots[index] = merged;
  }
  return {...usage, 'snapshots': snapshots};
}

/// [usage] with the [days] of a traffic [kind] merged in, a day in [days] replacing the stored one.
Map<String, Object?> withTraffic(Map<String, Object?> usage, String kind, Map<String, Map<String, int>> days) {
  final traffic = Map<String, Object?>.of(usage['traffic']! as Map<String, Object?>);
  final merged = {...?traffic[kind] as Map<String, Object?>?, ...days};
  traffic[kind] = {for (final day in merged.keys.toList()..sort()) day: merged[day]};
  return {...usage, 'traffic': traffic};
}

Future<Object?> _getJson(HttpClient client, String url, {String? token}) async {
  final request = await client.getUrl(Uri.parse(url));
  request.headers.set(HttpHeaders.acceptHeader, 'application/json');
  if (token != null) request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  if (response.statusCode != HttpStatus.ok) throw HttpException('${response.statusCode} ${response.reasonPhrase}');
  return jsonDecode(body);
}

/// The result of [read], or null with a note when it fails.
Future<T?> _attempt<T>(String what, Future<T> Function() read) async {
  try {
    final value = await read().timeout(const Duration(minutes: 1));
    stdout.writeln('Read $what.');
    return value;
  } on Object catch (error) {
    stderr.writeln('Could not read $what: $error');
    return null;
  }
}

String? _env(String name) {
  final value = Platform.environment[name];
  return value == null || value.isEmpty ? null : value;
}

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run tool/usage_metrics.dart <path to usage.json>');
    exit(64);
  }
  final file = File(args.single);
  var usage = parseUsage(file.existsSync() ? file.readAsStringSync() : '');

  final client = HttpClient()..connectionTimeout = const Duration(seconds: 30);
  final githubToken = _env('GITHUB_TOKEN');
  final trafficToken = _env('TRAFFIC_TOKEN');
  const github = 'https://api.github.com';
  Future<Object?> getGitHub(String path, {String? token}) => _getJson(client, '$github/$path', token: token);
  Future<int> openCount(String type) async => parseSearchCount(
    await getGitHub('search/issues?q=repo:$_repository+is:$type+is:open&per_page=1', token: githubToken),
  );

  final pub = await _attempt(
    'the pub.dev score',
    () async => parseScore(await _getJson(client, 'https://pub.dev/api/packages/kalender/score')),
  );
  final repository = await _attempt(
    'the GitHub repository',
    () async => parseRepository(await getGitHub('repos/$_repository', token: githubToken)),
  );
  final openIssues = await _attempt('the open issues', () => openCount('issue'));
  final openPullRequests = await _attempt('the open pull requests', () => openCount('pr'));

  final today = snapshot(
    utcDate(DateTime.now()),
    pub: pub,
    repository: repository,
    openIssues: openIssues,
    openPullRequests: openPullRequests,
  );
  var read = today != null;
  if (today != null) usage = withSnapshot(usage, today);

  if (trafficToken == null) {
    stdout.writeln('TRAFFIC_TOKEN is not set, so views and clones are not read.');
  } else {
    for (final kind in _trafficKinds) {
      final days = await _attempt(
        'the GitHub $kind',
        () async => parseTraffic(await getGitHub('repos/$_repository/traffic/$kind', token: trafficToken), kind),
      );
      if (days == null) continue;
      read = true;
      usage = withTraffic(usage, kind, days);
    }
  }
  client.close();

  if (!read) {
    stderr.writeln('No source could be read, so ${file.path} is unchanged.');
    exit(1);
  }
  file.writeAsStringSync(encodeUsage(usage));
  stdout.writeln('Wrote ${file.path}.');
}
