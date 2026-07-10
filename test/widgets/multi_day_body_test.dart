import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;
import 'package:kalender/src/widgets/internal_components/positioned_time_indicator.dart';

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late CalendarCallbacks callbacks;

  final preciseInteraction = CalendarInteraction(
    inputMode: InputMode.precise,
    createEventGesture: CreateEventGesture.tap,
    modifyEventGesture: CreateEventGesture.tap,
  );

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
      onEventChanged: (event, updatedEvent) => eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
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
                interaction: preciseInteraction,
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

      // Regression: a vertical resize took its day from the cursor's horizontal
      // position, and the drag anchored to the handle's left edge (the column
      // boundary), so the smallest sideways drift flipped the event to the
      // neighbouring day. The handle now anchors to the pointer, so a small
      // drift stays in the same column while a deliberate move still changes the
      // day.
      testWidgets('bottom-handle resize with a small horizontal drift keeps the event on its day', (tester) async {
        // Week view, with the event on a middle day so it has a column on
        // either side.
        final weekConfiguration = viewConfigurations[1];
        final id = eventsController.addEvent(
          CalendarEvent(
            dateTimeRange: DateTimeRange(
              start: start.copyWith(day: start.day + 2, hour: 10),
              end: start.copyWith(day: start.day + 2, hour: 12),
            ),
          ),
        );

        await pumpCalendarView(tester, weekConfiguration);

        final tile = find.byKey(DayEventTile.tileKey(id));
        expect(tile, findsOneWidget, reason: 'the event tile should be rendered');

        final gesture = await tester.createMouseGesture();
        await tester.hoverOn(tile, gesture);

        final bottomHandle = find.descendant(
          of: tile,
          matching: find.byKey(ResizeHandles.endResizeDraggableKey(id)),
        );
        expect(bottomHandle, findsOneWidget, reason: 'the bottom resize handle should be rendered');

        final before = eventsController.events.firstWhere((event) => event.id == id).dateTimeRange;

        // Drag the handle down, with a small leftward drift that stays inside
        // the event's own column.
        await tester.dragFrom(tester.getCenter(bottomHandle), const Offset(-20, 40));
        await tester.pumpAndSettle();

        final after = eventsController.events.firstWhere((event) => event.id == id).dateTimeRange;
        expect(after.start, equals(before.start), reason: 'a bottom resize leaves the start untouched');
        expect(after.end.isAfter(before.end), isTrue, reason: 'the end should extend downward');
        expect(after.start.day, equals(before.start.day), reason: 'the event must stay on its own day');
        expect(after.end.day, equals(before.start.day), reason: 'the end must not spill onto the previous day');
      });
    });

    group('Imprecise Gesture Tests', () {
      final start = DateTime(2025, 3, 24);
      final end = DateTime(2025, 3, 31);
      final dateTimeRange = DateTimeRange(start: start, end: end);

      final impreciseInteraction = CalendarInteraction(
        inputMode: InputMode.imprecise,
        createEventGesture: CreateEventGesture.longPress,
        modifyEventGesture: CreateEventGesture.longPress,
      );

      final impreciseViewConfigurations = [
        MultiDayViewConfiguration.singleDay(
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

      Future<void> pumpImpreciseCalendarView(
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
                interaction: impreciseInteraction,
                multiDayTileComponents: components,
                monthTileComponents: components,
                scheduleTileComponents: scheduleComponents,
              ),
            ),
          );

      for (final viewConfiguration in impreciseViewConfigurations) {
        testWidgets('Event resize via selection - ${viewConfiguration.name}', (tester) async {
          await pumpImpreciseCalendarView(tester, viewConfiguration);
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          // Resize handles are not visible before selection.
          expect(
            find.descendant(of: dayEventTile, matching: find.byKey(ResizeHandles.endResizeDraggableKey(eventId))),
            findsNothing,
          );

          // Select event to show resize handles.
          final event = eventsController.events.firstWhere((e) => e.id == eventId);
          calendarController.selectEvent(event);
          await tester.pumpAndSettle();

          final bottomResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(ResizeHandles.endResizeDraggableKey(eventId)),
          );
          expect(bottomResizeHandle, findsOneWidget, reason: 'Bottom resize handle should show after selection');

          final initialBottomRight = tester.getBottomRight(dayEventTile);

          await tester.dragFrom(tester.getCenter(bottomResizeHandle), const Offset(0, 50));
          await tester.pumpAndSettle();

          expect(
            tester.getBottomRight(dayEventTile).dy > initialBottomRight.dy,
            isTrue,
            reason: 'Bottom right dy should increase after resize',
          );
        });

        testWidgets('Event reschedule via long-press drag - ${viewConfiguration.name}', (tester) async {
          await pumpImpreciseCalendarView(tester, viewConfiguration);
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          final initialPosition = tester.getCenter(dayEventTile);

          await tester.longPressDragWidget(dayEventTile, const Offset(0, 50));

          expect(tester.getCenter(dayEventTile) == initialPosition, isFalse);
        });

        testWidgets('New event via long-press drag - ${viewConfiguration.name}', (tester) async {
          await pumpImpreciseCalendarView(tester, viewConfiguration);
          expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody should be rendered');

          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          expect(dayEventTile, findsOneWidget, reason: 'DayEventTile should be rendered');

          final newEventStart = tester.getBottomLeft(dayEventTile) + const Offset(0, 25);
          await tester.longPressDrag(newEventStart, const Offset(0, 100));

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
