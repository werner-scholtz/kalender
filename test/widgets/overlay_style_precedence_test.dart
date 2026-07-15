import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// The month body used to resolve overlay builders and styles the wrong way
// round, letting the global CalendarComponents.overlayStyles shadow the
// per-view MonthBodyComponentStyles.overlayStyles. The multi-day header always
// resolved them correctly. CalendarComponents documents that the more specific
// value wins.
void main() {
  /// Builds an [OverlayStyles] whose "+N more" button is labelled with [label],
  /// which is what these tests read back to see which style was resolved. The
  /// hidden-event count is left out on purpose, it varies with the cell height.
  OverlayStyles stylesLabelled(String label) => OverlayStyles(
        multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle(
          stringBuilder: (numberOfHiddenRows) => label,
        ),
      );

  /// The distinct labels of every rendered "+N more" button.
  ///
  /// Adjacent pages are built too, and a neighbouring month's grid can include
  /// the same day, so more than one button can exist for it.
  Set<String> buttonLabels(WidgetTester tester) {
    final texts = tester.widgetList<Text>(find.byKey(MultiDayPortalOverlayButton.textKey));
    expect(texts, isNotEmpty, reason: 'the day should overflow and show a "+N more" button');
    return texts.map((text) => text.data!).toSet();
  }

  /// Adds enough events on [day] to overflow the cell and show the button.
  DefaultEventsController controllerWithOverflowOn(DateTime day) {
    final eventsController = DefaultEventsController();
    for (var i = 0; i < 8; i++) {
      eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: day, end: day.add(const Duration(days: 1)))),
      );
    }
    return eventsController;
  }

  group('Month body overlay style precedence', () {
    Future<void> pumpMonthView(WidgetTester tester, {required CalendarComponents components}) {
      // 29 Jan 2025 sits in the last row of a 5-row January.
      final eventsController = controllerWithOverflowOn(DateTime.utc(2025, 1, 29));
      return pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: CalendarController(),
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: year2025DisplayRange,
            initialDateTime: DateTime(2025, 1, 15),
          ),
          components: components,
          body: const CalendarBody(),
        ),
      );
    }

    testWidgets('the month body style wins over the global style', (tester) async {
      await pumpMonthView(
        tester,
        components: CalendarComponents(
          overlayStyles: stylesLabelled('global'),
          monthComponentStyles: MonthComponentStyles(
            bodyStyles: MonthBodyComponentStyles(overlayStyles: stylesLabelled('specific')),
          ),
        ),
      );

      expect(buttonLabels(tester), {'specific'}, reason: 'the more specific month body style should win');
    });

    testWidgets('the global style is used when the month body sets none', (tester) async {
      await pumpMonthView(tester, components: CalendarComponents(overlayStyles: stylesLabelled('global')));

      expect(buttonLabels(tester), {'global'}, reason: 'the global style should still apply as a fallback');
    });
  });

  group('Multi-day header overlay style precedence', () {
    Future<void> pumpWeekView(WidgetTester tester, {required CalendarComponents components}) {
      final day = DateTime.utc(2025, 1, 15);
      return pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: controllerWithOverflowOn(day),
          calendarController: CalendarController(),
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: year2025DisplayRange,
            initialDateTime: day,
          ),
          components: components,
          header: const CalendarHeader(
            multiDayHeaderConfiguration: MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1),
          ),
        ),
      );
    }

    testWidgets('the header style wins over the global style', (tester) async {
      await pumpWeekView(
        tester,
        components: CalendarComponents(
          overlayStyles: stylesLabelled('global'),
          multiDayComponentStyles: MultiDayComponentStyles(
            headerStyles: MultiDayHeaderComponentStyles(overlayStyles: stylesLabelled('specific')),
          ),
        ),
      );

      expect(buttonLabels(tester), {'specific'}, reason: 'the more specific header style should win');
    });
  });
}
