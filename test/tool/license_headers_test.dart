// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import '../../tool/license_headers.dart' show hasHeader, header, withHeader;

void main() {
  group('withHeader', () {
    test('puts the header above the first line', () {
      expect(withHeader("import 'dart:io';\n"), "$header\nimport 'dart:io';\n");
    });

    test('keeps a shebang on the first line', () {
      expect(withHeader('#!/usr/bin/env dart\n\nvoid main() {}\n'), '#!/usr/bin/env dart\n\n$header\nvoid main() {}\n');
    });

    test('leaves a file that has the header unchanged', () {
      final content = "$header\nimport 'dart:io';\n";
      expect(withHeader(content), content);
    });

    test('replaces an outdated header', () {
      final outdated = header.replaceFirst('2023', '2022');
      expect(withHeader("$outdated\nimport 'dart:io';\n"), "$header\nimport 'dart:io';\n");
    });

    test('replaces an outdated header after a shebang', () {
      final outdated = header.replaceFirst('MIT', 'BSD-3-Clause');
      expect(
        withHeader('#!/usr/bin/env dart\n\n$outdated\nvoid main() {}\n'),
        '#!/usr/bin/env dart\n\n$header\nvoid main() {}\n',
      );
    });
  });

  group('hasHeader', () {
    test('is false when the header is not at the top', () {
      expect(hasHeader("import 'dart:io';\n\n$header"), isFalse);
    });

    test('is true after a shebang', () {
      expect(hasHeader('#!/usr/bin/env dart\n\n${header}void main() {}\n'), isTrue);
    });
  });
}
