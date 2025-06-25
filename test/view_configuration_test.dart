import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import 'utilities.dart';

/// The goal of these test is to ensure that navigation for different view controllers/viewconfigurations works as expected.
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
  final callbacks = CalendarCallbacks(onEventCreated: eventsController.addEvent);
  final components = TileComponents(
    tileBuilder: (event, tileRange) => Container(key: Key(event.id.toString()), color: Colors.red),
  );
  final scheduleComponents = ScheduleTileComponents(
    tileBuilder: (event, tileRange) => Container(key: Key(event.id.toString()), color: Colors.blue),
  );

  // The date range for the tests. This gives good coverage for the different view configurations.
  final start = DateTime(2024, 1, 1);
  final end = DateTime(2026, 12, 31);
  final displayRange = DateTimeRange(start: start, end: end);

  // The initial date for the calendar controller.
  final initialDate = DateTime(2025, 1, 1);

  /// What do we need we need a list of DateTime objects to event IDs. to ensure we can find them in the widget tree.
  final eventMapItems = List.generate(
    displayRange.dates().length + 1,
    (i) {
      final key = start.copyWith(year: start.year, month: start.month, day: start.day + i).startOfDay;
      final end = key.copyWith(hour: start.hour + 1);
      final value = eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: key, end: end)),
      );

      return MapEntry<DateTime, int>(key, value);
    },
  );
  final eventsMap = Map<DateTime, int>.fromEntries(eventMapItems);

  group('MultiDayViewConfiguration', () {
    group('singleDay', () {
      // TODO: Implement tests
    });
    group('week', () {
      // TODO: Implement tests
    });
    group('workWeek', () {
      // TODO: Implement tests
    });
    group('custom', () {
      // TODO: Implement tests
    });
    group('freeScroll', () {
      // TODO: Implement tests
    });
  });
  group('MonthViewConfiguration', () {
    group('singleMonth', () {
      // TODO: Implement tests
    });
  });
  group('ScheduleViewConfiguration', () {
    test('continuous (uninitialized)', () async {
      final viewConfiguration = ScheduleViewConfiguration.continuous(displayRange: displayRange);
      final viewController = ContinuousScheduleViewController(
        viewConfiguration: viewConfiguration,
        visibleDateTimeRange: ValueNotifier<DateTimeRange>(displayRange),
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
      final controller = CalendarController(initialDate: initialDate);

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: controller,
          viewConfiguration: viewConfiguration,
          callbacks: callbacks,
          body: CalendarBody(
            multiDayTileComponents: components,
            monthTileComponents: components,
            scheduleTileComponents: scheduleComponents,
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ScheduleBody), findsOneWidget);

      final jumpToDate = controller.jumpToDate;
      final animateToDate = controller.animateToDate;
      final animateToDateTime = controller.animateToDateTime;

      final repeatableFunctions = [
        jumpToDate,
        animateToDate,
        animateToDateTime,
      ];

      for (final function in repeatableFunctions) {
        // Test the start date.
        function.call(start);
        await tester.pumpAndSettle();
        expect(
          controller.visibleDateTimeRange.value.start,
          start,
          reason: '$function should set the visible range start to the start date',
        );
        expect(
          find.byKey(Key(eventsMap[start]!.toString())),
          findsOneWidget,
          reason: 'Event on start date should be visible ($function)',
        );
        var event = eventsController.byId(eventsMap[start]!);
        expect(
          controller.visibleEvents.value.contains(event),
          isTrue,
          reason: 'Event on start date should be in the visible events ($function)',
        );

        // Test the end date.
        function.call(end);
        await tester.pumpAndSettle();
        expect(
          end.isWithin(controller.visibleDateTimeRange.value, includeEnd: true),
          isTrue,
          reason: '$function should include the end date in the visible range',
        );
        expect(
          find.byKey(Key(eventsMap[end]!.toString())),
          findsOneWidget,
          reason: 'Event on end date should be visible ($function)',
        );
        event = eventsController.byId(eventsMap[end]!);
        expect(
          controller.visibleEvents.value.contains(event),
          isTrue,
          reason: 'Event on end date should be in the visible events ($function)',
        );

        // Test the initial date.
        function.call(initialDate);
        await tester.pumpAndSettle();
        expect(
          controller.visibleDateTimeRange.value.start,
          initialDate,
          reason: '$function should set the visible range start to the initial date',
        );
        expect(
          find.byKey(Key(eventsMap[initialDate]!.toString())),
          findsOneWidget,
          reason: 'Event on initial date should be visible ($function)',
        );
        event = eventsController.byId(eventsMap[initialDate]!);
        expect(
          controller.visibleEvents.value.contains(event),
          isTrue,
          reason: 'Event on initial date should be in the visible events ($function)',
        );
      }

      // Test animating to specific events.
      final firstEvent = eventsController.byId(eventsMap[start]!)!;
      final lastEvent = eventsController.byId(eventsMap[end]!)!;
      final middleEvent = eventsController.byId(eventsMap[initialDate]!)!;
      final eventsToTest = [firstEvent, lastEvent, middleEvent];

      for (final event in eventsToTest) {
        controller.animateToEvent(event);
        await tester.pumpAndSettle();
        expect(
          controller.visibleEvents.value.contains(event),
          isTrue,
          reason: 'Event ${event.id} should be in the visible events after animating to it',
        );
        expect(
          event.start.isWithin(controller.visibleDateTimeRange.value, includeEnd: true),
          isTrue,
          reason: 'Event start ${event.start} should be within the visible range after animating to it',
        );
      }
    });

    test('paginated (uninitialized)', () async {
      final viewConfiguration = ScheduleViewConfiguration.continuous(displayRange: displayRange);
      final viewController = PaginatedScheduleViewController(
        viewConfiguration: viewConfiguration,
        visibleDateTimeRange: ValueNotifier<DateTimeRange>(displayRange),
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
      final controller = CalendarController(initialDate: initialDate);

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: controller,
          viewConfiguration: viewConfiguration,
          callbacks: callbacks,
          body: CalendarBody(
            multiDayTileComponents: components,
            monthTileComponents: components,
            scheduleTileComponents: scheduleComponents,
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ScheduleBody), findsOneWidget);

      final jumpToDate = controller.jumpToDate;
      final animateToDate = controller.animateToDate;
      final animateToDateTime = controller.animateToDateTime;

      final repeatableFunctions = [
        jumpToDate,
        animateToDate,
        animateToDateTime,
      ];

      for (final function in repeatableFunctions) {
        // Test the start date.
        function.call(start);
        await tester.pumpAndSettle();
        expect(
          controller.visibleDateTimeRange.value.start,
          start,
          reason: '$function should set the visible range start to the start date',
        );
        expect(
          find.byKey(Key(eventsMap[start]!.toString())),
          findsOneWidget,
          reason: 'Event on start date should be visible ($function)',
        );
        var event = eventsController.byId(eventsMap[start]!);
        expect(
          controller.visibleEvents.value.contains(event),
          isTrue,
          reason: 'Event on start date should be in the visible events ($function)',
        );

        // Test the end date.
        function.call(end);
        await tester.pumpAndSettle();
        expect(
          end.isWithin(controller.visibleDateTimeRange.value, includeEnd: true),
          isTrue,
          reason: '$function should include the end date in the visible range',
        );
        expect(
          find.byKey(Key(eventsMap[end]!.toString())),
          findsOneWidget,
          reason: 'Event on end date should be visible ($function)',
        );
        event = eventsController.byId(eventsMap[end]!);
        expect(
          controller.visibleEvents.value.contains(event),
          isTrue,
          reason: 'Event on end date should be in the visible events ($function)',
        );

        // Test the initial date.
        function.call(initialDate);
        await tester.pumpAndSettle();
        expect(
          controller.visibleDateTimeRange.value.start,
          initialDate,
          reason: '$function should set the visible range start to the initial date',
        );
        expect(
          find.byKey(Key(eventsMap[initialDate]!.toString())),
          findsOneWidget,
          reason: 'Event on initial date should be visible ($function)',
        );
        event = eventsController.byId(eventsMap[initialDate]!);
        expect(
          controller.visibleEvents.value.contains(event),
          isTrue,
          reason: 'Event on initial date should be in the visible events ($function)',
        );
      }

      // Test animating to specific events.
      final firstEvent = eventsController.byId(eventsMap[start]!)!;
      final lastEvent = eventsController.byId(eventsMap[end]!)!;
      final middleEvent = eventsController.byId(eventsMap[initialDate]!)!;
      final eventsToTest = [firstEvent, lastEvent, middleEvent];

      for (final event in eventsToTest) {
        controller.animateToEvent(event);
        await tester.pumpAndSettle();
        expect(
          controller.visibleEvents.value.contains(event),
          isTrue,
          reason: 'Event ${event.id} should be in the visible events after animating to it',
        );
        expect(
          event.start.isWithin(controller.visibleDateTimeRange.value, includeEnd: true),
          isTrue,
          reason: 'Event start ${event.start} should be within the visible range after animating to it',
        );
      }
    });
  });
}
