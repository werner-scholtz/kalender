// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  testWidgets('the indents shorten the separator from the top and the bottom', (tester) async {
    const key = Key('column');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              key: key,
              width: 20,
              height: 100,
              child: Center(child: DaySeparator(style: DaySeparatorStyle(width: 2, topIndent: 10, bottomIndent: 30))),
            ),
          ),
        ),
      ),
    );

    final column = tester.getRect(find.byKey(key));
    final line = tester.getRect(find.descendant(of: find.byType(DaySeparator), matching: find.byType(ColoredBox)));
    expect(line.top, column.top + 10);
    expect(line.bottom, column.bottom - 30);
    expect(line.width, 2);
    expect(line.center.dx, column.center.dx);
  });
}
