// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check.dart' show Host, Mode, examples, selects, select, steps;

void main() {
  const linux = (linux: true, display: true);
  const headless = (linux: true, display: false);
  const mac = (linux: false, display: true);

  List<String> ids(Mode mode, List<String> changed, [Host host = linux]) =>
      select(mode, changed, host).where((s) => s.skipped == null).map((s) => s.step.id).toList();

  List<String> skipped(Mode mode, List<String> changed, Host host) =>
      select(mode, changed, host).where((s) => s.skipped != null).map((s) => '${s.step.id}: ${s.skipped}').toList();

  group('selects', () {
    test('a folder pattern selects what is under it and a file pattern one file', () {
      expect(selects('lib/src/a.dart', ['lib/']), isTrue);
      expect(selects('library/a.dart', ['lib/']), isFalse);
      expect(selects('README.md', ['README.md']), isTrue);
      expect(selects('example/README.md', ['README.md']), isFalse);
    });
  });

  group('select', () {
    test('quick runs the steps every change needs', () {
      expect(ids(Mode.quick, ['lib/src/a.dart']), ['pub', 'format', 'license', 'analyze', 'test']);
    });

    test('full runs every step, the matrix in place of the device timezone', () {
      expect(ids(Mode.full, []), steps.map((s) => s.id).where((id) => id != 'test'));
    });

    final cases = <({String name, List<String> changed, List<String> extra})>[
      (name: 'nothing', changed: [], extra: []),
      (name: 'a guide', changed: ['doc/views.md'], extra: ['snippets']),
      (name: 'the fix fixtures', changed: ['test_fixes/a.dart.expect'], extra: ['fixes']),
      (name: 'one example', changed: ['examples/riverpod/lib/main.dart'], extra: ['example:riverpod']),
      (name: 'the web demo', changed: ['examples/web_demo/lib/main.dart'], extra: ['example:web_demo', 'web']),
      (name: 'the perf harness', changed: ['examples/testing/lib/main.dart'], extra: ['example:testing', 'profile']),
      (name: 'the benchmarks', changed: ['benchmark/fixtures.dart'], extra: ['benchmarks', 'profile']),
      (
        name: 'the examples workflow',
        changed: ['.github/workflows/analyze_examples.yml'],
        extra: [for (final e in examples) 'example:$e'],
      ),
      (name: 'a test', changed: ['test/widgets/month_body_test.dart'], extra: ['timezones']),
      for (final file in ['lib/src/models/a.dart', 'pubspec.yaml', '.fvmrc'])
        (
          name: file,
          changed: [file],
          extra: ['timezones', 'fixes', 'snippets', 'benchmarks', for (final e in examples) 'example:$e', 'profile'],
        ),
    ];

    for (final c in cases) {
      test('changing ${c.name} adds ${c.extra.isEmpty ? 'nothing' : c.extra.join(', ')}', () {
        final always = ['pub', 'format', 'license', 'analyze', if (!c.extra.contains('timezones')) 'test'];
        expect(ids(Mode.changed, c.changed), unorderedEquals([...always, ...c.extra]));
      });
    }

    test('steps run in the declared order', () {
      final selected = ids(Mode.changed, ['lib/src/widgets/a.dart']);
      final order = steps.map((s) => s.id).toList();
      expect(selected, selected.toList()..sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b))));
    });

    test('the reason names the files that selected the step', () {
      final snippets = select(Mode.changed, [
        'doc/a.md',
        'doc/b.md',
      ], linux).singleWhere((s) => s.step.id == 'snippets');
      expect(snippets.reason, 'doc/a.md, doc/b.md');
    });

    test('off Linux the matrix is skipped and the device timezone runs', () {
      expect(ids(Mode.changed, ['lib/a.dart'], mac), contains('test'));
      expect(skipped(Mode.changed, ['lib/a.dart'], mac), ['timezones: Linux only', 'profile: Linux only']);
    });

    test('without a display the profiling is skipped', () {
      expect(skipped(Mode.full, [], headless), ['profile: needs a display']);
    });
  });

  test('the examples match the analyze_examples.yml matrix', () {
    final workflow = File('.github/workflows/analyze_examples.yml').readAsStringSync();
    final matrix = RegExp(r'example:\n((?:\s+- \w+\n)+)').firstMatch(workflow)!.group(1)!;
    final names = RegExp(r'- (\w+)').allMatches(matrix).map((m) => m.group(1)).toList();
    expect(examples, names);
  });
}
