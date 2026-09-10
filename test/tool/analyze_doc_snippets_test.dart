import 'package:flutter_test/flutter_test.dart';

import '../../tool/analyze_doc_snippets.dart'
    show GeneratedUnit, SnippetError, SnippetKind, generateUnit, groupSnippets, mapDiagnostics, parseSnippets;

/// Wraps [code] in a fenced dart block under [directive].
String block(String directive, String code) => '# Title\n\nSome prose.\n\n$directive\n```dart\n$code\n```\n';

void main() {
  group('parseSnippets', () {
    test('reads the directive and the code below it', () {
      final snippets = parseSnippets(block('<!-- snippet: expression -->', 'KalenderBody()'), 'doc/a.md');
      expect(snippets, hasLength(1));
      expect(snippets.single.kind, SnippetKind.expression);
      expect(snippets.single.code, 'KalenderBody()');
      expect(snippets.single.path, 'doc/a.md');
    });

    test('the line points at the first code line, not the fence', () {
      final snippets = parseSnippets(block('<!-- snippet: file -->', 'class A {}'), 'doc/a.md');
      expect(snippets.single.line, 7);
    });

    test('a block with no directive is an error naming the file and line', () {
      expect(
        () => parseSnippets('# Title\n\n```dart\nclass A {}\n```\n', 'doc/a.md'),
        throwsA(isA<SnippetError>().having((e) => e.message, 'message', contains('doc/a.md:3'))),
      );
    });

    test('a skipped block must give a reason', () {
      expect(
        () => parseSnippets(block('<!-- snippet: skip -->', 'whatever'), 'doc/a.md'),
        throwsA(isA<SnippetError>().having((e) => e.message, 'message', contains('must say why'))),
      );
      final skipped = parseSnippets(block('<!-- snippet: skip: pseudocode -->', 'whatever'), 'doc/a.md');
      expect(skipped.single.kind, SnippetKind.skip);
      expect(skipped.single.skipReason, 'pseudocode');
    });

    test('a continued block needs a compiled block above it', () {
      expect(
        () => parseSnippets(block('<!-- snippet: continues -->', 'class B {}'), 'doc/a.md'),
        throwsA(isA<SnippetError>().having((e) => e.message, 'message', contains('needs a compiled block above it'))),
      );
    });

    test('an indented block, as inside a details element, is dedented', () {
      const markdown =
          '<details>\n\n  <!-- snippet: expression -->\n  ```dart\n  KalenderBody(\n    x: 1,\n  )\n  ```\n';
      final snippets = parseSnippets(markdown, 'doc/a.md');
      expect(snippets.single.code, 'KalenderBody(\n  x: 1,\n)');
    });

    test('a blank line between the directive and the fence is allowed', () {
      final snippets = parseSnippets('<!-- snippet: file -->\n\n```dart\nclass A {}\n```\n', 'doc/a.md');
      expect(snippets.single.kind, SnippetKind.file);
    });

    test('a non-dart fence is ignored', () {
      expect(parseSnippets('```bash\nflutter pub add kalender\n```\n', 'README.md'), isEmpty);
    });
  });

  group('Snippet', () {
    test('imports are lifted out of the body', () {
      final snippet = parseSnippets(
        block('<!-- snippet: file -->', "import 'package:flutter/gestures.dart';\n\nclass A {}"),
        'doc/a.md',
      ).single;
      expect(snippet.imports, ["import 'package:flutter/gestures.dart';"]);
      expect(snippet.body, 'class A {}');
      expect(snippet.bodyOffset, 2);
    });
  });

  group('groupSnippets', () {
    test('a continued block joins the one above it, and skips are dropped', () {
      const markdown = '<!-- snippet: file -->\n```dart\nclass A {}\n```\n'
          '<!-- snippet: continues -->\n```dart\nclass B {}\n```\n'
          '<!-- snippet: skip: prose -->\n```dart\nnot code\n```\n'
          '<!-- snippet: file -->\n```dart\nclass C {}\n```\n';
      final units = groupSnippets(parseSnippets(markdown, 'doc/a.md'));
      expect(units, hasLength(2));
      expect(units.first, hasLength(2));
      expect(units.last, hasLength(1));
    });
  });

  group('generateUnit', () {
    GeneratedUnit unitFor(String directive, String code) =>
        generateUnit(groupSnippets(parseSnippets(block(directive, code), 'doc/a.md')).single, 0);

    test('an expression becomes a variable initializer', () {
      final unit = unitFor('<!-- snippet: expression -->', 'KalenderBody()');
      expect(unit.source, contains('final Object? _snippet0 =\nKalenderBody()\n;'));
    });

    test('statements become an async function body', () {
      final unit = unitFor('<!-- snippet: statements -->', 'final a = 1;');
      expect(unit.source, contains('Future<void> _snippet0() async {\nfinal a = 1;\n}'));
    });

    test('a file is used as it stands', () {
      final unit = unitFor('<!-- snippet: file -->', 'class A {}');
      expect(unit.source, contains('\nclass A {}\n'));
      expect(unit.source, isNot(contains('_snippet0')));
    });

    test('every snippet may assume material and kalender, and nothing more', () {
      final unit = unitFor('<!-- snippet: file -->', 'class A {}');
      expect(unit.source, contains("import 'package:flutter/material.dart';"));
      expect(unit.source, contains("import 'package:kalender/kalender.dart';"));
      expect(unit.source, isNot(contains("import 'package:flutter/gestures.dart';")));
      expect(unit.source, isNot(contains("import 'package:timezone/timezone.dart'")));
    });

    test("a snippet's own imports are added", () {
      final unit = unitFor('<!-- snippet: file -->', "import 'package:flutter/gestures.dart';\n\nclass A {}");
      expect(unit.source, contains("import 'package:flutter/gestures.dart';"));
    });

    test('each body line records the markdown line it came from', () {
      final unit = unitFor('<!-- snippet: file -->', 'class A {\n  int x = 1;\n}');
      final lines = unit.source.split('\n');
      final classLine = lines.indexOf('class A {') + 1;
      expect(unit.origins[classLine], (path: 'doc/a.md', line: 7));
      expect(unit.origins[classLine + 1], (path: 'doc/a.md', line: 8));
    });
  });

  group('mapDiagnostics', () {
    test('a generated location becomes the markdown line a reader sees', () {
      final unit = generateUnit(
        groupSnippets(parseSnippets(block('<!-- snippet: file -->', 'class A {\n  int x = 1;\n}'), 'doc/a.md')).single,
        0,
      );
      final generatedLine = unit.source.split('\n').indexOf('  int x = 1;') + 1;

      final mapped = mapDiagnostics(
        '  error • Something went wrong • lib/generated/snippet_0.dart:$generatedLine:7 • some_code',
        {'snippet_0.dart': unit},
      );

      expect(mapped.single, contains('doc/a.md:8:7'));
      expect(mapped.single, isNot(contains('snippet_0.dart')));
    });

    test('a diagnostic on the generated header is passed through unchanged', () {
      final unit = generateUnit(
        groupSnippets(parseSnippets(block('<!-- snippet: file -->', 'class A {}'), 'doc/a.md')).single,
        0,
      );
      final mapped = mapDiagnostics(
        '  error • Bad import • lib/generated/snippet_0.dart:3:1 • some_code',
        {'snippet_0.dart': unit},
      );
      expect(mapped.single, contains('snippet_0.dart:3:1'));
    });

    test('lines that are not diagnostics are dropped', () {
      expect(mapDiagnostics('Analyzing lib/generated...\n\n2 issues found.', const {}), isEmpty);
    });
  });
}
