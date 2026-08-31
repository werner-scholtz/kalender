import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/month_week_number_gutter.dart';
import 'package:kalender/src/widgets/internal_components/timeline_sizer.dart';

import '../utilities.dart';

/// The month week number column and the multi-day timeline are each drawn in the
/// body and reserved again in the header. [CalendarView] measures each once and
/// publishes the number, so the two halves cannot be given different widths.
///
/// Only the width is shared. A scoped [KalenderTheme] restyles what is drawn,
/// the way it does for every other style.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  tearDown(() {
    calendarController.dispose();
    eventsController.dispose();
  });

  final tiles = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());

  /// A calendar whose body is scoped to [bodyTheme] while the header is not.
  Widget splitTheme(ViewConfiguration configuration, KalenderThemeData bodyTheme) {
    return CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: configuration,
      header: CalendarHeader(multiDayTileComponents: tiles),
      body: KalenderTheme(data: bodyTheme, child: CalendarBody(multiDayTileComponents: tiles)),
    );
  }

  Widget plain(ViewConfiguration configuration, {KalenderThemeData? theme}) {
    final view = CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: configuration,
      header: CalendarHeader(multiDayTileComponents: tiles),
      body: CalendarBody(multiDayTileComponents: tiles),
    );
    return theme == null ? view : KalenderTheme(data: theme, child: view);
  }

  MonthViewConfiguration month() => MonthViewConfiguration.singleMonth(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 8),
        showWeekNumbers: true,
      );

  MultiDayViewConfiguration week() => MultiDayViewConfiguration.week(displayRange: year2025DisplayRange);

  group('month week number gutter', () {
    double gutterWidth(WidgetTester tester) => tester.getSize(find.byType(MonthWeekNumberGutter)).width;
    double spacerWidth(WidgetTester tester) => tester.getSize(find.byType(MonthWeekNumberSpacer)).width;

    testWidgets('the gutter and the header spacer measure alike by default', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, plain(month()));
      expect(gutterWidth(tester), moreOrLessEquals(spacerWidth(tester), epsilon: 0.5));
      expect(gutterWidth(tester), kDefaultWeekNumberWidth);
    });

    testWidgets('a body-scoped theme cannot move one without the other', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        splitTheme(month(), const KalenderThemeData(weekNumberStyle: WeekNumberStyle(buttonSize: Size(80, 80)))),
      );
      expect(gutterWidth(tester), moreOrLessEquals(spacerWidth(tester), epsilon: 0.5));
    });

    testWidgets('a width builder above the calendar reaches both halves', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: month(),
          components: const CalendarComponents(
            monthComponents: MonthComponents(
              bodyComponents: MonthBodyComponents(weekNumberWidth: _fixedWidth),
            ),
          ),
          header: CalendarHeader(multiDayTileComponents: tiles),
          body: CalendarBody(multiDayTileComponents: tiles),
        ),
      );

      expect(gutterWidth(tester), 90);
      expect(spacerWidth(tester), 90);
    });

    testWidgets('a button size above the calendar widens the column', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        plain(month(), theme: const KalenderThemeData(weekNumberStyle: WeekNumberStyle(buttonSize: Size(80, 30)))),
      );
      // The button plus the style's default horizontal padding.
      expect(gutterWidth(tester), 88);
    });
  });

  group('multi-day timeline gutter', () {
    testWidgets('the gutter and the header spacer measure alike by default', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, plain(week()));
      final drawn = tester.getSize(find.byKey(MultiDayBody.timelineKey)).width;
      final reserved = tester.getSize(find.byType(TimelineSizer)).width;
      expect(reserved, moreOrLessEquals(drawn, epsilon: 0.5));
      expect(drawn, isNot(moreOrLessEquals(140, epsilon: 0.5)), reason: 'the body scope does not reach the width');
    });

    testWidgets('a theme above the calendar reaches the gutter', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        plain(week(), theme: const KalenderThemeData(timelineStyle: TimelineStyle(width: 140))),
      );
      expect(tester.getSize(find.byKey(MultiDayBody.timelineKey)).width, moreOrLessEquals(140, epsilon: 0.5));
    });

    // The gutter is measured once and read three times: the body draws it, the
    // header reserves it, and TimelineSizer reserves it again for the drag
    // target row. A width that reached only one put the drag target out of line
    // with the day columns, so a drag landed in the wrong day.
    testWidgets('the drag target spacer matches the drawn gutter', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        splitTheme(week(), const KalenderThemeData(timelineStyle: TimelineStyle(width: 140))),
      );

      final drawn = tester.getSize(find.byKey(MultiDayBody.timelineKey)).width;
      final reserved = tester.getSize(find.byType(TimelineSizer)).width;
      expect(reserved, moreOrLessEquals(drawn, epsilon: 0.5));
    });

    testWidgets('a body-scoped text size restyles the labels and both halves still agree', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        splitTheme(week(), const KalenderThemeData(timelineStyle: TimelineStyle(textStyle: TextStyle(fontSize: 40)))),
      );

      final label = tester.widget<Text>(find.byKey(TimeLine.getTimeKey(1, 0)).first);
      expect(label.style?.fontSize, 40, reason: 'the label takes the scoped style');

      final drawn = tester.getSize(find.byKey(MultiDayBody.timelineKey)).width;
      final reserved = tester.getSize(find.byType(TimelineSizer)).width;
      expect(reserved, moreOrLessEquals(drawn, epsilon: 0.5), reason: 'the width is measured above the scope');
    });
    testWidgets('the width is measured once rather than at every reader', (tester) async {
      _timelineWidthCalls = 0;
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: week(),
          components: const CalendarComponents(
            multiDayComponents: MultiDayComponents(
              bodyComponents: MultiDayBodyComponents(timelineWidth: _countingTimelineWidth),
            ),
          ),
          header: CalendarHeader(multiDayTileComponents: tiles),
          body: CalendarBody(multiDayTileComponents: tiles),
        ),
      );

      // The body draws the gutter, the header reserves it and TimelineSizer
      // reserves it again, and all three read the one measurement.
      expect(_timelineWidthCalls, 1);
    });
  });
}

int _timelineWidthCalls = 0;

double _countingTimelineWidth(BuildContext context, TimeOfDayRange range) {
  _timelineWidthCalls++;
  return 120;
}

double _fixedWidth(BuildContext context) => 90;
