import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

import '../utilities.dart';

void main() {
  setUpAll(tz.initializeTimeZones);
  // ──────────────────────────────────────────────────────────────────────
  // Shared dates: a fixed week with a known "today" override.
  // ──────────────────────────────────────────────────────────────────────
  final monday = InternalDateTime(2026, 4, 13); // The callback "today"
  final tuesday = InternalDateTime(2026, 4, 14);
  final wednesday = InternalDateTime(2026, 4, 15);

  NowCallback nowCallbackMonday() => () => DateTime(2026, 4, 13, 14, 30);

  // A minimal view configuration that carries the callback.
  MultiDayViewConfiguration weekConfigWithCallback() {
    return MultiDayViewConfiguration.week(nowCallback: nowCallbackMonday());
  }

  MultiDayViewConfiguration weekConfigWithoutCallback() {
    return MultiDayViewConfiguration.week();
  }

  Widget buildTestProvider({
    required Widget child,
    required MultiDayViewConfiguration viewConfiguration,
    Location? location,
  }) {
    final calendarController = CalendarController();
    final eventsController = DefaultEventsController();
    final viewController = MultiDayViewController(
      viewConfiguration: viewConfiguration,
      visibleDateTimeRange: ValueNotifier(
        InternalDateTimeRange(start: monday, end: monday.endOfWeek()),
      ),
      visibleEvents: ValueNotifier(<CalendarEvent>{}),
      location: location,
    );
    calendarController.attach(viewController);

    return TestProvider(
      calendarController: calendarController,
      eventsController: eventsController,
      tileComponents: TileComponents.defaultComponents(),
      location: location,
      child: child,
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // DayHeader
  // ──────────────────────────────────────────────────────────────────────
  group('DayHeader uses nowCallback for today highlighting', () {
    testWidgets('highlights the day matching the callback', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithCallback(),
          child: DayHeader(date: monday),
        ),
      );

      expect(find.byKey(DayHeader.todayKey), findsOneWidget, reason: 'Monday should be highlighted');
    });

    testWidgets('does not highlight a day that does not match the callback', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithCallback(),
          child: DayHeader(date: tuesday),
        ),
      );

      expect(find.byKey(DayHeader.todayKey), findsNothing, reason: 'Tuesday should not be highlighted');
    });

    testWidgets('falls back to location-based isToday when callback is null', (tester) async {
      // With no callback, isToday uses DateTime.now() — only "real today" gets highlighted.
      final realToday = InternalDateTime.fromDateTime(DateTime.now()).startOfDay;
      final notToday = realToday.add(const Duration(days: 1));

      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithoutCallback(),
          child: DayHeader(date: notToday),
        ),
      );

      expect(find.byKey(DayHeader.todayKey), findsNothing, reason: 'Tomorrow should not be highlighted');
    });

    testWidgets('callback overrides location (UTC location, local callback)', (tester) async {
      // Calendar is in UTC, but callback returns local Monday — Monday should still highlight.
      final utc = getLocation('Etc/UTC');
      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithCallback(),
          location: utc,
          child: DayHeader(date: monday),
        ),
      );

      expect(find.byKey(DayHeader.todayKey), findsOneWidget, reason: 'Callback should override location');
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // MonthDayHeader
  // ──────────────────────────────────────────────────────────────────────
  group('MonthDayHeader uses nowCallback for today highlighting', () {
    testWidgets('highlights the day matching the callback', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithCallback(),
          child: MonthDayHeader(date: monday),
        ),
      );

      expect(find.byKey(MonthDayHeader.todayKey), findsOneWidget, reason: 'Monday should be highlighted');
    });

    testWidgets('does not highlight a day that does not match the callback', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithCallback(),
          child: MonthDayHeader(date: wednesday),
        ),
      );

      expect(find.byKey(MonthDayHeader.todayKey), findsNothing, reason: 'Wednesday should not be highlighted');
    });

    testWidgets('falls back to location-based isToday when callback is null', (tester) async {
      final realToday = InternalDateTime.fromDateTime(DateTime.now()).startOfDay;
      final notToday = realToday.add(const Duration(days: 2));

      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithoutCallback(),
          child: MonthDayHeader(date: notToday),
        ),
      );

      expect(find.byKey(MonthDayHeader.todayKey), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // ScheduleDate
  // ──────────────────────────────────────────────────────────────────────
  group('ScheduleDate uses nowCallback for today highlighting', () {
    testWidgets('highlights the day matching the callback', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithCallback(),
          child: ScheduleDate(date: monday),
        ),
      );

      expect(find.byKey(ScheduleDate.todayKey), findsOneWidget, reason: 'Monday should be highlighted');
    });

    testWidgets('does not highlight a day that does not match the callback', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithCallback(),
          child: ScheduleDate(date: tuesday),
        ),
      );

      expect(find.byKey(ScheduleDate.todayKey), findsNothing, reason: 'Tuesday should not be highlighted');
    });

    testWidgets('falls back to location-based isToday when callback is null', (tester) async {
      final realToday = InternalDateTime.fromDateTime(DateTime.now()).startOfDay;
      final notToday = realToday.add(const Duration(days: 1));

      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithoutCallback(),
          child: ScheduleDate(date: notToday),
        ),
      );

      expect(find.byKey(ScheduleDate.todayKey), findsNothing);
    });

    testWidgets('callback overrides location (UTC location, local callback)', (tester) async {
      final utc = getLocation('Etc/UTC');
      await pumpAndSettleWithMaterialApp(
        tester,
        buildTestProvider(
          viewConfiguration: weekConfigWithCallback(),
          location: utc,
          child: ScheduleDate(date: monday),
        ),
      );

      expect(find.byKey(ScheduleDate.todayKey), findsOneWidget, reason: 'Callback should override location');
    });
  });
}
