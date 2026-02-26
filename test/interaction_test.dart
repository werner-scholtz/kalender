import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';

import 'utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));
  final interaction = CalendarInteraction(allowResizing: true, allowRescheduling: true, allowEventCreation: true);

  late String dayEventID;
  late String multiDayEventID;
  late String customDayEventID;
  late String customMultiDayEventID;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();

    dayEventID = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 4))),
    );
    multiDayEventID = eventsController.addEvent(
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 2))),
    );
    customDayEventID = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 23)),
        interaction: EventInteraction(allowEndResize: true, allowStartResize: false, allowRescheduling: false),
      ),
    );
    customMultiDayEventID = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 2)),
        interaction: EventInteraction(allowEndResize: true, allowStartResize: false, allowRescheduling: false),
      ),
    );
  });

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> pumpMultiDayView(WidgetTester tester) => pumpAndSettleWithMaterialApp(
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

  Future<void> pumpMonthView(WidgetTester tester) => pumpAndSettleWithMaterialApp(
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

  Future<void> pumpScheduleView(WidgetTester tester) => pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: ScheduleViewConfiguration.continuous(displayRange: displayRange),
          header: CalendarHeader(interaction: interaction),
          body: CalendarBody(interaction: interaction),
        ),
      );

  // ---------------------------------------------------------------------------
  // MultiDayView
  // ---------------------------------------------------------------------------

  group('MultiDayView interaction', () {
    testWidgets('default events show all interaction handles', (tester) async {
      await pumpMultiDayView(tester);
      expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody not found');

      // Resize handles are only shown on hover for non-mobile devices.
      final gesture = await tester.createMouseGesture();

      final dayTile = find.byKey(DayEventTile.tileKey(dayEventID));
      expect(dayTile, findsOneWidget, reason: 'DayEventTile with id $dayEventID not found');
      await tester.hoverOn(dayTile, gesture);
      expect(find.byKey(DayEventTile.rescheduleDraggableKey(dayEventID)), findsOneWidget);
      expect(find.byKey(ResizeHandles.startResizeDraggableKey(dayEventID)), findsOneWidget);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(dayEventID)), findsOneWidget);

      final multiDayTile = find.byKey(MultiDayEventTile.tileKey(multiDayEventID));
      expect(multiDayTile, findsOneWidget, reason: 'MultiDayEventTile with id $multiDayEventID not found');
      await tester.hoverOn(multiDayTile, gesture);
      expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);
      expect(find.byKey(ResizeHandles.startResizeDraggableKey(multiDayEventID)), findsOneWidget);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(multiDayEventID)), findsOneWidget);
    });

    testWidgets('custom events respect per-event interaction overrides', (tester) async {
      await pumpMultiDayView(tester);
      expect(find.byType(MultiDayBody), findsOneWidget, reason: 'MultiDayBody not found');

      final gesture = await tester.createMouseGesture();

      // allowRescheduling: false, allowStartResize: false, allowEndResize: true
      final customDayTile = find.byKey(DayEventTile.tileKey(customDayEventID));
      expect(customDayTile, findsOneWidget, reason: 'DayEventTile with id $customDayEventID not found');
      await tester.hoverOn(customDayTile, gesture);
      expect(find.byKey(DayEventTile.rescheduleDraggableKey(customDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.startResizeDraggableKey(customDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(customDayEventID)), findsOneWidget);

      final customMultiDayTile = find.byKey(MultiDayEventTile.tileKey(customMultiDayEventID));
      expect(customMultiDayTile, findsOneWidget, reason: 'MultiDayEventTile with id $customMultiDayEventID not found');
      await tester.hoverOn(customMultiDayTile, gesture);
      expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.startResizeDraggableKey(customMultiDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(customMultiDayEventID)), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // MonthView
  // ---------------------------------------------------------------------------

  group('MonthView interaction', () {
    testWidgets('default event shows all interaction handles', (tester) async {
      await pumpMonthView(tester);
      expect(find.byType(MonthBody), findsOneWidget, reason: 'MonthBody not found');

      final gesture = await tester.createMouseGesture();

      final tile = find.byKey(MultiDayEventTile.tileKey(multiDayEventID));
      expect(tile, findsOneWidget, reason: 'MultiDayEventTile with id $multiDayEventID not found');
      await tester.hoverOn(tile, gesture);
      expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);
      expect(find.byKey(ResizeHandles.startResizeDraggableKey(multiDayEventID)), findsOneWidget);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(multiDayEventID)), findsOneWidget);
    });

    testWidgets('custom event respects per-event interaction overrides', (tester) async {
      await pumpMonthView(tester);
      expect(find.byType(MonthBody), findsOneWidget, reason: 'MonthBody not found');

      final gesture = await tester.createMouseGesture();

      // allowRescheduling: false, allowStartResize: false, allowEndResize: true
      final customTile = find.byKey(MultiDayEventTile.tileKey(customMultiDayEventID));
      expect(customTile, findsOneWidget, reason: 'MultiDayEventTile with id $customMultiDayEventID not found');
      await tester.hoverOn(customTile, gesture);
      expect(find.byKey(MultiDayEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.startResizeDraggableKey(customMultiDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(customMultiDayEventID)), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // ScheduleView
  // ---------------------------------------------------------------------------

  group('ScheduleView interaction', () {
    testWidgets('default event shows reschedule handle but no resize handles', (tester) async {
      await pumpScheduleView(tester);
      expect(find.byType(ScheduleBody), findsOneWidget, reason: 'ScheduleBody not found');

      final gesture = await tester.createMouseGesture();

      final tile = find.byKey(ScheduleEventTile.tileKey(multiDayEventID));
      expect(tile, findsOneWidget, reason: 'ScheduleEventTile with id $multiDayEventID not found');
      await tester.hoverOn(tile, gesture);
      expect(find.byKey(ScheduleEventTile.rescheduleDraggableKey(multiDayEventID)), findsOneWidget);
      expect(find.byKey(ResizeHandles.startResizeDraggableKey(multiDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(multiDayEventID)), findsNothing);
    });

    testWidgets('custom event suppresses all interaction handles', (tester) async {
      await pumpScheduleView(tester);
      expect(find.byType(ScheduleBody), findsOneWidget, reason: 'ScheduleBody not found');

      final gesture = await tester.createMouseGesture();

      final customTile = find.byKey(ScheduleEventTile.tileKey(customMultiDayEventID));
      expect(customTile, findsOneWidget, reason: 'ScheduleEventTile with id $customMultiDayEventID not found');
      await tester.hoverOn(customTile, gesture);
      expect(find.byKey(ScheduleEventTile.rescheduleDraggableKey(customMultiDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.startResizeDraggableKey(customMultiDayEventID)), findsNothing);
      expect(find.byKey(ResizeHandles.endResizeDraggableKey(customMultiDayEventID)), findsNothing);
    });
  });
}
