// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  KalenderController? kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
  });

  tearDown(() {
    kalenderController?.dispose();
    kalenderController = null;
    eventsController.dispose();
  });

  /// Two configurations built the same way, as a `build` method would.
  MultiDayViewConfiguration week() =>
      MultiDayViewConfiguration.week(displayRange: year2025DisplayRange, initialDateTime: DateTime(2025, 1, 13));

  MultiDayViewConfiguration weekWith({
    KalenderTime? initialTimeOfDay,
    double? initialHeightPerMinute,
    NowCallback? nowCallback,
  }) => MultiDayViewConfiguration.week(
    displayRange: year2025DisplayRange,
    initialDateTime: DateTime(2025, 1, 13),
    initialTimeOfDay: initialTimeOfDay ?? const KalenderTime(hour: 0, minute: 0),
    initialHeightPerMinute: initialHeightPerMinute ?? 0.7,
    nowCallback: nowCallback,
  );

  MonthViewConfiguration monthConfigWith({DateResolver? dateResolver}) =>
      MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange, dateResolver: dateResolver);

  MonthViewConfiguration monthConfig() => MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange);

  /// Pumps a calendar on [configuration], switching the controller to it after the first pump.
  Future<void> show(WidgetTester tester, ViewConfiguration configuration) async {
    kalenderController = await pumpConfiguration(
      tester,
      eventsController: eventsController,
      configuration: configuration,
      kalenderController: kalenderController,
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

  group('fields that must break equality', () {
    // Each of these is read when the view controller is created, so a change to
    // one has to recreate it.
    test('initialTimeOfDay', () {
      expect(week(), isNot(equals(weekWith(initialTimeOfDay: const KalenderTime(hour: 15, minute: 0)))));
    });

    test('initialHeightPerMinute', () {
      expect(week(), isNot(equals(weekWith(initialHeightPerMinute: 1.5))));
    });

    test('nowCallback', () {
      expect(week(), isNot(equals(weekWith(nowCallback: _stubNow))));
    });

    // nowCallback was in `==` but not in `hashCode`, which is legal but a sign
    // the field was missed when the others were added.
    test('nowCallback also reaches hashCode', () {
      expect(week().hashCode, isNot(equals(weekWith(nowCallback: _stubNow).hashCode)));
    });

    // A free scroll view and a single day view over the same range share a page
    // index calculator, so `type` is what tells the two configurations apart.
    test('type', () {
      final singleDay = MultiDayViewConfiguration.singleDay(
        name: 'same',
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 1, 13),
      );
      final freeScroll = MultiDayViewConfiguration.freeScroll(
        name: 'same',
        numberOfDays: 1,
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 1, 13),
      );

      expect(singleDay, isNot(equals(freeScroll)));
      expect(singleDay.hashCode, isNot(equals(freeScroll.hashCode)));
    });
  });

  group('fields that deliberately do not break equality', () {
    // Resolvers are read from the incoming configuration when a view switch
    // happens, so they are always current and need not recreate anything.
    test('dateResolver', () {
      expect(monthConfig(), equals(monthConfigWith(dateResolver: _stubResolver)));
    });
  });

  group('rebuilding with an equivalent configuration', () {
    testWidgets('keeps the same view controller', (tester) async {
      final held = week();
      await show(tester, held);
      final first = kalenderController!.viewController;

      await show(tester, held);
      expect(kalenderController!.viewController, same(first), reason: 'a configuration held in state');

      // The same calendar rebuilt, as happens on any setState in the parent.
      await show(tester, week());
      expect(kalenderController!.viewController, same(first), reason: 'an equal configuration built again');
    });

    testWidgets('the layout caches survive a rebuild', (tester) async {
      await show(tester, week());
      final firstCache = kalenderController!.viewController.cache;
      final firstFrameCache = kalenderController!.viewController.multiDayCache;

      await show(tester, week());

      expect(
        identical(kalenderController!.viewController.cache, firstCache),
        isTrue,
        reason: 'the event layout cache should survive a rebuild',
      );
      expect(
        identical(kalenderController!.viewController.multiDayCache, firstFrameCache),
        isTrue,
        reason: 'the multi-day frame cache should survive a rebuild',
      );
    });

    testWidgets('keeps the scroll position', (tester) async {
      await show(tester, week());
      final controller = kalenderController!.viewController as MultiDayViewController;
      controller.scrollController.jumpTo(300);
      await tester.pumpAndSettle();
      expect(controller.scrollController.offset, equals(300));

      await show(tester, week());

      final after = kalenderController!.viewController as MultiDayViewController;
      expect(after.scrollController.offset, equals(300));
    });
  });
}

DateTime _stubNow() => DateTime(2025, 1, 14);
FloatingDateTime _stubResolver(ViewTransitionContext transition) => FloatingDateTime(2025, 8, 20);
