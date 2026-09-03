import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// Overlay builders still resolve most-specific-first: a per-view
// OverlayBuilders wins over the global CalendarComponents.overlayBuilders. The
// month body used to resolve them the wrong way round.
//
// Overlay styles have no precedence left to test. The per-view and global style
// fields were removed in 0.26.0, so the theme is the only source, and these
// tests check it reaches the overflow button in both views.
void main() {
  /// A theme that colours the overflow button's text with [color], which is
  /// what these tests read back.
  KalenderThemeData themeColoured(Color color) => KalenderThemeData(
        multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle(
          textStyle: TextStyle(color: color),
        ),
      );

  /// Builds an [OverlayBuilders] whose overflow button is labelled [label]. The
  /// hidden-event count is left out on purpose, it varies with the cell height.
  OverlayBuilders buildersLabelled(String label) => OverlayBuilders(
        multiDayPortalOverlayButtonStringBuilder: (context, numberOfHiddenEvents) => label,
      );

  /// Every rendered overflow button, of which there can be more than one: adjacent
  /// pages are built too, and a neighbouring month's grid can include the same day.
  Iterable<Text> buttonTexts(WidgetTester tester) {
    final texts = tester.widgetList<Text>(find.byKey(MultiDayPortalOverlayButton.textKey));
    expect(texts, isNotEmpty, reason: 'the day should overflow and show an overflow button');
    return texts;
  }

  /// The distinct text colours of every rendered overflow button.
  Set<Color?> buttonColors(WidgetTester tester) => buttonTexts(tester).map((text) => text.style?.color).toSet();

  /// The distinct labels of every rendered overflow button.
  Set<String> buttonLabels(WidgetTester tester) => buttonTexts(tester).map((text) => text.data!).toSet();

  /// Adds enough events on [day] to overflow the cell and show the button.
  DefaultEventsController controllerWithOverflowOn(DateTime day) {
    final eventsController = DefaultEventsController();
    for (var i = 0; i < 8; i++) {
      eventsController.addEvent(
        CalendarEvent(start: day, end: day.add(const Duration(days: 1))),
      );
    }
    return eventsController;
  }

  group('Month body overlay resolution', () {
    Future<void> pumpMonthView(
      WidgetTester tester, {
      CalendarComponents? components,
      KalenderThemeData? theme,
    }) {
      // 29 Jan 2025 sits in the last row of a 5-row January.
      final eventsController = controllerWithOverflowOn(DateTime.utc(2025, 1, 29));
      final view = KalenderView(
        eventsController: eventsController,
        calendarController: CalendarController(),
        viewConfiguration: MonthViewConfiguration.singleMonth(
          displayRange: year2025DisplayRange,
          initialDateTime: DateTime(2025, 1, 15),
        ),
        components: components,
        body: const CalendarBody(),
      );

      return pumpAndSettleWithMaterialApp(
        tester,
        theme == null ? view : KalenderTheme(data: theme, child: view),
      );
    }

    testWidgets('the theme styles the overflow button', (tester) async {
      await pumpMonthView(tester, theme: themeColoured(Colors.green));

      expect(buttonColors(tester), {Colors.green});
    });

    testWidgets('the month body builders win over the global builders', (tester) async {
      await pumpMonthView(
        tester,
        components: CalendarComponents(
          overlayBuilders: buildersLabelled('global'),
          monthComponents: MonthComponents(
            bodyComponents: MonthBodyComponents(overlayBuilders: buildersLabelled('specific')),
          ),
        ),
      );

      expect(buttonLabels(tester), {'specific'}, reason: 'the more specific month body builder should win');
    });

    // MonthBodyComponents.overlayBuilders defaulted to a non-null empty
    // OverlayBuilders, and the month body resolves it with `?? global`, so the
    // empty default always shadowed the global builders.
    testWidgets('the global builders are used when the month body sets none', (tester) async {
      await pumpMonthView(tester, components: CalendarComponents(overlayBuilders: buildersLabelled('global')));

      expect(buttonLabels(tester), {'global'}, reason: 'the global builder should still apply as a fallback');
    });
  });

  group('Multi-day header overlay resolution', () {
    Future<void> pumpWeekView(
      WidgetTester tester, {
      CalendarComponents? components,
      KalenderThemeData? theme,
    }) {
      final day = DateTime.utc(2025, 1, 15);
      final view = KalenderView(
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
      );

      return pumpAndSettleWithMaterialApp(
        tester,
        theme == null ? view : KalenderTheme(data: theme, child: view),
      );
    }

    testWidgets('the theme styles the overflow button', (tester) async {
      await pumpWeekView(tester, theme: themeColoured(Colors.green));

      expect(buttonColors(tester), {Colors.green});
    });

    testWidgets('the header builders win over the global builders', (tester) async {
      await pumpWeekView(
        tester,
        components: CalendarComponents(
          overlayBuilders: buildersLabelled('global'),
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(overlayBuilders: buildersLabelled('specific')),
          ),
        ),
      );

      expect(buttonLabels(tester), {'specific'}, reason: 'the more specific header builder should win');
    });
  });
}
