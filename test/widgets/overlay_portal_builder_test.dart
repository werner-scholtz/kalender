import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Every overlay builder takes a [BuildContext] and resolves its own styles.
/// The overlay itself is built into an [Overlay] rather than below the calendar,
/// so its builder's context has to reach a [KalenderTheme] across that boundary.
void main() {
  final day = DateTime.utc(2025, 1, 15);

  /// Pumps a month view whose 15 January column overflows, with [portalBuilder]
  /// standing in for the built-in portal.
  Future<void> pumpOverflowingMonth(
    WidgetTester tester, {
    MultiDayOverlayPortalBuilder? portalBuilder,
    OverlayBuilders? overlayBuilders,
    KalenderThemeData? scoped,
  }) async {
    final dpi = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(800 * dpi, 600 * dpi);
    addTearDown(tester.view.resetPhysicalSize);

    final eventsController = DefaultEventsController();
    for (var i = 0; i < 8; i++) {
      eventsController.addEvent(
        CalendarEvent(start: day, end: day.add(const Duration(days: 1))),
      );
    }
    addTearDown(eventsController.dispose);

    final calendarController = CalendarController();
    addTearDown(calendarController.dispose);

    final view = KalenderView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MonthViewConfiguration.singleMonth(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 1, 15),
      ),
      components: CalendarComponents(
        overlayBuilders: overlayBuilders ?? OverlayBuilders(multiDayOverlayPortalBuilder: portalBuilder),
      ),
      body: const CalendarBody(),
    );

    await pumpAndSettleWithMaterialApp(
      tester,
      scoped == null ? view : KalenderTheme(data: scoped, child: view),
    );
  }

  testWidgets('a custom portal builder resolves the overlay styles from its context', (tester) async {
    MultiDayOverlayStyle? received;

    await pumpOverflowingMonth(
      tester,
      portalBuilder: (
        context, {
        required date,
        required events,
        required numberOfHiddenRows,
        required tileHeight,
        required getMultiDayEventLayoutRenderBox,
        required overlayTileBuilder,
        required overlayBuilders,
      }) {
        received = KalenderTheme.of(context).multiDayOverlayStyle;
        return const SizedBox();
      },
    );

    expect(
      received,
      isNotNull,
      reason: 'the Material defaults populate this even when the app sets nothing',
    );
  });

  testWidgets('a scoped theme reaches the custom portal builder', (tester) async {
    MultiDayOverlayStyle? received;

    await pumpOverflowingMonth(
      tester,
      scoped: const KalenderThemeData(multiDayOverlayStyle: MultiDayOverlayStyle(width: 321)),
      portalBuilder: (
        context, {
        required date,
        required events,
        required numberOfHiddenRows,
        required tileHeight,
        required getMultiDayEventLayoutRenderBox,
        required overlayTileBuilder,
        required overlayBuilders,
      }) {
        received = KalenderTheme.of(context).multiDayOverlayStyle;
        return const SizedBox();
      },
    );

    expect(received?.width, equals(321));
  });

  testWidgets('a custom overflow button builder resolves its style from its context', (tester) async {
    MultiDayPortalOverlayButtonStyle? received;

    await pumpOverflowingMonth(
      tester,
      scoped: const KalenderThemeData(
        multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle(textStyle: TextStyle(fontSize: 21)),
      ),
      overlayBuilders: OverlayBuilders(
        multiDayPortalOverlayButtonBuilder: (context, controller, numberOfHiddenRows) {
          received = KalenderTheme.of(context).multiDayPortalOverlayButtonStyle;
          return const SizedBox();
        },
      ),
    );

    expect(received?.textStyle?.fontSize, equals(21));
  });

  testWidgets('a custom overlay builder resolves its style across the Overlay boundary', (tester) async {
    MultiDayOverlayStyle? received;

    await pumpOverflowingMonth(
      tester,
      scoped: const KalenderThemeData(multiDayOverlayStyle: MultiDayOverlayStyle(width: 321)),
      overlayBuilders: OverlayBuilders(
        multiDayOverlayBuilder: (
          context, {
          required date,
          required events,
          required tileHeight,
          required portalController,
          required overlayTileBuilder,
          required getMultiDayEventLayoutRenderBox,
          required getOverlayPortalRenderBox,
        }) {
          received = KalenderTheme.of(context).multiDayOverlayStyle;
          return const SizedBox();
        },
      ),
    );

    await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(day)));
    await tester.pumpAndSettle();

    expect(received?.width, equals(321));
  });

  testWidgets('the built-in overlay still follows a scoped theme with nothing passed to it', (tester) async {
    final eventsController = DefaultEventsController();
    for (var i = 0; i < 8; i++) {
      eventsController.addEvent(
        CalendarEvent(start: day, end: day.add(const Duration(days: 1))),
      );
    }
    addTearDown(eventsController.dispose);

    final calendarController = CalendarController();
    addTearDown(calendarController.dispose);

    final dpi = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(800 * dpi, 600 * dpi);
    addTearDown(tester.view.resetPhysicalSize);

    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderTheme(
        data: const KalenderThemeData(multiDayOverlayStyle: MultiDayOverlayStyle(width: 321)),
        child: KalenderView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: year2025DisplayRange,
            initialDateTime: DateTime(2025, 1, 15),
          ),
          body: const CalendarBody(),
        ),
      ),
    );

    await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(day)));
    await tester.pumpAndSettle();

    // The overlay is built into an Overlay rather than below the calendar, so
    // this also covers the theme reaching across that boundary.
    final card = tester.getSize(find.byKey(MultiDayOverlay.getOverlayCardKey(day)));
    expect(card.width, moreOrLessEquals(321, epsilon: 0.5));
  });
}
