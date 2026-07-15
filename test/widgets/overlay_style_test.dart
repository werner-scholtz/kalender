import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// The overlay card, its close button and the barrier behind it used to be
// unstyleable: MultiDayOverlayStyle only reached the text and the paddings, so
// an app with its own calendar theme could not make the overlay match.
void main() {
  final day = DateTime.utc(2025, 1, 15);

  /// Pumps a month view and opens the overlay for [day].
  ///
  /// [extension] goes on `ThemeData.extensions`, [style] on the widget, which
  /// is the precedence ladder: widget style over extension over M3 defaults.
  Future<void> openOverlay(
    WidgetTester tester, {
    KalenderThemeData? extension,
    MultiDayOverlayStyle? style,
    CardThemeData? appCardTheme,
    NowCallback? nowCallback,
  }) async {
    final dpi = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(800 * dpi, 600 * dpi);
    addTearDown(tester.view.resetPhysicalSize);

    final eventsController = DefaultEventsController();
    for (var i = 0; i < 8; i++) {
      eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: day, end: day.add(const Duration(days: 1)))),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(cardTheme: appCardTheme, extensions: [if (extension != null) extension]),
        home: Scaffold(
          body: CalendarView(
            eventsController: eventsController,
            calendarController: CalendarController(),
            viewConfiguration: MonthViewConfiguration.singleMonth(
              displayRange: year2025DisplayRange,
              initialDateTime: DateTime(2025, 1, 15),
              nowCallback: nowCallback,
            ),
            components: CalendarComponents(
              monthComponentStyles: MonthComponentStyles(
                bodyStyles: MonthBodyComponentStyles(overlayStyles: OverlayStyles(multiDayOverlayStyle: style)),
              ),
            ),
            body: const CalendarBody(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(day)));
    await tester.pumpAndSettle();
    expect(find.byKey(MultiDayOverlay.getOverlayCardKey(day)), findsOne);
  }

  /// The [Card] the overlay is drawn on.
  Card overlayCard(WidgetTester tester) => tester.widget<Card>(find.byKey(MultiDayOverlay.getOverlayCardKey(day)));

  /// The color of the barrier drawn behind the card.
  Color barrierColor(WidgetTester tester) =>
      tester.widget<ColoredBox>(find.byKey(MultiDayOverlay.getBarrierKey(day))).color;

  /// The resolved [CardThemeData] the card sees.
  CardThemeData resolvedCardTheme(WidgetTester tester) {
    return CardTheme.of(tester.element(find.byKey(MultiDayOverlay.getOverlayCardKey(day))));
  }

  group('MultiDayOverlayStyle.cardTheme', () {
    testWidgets('falls back to the app card theme when unset', (tester) async {
      await openOverlay(tester, appCardTheme: const CardThemeData(color: Color(0xFF112233), elevation: 6));

      expect(resolvedCardTheme(tester).color, const Color(0xFF112233));
      expect(resolvedCardTheme(tester).elevation, 6);
      expect(overlayCard(tester).color, isNull, reason: 'the card sets nothing itself, it resolves from the theme');
    });

    testWidgets('overrides the app card theme when set', (tester) async {
      await openOverlay(
        tester,
        appCardTheme: const CardThemeData(color: Color(0xFF112233)),
        style: const MultiDayOverlayStyle(cardTheme: CardThemeData(color: Color(0xFFAABBCC))),
      );

      expect(resolvedCardTheme(tester).color, const Color(0xFFAABBCC));
    });

    testWidgets('the theme extension reaches the card', (tester) async {
      await openOverlay(
        tester,
        extension: const KalenderThemeData(
          multiDayOverlayStyle: MultiDayOverlayStyle(
            cardTheme: CardThemeData(color: Color(0xFF00FF00), elevation: 8),
          ),
        ),
      );

      expect(resolvedCardTheme(tester).color, const Color(0xFF00FF00));
      expect(resolvedCardTheme(tester).elevation, 8);
    });

    testWidgets('the widget style overrides the theme extension', (tester) async {
      await openOverlay(
        tester,
        extension: const KalenderThemeData(
          multiDayOverlayStyle: MultiDayOverlayStyle(cardTheme: CardThemeData(color: Color(0xFF00FF00))),
        ),
        style: const MultiDayOverlayStyle(cardTheme: CardThemeData(color: Color(0xFFFF0000))),
      );

      expect(resolvedCardTheme(tester).color, const Color(0xFFFF0000));
    });

    testWidgets('fields merge across the extension and the widget style', (tester) async {
      await openOverlay(
        tester,
        extension: const KalenderThemeData(
          multiDayOverlayStyle: MultiDayOverlayStyle(barrierColor: Color(0xFF0000FF), width: 250),
        ),
        style: const MultiDayOverlayStyle(width: 200),
      );

      final card = tester.getRect(find.byKey(MultiDayOverlay.getOverlayCardKey(day)));
      expect(card.width, 200, reason: 'width comes from the widget style');

      expect(barrierColor(tester), const Color(0xFF0000FF), reason: 'barrierColor still comes from the extension');
    });
  });

  group('MultiDayOverlayStyle.barrierColor', () {
    testWidgets('is transparent by default', (tester) async {
      await openOverlay(tester);

      expect(barrierColor(tester), Colors.transparent);
    });

    testWidgets('is applied when set', (tester) async {
      await openOverlay(tester, style: const MultiDayOverlayStyle(barrierColor: Color(0x80123456)));

      expect(barrierColor(tester), const Color(0x80123456));
    });
  });

  group('MultiDayOverlayStyle.closeButtonStyle', () {
    testWidgets('is applied to the close button', (tester) async {
      const buttonStyle = ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xFF654321)));
      await openOverlay(tester, style: const MultiDayOverlayStyle(closeButtonStyle: buttonStyle));

      final button = tester.widget<IconButton>(find.byKey(MultiDayOverlay.getCloseButtonKey(day)));
      expect(button.style?.backgroundColor?.resolve({}), const Color(0xFF654321));
    });

    testWidgets('the close button still closes the overlay', (tester) async {
      await openOverlay(tester, style: const MultiDayOverlayStyle(closeButtonStyle: ButtonStyle()));

      await tester.tap(find.byKey(MultiDayOverlay.getCloseButtonKey(day)));
      await tester.pumpAndSettle();

      expect(find.byKey(MultiDayOverlay.getOverlayCardKey(day)), findsNothing);
    });
  });

  group('MultiDayOverlayStyle.width and headerHeight', () {
    testWidgets('default to the documented values', (tester) async {
      await openOverlay(tester);

      final card = tester.getRect(find.byKey(MultiDayOverlay.getOverlayCardKey(day)));
      expect(card.width, MultiDayOverlay.defaultWidth);
    });

    testWidgets('are applied when set', (tester) async {
      await openOverlay(tester, style: const MultiDayOverlayStyle(width: 220, headerHeight: 50));

      final card = tester.getRect(find.byKey(MultiDayOverlay.getOverlayCardKey(day)));
      expect(card.width, 220);
    });

    testWidgets('the card never gets wider than the space available', (tester) async {
      await openOverlay(tester, style: const MultiDayOverlayStyle(width: 5000));

      final card = tester.getRect(find.byKey(MultiDayOverlay.getOverlayCardKey(day)));
      expect(card.width, lessThanOrEqualTo(800));
    });
  });

  // The date used to be an IconButton.filledTonal with `onPressed: () {}` — an
  // enabled button that did nothing. It is disabled now, and the filled variant
  // is reserved for today, matching DayHeader, MonthDayHeader and ScheduleDate.
  group('the date in the header', () {
    /// The IconButton the day number sits in.
    IconButton dateButton(WidgetTester tester) {
      return tester.widget<IconButton>(
        find.ancestor(
          of: find.descendant(of: find.byKey(MultiDayOverlay.getOverlayCardKey(day)), matching: find.text('15')),
          matching: find.byType(IconButton),
        ),
      );
    }

    testWidgets('is not interactive', (tester) async {
      await openOverlay(tester);

      expect(dateButton(tester).onPressed, isNull, reason: 'it is a label, it should offer nothing to press');
    });

    testWidgets('uses dateTextStyle', (tester) async {
      await openOverlay(tester, style: const MultiDayOverlayStyle(dateTextStyle: TextStyle(fontSize: 33)));

      final text = tester.widget<Text>(
        find.descendant(of: find.byKey(MultiDayOverlay.getOverlayCardKey(day)), matching: find.text('15')),
      );
      expect(text.style?.fontSize, 33);
    });

    testWidgets('is highlighted when the date is today', (tester) async {
      await openOverlay(tester, nowCallback: () => DateTime(2025, 1, 15, 10));

      expect(find.byKey(MultiDayOverlay.todayKey), findsOne);
      expect(
        find.descendant(of: find.byKey(MultiDayOverlay.todayKey), matching: find.text('15')),
        findsOne,
        reason: 'the highlight should be on the overlay\'s own date',
      );
      expect(dateButton(tester).onPressed, isNull, reason: 'the highlight is still not interactive');
    });

    testWidgets('is not highlighted when the date is not today', (tester) async {
      await openOverlay(tester, nowCallback: () => DateTime(2025, 1, 16, 10));

      expect(find.byKey(MultiDayOverlay.todayKey), findsNothing);
      expect(
        find.descendant(of: find.byKey(MultiDayOverlay.getOverlayCardKey(day)), matching: find.text('15')),
        findsOne,
        reason: 'the date should still render, just without the highlight',
      );
    });

    testWidgets('follows the now callback rather than the real clock', (tester) async {
      // A neighbouring day being "today" must not highlight this overlay.
      await openOverlay(tester, nowCallback: () => DateTime(2025, 1, 14, 23, 59));

      expect(find.byKey(MultiDayOverlay.todayKey), findsNothing);
    });
  });
}
