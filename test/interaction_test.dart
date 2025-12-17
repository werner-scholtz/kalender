import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';

import 'utilities.dart';

void main() {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();
  final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));
  final interaction = ValueNotifier(
    CalendarInteraction(allowResizing: true, allowRescheduling: true, allowEventCreation: true),
  );

  late int dayEventID;
  late int multiDayEventID;

  late int customDayEventID;
  late int customMultiDayEventID;

  setUpAll(() {
    dayEventID = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 4))),
    );
    multiDayEventID = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 2))),
    );

    customDayEventID = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 23)),
        interaction: EventInteraction(
          allowEndResize: true,
          allowStartResize: false,
          allowRescheduling: false,
        ),
      ),
    );

    customMultiDayEventID = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 2)),
        interaction: EventInteraction(
          allowEndResize: true,
          allowStartResize: false,
          allowRescheduling: false,
        ),
      ),
    );
  });

  testWidgets('MultiDayView test', (tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(
          displayRange: displayRange,
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          initialDateTime: DateTime(2025, 1, 1),
        ),
        header: CalendarHeader(interaction: interaction),
        body: CalendarBody(interaction: interaction),
      ),
    );

    expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody not found');

    // Create a mouse gesture to hover over the event tile.
    // This is needed because resize handles are only shown on hover for non-mobile devices.
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    var tile = find.byKey(DayEventTile.tileKey(dayEventID));
    expect(tile, findsOneWidget, reason: 'DayEventTile with id $dayEventID not found');
    await tester.hoverOn(tile, gesture);
    expect(find.byKey(DayEventTile.rescheduleDraggableKey(dayEventID)), findsOneWidget);
    expect(find.byKey(ResizeHandles.startResizeDraggableKey(dayEventID)), findsOneWidget);
    expect(find.byKey(ResizeHandles.endResizeDraggableKey(dayEventID)), findsOneWidget);

    tile = find.byKey(DayEventTile.tileKey(customDayEventID));
    expect(tile, findsOneWidget, reason: 'Custom DayEventTile with id $customDayEventID not found');
    await tester.hoverOn(tile, gesture);
    expect(find.byKey(DayEventTile.rescheduleDraggableKey(customDayEventID)), findsNothing);
    expect(find.byKey(ResizeHandles.startResizeDraggableKey(customDayEventID)), findsNothing);
    expect(find.byKey(ResizeHandles.endResizeDraggableKey(customDayEventID)), findsOneWidget);

    tile = find.byKey(MultiDayEventTile.tileKey(multiDayEventID));
    expect(tile, findsOneWidget, reason: 'MultiDayEventTile with id $multiDayEventID not found');
    await tester.hoverOn(tile, gesture);
    expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);
    expect(find.byKey(ResizeHandles.startResizeDraggableKey(multiDayEventID)), findsOneWidget);
    expect(find.byKey(ResizeHandles.endResizeDraggableKey(multiDayEventID)), findsOneWidget);

    tile = find.byKey(MultiDayEventTile.tileKey(customMultiDayEventID));
    expect(tile, findsOneWidget, reason: 'Custom MultiDayEventTile with id $customMultiDayEventID not found');
    await tester.hoverOn(tile, gesture);
    expect(find.byKey(ResizeHandles.startResizeDraggableKey(customMultiDayEventID)), findsNothing);
    expect(find.byKey(ResizeHandles.endResizeDraggableKey(customMultiDayEventID)), findsOneWidget);
    expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
  });

  testWidgets('MonthView test', (tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MonthViewConfiguration.singleMonth(
          displayRange: displayRange,
          initialDateTime: DateTime(2025),
        ),
        header: CalendarHeader(interaction: interaction),
        body: CalendarBody(interaction: interaction),
      ),
    );

    expect(find.byType(MonthBody), findsOneWidget, reason: 'MonthBody not found');

    // Create a mouse gesture to hover over the event tile.
    // This is needed because resize handles are only shown on hover for non-mobile devices.
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    var tile = find.byKey(MultiDayEventTile.tileKey(multiDayEventID));
    expect(tile, findsOneWidget, reason: 'MultiDayEventTile with id $multiDayEventID not found');
    await tester.hoverOn(tile, gesture);
    expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);
    expect(find.byKey(ResizeHandles.startResizeDraggableKey(multiDayEventID)), findsOneWidget);
    expect(find.byKey(ResizeHandles.endResizeDraggableKey(multiDayEventID)), findsOneWidget);

    tile = find.byKey(MultiDayEventTile.tileKey(customMultiDayEventID));
    expect(tile, findsOneWidget, reason: 'Custom MultiDayEventTile with id $customMultiDayEventID not found');
    await tester.hoverOn(tile, gesture);
    expect(find.byKey(ResizeHandles.startResizeDraggableKey(customMultiDayEventID)), findsNothing);
    expect(find.byKey(ResizeHandles.endResizeDraggableKey(customMultiDayEventID)), findsOneWidget);
    expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
  });

  testWidgets('ScheduleView test', (tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: ScheduleViewConfiguration.continuous(),
        header: CalendarHeader(interaction: interaction),
        body: CalendarBody(interaction: interaction),
      ),
    );

    expect(find.byType(ScheduleBody), findsOneWidget);

    // Create a mouse gesture to hover over the event tile.
    // This is needed because resize handles are only shown on hover for non-mobile devices.
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    var tile = find.byKey(ScheduleEventTile.tileKey(multiDayEventID));
    expect(tile, findsOneWidget, reason: 'ScheduleEventTile with id $multiDayEventID not found');
    await tester.hoverOn(tile, gesture);
    expect(find.byKey(ScheduleEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);
    expect(find.byKey(ResizeHandles.startResizeDraggableKey(multiDayEventID)), findsNothing);
    expect(find.byKey(ResizeHandles.endResizeDraggableKey(multiDayEventID)), findsNothing);

    tile = find.byKey(ScheduleEventTile.tileKey(customMultiDayEventID));
    expect(tile, findsOneWidget, reason: 'Custom ScheduleEventTile with id $customMultiDayEventID not found');
    await tester.hoverOn(tile, gesture);
    expect(find.byKey(ResizeHandles.startResizeDraggableKey(customMultiDayEventID)), findsNothing);
    expect(find.byKey(ResizeHandles.endResizeDraggableKey(customMultiDayEventID)), findsNothing);
    expect(find.byKey(ScheduleEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
  });
}
