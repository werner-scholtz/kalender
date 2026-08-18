import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/gutter_styles.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart' show ExpandablePageView;
import 'package:kalender/src/widgets/internal_components/month_week_number_gutter.dart';
import 'package:kalender/src/widgets/internal_components/timeline_sizer.dart';

import '../utilities.dart';

/// The month week number column and the multi-day timeline are each drawn in the
/// body and reserved again in the header. Both used to resolve their style from
/// their own position in the tree, so a `KalenderTheme` scoped to one half moved
/// it and left the other behind. [CalendarView] now resolves both above the two,
/// and reports a scoped value it has to ignore.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late List<String> warnings;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    debugResetGutterStyleWarnings();
    warnings = [];
  });

  tearDown(() {
    calendarController.dispose();
    eventsController.dispose();
  });

  /// Collects what the calendar reports while [body] runs.
  ///
  /// [debugPrint] is restored before returning, because the test framework
  /// checks that foundation debug variables are unset when the body ends.
  Future<void> capturingWarnings(Future<void> Function() body) async {
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      if (message != null) warnings.add(message);
    };
    try {
      await body();
    } finally {
      debugPrint = original;
    }
  }

  final tiles = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());

  /// A calendar whose body is scoped to [bodyTheme] while the header is not,
  /// which is the shape the migration guide recommends for per-view styling.
  Widget splitTheme(ViewConfiguration configuration, KalenderThemeData bodyTheme) {
    return CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: configuration,
      header: CalendarHeader(multiDayTileComponents: tiles),
      body: KalenderTheme(data: bodyTheme, child: CalendarBody(multiDayTileComponents: tiles)),
    );
  }

  group('month week number gutter', () {
    MonthViewConfiguration month() => MonthViewConfiguration.singleMonth(
          displayRange: year2025DisplayRange,
          initialDateTime: DateTime(2025, 8),
          showWeekNumbers: true,
        );

    double gutterWidth(WidgetTester tester) => tester.getSize(find.byType(MonthWeekNumberGutter)).width;
    double spacerWidth(WidgetTester tester) => tester.getSize(find.byType(MonthWeekNumberSpacer)).width;

    testWidgets('the gutter and the header spacer measure alike by default', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: month(),
          header: const CalendarHeader(),
          body: const CalendarBody(),
        ),
      );

      expect(gutterWidth(tester), moreOrLessEquals(spacerWidth(tester), epsilon: 0.5));
    });

    testWidgets('a body-scoped week number style cannot move one without the other', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        splitTheme(
          month(),
          const KalenderThemeData(weekNumberStyle: WeekNumberStyle(padding: EdgeInsets.symmetric(horizontal: 40))),
        ),
      );

      expect(
        gutterWidth(tester),
        moreOrLessEquals(spacerWidth(tester), epsilon: 0.5),
        reason: 'the width is resolved above both, so a scope inside the body cannot widen only the gutter',
      );
    });

    testWidgets('the ignored scoped style is reported', (tester) async {
      await capturingWarnings(() async {
        await pumpAndSettleWithMaterialApp(
          tester,
          splitTheme(
            month(),
            const KalenderThemeData(weekNumberStyle: WeekNumberStyle(padding: EdgeInsets.symmetric(horizontal: 40))),
          ),
        );
      });

      expect(warnings.where((w) => w.contains('weekNumberStyle')), isNotEmpty);
      expect(warnings.first, contains('is ignored'));
      expect(warnings.first, contains('above the CalendarView'));
    });

    testWidgets('a theme above the calendar reaches the gutter and stays silent', (tester) async {
      await capturingWarnings(() async {
        await pumpAndSettleWithMaterialApp(
          tester,
          KalenderTheme(
            data: const KalenderThemeData(
              weekNumberStyle: WeekNumberStyle(padding: EdgeInsets.symmetric(horizontal: 40)),
            ),
            child: CalendarView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: month(),
              header: const CalendarHeader(),
              body: const CalendarBody(),
            ),
          ),
        );
      });

      expect(gutterWidth(tester), moreOrLessEquals(spacerWidth(tester), epsilon: 0.5));
      expect(gutterWidth(tester), greaterThan(80), reason: 'the 40px horizontal padding should apply');
      expect(warnings, isEmpty, reason: 'nothing is ignored when the theme sits above both halves');
    });

    testWidgets('the report names the field once, not once per frame', (tester) async {
      final view = splitTheme(
        month(),
        const KalenderThemeData(weekNumberStyle: WeekNumberStyle(padding: EdgeInsets.symmetric(horizontal: 40))),
      );
      await capturingWarnings(() async {
        await pumpAndSettleWithMaterialApp(tester, view);
      });
      final afterFirst = warnings.length;

      await capturingWarnings(() async {
        await tester.pump();
        await tester.pumpAndSettle();
      });

      expect(warnings.length, equals(afterFirst));
    });
  });

  group('multi-day timeline gutter', () {
    MultiDayViewConfiguration week() => MultiDayViewConfiguration.week(
          displayRange: year2025DisplayRange,
          initialDateTime: DateTime(2025, 1, 13),
        );

    testWidgets('a body-scoped timeline style keeps the columns aligned', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        splitTheme(
          week(),
          const KalenderThemeData(timelineStyle: TimelineStyle(width: 140)),
        ),
      );

      final bodyDayArea = tester.getRect(find.byType(HourLines));
      final headerDayArea = tester.getRect(find.byType(ExpandablePageView));
      expect(headerDayArea.left, moreOrLessEquals(bodyDayArea.left, epsilon: 0.5));
      expect(headerDayArea.right, moreOrLessEquals(bodyDayArea.right, epsilon: 0.5));
    });

    testWidgets('the ignored scoped style is reported', (tester) async {
      await capturingWarnings(() async {
        await pumpAndSettleWithMaterialApp(
          tester,
          splitTheme(
            week(),
            const KalenderThemeData(timelineStyle: TimelineStyle(width: 140)),
          ),
        );
      });

      expect(warnings.where((w) => w.contains('timelineStyle')), isNotEmpty);
    });

    // The gutter is measured three times: the body draws it, the header reserves
    // it, and TimelineSizer reserves it again for the drag target row. A scoped
    // style that reached only one of them put the drag target out of line with
    // the day columns, so a drag landed in the wrong day.
    testWidgets('the drag target spacer matches the drawn gutter', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        splitTheme(
          week(),
          const KalenderThemeData(timelineStyle: TimelineStyle(width: 140)),
        ),
      );

      final drawn = tester.getSize(find.byKey(MultiDayBody.timelineKey)).width;
      final reserved = tester.getSize(find.byType(TimelineSizer)).width;
      expect(reserved, moreOrLessEquals(drawn, epsilon: 0.5));
    });

    testWidgets('the timeline labels fit the gutter they are drawn in', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        splitTheme(
          week(),
          const KalenderThemeData(timelineStyle: TimelineStyle(textStyle: TextStyle(fontSize: 40))),
        ),
      );

      final gutter = tester.getRect(find.byKey(MultiDayBody.timelineKey));
      final label = tester.getRect(find.byKey(TimeLine.getTimeKey(1, 0)).first);
      expect(
        label.width,
        lessThanOrEqualTo(gutter.width + 0.5),
        reason: 'a scoped text size must not lay the labels out wider than the box measured for them',
      );
    });
  });
}
