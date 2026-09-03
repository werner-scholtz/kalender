import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late KalenderController calendarController;
  late KalenderCallbacks callbacks;

  final preciseInteraction = KalenderInteraction(
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );

  final components = TileComponents(
    tileBuilder: (context, event, tileRange) => Container(
      key: ValueKey(event.id),
      color: Colors.red,
    ),
  );
  final scheduleComponents = ScheduleTileComponents(
    tileBuilder: (context, event, tileRange) => Container(
      key: ValueKey(event.id),
      color: Colors.blue,
    ),
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = KalenderController();
    callbacks = KalenderCallbacks(
      onEventCreated: eventsController.addEvent,
      onEventChanged: (event, updatedEvent) => eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
    );
  });

  group('MultiDayBody', () {
    group('Gesture Tests', () {
      final start = DateTime(2025, 3, 24);
      final end = DateTime(2025, 3, 31);
      final dateTimeRange = KalenderDateTimeRange(start: start, end: end);

      /// A list of different view configurations to test.
      final viewConfigurations = [
        MultiDayViewConfiguration.singleDay(
          initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
        MultiDayViewConfiguration.week(
          initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
        MultiDayViewConfiguration.week(
          firstDayOfWeek: DateTime.monday,
          timeOfDayRange: KalenderTimeRange(
            start: const KalenderTime(hour: 5, minute: 0),
            end: const KalenderTime(hour: 23, minute: 59),
          ),
          initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
      ];

      late String eventId;
      setUp(() {
        eventId = eventsController.addEvent(
          KalenderEvent(
            start: start.copyWith(hour: 6),
            end: start.copyWith(hour: 8),
          ),
        );
      });

      Future<void> pumpCalendarView(
        WidgetTester tester,
        MultiDayViewConfiguration viewConfiguration,
      ) =>
          pumpAndSettleWithMaterialApp(
            tester,
            KalenderView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: viewConfiguration,
              callbacks: callbacks,
              body: KalenderBody(
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
            matching: find.byKey(ResizeDetector.startResizeDraggableKey(eventId)),
          );
          expect(topResizeHandle, findsOneWidget, reason: 'Top resize handle should be rendered');
          final bottomResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(ResizeDetector.endResizeDraggableKey(eventId)),
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
          KalenderEvent(
            start: start.copyWith(day: start.day + 2, hour: 10),
            end: start.copyWith(day: start.day + 2, hour: 12),
          ),
        );

        await pumpCalendarView(tester, weekConfiguration);

        final tile = find.byKey(DayEventTile.tileKey(id));
        expect(tile, findsOneWidget, reason: 'the event tile should be rendered');

        final gesture = await tester.createMouseGesture();
        await tester.hoverOn(tile, gesture);

        final bottomHandle = find.descendant(
          of: tile,
          matching: find.byKey(ResizeDetector.endResizeDraggableKey(id)),
        );
        expect(bottomHandle, findsOneWidget, reason: 'the bottom resize handle should be rendered');

        final before = eventsController.events.firstWhere((event) => event.id == id).dateTimeRange;

        // Drag the handle down, with a small leftward drift that stays inside
        // the event's own column.
        await tester.dragFrom(tester.getCenter(bottomHandle), const Offset(-20, 40));
        await tester.pumpAndSettle();

        final after = eventsController.events.firstWhere((event) => event.id == id).dateTimeRange;
        // Compare instants, not calendar fields: the stored range is in UTC, so
        // in far-east timezones the local day and the UTC day differ. The
        // day-flip bug moves the start, so an unchanged start is the robust
        // signal that it stayed on its own day.
        expect(
          after.start.isAtSameMomentAs(before.start),
          isTrue,
          reason: 'a bottom resize leaves the start where it was; it must not flip to another day',
        );
        expect(after.end.isAfter(before.end), isTrue, reason: 'the end should extend downward');
      });
    });

    group('Imprecise Gesture Tests', () {
      final start = DateTime(2025, 3, 24);
      final end = DateTime(2025, 3, 31);
      final dateTimeRange = KalenderDateTimeRange(start: start, end: end);

      final impreciseInteraction = KalenderInteraction(
        inputMode: InputMode.imprecise,
        createEventGesture: EventInteractionGesture.longPress,
        modifyEventGesture: EventInteractionGesture.longPress,
      );

      final impreciseViewConfigurations = [
        MultiDayViewConfiguration.singleDay(
          initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
      ];

      late String eventId;
      setUp(() {
        eventId = eventsController.addEvent(
          KalenderEvent(
            start: start.copyWith(hour: 6),
            end: start.copyWith(hour: 8),
          ),
        );
      });

      Future<void> pumpImpreciseCalendarView(
        WidgetTester tester,
        MultiDayViewConfiguration viewConfiguration,
      ) =>
          pumpAndSettleWithMaterialApp(
            tester,
            KalenderView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: viewConfiguration,
              callbacks: callbacks,
              body: KalenderBody(
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
            find.descendant(of: dayEventTile, matching: find.byKey(ResizeDetector.endResizeDraggableKey(eventId))),
            findsNothing,
          );

          // Select event to show resize handles.
          final event = eventsController.events.firstWhere((e) => e.id == eventId);
          calendarController.selectEvent(event);
          await tester.pumpAndSettle();

          final bottomResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(ResizeDetector.endResizeDraggableKey(eventId)),
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
            KalenderView(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: viewConfiguration,
              callbacks: callbacks,
              body: KalenderBody(
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
  });
}
