#!/usr/bin/env dart

// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// Runs the checks CI runs, selected by what changed.
//
// Usage: dart tool/check.dart [--quick | --full] [--base <ref>] [--list]
//
// Without a mode the steps every change needs run, plus the ones selected by the files changed since the merge base
// with origin/main. --quick runs only the first set. --full runs every step. --list prints the selection and stops.
// --base compares against another ref.
//
// The Flutter SDK named in .fvmrc is used when fvm has it installed, since the formatter output depends on the version.
// Runs on Linux and macOS. The timezone matrix and the profiling harness need Linux, the harness also a display.

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/// Which steps run.
enum Mode { quick, changed, full }

/// What the machine can run.
typedef Host = ({bool linux, bool display});

/// A check, and the paths that select it. A path ending in `/` matches a folder, any other path matches one file.
class Step {
  const Step(this.id, this.description, {this.always = false, this.paths = const [], this.supersedes});

  final String id;
  final String description;

  /// Runs in every mode.
  final bool always;

  final List<String> paths;

  /// The id of the step this one replaces when both are selected.
  final String? supersedes;

  @override
  String toString() => id;
}

/// The examples `analyze_examples.yml` checks. `doc_snippets` is covered by the snippets step.
const examples = [
  'example',
  'advanced_example',
  'recurrence',
  'riverpod',
  'ics',
  'intl4x',
  'material_ui',
  'web_demo',
  'testing',
];

/// What every step that compiles the package depends on.
const _package = ['lib/', 'pubspec.yaml', '.fvmrc'];

/// The steps in the order they run.
final steps = <Step>[
  const Step('pub', 'flutter pub get', always: true),
  const Step('format', 'dart format on the package, tools, benchmarks and fix fixtures', always: true),
  const Step('license', 'license headers', always: true),
  const Step('analyze', 'dart analyze and flutter analyze', always: true),
  const Step('test', 'flutter test in the device timezone', always: true),
  const Step('timezones', 'flutter test in the CI timezone matrix', paths: [..._package, 'test/'], supersedes: 'test'),
  const Step('fixes', 'dart fix fixtures', paths: [..._package, 'test_fixes/']),
  const Step(
    'snippets',
    'the documentation snippets compile',
    paths: [
      ..._package,
      'doc/',
      'README.md',
      'example/README.md',
      'examples/doc_snippets/',
      'tool/analyze_doc_snippets.dart',
    ],
  ),
  const Step('benchmarks', 'the micro-benchmarks run', paths: [..._package, 'benchmark/']),
  for (final name in examples)
    Step(
      'example:$name',
      'examples/$name formats, analyzes and tests',
      paths: [..._package, 'examples/$name/', '.github/workflows/analyze_examples.yml'],
    ),
  const Step(
    'profile',
    'the frame profiling harness runs once on Linux desktop',
    paths: [..._package, 'examples/testing/', 'benchmark/'],
  ),
  const Step('web', 'the web demo builds for wasm', paths: ['examples/web_demo/', '.github/workflows/site.yml']),
];

/// Whether [path] is under one of [patterns].
bool selects(String path, List<String> patterns) =>
    patterns.any((pattern) => pattern.endsWith('/') ? path.startsWith(pattern) : path == pattern);

/// A selected step and why.
typedef Selection = ({Step step, String reason, String? skipped});

/// The steps [mode] runs for [changed] on [host], in order, with the paths that selected each one.
List<Selection> select(Mode mode, Iterable<String> changed, Host host) {
  final selected = <Selection>[];
  for (final step in steps) {
    final String reason;
    if (step.always) {
      reason = 'every change';
    } else if (mode == Mode.full) {
      reason = 'full';
    } else if (mode == Mode.changed) {
      final paths = changed.where((path) => selects(path, step.paths)).toList();
      if (paths.isEmpty) continue;
      reason = paths.length > 3 ? '${paths.take(3).join(', ')} and ${paths.length - 3} more' : paths.join(', ');
    } else {
      continue;
    }
    selected.add((step: step, reason: reason, skipped: _unavailable(step, host)));
  }

  final superseded = {
    for (final s in selected)
      if (s.skipped == null && s.step.supersedes != null) s.step.supersedes,
  };
  return selected.where((s) => !superseded.contains(s.step.id)).toList();
}

String? _unavailable(Step step, Host host) {
  if (step.id == 'timezones' && !host.linux) return 'Linux only';
  if (step.id == 'profile' && !host.linux) return 'Linux only';
  if (step.id == 'profile' && !host.display) return 'needs a display';
  return null;
}

/// The files changed since [base], tracked and untracked.
List<String> changedFiles(String root, String base) {
  final diff = _git(root, ['diff', '--name-only', '--no-renames', base]);
  final untracked = _git(root, ['ls-files', '--others', '--exclude-standard']);
  return {...diff, ...untracked}.toList()..sort();
}

List<String> _git(String root, List<String> args) {
  final result = Process.runSync('git', args, workingDirectory: root);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(1);
  }
  return (result.stdout as String).split('\n').where((line) => line.isNotEmpty).toList();
}

/// A process to run for a step.
typedef Command = ({List<String> args, String directory, Map<String, String> environment});

/// The commands [step] runs, relative to [root].
List<Command> commands(Step step, String root) {
  Command at(String directory, List<String> args, {Map<String, String> environment = const {}}) =>
      (args: args, directory: '$root/$directory', environment: environment);
  Command here(List<String> args) => at('.', args);

  switch (step.id) {
    case 'pub':
      return [
        here(['flutter', 'pub', 'get']),
      ];
    case 'format':
      return [
        here([
          'dart',
          'format',
          '--output=none',
          '--set-exit-if-changed',
          'lib',
          'test',
          'tool',
          'benchmark',
          'test_fixes',
        ]),
      ];
    case 'license':
      return [
        here(['dart', 'run', 'tool/license_headers.dart', '--check']),
      ];
    case 'analyze':
      return [
        here(['dart', 'analyze']),
        here(['flutter', 'analyze']),
      ];
    case 'test':
      return [
        here(['flutter', 'test']),
      ];
    case 'timezones':
      return [
        here(['dart', 'tool/test_timezones_linux.dart']),
      ];
    case 'fixes':
      return [
        here(['dart', 'fix', '--compare-to-golden', 'test_fixes']),
      ];
    case 'snippets':
      return [
        here(['dart', 'run', 'tool/analyze_doc_snippets.dart']),
      ];
    case 'benchmarks':
      return [
        here(['flutter', 'test', 'benchmark/micro_benchmark_test.dart']),
      ];
    case 'profile':
      return [
        at('examples/testing', ['flutter', 'pub', 'get']),
        at(
          'examples/testing',
          [
            'flutter',
            'drive',
            '--driver=test_driver/perf_driver.dart',
            '--target=integration_test/performance_profiling_test.dart',
            '--profile',
            '-d',
            'linux',
          ],
          environment: {'KALENDER_PERF_RUNS': '1'},
        ),
      ];
    case 'web':
      return [
        at('examples/web_demo', ['flutter', 'pub', 'get']),
        at('examples/web_demo', [
          'flutter',
          'build',
          'web',
          '--release',
          '--wasm',
          '--no-web-resources-cdn',
          '--base-href',
          '/kalender/',
        ]),
      ];
  }

  final example = step.id.split(':').last;
  final directory = 'examples/$example';
  return [
    at(directory, ['flutter', 'pub', 'get']),
    at(directory, ['dart', 'format', '--output=none', '--set-exit-if-changed', '.']),
    at(directory, ['flutter', 'analyze']),
    if (Directory('$root/$directory/test').existsSync()) at(directory, ['flutter', 'test']),
  ];
}

const _reset = '\x1B[0m';
const _bold = '\x1B[1m';
const _green = '\x1B[32m';
const _red = '\x1B[31m';
const _yellow = '\x1B[33m';

void main(List<String> args) async {
  var mode = Mode.changed;
  var list = false;
  String? base;
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--quick':
        mode = Mode.quick;
      case '--full':
        mode = Mode.full;
      case '--list':
        list = true;
      case '--base' when i + 1 < args.length:
        base = args[++i];
      default:
        stderr.writeln(
          'Unknown argument ${args[i]}. Usage: dart tool/check.dart [--quick | --full] [--base <ref>] [--list]',
        );
        exit(2);
    }
  }

  final root = _findProjectRoot();
  final host = (
    linux: Platform.isLinux,
    display: Platform.environment['DISPLAY'] != null || Platform.environment['WAYLAND_DISPLAY'] != null,
  );
  final changed = mode == Mode.changed ? changedFiles(root, _mergeBase(root, base)) : const <String>[];
  final selected = select(mode, changed, host);
  final environment = _environment(root);

  print('$_bold${selected.length} steps, ${mode.name} mode$_reset');
  for (final s in selected) {
    final note = s.skipped != null ? ' ${_yellow}skipped, ${s.skipped}$_reset' : '';
    print('  ${s.step.id.padRight(24)} ${s.reason}$note');
  }
  print('');
  if (list) return;

  final results = <String, String?>{};
  for (final s in selected) {
    if (s.skipped != null) continue;
    print('$_bold── ${s.step.id}: ${s.step.description}$_reset');
    String? failure;
    for (final command in commands(s.step, root)) {
      print('\$ ${command.args.join(' ')}');
      final process = await Process.start(
        command.args.first,
        command.args.skip(1).toList(),
        workingDirectory: command.directory,
        environment: {...environment, ...command.environment},
        mode: ProcessStartMode.inheritStdio,
      );
      if (await process.exitCode != 0) {
        failure = command.args.join(' ');
        break;
      }
    }
    results[s.step.id] = failure;
    print('');
  }

  print('$_bold── Summary$_reset');
  var failed = false;
  for (final s in selected) {
    final String status;
    if (s.skipped != null) {
      status = '${_yellow}SKIP$_reset  ${s.step.id}, ${s.skipped}';
    } else if (results[s.step.id] == null) {
      status = '${_green}PASS$_reset  ${s.step.id}';
    } else {
      failed = true;
      status = '${_red}FAIL$_reset  ${s.step.id}: ${results[s.step.id]}';
    }
    print('  $status');
  }
  exit(failed ? 1 : 0);
}

/// The merge base with [ref], or with `origin/main` or `main` when there is none.
String _mergeBase(String root, String? ref) {
  for (final ref in [if (ref != null) ref, 'origin/main', 'main']) {
    final result = Process.runSync('git', ['merge-base', 'HEAD', ref], workingDirectory: root);
    if (result.exitCode == 0) return (result.stdout as String).trim();
  }
  stderr.writeln('No ref to compare against. Pass --base <ref>.');
  exit(1);
}

/// The environment the commands run in, with the SDK from `.fvmrc` first on the path when fvm has it.
Map<String, String> _environment(String root) {
  final environment = {...Platform.environment};
  final fvmrc = File('$root/.fvmrc');
  final home = environment['HOME'];
  if (!fvmrc.existsSync() || home == null) return environment;
  final version = (jsonDecode(fvmrc.readAsStringSync()) as Map)['flutter'] as String;
  final bin = Directory('${_fvmCache(environment, home)}/versions/$version/bin');
  if (bin.existsSync()) {
    environment['PATH'] = '${bin.path}:${environment['PATH']}';
  } else {
    print('${_yellow}Flutter $version from .fvmrc is not installed through fvm, using flutter from the path.$_reset');
  }
  return environment;
}

/// Where fvm keeps its SDKs: `FVM_CACHE_PATH`, the `cachePath` in fvm's global config, or `~/.fvm`.
String _fvmCache(Map<String, String> environment, String home) {
  final fromEnvironment = environment['FVM_CACHE_PATH'];
  if (fromEnvironment != null) return fromEnvironment;
  final config = File('$home/.config/fvm/.fvmrc');
  if (config.existsSync()) {
    final cachePath = (jsonDecode(config.readAsStringSync()) as Map)['cachePath'];
    if (cachePath is String) return cachePath;
  }
  return '$home/.fvm';
}

/// Walks up from the script location until it finds a pubspec.yaml.
String _findProjectRoot() {
  var dir = File(Platform.script.toFilePath()).parent;
  while (!File('${dir.path}/pubspec.yaml').existsSync()) {
    final parent = dir.parent;
    if (parent.path == dir.path) throw StateError('Could not find pubspec.yaml above ${Platform.script}');
    dir = parent;
  }
  return dir.path;
}
