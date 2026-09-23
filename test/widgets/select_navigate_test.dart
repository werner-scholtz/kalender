// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  final displayRange = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));

  setUpAll(initializeTimeZones);
  setUp(() {
    eventsController = DefaultEventsController();
  });

  final march = MonthViewConfiguration.singleMonth(displayRange: displayRange, initialDateTime: DateTime(2025, 3, 10));

  Future<void> pump(WidgetTester tester, {KalenderBody body = const KalenderBody()}) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(eventsController: eventsController, kalenderController: kalenderController, body: body),
    );
  }

  FloatingDateTimeRange visible() => kalenderController.floatingVisibleRange.value!;

  group('navigate', () {
    testWidgets('moves to a day that is not visible', (tester) async {
      kalenderController = KalenderController(viewConfiguration: march);
      await pump(tester);

      kalenderController.selectDate(DateTime(2025, 6, 18), navigate: true);
      await tester.pumpAndSettle();
      expect(visible().dominantMonthDate.month, 6);
    });

    testWidgets('leaves the view alone when the day is visible or when false', (tester) async {
      kalenderController = KalenderController(viewConfiguration: march);
      await pump(tester);
      final before = visible();

      kalenderController.selectDate(DateTime(2025, 3, 20), navigate: true);
      await tester.pumpAndSettle();
      expect(visible(), before);

      kalenderController.selectDate(DateTime(2025, 6, 18));
      await tester.pumpAndSettle();
      expect(visible(), before);
    });

    testWidgets('leaves the continuous schedule alone when the last visible day is selected', (tester) async {
      kalenderController = KalenderController(
        viewConfiguration: ScheduleViewConfiguration.continuous(
          displayRange: displayRange,
          initialDateTime: DateTime(2025, 3, 10),
        ),
      );
      await pump(
        tester,
        body: KalenderBody(scheduleBodyConfiguration: ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.show)),
      );
      final before = visible();
      final schedule = kalenderController.viewController as ScheduleViewController;
      final lastIndex = schedule.itemPositionsListener!.itemPositions.value
          .map((position) => position.index)
          .reduce(max);
      final lastDay = schedule.dateTimeFromIndex(lastIndex)!;
      expect(before.end, lastDay.endOfDay);

      kalenderController.selectDate(lastDay, navigate: true);
      await tester.pumpAndSettle();
      expect(visible(), before);
    });
  });

  group('before a view attaches', () {
    testWidgets('the selection is resolved in the calendar location', (tester) async {
      kalenderController = KalenderController(viewConfiguration: march, location: getLocation('Pacific/Kiritimati'));
      // 23:00 UTC on the 15th is the 16th at UTC+14.
      kalenderController.selectDate(TZDateTime.utc(2025, 3, 15, 23));

      await pump(tester);
      expect(kalenderController.selectedRange.value, FloatingDateTime(2025, 3, 16).dayRange);
    });

    testWidgets('navigate moves the view once it has built', (tester) async {
      kalenderController = KalenderController(viewConfiguration: march);
      kalenderController.selectDate(DateTime(2025, 6, 18), navigate: true);

      await pump(tester);
      expect(visible().dominantMonthDate.month, 6);
    });

    testWidgets('deselecting clears the selection and keeps the navigation', (tester) async {
      kalenderController = KalenderController(viewConfiguration: march);
      kalenderController.selectDate(DateTime(2025, 6, 18), navigate: true);
      kalenderController.deselectRange();

      await pump(tester);
      expect((kalenderController.selectedRange.value, visible().dominantMonthDate.month), (null, 6));
    });
  });
}
