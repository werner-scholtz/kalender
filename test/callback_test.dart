import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';

import 'utilities.dart';

void main() {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();
  final displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));
  final interaction = ValueNotifier(
    CalendarInteraction(allowResizing: true, allowRescheduling: true, allowEventCreation: true),
  );

  group('Calendar Callbacks', () {
    testWidgets('MultiDayView', (tester) async {
      DateTime? onTapped;
      TapDetail? onTappedWithDetail;

      DateTime? onLongPressed;
      TapDetail? onLongPressedWithDetail;

      CalendarEvent? onEventChange;
      CalendarEvent? onEventChanged;

      CalendarEvent? onEventCreate;
      CalendarEvent? onEventCreated;

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.singleDay(
            displayRange: displayRange,
            initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
            selectedDate: DateTime(2025, 1, 1),
          ),
          callbacks: CalendarCallbacks(
            onTapped: (date) => onTapped = date,
            onTappedWithDetail: (details) => onTappedWithDetail = details,
            onLongPressed: (date) => onLongPressed = date,
            onLongPressedWithDetail: (details) => onLongPressedWithDetail = details,
            onEventChange: (event) => onEventChange = event,
            onEventChanged: (event, updatedEvent) => onEventChanged = updatedEvent,
            onEventCreate: (event) {
              onEventCreate = event;
              return event;
            },
            onEventCreated: (event) => onEventCreated = event,
          ),
          header: CalendarHeader(interaction: interaction),
          body: CalendarBody(interaction: interaction),
        ),
      );

      final body = find.byType(MultiDayBody);
      expect(body, findsOneWidget);

      expect(onTapped, isNull);
      expect(onTappedWithDetail, isNull);
      await tester.tapAt(tester.getCenter(body));
      expect(onTapped, DateTime(2025, 1, 1, 6, 30));
      expect(onTappedWithDetail, isNotNull);
      expect(onTappedWithDetail!.localOffset, const Offset(284, 272));
      expect(onTappedWithDetail!.renderBox.localToGlobal(Offset.zero), const Offset(116, 56));

      expect(onLongPressed, isNull);
      expect(onLongPressedWithDetail, isNull);
      await tester.longPressAt(tester.getCenter(body));
      expect(onLongPressed, isNotNull);
      expect(onLongPressedWithDetail, isNotNull);

      expect(onEventCreate, isNull);
      expect(onEventCreated, isNull);
      expect(onEventChange, isNull);
      expect(onEventChanged, isNull);
      await tester.dragFrom(tester.getCenter(body), const Offset(0, 100));
      expect(onEventChange, isNull);
      expect(onEventChanged, isNull);
      expect(onEventCreate, isNotNull);
      expect(onEventCreated, isNotNull);

      eventsController.clearEvents();
      await tester.pumpAndSettle();

      final id = eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 12))),
      );

      await tester.pumpAndSettle();

      final eventFinder = find.byKey(DayEventTile.tileKey(id));
      expect(eventFinder, findsOneWidget);
      expect(onEventChange, isNull);
      expect(onEventChanged, isNull);
      await tester.drag(eventFinder, const Offset(0, 100));
      expect(onEventChange, isNotNull);
      expect(onEventChanged, isNotNull);
    });

    testWidgets('MonthView', (tester) async {
      DateTime? onTapped;
      TapDetail? onTappedWithDetail;

      DateTime? onLongPressed;
      TapDetail? onLongPressedWithDetail;

      CalendarEvent? onEventChange;
      CalendarEvent? onEventChanged;

      CalendarEvent? onEventCreate;
      CalendarEvent? onEventCreated;

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration:
              MonthViewConfiguration.singleMonth(displayRange: displayRange, selectedDate: DateTime(2025, 1, 1)),
          callbacks: CalendarCallbacks(
            onTapped: (date) => onTapped = date,
            onTappedWithDetail: (details) => onTappedWithDetail = details,
            onLongPressed: (date) => onLongPressed = date,
            onLongPressedWithDetail: (details) => onLongPressedWithDetail = details,
            onEventChange: (event) => onEventChange = event,
            onEventChanged: (event, updatedEvent) => onEventChanged = updatedEvent,
            onEventCreate: (event) {
              onEventCreate = event;
              return event;
            },
            onEventCreated: (event) => onEventCreated = event,
          ),
          header: CalendarHeader(interaction: interaction),
          body: CalendarBody(interaction: interaction),
        ),
      );

      final body = find.byType(MonthBody);
      expect(body, findsOneWidget);

      expect(onTapped, isNull);
      expect(onTappedWithDetail, isNull);
      await tester.tapAt(tester.getCenter(body));
      expect(onTapped, isNotNull);
      expect(onTappedWithDetail, isNotNull);

      expect(onLongPressed, isNull);
      expect(onLongPressedWithDetail, isNull);
      await tester.longPressAt(tester.getCenter(body));
      expect(onLongPressed, isNotNull);
      expect(onLongPressedWithDetail, isNotNull);

      expect(onEventCreate, isNull);
      expect(onEventCreated, isNull);
      expect(onEventChange, isNull);
      expect(onEventChanged, isNull);
      await tester.dragFrom(tester.getCenter(body), const Offset(100, 0));
      expect(onEventChange, isNull);
      expect(onEventChanged, isNull);
      expect(onEventCreate, isNotNull);
      expect(onEventCreated, isNotNull);

      eventsController.clearEvents();
      await tester.pumpAndSettle();

      final id = eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 1, 1))),
      );

      await tester.pumpAndSettle();

      final eventFinder = find.byKey(MultiDayEventTile.tileKey(id));
      expect(eventFinder, findsOneWidget);
      expect(onEventChange, isNull);
      expect(onEventChanged, isNull);
      await tester.drag(eventFinder, const Offset(100, 0));
      expect(onEventChange, isNotNull);
      expect(onEventChanged, isNotNull);
    });
  });
}
