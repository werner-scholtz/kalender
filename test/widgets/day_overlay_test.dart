// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// #215: the controller opens the day overlay for any visible day.
void main() {
  final busyDay = DateTime(2025, 1, 15);
  final emptyDay = DateTime(2025, 1, 22);

  final range = KalenderDateTimeRange(start: DateTime(2024, 12), end: DateTime(2025, 6));
  final month = MonthViewConfiguration.singleMonth(displayRange: range, initialDateTime: busyDay);
  final week = MultiDayViewConfiguration.week(displayRange: range, initialDateTime: busyDay);
  final schedule = ScheduleViewConfiguration.continuous(displayRange: range, initialDateTime: busyDay);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  late List<String> printed;

  setUp(() {
    eventsController = controllerWithOverflowOn(busyDay);
    kalenderController = KalenderController(viewConfiguration: month);
    printed = [];
  });

  tearDown(() {
    eventsController.dispose();
    kalenderController.dispose();
  });

  Future<void> capturePrints(Future<void> Function() body) async {
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) => printed.add(message ?? '');
    try {
      await body();
    } finally {
      debugPrint = original;
    }
  }

  void startOn(ViewConfiguration configuration) {
    kalenderController.dispose();
    kalenderController = KalenderController(viewConfiguration: configuration);
  }

  Future<void> pump(
    WidgetTester tester, {
    OverlayBuilders? overlayBuilders,
    KalenderCallbacks? callbacks,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    tester.setViewSize(const Size(800, 600));

    return pumpAndSettleWithMaterialApp(
      tester,
      Directionality(
        textDirection: textDirection,
        child: KalenderView(
          eventsController: eventsController,
          kalenderController: kalenderController,
          callbacks: callbacks,
          components: KalenderComponents(overlayBuilders: overlayBuilders),
          header: const KalenderHeader(),
          body: const KalenderBody(),
        ),
      ),
    );
  }

  Finder card(DateTime date) =>
      find.byKey(MultiDayOverlay.getOverlayCardKey(DateTime.utc(date.year, date.month, date.day)));

  FloatingDateTime floating(DateTime date) => FloatingDateTime(date.year, date.month, date.day);

  group('showDayOverlay', () {
    testWidgets('opens the overlay of a day without events', (tester) async {
      await pump(tester);

      kalenderController.showDayOverlay(emptyDay);
      await tester.pumpAndSettle();

      expect(card(emptyDay), findsOneWidget);
      expect(kalenderController.openDayOverlay.value, floating(emptyDay));

      kalenderController.hideDayOverlay();
      await tester.pumpAndSettle();

      expect(find.byType(MultiDayOverlay), findsNothing);
      expect(kalenderController.openDayOverlay.value, isNull);
    });

    testWidgets('opens one overlay for a day with hidden events', (tester) async {
      await pump(tester);

      kalenderController.showDayOverlay(busyDay);
      await tester.pumpAndSettle();

      expect(card(busyDay), findsOneWidget);
      expect(find.byType(MultiDayOverlay), findsOneWidget);
    });

    testWidgets('closes the open overlay when another day opens', (tester) async {
      await pump(tester);

      kalenderController.showDayOverlay(busyDay);
      await tester.pumpAndSettle();
      kalenderController.showDayOverlay(emptyDay);
      await tester.pumpAndSettle();

      expect(find.byType(MultiDayOverlay), findsOneWidget);
      expect(card(emptyDay), findsOneWidget);
    });

    testWidgets('opens nothing for a day that is not visible, and says why', (tester) async {
      await pump(tester);

      await capturePrints(() async {
        kalenderController.showDayOverlay(DateTime(2025, 3, 10));
        await tester.pumpAndSettle();
      });

      expect(find.byType(MultiDayOverlay), findsNothing);
      expect(kalenderController.openDayOverlay.value, isNull);
      expect(printed, [contains('is not visible')]);
    });

    testWidgets('moves to a day that is not visible when asked to', (tester) async {
      await pump(tester);

      kalenderController.showDayOverlay(DateTime(2025, 3, 10), navigate: true);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      expect(floating(DateTime(2025, 3, 10)).isWithin(kalenderController.floatingVisibleRange.value!), isTrue);
      expect(card(DateTime(2025, 3, 10)), findsOneWidget);
    });

    testWidgets('opens nothing past the display range, even when asked to move', (tester) async {
      await pump(tester);

      await capturePrints(() async {
        kalenderController.showDayOverlay(DateTime(2025, 9, 10), navigate: true);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
      });

      expect(find.byType(MultiDayOverlay), findsNothing);
      expect(kalenderController.openDayOverlay.value, isNull);
      expect(printed, [contains('cannot move')]);
    });

    testWidgets('opens nothing without a view', (tester) async {
      await pump(tester);
      await tester.pumpWidget(const SizedBox());

      await capturePrints(() => kalenderController.showDayOverlay(busyDay));

      expect(kalenderController.openDayOverlay.value, isNull);
      expect(printed, [contains('is not visible')]);
    });

    testWidgets('a day that is open when the calendar builds shows its overlay', (tester) async {
      kalenderController.openDayOverlay.value = floating(emptyDay);
      await pump(tester);

      expect(card(emptyDay), findsOneWidget);
    });

    testWidgets('opens the overlay in the multi-day header', (tester) async {
      startOn(week);
      await pump(tester);

      kalenderController.showDayOverlay(DateTime(2025, 1, 16));
      await tester.pumpAndSettle();

      expect(card(DateTime(2025, 1, 16)), findsOneWidget);
    });

    testWidgets('opens nothing in the schedule view, and says why', (tester) async {
      startOn(schedule);
      await pump(tester);

      await capturePrints(() async {
        kalenderController.showDayOverlay(busyDay);
        await tester.pumpAndSettle();
      });

      expect(find.byType(MultiDayOverlay), findsNothing);
      expect(printed, [contains('schedule view')]);
    });

    testWidgets('can be called from a date label tap', (tester) async {
      await pump(
        tester,
        callbacks: KalenderCallbacks(
          dateLabel: GestureCallbacks(onTap: (detail) => kalenderController.showDayOverlay(detail.date)),
        ),
      );

      await tester.tap(find.text('22'));
      await tester.pumpAndSettle();

      expect(card(emptyDay), findsOneWidget);
    });

    for (final textDirection in TextDirection.values) {
      testWidgets('places the "+N more" button under its day, ${textDirection.name}', (tester) async {
        await pump(tester, textDirection: textDirection);

        final button = find.byKey(MultiDayPortalOverlayButton.getKey(DateTime.utc(2025, 1, 15)));
        expect(tester.getCenter(button).dx, moreOrLessEquals(tester.getCenter(find.text('15')).dx, epsilon: 1));
      });

      testWidgets('places the overlay over its day, ${textDirection.name}', (tester) async {
        await pump(tester, textDirection: textDirection);
        final label = tester.getCenter(find.text('22'));

        kalenderController.showDayOverlay(emptyDay);
        await tester.pumpAndSettle();

        expect(tester.getCenter(card(emptyDay)).dx, moreOrLessEquals(label.dx, epsilon: 1));
      });
    }
  });

  group('openDayOverlay', () {
    testWidgets('follows the "+N more" button and the close button', (tester) async {
      await pump(tester);

      await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(DateTime.utc(2025, 1, 15))));
      await tester.pumpAndSettle();
      expect(kalenderController.openDayOverlay.value, floating(busyDay));

      await tester.tap(find.byKey(MultiDayOverlay.getCloseButtonKey(DateTime.utc(2025, 1, 15))));
      await tester.pumpAndSettle();
      expect(kalenderController.openDayOverlay.value, isNull);
      expect(find.byType(MultiDayOverlay), findsNothing);
    });

    testWidgets('clears when the view switches, and the day opens again after', (tester) async {
      await pump(tester);
      kalenderController.showDayOverlay(emptyDay);
      await tester.pumpAndSettle();

      kalenderController.viewConfiguration = week;
      await tester.pumpAndSettle();
      expect(kalenderController.openDayOverlay.value, isNull);

      kalenderController.viewConfiguration = month;
      await tester.pumpAndSettle();
      kalenderController.showDayOverlay(emptyDay, navigate: true);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(card(emptyDay), findsOneWidget);
    });
  });

  group('A custom portal builder', () {
    testWidgets('does not stop the controller opening the built-in overlay', (tester) async {
      await pump(
        tester,
        overlayBuilders: OverlayBuilders(
          multiDayOverlayPortalBuilder:
              (
                context, {
                required date,
                required events,
                required numberOfHiddenRows,
                required tileHeight,
                required overlayBuilders,
              }) => const Text('custom'),
        ),
      );
      expect(find.text('custom'), findsWidgets);

      kalenderController.showDayOverlay(busyDay);
      await tester.pumpAndSettle();

      expect(find.byType(MultiDayOverlay), findsOneWidget);
    });

    testWidgets('wrapping the built-in portal opens one overlay', (tester) async {
      await pump(
        tester,
        overlayBuilders: OverlayBuilders(
          multiDayOverlayPortalBuilder:
              (
                context, {
                required date,
                required events,
                required numberOfHiddenRows,
                required tileHeight,
                required overlayBuilders,
              }) => MultiDayOverlayPortal(
                date: FloatingDateTime.fromDateTime(date),
                numberOfHiddenRows: numberOfHiddenRows,
                overlayBuilders: overlayBuilders,
              ),
        ),
      );

      kalenderController.showDayOverlay(busyDay);
      await tester.pumpAndSettle();
      expect(find.byType(MultiDayOverlay), findsOneWidget);

      kalenderController.hideDayOverlay();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(DateTime.utc(2025, 1, 15))));
      await tester.pumpAndSettle();
      expect(find.byType(MultiDayOverlay), findsOneWidget);
    });
  });
}
