// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Navigation through the [KalenderController] in each view configuration.
void main() {
  final eventsController = DefaultEventsController();
  final components = TileComponents(
    tileBuilder: (context, event, tileRange) => Container(key: Key(event.id.toString()), color: Colors.red),
  );
  final scheduleComponents = ScheduleTileComponents(
    tileBuilder: (context, event, tileRange) => Container(key: Key(event.id.toString()), color: Colors.blue),
  );

  // All dates used for testing should be Monday - Friday, as the work week view only shows those days.
  final start = DateTime(2024, 1, 1);
  final end = DateTime(2027, 1, 1);
  final lastDisplayDate = DateTime(2025, 12, 31);
  final displayRange = KalenderDateTimeRange(start: start, end: end);

  final initialDate = FloatingDateTime(2025, 1, 1);
  final startDate = FloatingDateTime.fromDateTime(start);
  final endDate = FloatingDateTime.fromDateTime(lastDisplayDate);

  final eventMapItems = List.generate(FloatingDateTimeRange.fromDateTimeRange(displayRange).dates().length, (i) {
    final key = start.copyWith(year: start.year, month: start.month, day: start.day + i);
    final end = key.copyWith(hour: start.hour + 1);
    final value = eventsController.addEvent(KalenderEvent(start: key, end: end));
    return MapEntry<DateTime, String>(key, value);
  });
  final eventsMap = Map<DateTime, String>.fromEntries(eventMapItems);

  final firstEvent = eventsController.byId(eventsMap[start]!)!;
  final lastEvent = eventsController.byId(eventsMap[lastDisplayDate]!)!;
  final middleEvent = eventsController.byId(eventsMap[initialDate.forLocation()]!)!;
  final eventsToTest = [firstEvent, lastEvent, middleEvent];
  final targets = [
    (date: startDate, event: firstEvent),
    (date: endDate, event: lastEvent),
    (date: initialDate, event: middleEvent),
  ];

  Future<KalenderController> pumpCalendarView(WidgetTester tester, ViewConfiguration viewConfiguration) async {
    final controller = KalenderController(viewConfiguration: viewConfiguration);
    addTearDown(controller.dispose);
    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: controller,
      body: KalenderBody(
        multiDayTileComponents: components,
        monthTileComponents: components,
        scheduleTileComponents: scheduleComponents,
      ),
    );
    return controller;
  }

  for (final testCase in [
    (
      name: 'MultiDayViewConfiguration.singleDay',
      configuration: MultiDayViewConfiguration.singleDay(displayRange: displayRange),
      body: MultiDayBody,
      exact: [true, true, true],
    ),
    (
      name: 'MultiDayViewConfiguration.week',
      configuration: MultiDayViewConfiguration.week(displayRange: displayRange),
      body: MultiDayBody,
      exact: [true, false, false],
    ),
    (
      name: 'MultiDayViewConfiguration.workWeek',
      configuration: MultiDayViewConfiguration.workWeek(displayRange: displayRange),
      body: MultiDayBody,
      exact: [true, false, false],
    ),
    (
      name: 'MultiDayViewConfiguration.custom',
      configuration: MultiDayViewConfiguration.custom(displayRange: displayRange, numberOfDays: 3),
      body: MultiDayBody,
      exact: [true, false, false],
    ),
    (
      name: 'MultiDayViewConfiguration.freeScroll',
      configuration: MultiDayViewConfiguration.freeScroll(displayRange: displayRange, numberOfDays: 2),
      body: MultiDayBody,
      exact: [false, false, false],
    ),
    (
      name: 'MonthViewConfiguration.singleMonth',
      configuration: MonthViewConfiguration.singleMonth(displayRange: displayRange),
      body: MonthBody,
      exact: [true, false, false],
    ),
    (
      name: 'ScheduleViewConfiguration.continuous',
      configuration: ScheduleViewConfiguration.continuous(displayRange: displayRange),
      body: ScheduleBody,
      exact: [true, false, true],
    ),
    (
      name: 'ScheduleViewConfiguration.paginated',
      configuration: ScheduleViewConfiguration.paginated(displayRange: displayRange),
      body: ScheduleBody,
      exact: [true, false, true],
    ),
  ]) {
    testWidgets(testCase.name, (tester) async {
      final controller = await pumpCalendarView(tester, testCase.configuration);

      expect(find.byType(testCase.body), findsOneWidget);
      expect(controller.visibleEvents.value, isNotEmpty);

      for (final function in [controller.jumpToDate, controller.animateToDate, controller.animateToDateTime]) {
        for (final (i, target) in targets.indexed) {
          await tester.testDateFunction(
            controller: controller,
            dateTime: target.date,
            function: function,
            event: target.event,
            exact: testCase.exact[i],
          );
        }
      }

      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });
  }

  for (final (name, configuration, create) in [
    (
      'continuous',
      ScheduleViewConfiguration.continuous(displayRange: displayRange),
      ContinuousScheduleViewController.new,
    ),
    ('paginated', ScheduleViewConfiguration.paginated(displayRange: displayRange), PaginatedScheduleViewController.new),
  ]) {
    test('ScheduleViewConfiguration.$name (uninitialized)', () async {
      final viewController = create(
        viewConfiguration: configuration,
        initial: ViewSnapshot(date: initialDate),
      );

      await expectLater(viewController.animateToDate(DateTime.now()), completes);
      await expectLater(viewController.animateToDateTime(DateTime.now()), completes);
      await expectLater(viewController.animateToNextPage(), completes);
      await expectLater(viewController.animateToPreviousPage(), completes);
    });
  }
}

extension on WidgetTester {
  /// Test event visibility in the widget tree after jumping to a specific date.
  Future<void> testAnimateToCalendarEvent(KalenderController controller, KalenderEvent event) async {
    controller.animateToEvent(event);
    await pumpAndSettle();
    expect(
      controller.visibleEvents.value.contains(event),
      isTrue,
      reason: 'Event ${event.id} should be in the visible events after animating to it',
    );
    expect(
      event.floatingStart().isWithin(controller.floatingVisibleRange.value!, includeEnd: true),
      isTrue,
      reason: 'Event start ${event.start} should be within the visible range after animating to it',
    );
  }

  /// Test that a function call makes the visible range of the [KalenderController] start at the given dateTime when
  /// [exact], or include it otherwise, and shows [event].
  Future<void> testDateFunction({
    required KalenderController controller,
    required FloatingDateTime dateTime,
    required void Function(DateTime dateTime) function,
    required KalenderEvent event,
    required bool exact,
  }) async {
    function(dateTime);
    await pumpAndSettle();

    final visibleRange = controller.floatingVisibleRange.value!;
    if (exact) {
      expect(
        visibleRange.start,
        dateTime,
        reason: 'Calling the $function should set the visible range start to $dateTime',
      );
    } else {
      expect(
        dateTime.isWithin(visibleRange, includeEnd: true),
        isTrue,
        reason: 'Calling the $function should include the $dateTime date in the visible range, which is $visibleRange',
      );
    }

    expect(
      controller.visibleEvents.value.contains(event),
      isTrue,
      reason: '$event on $dateTime should be in the visible events after calling ($function)',
    );
  }
}
