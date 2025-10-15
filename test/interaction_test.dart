import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/day_event_tile.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';
import 'package:kalender/src/widgets/event_tiles/schedule_event_tile.dart';

import 'utilities.dart';

void main() {
  // TODO: add tests that ensure EventInteraction and CalendarInteraction works as expected.

  final eventsController = DefaultEventsController();
  final calendarController = CalendarController(initialDate: DateTime(2025));
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
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 23))),
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

  group('CalendarInteraction', () {
    testWidgets('MultiDayView', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: displayRange),
          header: CalendarHeader(interaction: interaction),
          body: CalendarBody(interaction: interaction),
        ),
      );

      expect(find.byType(MultiDayBody), findsOneWidget);

      expect(find.byKey(ResizeHandles.startResizeDraggableKey(dayEventID, Axis.vertical)), findsOneWidget);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(dayEventID, Axis.vertical)), findsOneWidget);
      expect(find.byKey(DayEventTile.rescheduleDraggableKey(dayEventID)), findsOneWidget);

      expect(find.byKey(ResizeHandles.startResizeDraggableKey(customDayEventID, Axis.vertical)), findsNothing);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(customDayEventID, Axis.vertical)), findsOneWidget);
      expect(find.byKey(DayEventTile.rescheduleDraggableKey(customDayEventID)), findsNothing);

      expect(find.byKey(ResizeHandles.startResizeDraggableKey(multiDayEventID, Axis.horizontal)), findsOneWidget);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(multiDayEventID, Axis.horizontal)), findsOneWidget);
      expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);

      expect(find.byKey(ResizeHandles.startResizeDraggableKey(customMultiDayEventID, Axis.horizontal)), findsNothing);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(customMultiDayEventID, Axis.horizontal)), findsOneWidget);
      expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
    });

    testWidgets('MonthView', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MonthViewConfiguration.singleMonth(displayRange: displayRange),
          header: CalendarHeader(interaction: interaction),
          body: CalendarBody(interaction: interaction),
        ),
      );

      expect(find.byType(MonthBody), findsOneWidget);

      expect(find.byKey(ResizeHandles.startResizeDraggableKey(multiDayEventID, Axis.horizontal)), findsOneWidget);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(multiDayEventID, Axis.horizontal)), findsOneWidget);
      expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);

      expect(find.byKey(ResizeHandles.startResizeDraggableKey(customMultiDayEventID, Axis.horizontal)), findsNothing);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(customMultiDayEventID, Axis.horizontal)), findsOneWidget);
      expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
    });
  });

  testWidgets('ScheduleView', (tester) async {
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
    expect(find.byKey(ScheduleEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);
    expect(find.byKey(ScheduleEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
  });
}
