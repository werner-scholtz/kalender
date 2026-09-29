// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl4x_example/main.dart';
import 'package:kalender/kalender.dart';

/// Renders every view of the app in every locale its picker offers.
void main() {
  const locales = ['en', 'de', 'fr', 'pt-BR', 'ja'];
  const views = ['Week', 'Month', 'Schedule (continuous)'];

  Future<void> pick(WidgetTester tester, Type type, String item) async {
    await tester.tap(find.byWidgetPredicate((widget) => widget.runtimeType == type));
    await tester.pumpAndSettle();
    await tester.tap(find.text(item).last);
    await tester.pumpAndSettle();
  }

  for (final locale in locales) {
    for (final view in views) {
      testWidgets('renders $view in $locale', (tester) async {
        await runZoned(
          () async {
            await tester.pumpWidget(const IntlFourXApp());
            await tester.pumpAndSettle();
            await pick(tester, DropdownButton<Locale>, locale);
            await pick(tester, DropdownButton<ViewConfiguration>, view);
          },
          zoneValues: {#test.allowFormatting: true},
        );

        expect(tester.takeException(), isNull);
      });
    }
  }
}
