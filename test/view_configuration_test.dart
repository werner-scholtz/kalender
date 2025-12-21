import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import 'utilities.dart';

/// The goal of these test is to ensure that navigation for different view controllers/viewConfigurations works as expected.
///
/// This test should be done for all the implementations of [ViewController]s:
/// - [MultiDayViewConfiguration]
///   - [MultiDayViewConfiguration.singleDay]
///   - [MultiDayViewConfiguration.week]
///   - [MultiDayViewConfiguration.workWeek]
///   - [MultiDayViewConfiguration.custom]
///   - [MultiDayViewConfiguration.freeScroll]
/// - [MonthViewConfiguration]
///   - [MonthViewConfiguration.singleMonth]
/// - [ScheduleViewConfiguration]
///   -[ScheduleViewConfiguration.continuous]
///   -[ScheduleViewConfiguration.paginated]
///
/// We will be testing the following functionality of the [ViewController]:
///
/// - [ViewController.jumpToPage]
/// - [ViewController.jumpToDate]
/// - [ViewController.animateToNextPage]
/// - [ViewController.animateToPreviousPage]
/// - [ViewController.animateToDate]
/// - [ViewController.animateToDateTime]
/// - [ViewController.animateToEvent]
/// - [ViewController.visibleDateTimeRange]
/// - [ViewController.visibleEvents]
///
void main() {
  // Set up the events controller, callbacks, and components used in the tests.
  final eventsController = DefaultEventsController();
  final components = TileComponents(
    tileBuilder: (event, tileRange) => Container(key: Key(event.id.toString()), color: Colors.red),
  );
  final scheduleComponents = ScheduleTileComponents(
    tileBuilder: (event, tileRange) => Container(key: Key(event.id.toString()), color: Colors.blue),
  );

  // The date range for the tests. This gives good coverage for the different view configurations.
  // Note all dates used for testing should be Monday - Friday, as the work week view only shows those days.
  final start = DateTime(2024, 1, 1);
  final end = DateTime(2027, 1, 1);
  final lastDisplayDate = DateTime(2025, 12, 31);
  final displayRange = DateTimeRange(start: start, end: end);

  // The initial date for the calendar controller.
  final initialDate = InternalDateTime(2025, 1, 1);
  final startDate = InternalDateTime.fromDateTime(start);
  final endDate = InternalDateTime.fromDateTime(lastDisplayDate);

  // What do we need we need a list of DateTime objects to event IDs. to ensure we can find them in the widget tree.
  final eventMapItems = List.generate(
    displayRange.dates().length,
    (i) {
      final key = start.copyWith(year: start.year, month: start.month, day: start.day + i).startOfDay;
      final end = key.copyWith(hour: start.hour + 1);
      final value = eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: key, end: end)),
      );
      return MapEntry<DateTime, String>(key, value);
    },
  );
  final eventsMap = Map<DateTime, String>.fromEntries(eventMapItems);

  // Test animating to specific events.
  final firstEvent = eventsController.byId(eventsMap[start]!)!;
  final lastEvent = eventsController.byId(eventsMap[lastDisplayDate]!)!;
  final middleEvent = eventsController.byId(eventsMap[initialDate.forLocation()]!)!;
  final eventsToTest = [firstEvent, lastEvent, middleEvent];

  final controller = CalendarController();
  final jumpToDate = controller.jumpToDate;
  final animateToDate = controller.animateToDate;
  final animateToDateTime = controller.animateToDateTime;
  final repeatableFunctions = [jumpToDate, animateToDate, animateToDateTime];

  group('MultiDayViewConfiguration', () {
    testWidgets('singleDay', (tester) async {
      final viewConfiguration = MultiDayViewConfiguration.singleDay(displayRange: displayRange);

      await tester.pumpCalendarView(
        controller: controller,
        viewConfiguration: viewConfiguration,
        eventsController: eventsController,
        components: components,
        scheduleComponents: scheduleComponents,
      );

      expect(find.byType(MultiDayBody), findsOneWidget);

      for (final function in repeatableFunctions) {
        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: startDate,
          function: function,
          event: firstEvent,
        );

        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: endDate,
          function: function,
          event: lastEvent,
        );

        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: initialDate,
          function: function,
          event: middleEvent,
        );
      }

      // Test animating to specific events.
      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });
    testWidgets('week', (tester) async {
      final viewConfiguration = MultiDayViewConfiguration.week(displayRange: displayRange);
      await tester.pumpCalendarView(
        controller: controller,
        viewConfiguration: viewConfiguration,
        eventsController: eventsController,
        components: components,
        scheduleComponents: scheduleComponents,
      );

      expect(find.byType(MultiDayBody), findsOneWidget);

      for (final function in repeatableFunctions) {
        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: startDate,
          function: function,
          event: firstEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: endDate,
          function: function,
          event: lastEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: initialDate,
          function: function,
          event: middleEvent,
        );
      }

      // Test animating to specific events.
      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });
    testWidgets('workWeek', (tester) async {
      final viewConfiguration = MultiDayViewConfiguration.workWeek(displayRange: displayRange);

      await tester.pumpCalendarView(
        controller: controller,
        viewConfiguration: viewConfiguration,
        eventsController: eventsController,
        components: components,
        scheduleComponents: scheduleComponents,
      );

      expect(find.byType(MultiDayBody), findsOneWidget);

      for (final function in repeatableFunctions) {
        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: startDate,
          function: function,
          event: firstEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: endDate,
          function: function,
          event: lastEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: initialDate,
          function: function,
          event: middleEvent,
        );
      }

      // Test animating to specific events.
      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });
    testWidgets('custom', (tester) async {
      final viewConfiguration = MultiDayViewConfiguration.custom(displayRange: displayRange, numberOfDays: 3);

      await tester.pumpCalendarView(
        controller: controller,
        viewConfiguration: viewConfiguration,
        eventsController: eventsController,
        components: components,
        scheduleComponents: scheduleComponents,
      );

      expect(find.byType(MultiDayBody), findsOneWidget);

      for (final function in repeatableFunctions) {
        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: startDate,
          function: function,
          event: firstEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: endDate,
          function: function,
          event: lastEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: initialDate,
          function: function,
          event: middleEvent,
        );
      }

      // Test animating to specific events.
      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });
    testWidgets('freeScroll', (tester) async {
      // TODO: Implement free scroll view configuration test.

      final viewConfiguration = MultiDayViewConfiguration.freeScroll(displayRange: displayRange, numberOfDays: 2);

      await tester.pumpCalendarView(
        controller: controller,
        viewConfiguration: viewConfiguration,
        eventsController: eventsController,
        components: components,
        scheduleComponents: scheduleComponents,
      );

      expect(find.byType(MultiDayBody), findsOneWidget);

      // The viewController's visible events should be empty at this point.
      // This is because the page(s) have been built already.
      expect(controller.visibleEvents.value.isNotEmpty, isTrue);

      for (final function in repeatableFunctions) {
        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: startDate,
          function: function,
          event: firstEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: endDate,
          function: function,
          event: lastEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: initialDate,
          function: function,
          event: middleEvent,
        );
      }

      // Test animating to specific events.
      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });
  });
  group('MonthViewConfiguration', () {
    testWidgets('singleMonth', (tester) async {
      final viewConfiguration = MonthViewConfiguration.singleMonth(displayRange: displayRange);
      await tester.pumpCalendarView(
        controller: controller,
        viewConfiguration: viewConfiguration,
        eventsController: eventsController,
        components: components,
        scheduleComponents: scheduleComponents,
      );

      expect(find.byType(MonthBody), findsOneWidget);

      for (final function in repeatableFunctions) {
        // How fortunate that 2024 starts on a Monday.
        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: startDate,
          function: function,
          event: firstEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: endDate,
          function: function,
          event: lastEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: initialDate,
          function: function,
          event: middleEvent,
        );
      }

      // Test animating to specific events.
      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });
  });
  group('ScheduleViewConfiguration', () {
    test('continuous (uninitialized)', () async {
      final viewConfiguration = ScheduleViewConfiguration.continuous(displayRange: displayRange);
      final viewController = ContinuousScheduleViewController(
        viewConfiguration: viewConfiguration,
        visibleDateTimeRange: ValueNotifier(InternalDateTimeRange.fromDateTimeRange(displayRange)),
        visibleEvents: ValueNotifier<Set<CalendarEvent>>({}),
        initialDate: initialDate,
      );

      await expectLater(viewController.animateToDate(DateTime.now()), completes);
      await expectLater(viewController.animateToDateTime(DateTime.now()), completes);
      await expectLater(viewController.animateToNextPage(), completes);
      await expectLater(viewController.animateToPreviousPage(), completes);
    });

    testWidgets('continuous', (tester) async {
      final viewConfiguration = ScheduleViewConfiguration.continuous(displayRange: displayRange);

      await tester.pumpCalendarView(
        controller: controller,
        viewConfiguration: viewConfiguration,
        eventsController: eventsController,
        components: components,
        scheduleComponents: scheduleComponents,
      );

      await tester.pumpAndSettle();
      expect(find.byType(ScheduleBody), findsOneWidget);

      for (final function in repeatableFunctions) {
        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: startDate,
          function: function,
          event: firstEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: endDate,
          function: function,
          event: lastEvent,
        );

        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: initialDate,
          function: function,
          event: middleEvent,
        );
      }

      // Test animating to specific events.
      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });

    test('paginated (uninitialized)', () async {
      final viewConfiguration = ScheduleViewConfiguration.continuous(displayRange: displayRange);
      final viewController = PaginatedScheduleViewController(
        viewConfiguration: viewConfiguration,
        visibleDateTimeRange: ValueNotifier(InternalDateTimeRange.fromDateTimeRange(displayRange)),
        visibleEvents: ValueNotifier<Set<CalendarEvent>>({}),
        initialDate: initialDate,
      );

      await expectLater(viewController.animateToDate(DateTime.now()), completes);
      await expectLater(viewController.animateToDateTime(DateTime.now()), completes);
      await expectLater(viewController.animateToNextPage(), completes);
      await expectLater(viewController.animateToPreviousPage(), completes);
    });

    testWidgets('paginated', (tester) async {
      final viewConfiguration = ScheduleViewConfiguration.paginated(displayRange: displayRange);

      await tester.pumpCalendarView(
        controller: controller,
        viewConfiguration: viewConfiguration,
        eventsController: eventsController,
        components: components,
        scheduleComponents: scheduleComponents,
      );

      await tester.pumpAndSettle();
      expect(find.byType(ScheduleBody), findsOneWidget);

      for (final function in repeatableFunctions) {
        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: startDate,
          function: function,
          event: firstEvent,
        );

        await tester.testDateFunctionCallWithin(
          controller: controller,
          dateTime: endDate,
          function: function,
          event: lastEvent,
        );

        await tester.testDateFunctionExact(
          controller: controller,
          dateTime: initialDate,
          function: function,
          event: middleEvent,
        );
      }

      for (final event in eventsToTest) {
        await tester.testAnimateToCalendarEvent(controller, event);
      }
    });
  });
}

extension ViewControllerUtilities on WidgetTester {
  Future<void> pumpCalendarView({
    required DefaultEventsController eventsController,
    required CalendarController controller,
    required ViewConfiguration viewConfiguration,
    required TileComponents components,
    required ScheduleTileComponents scheduleComponents,
  }) async {
    await pumpAndSettleWithMaterialApp(
      this,
      CalendarView(
        eventsController: eventsController,
        calendarController: controller,
        viewConfiguration: viewConfiguration,
        body: CalendarBody(
          multiDayTileComponents: components,
          monthTileComponents: components,
          scheduleTileComponents: scheduleComponents,
        ),
      ),
    );

    await pumpAndSettle();
  }

  /// Test event visibility in the widget tree after jumping to a specific date.
  Future<void> testAnimateToCalendarEvent(
    CalendarController controller,
    CalendarEvent event,
  ) async {
    controller.animateToEvent(event);
    await pumpAndSettle();
    expect(
      controller.visibleEvents.value.contains(event),
      isTrue,
      reason: 'Event ${event.id} should be in the visible events after animating to it',
    );
    expect(
      event.start.isWithin(controller.visibleDateTimeRange.value!, includeEnd: true),
      isTrue,
      reason: 'Event start ${event.start} should be within the visible range after animating to it',
    );
  }

  /// Test that a function call changes the visible range start of the [CalendarController] to the given dateTime.
  Future<void> testDateFunctionExact({
    required CalendarController controller,
    required InternalDateTime dateTime,
    required void Function(DateTime dateTime) function,
    CalendarEvent? event,
  }) async {
    // Call the function with the dateTime.
    function.call(dateTime);
    // Pump the widget tree to ensure the changes are applied.
    await pumpAndSettle();
    // Check if the visible range start is the same as the dateTime.
    expect(
      controller.internalDateTimeRange.value!.start,
      dateTime,
      reason: 'Calling the $function should set the change the visible range start to $dateTime',
    );

    // If an event is provided, check if it is visible.
    if (event != null) {
      expect(
        controller.visibleEvents.value.contains(event),
        isTrue,
        reason: '$event on $dateTime should be in the visible events after calling ($function)',
      );
    }
  }

  /// Test that a function call includes the given dateTime in the visible range of the [CalendarController].
  Future<void> testDateFunctionCallWithin({
    required CalendarController controller,
    required InternalDateTime dateTime,
    required void Function(DateTime dateTime) function,
    CalendarEvent? event,
  }) async {
    // Test the end date.
    function.call(dateTime);
    await pumpAndSettle();

    expect(
      dateTime.isWithin(controller.internalDateTimeRange.value!, includeEnd: true),
      isTrue,
      reason: 'Calling the $function should include the $dateTime date in the visible range, '
          'which is ${controller.internalDateTimeRange.value}',
    );

    // If an event is provided, check if it is visible.
    if (event != null) {
      expect(
        controller.visibleEvents.value.contains(event),
        isTrue,
        reason: '$event on $dateTime should be in the visible events after calling ($function)',
      );
    }
  }
}
