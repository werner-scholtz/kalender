#!/usr/bin/env dart
// Replicates the GitHub Actions timezone matrix locally.
// Usage (from the repo root):
//   dart tool/test_timezones.dart [flutter-test-args...]
//
// Examples:
//   dart tool/test_timezones.dart
//   dart tool/test_timezones.dart test/extensions/internal_date_time_test.dart
//   dart tool/test_timezones.dart --name "startOfDay"
// ignore_for_file: avoid_print

import 'dart:io';

/// Mirrors the timezone matrix in .github/workflows/flutter_analyze_and_test.yml
const _timezones = [
  'America/New_York',
  'Europe/London',
  'Asia/Tokyo',
  'Australia/Sydney',
  'Africa/Johannesburg',
  'UTC',
];

const _reset = '\x1B[0m';
const _bold = '\x1B[1m';
const _green = '\x1B[32m';
const _red = '\x1B[31m';
const _cyan = '\x1B[36m';

void main(List<String> args) async {
  final results = <String, bool>{};
  final projectRoot = _findProjectRoot();

  print('${_bold}Running flutter test across ${_timezones.length} timezones$_reset');
  print('Project root: $projectRoot\n');

  for (final tz in _timezones) {
    final childNow = await _probeDateTime(tz);
    stdout.write('$_cyan=== $tz — $childNow ===$_reset\n');

    final process = await Process.start(
      'flutter',
      ['test', ...args],
      workingDirectory: projectRoot,
      environment: {...Platform.environment, 'TZ': tz},
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await process.exitCode;
    results[tz] = exitCode == 0;
    print('');
  }

  // ── Summary ────────────────────────────────────────────────────────────────
  print('$_bold── Summary ─────────────────────────────────────────────$_reset');
  var allPassed = true;
  for (final entry in results.entries) {
    final icon = entry.value ? '${_green}PASS$_reset' : '${_red}FAIL$_reset';
    print('  $icon  ${entry.key}');
    if (!entry.value) allPassed = false;
  }
  print('');

  if (allPassed) {
    print('$_green${_bold}All timezones passed.$_reset');
    exit(0);
  } else {
    print('$_red${_bold}One or more timezones failed.$_reset');
    exit(1);
  }
}

/// Walks up from the script location until it finds a pubspec.yaml.
String _findProjectRoot() {
  var dir = File(Platform.script.toFilePath()).parent;
  while (!File('${dir.path}/pubspec.yaml').existsSync()) {
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError('Could not find pubspec.yaml above ${Platform.script}');
    }
    dir = parent;
  }
  return dir.path;
}

/// Spawns the system `date` command with [tz] injected as the TZ environment
/// variable, confirming the clock the child `flutter test` process will see.
Future<String> _probeDateTime(String tz) async {
  final result = await Process.run(
    'date',
    [],
    environment: {...Platform.environment, 'TZ': tz},
  );
  return (result.stdout as String).trim();
}
