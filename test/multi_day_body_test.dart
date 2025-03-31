import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/day_event_tile.dart' show DayEventTile;

import 'utilities.dart';

void main() {
  final eventsController = DefaultEventsController();
  final callbacks = CalendarCallbacks(onEventCreated: eventsController.addEvent);
  final components = TileComponents(
    tileBuilder: (event, tileRange) => Container(
      key: ValueKey(event.data as int?),
      color: Colors.red,
    ),
  );

  group('MultiDayBody', () {
    group('Gesture Tests', () {
      final start = DateTime(2025, 3, 24);
      final end = DateTime(2025, 3, 31);
      final dateTimeRange = DateTimeRange(start: start, end: end);
      final calendarController = CalendarController(initialDate: start);

      /// A list of different view configurations to test.
      final viewconfigurations = [
        MultiDayViewConfiguration.singleDay(
          initialTimeOfDay: const TimeOfDay(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
        ),
        MultiDayViewConfiguration.week(
          initialTimeOfDay: const TimeOfDay(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
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
        ),
      ];

      late int eventId;
      setUp(() {
        eventId = eventsController.addEvent(
          CalendarEvent(
            data: 1,
            dateTimeRange: DateTimeRange(
              start: start.copyWith(hour: 6),
              end: start.copyWith(hour: 8),
            ),
          ),
        );
      });

      tearDown(eventsController.clearEvents);

      for (final viewConfiguration in viewconfigurations) {
        testWidgets('Event resize', (tester) async {
          await tester.pumpWidget(
            wrapWithMaterialApp(
              CalendarView(
                eventsController: eventsController,
                calendarController: calendarController,
                viewConfiguration: viewConfiguration,
                callbacks: callbacks,
                body: CalendarBody(
                  multiDayTileComponents: components,
                  monthTileComponents: components,
                ),
              ),
            ),
          );

          await tester.pump();
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          // Check that the event is rendered.
          final dayEventTile = find.byKey(DayEventTile.getKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          // Find the resize handles.
          final topResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(DayEventTile.topResizeDraggable),
          );
          expect(topResizeHandle, findsOneWidget, reason: 'Top resize handle should be rendered');
          final bottomResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(DayEventTile.bottomResizeDraggable),
          );
          expect(bottomResizeHandle, findsOneWidget, reason: 'Bottom resize handle should be rendered');

          final initialSize = tester.getSize(dayEventTile);
          final initialTopLeft = tester.getTopLeft(dayEventTile);
          final initialBottomRight = tester.getBottomRight(dayEventTile);

          // Perform a resize action on the bottom resize handle.
          final bottomResizeHandleCenter = tester.getCenter(bottomResizeHandle);
          await tester.dragFrom(bottomResizeHandleCenter, const Offset(0, 50));
          await tester.pumpAndSettle();

          final size = tester.getSize(dayEventTile);
          final topLeft = tester.getTopLeft(dayEventTile);
          final bottomRight = tester.getBottomRight(dayEventTile);

          // Check that the size of the tile has changed.
          expect(initialSize.height < size.height, isTrue, reason: 'Height should increase');
          expect(initialTopLeft == topLeft, isTrue, reason: 'Top left should not change');
          expect(initialBottomRight.dy < bottomRight.dy, isTrue, reason: 'Bottom right dy should increase');
        });

        testWidgets('Event reschedule', (tester) async {
          await tester.pumpWidget(
            wrapWithMaterialApp(
              CalendarView(
                eventsController: eventsController,
                calendarController: calendarController,
                viewConfiguration: viewConfiguration,
                callbacks: callbacks,
                body: CalendarBody(
                  multiDayTileComponents: components,
                  monthTileComponents: components,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          // Check that the event is rendered.
          final dayEventTile = find.byKey(DayEventTile.getKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          final rescheduleDraggable = find.descendant(
            of: dayEventTile,
            matching: find.byKey(DayEventTile.rescheduleDraggable),
          );

          // Check that the draggable(s) widget is rendered.
          expect(rescheduleDraggable, findsOneWidget, reason: 'Reschedule draggable should be rendered');

          final initialPosition = tester.getCenter(dayEventTile);

          await tester.drag(dayEventTile, const Offset(0, 50));
          // await tester.dragFrom(tester.getCenter(dayEventTile), const Offset(0, 50));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          final position = tester.getCenter(dayEventTile);

          // Check that the position of the tile has changed.
          expect(initialPosition == position, isFalse);
        });

        testWidgets('New event', (tester) async {
          await tester.pumpWidget(
            wrapWithMaterialApp(
              CalendarView(
                eventsController: eventsController,
                calendarController: calendarController,
                viewConfiguration: viewConfiguration,
                callbacks: callbacks,
                body: CalendarBody(
                  multiDayTileComponents: components,
                  monthTileComponents: components,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          // Check that the event is rendered.
          final dayEventTile = find.byKey(DayEventTile.getKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          // get the bottom of the dayEventTile
          final bottomOfExistingEvent = tester.getBottomLeft(dayEventTile);
          final newEventStart = bottomOfExistingEvent + const Offset(0, 25);
          await tester.dragFrom(newEventStart, const Offset(0, 100));
          await tester.pumpAndSettle();

          expect(eventsController.events.length, 2, reason: 'There should be 2 events');
        });
      }
    });

    group('Layout Tests', () {
      late DateTime now;
      late CalendarController calendarController;
      setUp(() {
        now = DateTime.now();
        calendarController = CalendarController(initialDate: now);
      });

      testWidgets('Time Indicator (singleDay)', (tester) async {
        final viewConfiguration = MultiDayViewConfiguration.singleDay(initialHeightPerMinute: 0.5);
        await tester.pumpWidget(
          wrapWithMaterialApp(
            CalendarView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: viewConfiguration,
              callbacks: callbacks,
              body: CalendarBody(
                multiDayTileComponents: components,
                monthTileComponents: components,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');
        final timeIndicator = find.byType(TimeIndicator);
        expect(timeIndicator, findsOneWidget, reason: 'TimeIndicator should be rendered');
      });

      testWidgets('Time Indicator (week)', (tester) async {
        final viewConfiguration = MultiDayViewConfiguration.week(initialHeightPerMinute: 0.5);

        await tester.pumpWidget(
          wrapWithMaterialApp(
            CalendarView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: viewConfiguration,
              callbacks: callbacks,
              body: CalendarBody(
                multiDayTileComponents: components,
                monthTileComponents: components,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

        final content = find.byKey(MultiDayBody.contentKey);
        final contentLeft = tester.getTopLeft(content);
        final contentSize = tester.getSize(content);
        final dayWidth = contentSize.width / 7;

        final timeIndicator = find.byType(TimeIndicator);
        expect(timeIndicator, findsOneWidget, reason: 'TimeIndicator should be rendered');

        final timeIndicatorLeft = tester.getTopLeft(timeIndicator);
        final expectedLeft = contentLeft.dx + dayWidth * (now.weekday - 1);

        expect(timeIndicatorLeft.dx == expectedLeft, isTrue);
      });
    });
  });
}
