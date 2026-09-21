// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// [ScheduleDate] shows the locale's short day name from [DateTimeExtensions.dayNameShortLocalized].
void main() {
  // 15 January 2025 is a Wednesday, whose abbreviation differs from the first
  // three letters of its full name in several locales.
  final wednesday = FloatingDateTime(2025, 1, 15);

  Future<void> pumpInLocale(WidgetTester tester, Locale locale, {Widget? child}) async {
    await initializeDateFormatting(locale.toLanguageTag());
    await pumpAndSettleWithMaterialApp(
      tester,
      TestProvider(
        kalenderController: KalenderController(),
        eventsController: DefaultEventsController(),
        tileComponents: TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox()),
        locale: locale,
        child: child ?? ScheduleDate(date: wednesday),
      ),
    );
  }

  testWidgets('uses the locale\'s own abbreviation, not the first three letters', (tester) async {
    await pumpInLocale(tester, const Locale('de'));

    expect(find.text('Mi'), findsOneWidget);
    expect(find.text('Mit'), findsNothing, reason: 'Mittwoch cut at three characters is not how German abbreviates it');
  });

  testWidgets('uses the English three-letter abbreviation', (tester) async {
    await pumpInLocale(tester, const Locale('en'));

    expect(find.text('Wed'), findsOneWidget);
  });

  testWidgets('keeps abbreviations that are not three characters long', (tester) async {
    await pumpInLocale(tester, const Locale('ru'));

    expect(find.text('ср'), findsOneWidget);
    expect(find.text('сре'), findsNothing);
  });

  testWidgets('matches what the multi-day day header shows for the same date', (tester) async {
    await pumpInLocale(
      tester,
      const Locale('de'),
      child: Column(
        children: [
          ScheduleDate(date: wednesday),
          DayHeader(date: wednesday),
        ],
      ),
    );

    expect(find.text('Mi'), findsNWidgets(2));
  });
}
