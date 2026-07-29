// Compiles every Dart snippet in the README and the doc/ guides.
//
// The snippets are the first code a reader copies, so a snippet that no longer
// compiles is a broken promise. `flutter analyze` at the root cannot catch it,
// because the code lives in markdown.
//
// Each fenced dart block must be preceded by a directive comment saying how to
// compile it. A block without one is an error, so a new snippet cannot be added
// unchecked:
//
//   <!-- snippet: file -->          top-level declarations, used as they are
//   <!-- snippet: statements -->    wrapped in an async function body
//   <!-- snippet: expression -->    wrapped in a variable initializer
//   <!-- snippet: continues -->     appended to the block above, for an example
//                                   split by prose
//   <!-- snippet: skip: reason -->  not compiled, reason required
//
// A snippet may assume only material.dart and kalender.dart. Anything else it
// uses has to be imported in the block, so a snippet a reader copies whole
// really does compile. Identifiers the docs use as placeholders, such as the
// Event subclass, come from examples/doc_snippets/lib/preamble.dart.
//
// Usage: dart run tool/analyze_doc_snippets.dart

import 'dart:io';

/// Where the generated package lives, relative to the repository root.
const snippetPackage = 'examples/doc_snippets';

/// The imports every snippet may assume, because every file using this package
/// already has them.
///
/// Deliberately short. Anything else has to appear in the snippet itself, so a
/// snippet that presents as a file a reader can copy really is one. A wider
/// header would have hidden the missing `gestures.dart` and `services.dart` in
/// the zoom example, which is the failure this tool exists to catch.
const impliedImports = <String>[
  "import 'package:flutter/material.dart';",
  "import 'package:kalender/kalender.dart';",
  "import 'package:doc_snippets/preamble.dart';",
];

/// A directive comment naming how the block below it is compiled.
final directivePattern =
    RegExp(r'^\s*<!--\s*snippet:\s*(file|statements|expression|continues|skip)\s*(?::\s*(.*?))?\s*-->\s*$');

/// The opening of a fenced dart block, capturing its indentation.
final fenceOpenPattern = RegExp(r'^(\s*)```dart\s*$');

/// An import or export line, which is lifted out of a snippet.
final importPattern = RegExp(r"^\s*(?:import|export)\s+'[^']+'.*;\s*$");

/// How a snippet is compiled.
enum SnippetKind { file, statements, expression, continues, skip }

/// A dart block found in a markdown file.
class Snippet {
  Snippet({required this.path, required this.line, required this.kind, required this.code, this.skipReason});

  /// The markdown file the block came from.
  final String path;

  /// The 1-based line of the block's first code line.
  final int line;

  final SnippetKind kind;

  /// The block, dedented, with imports still in place.
  final String code;

  final String? skipReason;

  /// The import lines lifted out of [code].
  List<String> get imports => code.split('\n').where(importPattern.hasMatch).map((line) => line.trim()).toList();

  /// [code] without its import lines, and without the blank run they leave.
  String get body {
    final lines = code.split('\n').where((line) => !importPattern.hasMatch(line)).toList();
    while (lines.isNotEmpty && lines.first.trim().isEmpty) {
      lines.removeAt(0);
    }
    return lines.join('\n').trimRight();
  }

  /// How many lines [body] dropped from the front of [code], so a diagnostic can
  /// be reported against the line the reader sees.
  int get bodyOffset {
    final lines = code.split('\n');
    var offset = 0;
    while (offset < lines.length && (importPattern.hasMatch(lines[offset]) || lines[offset].trim().isEmpty)) {
      offset++;
    }
    return offset;
  }
}

/// A missing or malformed directive, reported with the line to fix.
class SnippetError implements Exception {
  SnippetError(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Every dart block in [markdown], in order.
///
/// Throws a [SnippetError] if a block has no directive above it.
List<Snippet> parseSnippets(String markdown, String path) {
  final lines = markdown.split('\n');
  final snippets = <Snippet>[];

  for (var i = 0; i < lines.length; i++) {
    final open = fenceOpenPattern.firstMatch(lines[i]);
    if (open == null) continue;

    final indent = open.group(1)!;
    final closing = '$indent```';

    // Collect the block.
    final code = <String>[];
    var end = i + 1;
    while (end < lines.length && lines[end].trimRight() != closing.trimRight()) {
      code.add(_dedent(lines[end], indent));
      end++;
    }

    final directive = _directiveAbove(lines, i);
    if (directive == null) {
      throw SnippetError(
        '$path:${i + 1}: this dart block has no snippet directive above it.\n'
        '  Add one of: <!-- snippet: file -->, <!-- snippet: statements -->, '
        '<!-- snippet: expression -->, <!-- snippet: skip: reason -->',
      );
    }

    final kind = SnippetKind.values.byName(directive.group(1)!);
    final reason = directive.group(2);
    if (kind == SnippetKind.skip && (reason == null || reason.trim().isEmpty)) {
      throw SnippetError('$path:${i + 1}: a skipped snippet must say why, as <!-- snippet: skip: reason -->');
    }
    if (kind == SnippetKind.continues && snippets.every((s) => s.kind == SnippetKind.skip)) {
      throw SnippetError('$path:${i + 1}: a continued snippet needs a compiled block above it in the same file');
    }

    snippets.add(
      Snippet(path: path, line: i + 2, kind: kind, code: code.join('\n'), skipReason: reason),
    );
    i = end;
  }

  return snippets;
}

/// The directive comment above the fence at [fenceIndex], skipping blank lines.
RegExpMatch? _directiveAbove(List<String> lines, int fenceIndex) {
  for (var i = fenceIndex - 1; i >= 0; i--) {
    if (lines[i].trim().isEmpty) continue;
    return directivePattern.firstMatch(lines[i]);
  }
  return null;
}

/// [line] with [indent] removed from its front, when it is there.
String _dedent(String line, String indent) {
  if (indent.isEmpty) return line;
  return line.startsWith(indent) ? line.substring(indent.length) : line.trimLeft();
}

/// One generated file, with the markdown line each of its lines came from.
class GeneratedUnit {
  GeneratedUnit({required this.name, required this.source, required this.origins});

  final String name;
  final String source;

  /// 1-based generated line to the markdown line a reader sees.
  final Map<int, ({String path, int line})> origins;
}

/// Groups snippets so that each `continues` block joins the block above it.
List<List<Snippet>> groupSnippets(List<Snippet> snippets) {
  final units = <List<Snippet>>[];
  for (final snippet in snippets) {
    if (snippet.kind == SnippetKind.skip) continue;
    if (snippet.kind == SnippetKind.continues && units.isNotEmpty) {
      units.last.add(snippet);
    } else {
      units.add([snippet]);
    }
  }
  return units;
}

/// The Dart source compiled for [unit], recording where every line came from so
/// a diagnostic points at the markdown a reader sees.
GeneratedUnit generateUnit(List<Snippet> unit, int index) {
  final base = unit.first;
  final imports = <String>{...impliedImports, for (final s in unit) ...s.imports}.toList()..sort();

  final out = <String>[
    '// Generated from ${base.path}. Do not edit.',
    '// ignore_for_file: type=lint',
    ...imports,
    '',
  ];
  final origins = <int, ({String path, int line})>{};

  void emit(Snippet snippet) {
    final firstMarkdownLine = snippet.line + snippet.bodyOffset;
    final bodyLines = snippet.body.split('\n');
    for (var i = 0; i < bodyLines.length; i++) {
      out.add(bodyLines[i]);
      origins[out.length] = (path: snippet.path, line: firstMarkdownLine + i);
    }
  }

  switch (base.kind) {
    case SnippetKind.file:
    case SnippetKind.continues:
      emit(base);
    case SnippetKind.statements:
      out.add('Future<void> _snippet$index() async {');
      emit(base);
      out.add('}');
    case SnippetKind.expression:
      out.add('final Object? _snippet$index =');
      emit(base);
      out.add(';');
    case SnippetKind.skip:
      throw StateError('a skipped snippet is never generated');
  }

  for (final continuation in unit.skip(1)) {
    out.add('');
    emit(continuation);
  }

  return GeneratedUnit(name: 'snippet_$index.dart', source: '${out.join('\n')}\n', origins: origins);
}

/// The markdown files whose snippets are compiled.
List<String> snippetSources() {
  final docs = Directory('doc').existsSync()
      ? (Directory('doc').listSync().whereType<File>().map((f) => f.path).where((p) => p.endsWith('.md')).toList()
        ..sort())
      : <String>[];
  return ['README.md', 'example/README.md', ...docs];
}

void main(List<String> args) async {
  final sources = snippetSources();
  final snippets = <Snippet>[];

  try {
    for (final path in sources) {
      final file = File(path);
      if (!file.existsSync()) continue;
      snippets.addAll(parseSnippets(file.readAsStringSync(), path));
    }
  } on SnippetError catch (error) {
    stderr.writeln(error.message);
    exit(1);
  }

  final compiled = snippets.where((s) => s.kind != SnippetKind.skip).toList();
  final skipped = snippets.where((s) => s.kind == SnippetKind.skip).toList();
  final units = groupSnippets(snippets);

  final generated = Directory('$snippetPackage/lib/generated');
  if (generated.existsSync()) generated.deleteSync(recursive: true);
  generated.createSync(recursive: true);

  final byFile = <String, GeneratedUnit>{};
  for (var i = 0; i < units.length; i++) {
    final unit = generateUnit(units[i], i);
    File('${generated.path}/${unit.name}').writeAsStringSync(unit.source);
    byFile[unit.name] = unit;
  }

  stdout.writeln('Compiling ${compiled.length} snippets from ${sources.length} files.');
  for (final snippet in skipped) {
    stdout.writeln('  skipped ${snippet.path}:${snippet.line} (${snippet.skipReason})');
  }

  final pubGet = await Process.run('flutter', ['pub', 'get'], workingDirectory: snippetPackage);
  if (pubGet.exitCode != 0) {
    stderr.writeln(pubGet.stdout);
    stderr.writeln(pubGet.stderr);
    exit(1);
  }

  final analyze = await Process.run('flutter', ['analyze', 'lib/generated'], workingDirectory: snippetPackage);
  final output = '${analyze.stdout}${analyze.stderr}';

  if (analyze.exitCode == 0) {
    stdout.writeln('All snippets compile.');
    exit(0);
  }

  stderr.writeln('\nSnippets that do not compile:\n');
  for (final line in mapDiagnostics(output, byFile)) {
    stderr.writeln(line);
  }
  exit(1);
}

/// A generated-file location in an analyzer diagnostic.
final diagnosticLocation = RegExp(r'lib[/\\]generated[/\\](snippet_\d+\.dart):(\d+):(\d+)');

/// Rewrites analyzer diagnostics so they point at the markdown line a reader
/// sees rather than at the generated file.
List<String> mapDiagnostics(String output, Map<String, GeneratedUnit> byFile) {
  final mapped = <String>[];

  for (final line in output.split('\n')) {
    final match = diagnosticLocation.firstMatch(line);
    if (match == null) {
      if (line.trim().isNotEmpty && line.contains('•')) mapped.add(line);
      continue;
    }

    final unit = byFile[match.group(1)!];
    final origin = unit?.origins[int.parse(match.group(2)!)];
    if (origin == null) {
      // A diagnostic on the generated header, which no markdown line produced.
      mapped.add(line);
      continue;
    }

    mapped.add(line.replaceRange(match.start, match.end, '${origin.path}:${origin.line}:${match.group(3)}'));
  }

  return mapped;
}
