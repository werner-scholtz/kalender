// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/usage_metrics.dart'
    show
        encodeUsage,
        parseRepository,
        parseScore,
        parseSearchCount,
        parseTraffic,
        parseUsage,
        snapshot,
        utcDate,
        withSnapshot,
        withTraffic;

void main() {
  const pub = {'likes': 189, 'points': 160, 'maxPoints': 160, 'downloads30Days': 21944};
  const repository = {'stars': 185, 'forks': 71, 'watchers': 4};

  group('parse', () {
    test('parseScore reads the pub.dev score', () {
      final json = jsonDecode(
        '{"grantedPoints":160,"maxPoints":160,"likeCount":189,"downloadCount30Days":21944,"tags":["sdk:flutter"]}',
      );
      expect(parseScore(json), pub);
    });

    test('parseRepository reads the GitHub repository', () {
      final json = jsonDecode(
        '{"stargazers_count":185,"forks_count":71,"open_issues_count":15,"subscribers_count":4,"watchers_count":185}',
      );
      expect(parseRepository(json), repository);
    });

    test('parseSearchCount reads the total count', () {
      expect(parseSearchCount(jsonDecode('{"total_count":11,"incomplete_results":false,"items":[]}')), 11);
    });

    test('parseTraffic keys the days by UTC date', () {
      final json = jsonDecode(
        '{"count":43,"uniques":33,"views":['
        '{"timestamp":"2026-11-02T00:00:00Z","count":12,"uniques":8},'
        '{"timestamp":"2026-11-03T00:00:00Z","count":31,"uniques":25}]}',
      );
      expect(parseTraffic(json, 'views'), {
        '2026-11-02': {'count': 12, 'uniques': 8},
        '2026-11-03': {'count': 31, 'uniques': 25},
      });
    });

    final unexpected = <String, void Function()>{
      'parseScore': () => parseScore(jsonDecode('{"likeCount":189}')),
      'parseRepository': () => parseRepository(jsonDecode('{"message":"API rate limit exceeded"}')),
      'parseSearchCount': () => parseSearchCount(jsonDecode('{"message":"Validation Failed"}')),
      'parseTraffic': () => parseTraffic(jsonDecode('{"clones":[]}'), 'views'),
      'parseTraffic on a day': () => parseTraffic(jsonDecode('{"views":[{"count":1}]}'), 'views'),
    };
    for (final MapEntry(key: name, value: parse) in unexpected.entries) {
      test('$name throws on an unexpected response', () {
        expect(parse, throwsFormatException);
      });
    }
  });

  group('parseUsage', () {
    test('a blank file is an empty history', () {
      expect(parseUsage(''), {'snapshots': <Object?>[], 'traffic': <String, Object?>{}});
    });

    test('reads back what encodeUsage writes', () {
      final usage = withTraffic(withSnapshot(parseUsage(''), snapshot('2026-11-04', pub: pub)!), 'views', {
        '2026-11-03': {'count': 31, 'uniques': 25},
      });
      expect(parseUsage(encodeUsage(usage)), usage);
    });
  });

  test('utcDate is the date in UTC', () {
    expect(utcDate(DateTime.parse('2026-11-04T23:30:00-02:00')), '2026-11-05');
  });

  group('snapshot', () {
    test('holds every source that was read', () {
      expect(snapshot('2026-11-04', pub: pub, repository: repository, openIssues: 11, openPullRequests: 4), {
        'date': '2026-11-04',
        'pub': pub,
        'github': {...repository, 'openIssues': 11, 'openPullRequests': 4},
      });
    });

    test('leaves out a source that was not read', () {
      expect(snapshot('2026-11-04', openIssues: 11), {
        'date': '2026-11-04',
        'github': {'openIssues': 11},
      });
    });

    test('is null when nothing was read', () {
      expect(snapshot('2026-11-04'), isNull);
    });
  });

  group('withSnapshot', () {
    final first = snapshot('2026-11-03', pub: pub)!;

    test('adds a new day in date order', () {
      final second = snapshot('2026-11-04', pub: pub)!;
      final earlier = snapshot('2026-11-02', pub: pub)!;
      final usage = withSnapshot(withSnapshot(withSnapshot(parseUsage(''), first), second), earlier);
      expect(usage['snapshots'], [earlier, first, second]);
    });

    test('replaces the fields of a snapshot for the same day', () {
      final rerun = snapshot('2026-11-03', pub: {...pub, 'likes': 190}, repository: repository)!;
      expect(withSnapshot(withSnapshot(parseUsage(''), first), rerun)['snapshots'], [rerun]);
    });

    test('keeps a source that a rerun on the same day could not read', () {
      final full = snapshot('2026-11-03', pub: pub, repository: repository, openIssues: 11)!;
      final rerun = snapshot('2026-11-03', openIssues: 12)!;
      expect(withSnapshot(withSnapshot(parseUsage(''), full), rerun)['snapshots'], [
        {
          'date': '2026-11-03',
          'pub': pub,
          'github': {...repository, 'openIssues': 12},
        },
      ]);
    });
  });

  group('withTraffic', () {
    test('merges the days, a new read replacing a stored day', () {
      final stored = withTraffic(parseUsage(''), 'views', {
        '2026-11-02': {'count': 12, 'uniques': 8},
        '2026-11-03': {'count': 5, 'uniques': 4},
      });
      final usage = withTraffic(stored, 'views', {
        '2026-11-03': {'count': 31, 'uniques': 25},
        '2026-11-04': {'count': 2, 'uniques': 2},
      });
      expect(usage['traffic'], {
        'views': {
          '2026-11-02': {'count': 12, 'uniques': 8},
          '2026-11-03': {'count': 31, 'uniques': 25},
          '2026-11-04': {'count': 2, 'uniques': 2},
        },
      });
    });

    test('leaves today out', () {
      final usage = withTraffic(parseUsage(''), 'views', {
        '2026-11-03': {'count': 31, 'uniques': 25},
        '2026-11-04': {'count': 2, 'uniques': 2},
      }, today: '2026-11-04');
      expect(usage['traffic'], {
        'views': {
          '2026-11-03': {'count': 31, 'uniques': 25},
        },
      });
    });

    test('keeps the other kind', () {
      final views = {
        '2026-11-03': {'count': 31, 'uniques': 25},
      };
      final clones = {
        '2026-11-03': {'count': 12, 'uniques': 8},
      };
      final usage = withTraffic(withTraffic(parseUsage(''), 'views', views), 'clones', clones);
      expect(usage['traffic'], {'views': views, 'clones': clones});
    });

    test('keeps the snapshots', () {
      final usage = withSnapshot(parseUsage(''), snapshot('2026-11-04', pub: pub)!);
      expect(withTraffic(usage, 'views', {})['snapshots'], usage['snapshots']);
    });
  });
}
