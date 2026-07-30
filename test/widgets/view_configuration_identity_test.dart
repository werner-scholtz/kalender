import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

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

  /// Two configurations built the same way, as a `build` method would.
  MultiDayViewConfiguration week() => MultiDayViewConfiguration.week(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 1, 13),
      );

  MonthViewConfiguration monthConfig() => MonthViewConfiguration.singleMonth(
        displayRange: year2025DisplayRange,
      );

  Widget build(ViewConfiguration configuration) {
    return CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: configuration,
      header: const CalendarHeader(),
      body: const CalendarBody(),
    );
  }

  group('view configurations built twice compare equal', () {
    test('MultiDayViewConfiguration', () {
      expect(week(), equals(week()));
    });

    test('MonthViewConfiguration', () {
      expect(monthConfig(), equals(monthConfig()));
    });

    test('the page index calculator behind them', () {
      expect(week().pageIndexCalculator, equals(week().pageIndexCalculator));
    });
  });

  group('rebuilding with an equivalent configuration', () {
    testWidgets('keeps the same view controller', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, build(week()));
      final first = calendarController.viewController;

      // The same calendar rebuilt, as happens on any setState in the parent.
      await pumpAndSettleWithMaterialApp(tester, build(week()));

      expect(
        identical(calendarController.viewController, first),
        isTrue,
        reason: 'an unchanged configuration should not recreate the view controller',
      );
    });

    testWidgets('a configuration held in state does not recreate the controller', (tester) async {
      final held = week();
      await pumpAndSettleWithMaterialApp(tester, build(held));
      final first = calendarController.viewController;
      await pumpAndSettleWithMaterialApp(tester, build(held));
      expect(identical(calendarController.viewController, first), isTrue);
    });

    testWidgets('the layout caches are discarded', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, build(week()));
      final firstCache = calendarController.viewController!.cache;
      final firstFrameCache = calendarController.viewController!.multiDayCache;

      await pumpAndSettleWithMaterialApp(tester, build(week()));

      expect(
        identical(calendarController.viewController!.cache, firstCache),
        isTrue,
        reason: 'the event layout cache should survive a rebuild',
      );
      expect(
        identical(calendarController.viewController!.multiDayCache, firstFrameCache),
        isTrue,
        reason: 'the multi-day frame cache should survive a rebuild',
      );
    });

    testWidgets('keeps the scroll position', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, build(week()));
      final controller = calendarController.viewController! as MultiDayViewController;
      controller.scrollController.jumpTo(300);
      await tester.pumpAndSettle();
      expect(controller.scrollController.offset, equals(300));

      await pumpAndSettleWithMaterialApp(tester, build(week()));

      final after = calendarController.viewController! as MultiDayViewController;
      expect(after.scrollController.offset, equals(300));
    });
  });
}
