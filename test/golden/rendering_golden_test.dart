import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Reference images for the calendar's rendered output.
///
/// These exist to catch a refactor that changes how a style or a component
/// reaches the widget that draws it. The behavioural tests assert that a widget
/// is present and sized; these assert what it looks like, which is what a
/// resolution change actually moves.
///
/// Everything here is pinned: the surface size, the display range, the events,
/// and "now" through [ViewConfiguration.nowCallback]. Without the last one the
/// time indicator and the today highlight move with the clock.
void main() {
  const surface = Size(900, 700);
  final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));
  DateTime now() => DateTime(2025, 1, 15, 10, 30);

  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    for (final event in [
      DateTimeRange(start: DateTime(2025, 1, 15, 9), end: DateTime(2025, 1, 15, 11)),
      DateTimeRange(start: DateTime(2025, 1, 15, 10), end: DateTime(2025, 1, 15, 12)),
      DateTimeRange(start: DateTime(2025, 1, 16, 14), end: DateTime(2025, 1, 16, 15, 30)),
      DateTimeRange(start: DateTime(2025, 1, 14), end: DateTime(2025, 1, 17)),
    ]) {
      eventsController.addEvent(CalendarEvent(dateTimeRange: event));
    }
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  final tiles = TileComponents(
    tileBuilder: (event, tileRange) => Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(color: Colors.blue.shade200, borderRadius: BorderRadius.circular(4)),
    ),
  );

  final scheduleTiles = ScheduleTileComponents(
    tileBuilder: (event, tileRange) => Container(
      height: 24,
      decoration: BoxDecoration(color: Colors.blue.shade200, borderRadius: BorderRadius.circular(4)),
    ),
  );

  /// A theme that moves every style this stack touches, so a resolution change
  /// that drops one shows up as a pixel change rather than as nothing.
  const customTheme = KalenderThemeData(
    timelineStyle: TimelineStyle(textStyle: TextStyle(fontSize: 10, color: Color(0xFF880000)), width: 72),
    hourLinesStyle: HourLinesStyle(color: Color(0xFF00AA00), thickness: 2),
    daySeparatorStyle: DaySeparatorStyle(color: Color(0xFF0000AA), width: 2),
    timeIndicatorStyle: TimeIndicatorStyle(lineColor: Color(0xFFFF00FF), circleColor: Color(0xFFFF00FF), thickness: 3),
    dayHeaderStyle: DayHeaderStyle(textStyle: TextStyle(fontSize: 9, color: Color(0xFF884400))),
    weekNumberStyle: WeekNumberStyle(textStyle: TextStyle(fontSize: 8, color: Color(0xFF008888))),
    monthGridStyle: MonthGridStyle(color: Color(0xFFAA00AA), thickness: 2),
    monthDayHeaderStyle: MonthDayHeaderStyle(numberTextStyle: TextStyle(fontSize: 9, color: Color(0xFF222288))),
    weekDayHeaderStyle: WeekDayHeaderStyle(textStyle: TextStyle(fontSize: 9, color: Color(0xFF228822))),
    scheduleDateStyle: ScheduleDateStyle(textStyle: TextStyle(fontSize: 9, color: Color(0xFF882222))),
  );

  Future<void> pump(
    WidgetTester tester,
    ViewConfiguration viewConfiguration, {
    KalenderThemeData? theme,
    bool header = true,
  }) async {
    tester.view.physicalSize = surface * tester.view.devicePixelRatio;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = surface;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final view = CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: viewConfiguration,
      header: header ? CalendarHeader(multiDayTileComponents: tiles) : null,
      body: CalendarBody(
        multiDayTileComponents: tiles,
        monthTileComponents: tiles,
        scheduleTileComponents: scheduleTiles,
      ),
    );

    await pumpAndSettleWithMaterialApp(tester, theme == null ? view : KalenderTheme(data: theme, child: view));
  }

  MultiDayViewConfiguration week() => MultiDayViewConfiguration.week(
        displayRange: displayRange,
        initialDateTime: DateTime(2025, 1, 15),
        initialTimeOfDay: const TimeOfDay(hour: 8, minute: 0),
        nowCallback: now,
      );

  MonthViewConfiguration month({bool showWeekNumbers = false}) => MonthViewConfiguration.singleMonth(
        displayRange: displayRange,
        initialDateTime: DateTime(2025, 1, 15),
        showWeekNumbers: showWeekNumbers,
        nowCallback: now,
      );

  group('multi-day', () {
    testWidgets('week, default theme', (tester) async {
      await pump(tester, week());
      await expectLater(find.byType(CalendarView), matchesGoldenFile('goldens/week_default.png'));
    });

    testWidgets('week, custom theme', (tester) async {
      await pump(tester, week(), theme: customTheme);
      await expectLater(find.byType(CalendarView), matchesGoldenFile('goldens/week_themed.png'));
    });
  });

  group('schedule', () {
    testWidgets('continuous, default theme', (tester) async {
      await pump(
        tester,
        ScheduleViewConfiguration.continuous(
          displayRange: displayRange,
          initialDateTime: DateTime(2025, 1, 15),
          nowCallback: now,
        ),
        header: false,
      );
      await expectLater(find.byType(CalendarView), matchesGoldenFile('goldens/schedule_default.png'));
    });

    testWidgets('continuous, custom theme', (tester) async {
      await pump(
        tester,
        ScheduleViewConfiguration.continuous(
          displayRange: displayRange,
          initialDateTime: DateTime(2025, 1, 15),
          nowCallback: now,
        ),
        theme: customTheme,
        header: false,
      );
      await expectLater(find.byType(CalendarView), matchesGoldenFile('goldens/schedule_themed.png'));
    });
  });

  group('month', () {
    testWidgets('month, default theme', (tester) async {
      await pump(tester, month());
      await expectLater(find.byType(CalendarView), matchesGoldenFile('goldens/month_default.png'));
    });

    testWidgets('month with week numbers, default theme', (tester) async {
      await pump(tester, month(showWeekNumbers: true));
      await expectLater(find.byType(CalendarView), matchesGoldenFile('goldens/month_week_numbers.png'));
    });

    testWidgets('month with week numbers, custom theme', (tester) async {
      await pump(tester, month(showWeekNumbers: true), theme: customTheme);
      await expectLater(find.byType(CalendarView), matchesGoldenFile('goldens/month_week_numbers_themed.png'));
    });
  });
}
