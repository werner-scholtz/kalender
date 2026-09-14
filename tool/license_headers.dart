// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// Adds the SPDX license header to every tracked Dart file that lacks one.
//
// Usage: dart run tool/license_headers.dart [--check]
//
// With --check nothing is written, and the files missing the header are listed.

import 'dart:io';

/// The header every Dart file starts with, after the shebang line if there is one.
const header = '''
// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT
''';

final _shebang = RegExp(r'#!.*\n');
final _leadingNewlines = RegExp(r'^\n+');

String _body(String content) {
  final shebang = _shebang.matchAsPrefix(content);
  return content.substring(shebang?.end ?? 0).replaceFirst(_leadingNewlines, '');
}

/// Whether [content] starts with [header].
bool hasHeader(String content) => _body(content).startsWith(header);

/// [content] with [header] added, or [content] unchanged when it already has it.
String withHeader(String content) {
  if (hasHeader(content)) return content;
  final shebang = _shebang.matchAsPrefix(content)?[0];
  return [if (shebang != null) '$shebang\n', header, '\n', _body(content)].join();
}

void main(List<String> args) {
  final check = args.contains('--check');
  final files = Process.runSync('git', ['ls-files', '*.dart', '*.dart.expect']);
  if (files.exitCode != 0) {
    stderr.write(files.stderr);
    exit(1);
  }

  final missing = <String>[];
  for (final path in (files.stdout as String).split('\n').where((path) => path.isNotEmpty)) {
    final file = File(path);
    final content = file.readAsStringSync();
    if (hasHeader(content)) continue;
    missing.add(path);
    if (!check) file.writeAsStringSync(withHeader(content));
  }

  if (!check) {
    stdout.writeln('Added the license header to ${missing.length} files.');
  } else if (missing.isNotEmpty) {
    stderr.writeln('These files have no license header. Run: dart run tool/license_headers.dart');
    missing.forEach(stderr.writeln);
    exit(1);
  }
}
