import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;
import 'package:kalender/src/widgets/internal_components/positioned_timeline.dart';

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late CalendarCallbacks callbacks;

  final components = TileComponents(
    tileBuilder: (event, tileRange) => Container(
      key: ValueKey(event.id),
      color: Colors.red,
    ),
  );
  final scheduleComponents = ScheduleTileComponents(
    tileBuilder: (event, tileRange) => Container(
      key: ValueKey(event.id),
      color: Colors.blue,
    ),
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    callbacks = CalendarCallbacks(
      onEventCreated: eventsController.addEvent,
      onEventChanged: (event, updatedEvent) =>
          eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
    );
  });

  group('MultiDayBody', () {
    group('Gesture Tests', () {
      final start = DateTime(2025, 3, 24);
      final end = DateTime(2025, 3, 31);
      final dateTimeRange = DateTimeRange(start: start, end: end);

      /// A list of different view configurations to test.
      final viewConfigurations = [
        MultiDayViewConfiguration.singleDay(
          initialTimeOfDay: const TimeOfDay(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
        MultiDayViewConfiguration.week(
          initialTimeOfDay: const TimeOfDay(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
        MultiDayViewConfiguration.week(
          firstDayOfWeek: DateTime.monday,
          timeOfDayRange: TimeOfDayRange(
            start: const TimeOfDay(hour: 5, minute: 0),
            end: const TimeOfDay(hour: 23, minute: 59),
          ),
          initialTimeOfDay: const TimeOfDay(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
      ];

      late String eventId;
      setUp(() {
        eventId = eventsController.addEvent(
          CalendarEvent(
            dateTimeRange: DateTimeRange(
              start: start.copyWith(hour: 6),
              end: start.copyWith(hour: 8),
            ),
          ),
        );
      });

      Future<void> pumpCalendarView(
        WidgetTester tester,
        MultiDayViewConfiguration viewConfiguration,
      ) =>
          pumpAndSettleWithMaterialApp(
            tester,
            CalendarView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: viewConfiguration,
              callbacks: callbacks,
              body: CalendarBody(
                multiDayTileComponents: components,
                monthTileComponents: components,
                scheduleTileComponents: scheduleComponents,
              ),
            ),
          );

      for (final viewConfiguration in viewConfigurations) {
        testWidgets('Event resize - ${viewConfiguration.name}', (tester) async {
          await pumpCalendarView(tester, viewConfiguration);
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          // Resize handles are only shown on hover for non-mobile devices.
          final gesture = await tester.createMouseGesture();

          // Check that the event is rendered.
          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          await tester.hoverOn(dayEventTile, gesture);
          final topResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(ResizeHandles.startResizeDraggableKey(eventId)),
          );
          expect(topResizeHandle, findsOneWidget, reason: 'Top resize handle should be rendered');
          final bottomResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(ResizeHandles.endResizeDraggableKey(eventId)),
          );
          expect(bottomResizeHandle, findsOneWidget, reason: 'Bottom resize handle should be rendered');

          final initialSize = tester.getSize(dayEventTile);
          final initialTopLeft = tester.getTopLeft(dayEventTile);
          final initialBottomRight = tester.getBottomRight(dayEventTile);

          await tester.dragFrom(tester.getCenter(bottomResizeHandle), const Offset(0, 50));
          await tester.pumpAndSettle();

          final size = tester.getSize(dayEventTile);
          final topLeft = tester.getTopLeft(dayEventTile);
          final bottomRight = tester.getBottomRight(dayEventTile);

          expect(initialSize.height < size.height, isTrue, reason: 'Height should increase');
          expect(initialTopLeft == topLeft, isTrue, reason: 'Top left should not change');
          expect(initialBottomRight.dy < bottomRight.dy, isTrue, reason: 'Bottom right dy should increase');
        });

        testWidgets('Event reschedule - ${viewConfiguration.name}', (tester) async {
          await pumpCalendarView(tester, viewConfiguration);
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          final rescheduleDraggable = find.descendant(
            of: dayEventTile,
            matching: find.byKey(DayEventTile.rescheduleDraggableKey(eventId)),
          );
          expect(rescheduleDraggable, findsOneWidget, reason: 'Reschedule draggable should be rendered');

          final initialPosition = tester.getCenter(dayEventTile);

          await tester.drag(dayEventTile, const Offset(0, 50));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(tester.getCenter(dayEventTile) == initialPosition, isFalse);
        });

        testWidgets('New event - ${viewConfiguration.name}', (tester) async {
          await pumpCalendarView(tester, viewConfiguration);
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          final newEventStart = tester.getBottomLeft(dayEventTile) + const Offset(0, 25);
          await tester.dragFrom(newEventStart, const Offset(0, 100));
          await tester.pumpAndSettle();

          expect(eventsController.events.length, 2, reason: 'There should be 2 events');
        });
      }
    });

    group('Day Separator Tests', () {
      /// A list of different view configurations to test.
      final viewConfigurations = [
        MultiDayViewConfiguration.singleDay(),
        MultiDayViewConfiguration.week(),
        MultiDayViewConfiguration.workWeek(),
        MultiDayViewConfiguration.freeScroll(numberOfDays: 2),
        MultiDayViewConfiguration.freeScroll(numberOfDays: 3),
      ];

      for (final viewConfiguration in viewConfigurations) {
        testWidgets('Day Separator - ${viewConfiguration.name}', (tester) async {
          await pumpAndSettleWithMaterialApp(
            tester,
            CalendarView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: viewConfiguration,
              callbacks: callbacks,
              body: CalendarBody(
                multiDayTileComponents: components,
                monthTileComponents: components,
                scheduleTileComponents: scheduleComponents,
              ),
            ),
          );
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');
          final expectedCount = viewConfiguration.type == MultiDayViewType.freeScroll
              ? viewConfiguration.numberOfDays
              : viewConfiguration.numberOfDays + 1;
          expect(
            find.byType(DaySeparator),
            findsNWidgets(expectedCount),
            reason: 'There should be $expectedCount DaySeparators',
          );
        });
      }
    });

    group('PositionedTimeIndicator Tests', () {
      final now = InternalDateTime.fromDateTime(DateTime.now());
      final start = now.startOfWeek();
      final end = now.endOfWeek();
      final range = InternalDateTimeRange(start: start, end: end);
      final visibleDates = range.dates();

      for (var weekday = 0; weekday < 7; weekday++) {
        final day = visibleDates[weekday];

        for (var i = 0; i < 24; i++) {
          final nowOverride = InternalDateTime.fromDateTime(
            start.copyWith(year: day.year, month: day.month, day: day.day, hour: i),
          );
          testWidgets('$nowOverride', (tester) async {
            const dayWidth = 50.0;
            await pumpAndSettleWithMaterialApp(
              tester,
              Stack(
                children: [
                  const SizedBox(width: dayWidth * 7),
                  PositionedTimeIndicator(
                    visibleDates: visibleDates,
                    dayWidth: dayWidth,
                    nowOverride: nowOverride,
                    child: const SizedBox(
                      width: dayWidth,
                      key: ValueKey('child'),
                    ),
                  ),
                ],
              ),
            );

            final child = find.byKey(const ValueKey('child'));
            expect(child, findsOneWidget);

            final childPosition = tester.getTopLeft(child);
            expect(
              childPosition,
              Offset(weekday * dayWidth, 0),
              reason: 'Child should be positioned correctly',
            );
          });
        }
      }
    });
  });
}
