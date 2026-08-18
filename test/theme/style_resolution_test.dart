import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Every style has to reach the widget that draws it.
///
/// The rest of the suite asserts that a component is present and sized. That
/// leaves a gap: a change to how a style is resolved can land on a different
/// value, or on none, while every one of those tests still passes. Each case
/// here sets one style to a value nothing else would produce, then reads it back
/// off the widget that was built.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));
  DateTime now() => DateTime(2025, 1, 15, 10, 30);

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  final tiles = TileComponents(tileBuilder: (event, tileRange) => const SizedBox());

  Future<void> pump(
    WidgetTester tester,
    ViewConfiguration viewConfiguration,
    KalenderThemeData theme, {
    bool header = true,
  }) async {
    final view = CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: viewConfiguration,
      header: header ? CalendarHeader(multiDayTileComponents: tiles) : null,
      body: CalendarBody(
        multiDayTileComponents: tiles,
        monthTileComponents: tiles,
        scheduleTileComponents: ScheduleTileComponents(tileBuilder: (event, range) => const SizedBox()),
      ),
    );
    await pumpAndSettleWithMaterialApp(tester, KalenderTheme(data: theme, child: view));
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

  /// The first [Container] a component built, which is the line or bar it draws.
  Container containerOf(WidgetTester tester, Type component) {
    return tester
        .widgetList<Container>(find.descendant(of: find.byType(component), matching: find.byType(Container)))
        .first;
  }

  /// The first [Text] a component built.
  Text textOf(WidgetTester tester, Type component) {
    return tester.widgetList<Text>(find.descendant(of: find.byType(component), matching: find.byType(Text))).first;
  }

  group('multi-day body', () {
    testWidgets('the day separator draws in the themed colour and width', (tester) async {
      await pump(
        tester,
        week(),
        const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: Color(0xFF0000AA), width: 3)),
      );

      final separator = containerOf(tester, DaySeparator);
      expect(separator.color, const Color(0xFF0000AA));
      expect(tester.getSize(find.byType(DaySeparator).first).width, 3);
    });

    testWidgets('the hour lines draw in the themed colour and thickness', (tester) async {
      await pump(
        tester,
        week(),
        const KalenderThemeData(hourLinesStyle: HourLinesStyle(color: Color(0xFF00AA00), thickness: 4)),
      );

      final line = containerOf(tester, HourLines);
      expect(line.color, const Color(0xFF00AA00));
      expect(line.constraints?.maxHeight, 4);
    });

    testWidgets('the timeline labels use the themed text style', (tester) async {
      await pump(
        tester,
        week(),
        const KalenderThemeData(timelineStyle: TimelineStyle(textStyle: TextStyle(fontSize: 21))),
      );

      expect(textOf(tester, TimeLine).style?.fontSize, 21);
    });

    testWidgets('the themed timeline width sizes the gutter', (tester) async {
      await pump(tester, week(), const KalenderThemeData(timelineStyle: TimelineStyle(width: 77)));

      expect(tester.getSize(find.byKey(MultiDayBody.timelineKey)).width, moreOrLessEquals(77, epsilon: 0.5));
    });
  });

  group('multi-day header', () {
    testWidgets('the day header uses the themed text style', (tester) async {
      await pump(
        tester,
        week(),
        const KalenderThemeData(dayHeaderStyle: DayHeaderStyle(textStyle: TextStyle(fontSize: 19))),
      );

      final texts = tester.widgetList<Text>(find.descendant(of: find.byType(DayHeader), matching: find.byType(Text)));
      expect(texts.any((t) => t.style?.fontSize == 19), isTrue, reason: 'the day name should use textStyle');
    });

    testWidgets('the week number uses the themed text style', (tester) async {
      await pump(
        tester,
        week(),
        const KalenderThemeData(weekNumberStyle: WeekNumberStyle(textStyle: TextStyle(fontSize: 17))),
      );

      expect(textOf(tester, WeekNumber).style?.fontSize, 17);
    });
  });

  group('month', () {
    testWidgets('the grid draws in the themed colour', (tester) async {
      await pump(tester, month(), const KalenderThemeData(monthGridStyle: MonthGridStyle(color: Color(0xFFAA00AA))));

      expect(containerOf(tester, MonthGrid).color, const Color(0xFFAA00AA));
    });

    testWidgets('the day header number uses the themed text style', (tester) async {
      await pump(
        tester,
        month(),
        const KalenderThemeData(monthDayHeaderStyle: MonthDayHeaderStyle(numberTextStyle: TextStyle(fontSize: 23))),
      );

      expect(textOf(tester, MonthDayHeader).style?.fontSize, 23);
    });

    testWidgets('the week day header uses the themed text style', (tester) async {
      await pump(
        tester,
        month(),
        const KalenderThemeData(weekDayHeaderStyle: WeekDayHeaderStyle(textStyle: TextStyle(fontSize: 13))),
      );

      expect(textOf(tester, WeekDayHeader).style?.fontSize, 13);
    });

    testWidgets('the week number gutter keeps its top alignment', (tester) async {
      await pump(tester, month(showWeekNumbers: true), const KalenderThemeData());

      final align =
          tester.widgetList<Align>(find.descendant(of: find.byType(WeekNumber), matching: find.byType(Align))).first;
      expect(
        align.alignment,
        Alignment.topCenter,
        reason: 'the month gutter sits at the top of its row, unlike every other week number',
      );
    });

    testWidgets('a themed alignment wins over the month gutter default', (tester) async {
      await pump(
        tester,
        month(showWeekNumbers: true),
        const KalenderThemeData(weekNumberStyle: WeekNumberStyle(alignment: Alignment.bottomCenter)),
      );

      final align =
          tester.widgetList<Align>(find.descendant(of: find.byType(WeekNumber), matching: find.byType(Align))).first;
      expect(align.alignment, Alignment.bottomCenter);
    });
  });

  group('schedule', () {
    testWidgets('the leading date uses the themed text style', (tester) async {
      await pump(
        tester,
        ScheduleViewConfiguration.continuous(
          displayRange: displayRange,
          initialDateTime: DateTime(2025, 1, 15),
          nowCallback: now,
        ),
        const KalenderThemeData(scheduleDateStyle: ScheduleDateStyle(textStyle: TextStyle(fontSize: 11))),
        header: false,
      );

      expect(textOf(tester, ScheduleDate).style?.fontSize, 11);
    });
  });
}
