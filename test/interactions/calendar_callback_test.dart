import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  final interaction = CalendarInteraction(allowResizing: true, allowRescheduling: true, allowEventCreation: true);

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  /// Helper to pump a MultiDayView (single day) with the given callbacks.
  Future<void> pumpMultiDayView(
    WidgetTester tester, {
    required CalendarCallbacks callbacks,
  }) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(
          displayRange: year2025DisplayRange,
          initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
          initialDateTime: DateTime(2025, 1, 1),
        ),
        callbacks: callbacks,
        header: CalendarHeader(interaction: interaction),
        body: CalendarBody(interaction: interaction),
      ),
    );
  }

  /// Helper to pump a MonthView with the given callbacks.
  Future<void> pumpMonthView(
    WidgetTester tester, {
    required CalendarCallbacks callbacks,
  }) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MonthViewConfiguration.singleMonth(
          displayRange: year2025DisplayRange,
          initialDateTime: DateTime(2025, 1, 1),
        ),
        callbacks: callbacks,
        header: CalendarHeader(interaction: interaction),
        body: CalendarBody(interaction: interaction),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MultiDayView Tests
  // ---------------------------------------------------------------------------
  group('MultiDayView Callbacks', () {
    testWidgets('onTapped fires with correct date', (tester) async {
      DateTime? tappedDate;
      TapDetail? tappedDetail;

      await pumpMultiDayView(
        tester,
        callbacks: CalendarCallbacks(
          onTapped: (date) => tappedDate = date,
          onTappedWithDetail: (details) => tappedDetail = details,
        ),
      );

      final body = find.byType(MultiDayBody);
      expect(body, findsOneWidget);

      expect(tappedDate, isNull);
      expect(tappedDetail, isNull);

      await tester.tapAt(tester.getCenter(body));

      expect(tappedDate, DateTime(2025, 1, 1, 6, 30));
      expect(tappedDetail, isNotNull);
      expect(tappedDetail!.isDayDetail, isTrue);
      expect(tappedDetail!.localOffset.dx, greaterThan(0));
      expect(tappedDetail!.localOffset.dy, greaterThan(0));
      expect(tappedDetail!.renderBox.localToGlobal(Offset.zero).dx, greaterThanOrEqualTo(0));
      expect(tappedDetail!.renderBox.localToGlobal(Offset.zero).dy, greaterThanOrEqualTo(0));
    });

    testWidgets('onLongPressed fires', (tester) async {
      DateTime? longPressedDate;
      TapDetail? longPressedDetail;

      await pumpMultiDayView(
        tester,
        callbacks: CalendarCallbacks(
          onLongPressed: (date) => longPressedDate = date,
          onLongPressedWithDetail: (details) => longPressedDetail = details,
        ),
      );

      final body = find.byType(MultiDayBody);

      expect(longPressedDate, isNull);
      expect(longPressedDetail, isNull);

      await tester.longPressAt(tester.getCenter(body));

      expect(longPressedDate, isNotNull);
      expect(longPressedDetail, isNotNull);
      expect(longPressedDetail!.isDayDetail, isTrue);
    });

    testWidgets('drag-to-create fires onEventCreate and onEventCreated', (tester) async {
      CalendarEvent? createdEvent;
      CalendarEvent? createdConfirmed;

      await pumpMultiDayView(
        tester,
        callbacks: CalendarCallbacks(
          onEventCreate: (event) {
            createdEvent = event;
            return event;
          },
          onEventCreated: (event) => createdConfirmed = event,
        ),
      );

      final body = find.byType(MultiDayBody);

      expect(createdEvent, isNull);
      expect(createdConfirmed, isNull);

      await tester.dragFrom(tester.getCenter(body), const Offset(0, 100));

      expect(createdEvent, isNotNull);
      expect(createdConfirmed, isNotNull);
    });

    testWidgets('drag-to-create does NOT fire onEventChange/onEventChanged', (tester) async {
      CalendarEvent? changedBefore;
      CalendarEvent? changedAfter;

      await pumpMultiDayView(
        tester,
        callbacks: CalendarCallbacks(
          onEventCreate: (event) => event,
          onEventCreated: (_) {},
          onEventChange: (event) => changedBefore = event,
          onEventChanged: (_, updated) => changedAfter = updated,
        ),
      );

      final body = find.byType(MultiDayBody);
      await tester.dragFrom(tester.getCenter(body), const Offset(0, 100));

      expect(changedBefore, isNull);
      expect(changedAfter, isNull);
    });

    testWidgets('drag-to-reschedule fires onEventChange and onEventChanged', (tester) async {
      CalendarEvent? changedBefore;
      CalendarEvent? changedAfter;

      await pumpMultiDayView(
        tester,
        callbacks: CalendarCallbacks(
          onEventChange: (event) => changedBefore = event,
          onEventChanged: (_, updated) => changedAfter = updated,
        ),
      );

      final id = eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 12))),
      );
      await tester.pumpAndSettle();

      final eventFinder = find.byKey(DayEventTile.tileKey(id));
      expect(eventFinder, findsOneWidget);

      expect(changedBefore, isNull);
      expect(changedAfter, isNull);

      await tester.drag(eventFinder, const Offset(0, 100));

      expect(changedBefore, isNotNull);
      expect(changedAfter, isNotNull);
    });

    testWidgets('onEventTapped fires when tapping an event', (tester) async {
      CalendarEvent? tappedEvent;
      RenderBox? tappedRenderBox;
      TapDetail? tappedDetail;

      await pumpMultiDayView(
        tester,
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) {
            tappedEvent = event;
            tappedRenderBox = renderBox;
          },
          onEventTappedWithDetail: (event, renderBox, detail) {
            tappedDetail = detail;
          },
        ),
      );

      final id = eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 12))),
      );
      await tester.pumpAndSettle();

      final gestureDetector = find.byKey(DayEventTile.gestureDetectorKey(id));
      expect(gestureDetector, findsOneWidget);

      expect(tappedEvent, isNull);
      expect(tappedRenderBox, isNull);
      expect(tappedDetail, isNull);

      await tester.tap(gestureDetector);
      await tester.pumpAndSettle();

      expect(tappedEvent, isNotNull);
      expect(tappedEvent!.id, id);
      expect(tappedRenderBox, isNotNull);
      expect(tappedDetail, isNotNull);
      expect(tappedDetail!.isDayDetail, isTrue);
    });

    testWidgets('onPageChanged fires when navigating pages', (tester) async {
      DateTimeRange? changedRange;

      await pumpMultiDayView(
        tester,
        callbacks: CalendarCallbacks(
          onPageChanged: (range) => changedRange = range,
        ),
      );

      expect(changedRange, isNull);

      // Use jumpToDate instead of animateToNextPage to avoid animation that never settles.
      calendarController.jumpToDate(DateTime(2025, 1, 2));
      await tester.pumpAndSettle();

      expect(changedRange, isNotNull);
    });

    testWidgets('onEventCreate returning null falls back to default event', (tester) async {
      CalendarEvent? createdConfirmed;

      await pumpMultiDayView(
        tester,
        callbacks: CalendarCallbacks(
          onEventCreate: (event) => null, // Return null to use default event
          onEventCreated: (event) => createdConfirmed = event,
        ),
      );

      final body = find.byType(MultiDayBody);
      await tester.dragFrom(tester.getCenter(body), const Offset(0, 100));

      // When onEventCreate returns null, the library falls back to the default event
      // and onEventCreated still fires.
      expect(createdConfirmed, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  // MonthView Tests
  // ---------------------------------------------------------------------------
  group('MonthView Callbacks', () {
    testWidgets('onTapped fires with correct date', (tester) async {
      DateTime? tappedDate;
      TapDetail? tappedDetail;

      await pumpMonthView(
        tester,
        callbacks: CalendarCallbacks(
          onTapped: (date) => tappedDate = date,
          onTappedWithDetail: (details) => tappedDetail = details,
        ),
      );

      final body = find.byType(MonthBody);
      expect(body, findsOneWidget);

      expect(tappedDate, isNull);
      expect(tappedDetail, isNull);

      await tester.tapAt(tester.getCenter(body));

      expect(tappedDate, isNotNull);
      expect(tappedDetail, isNotNull);
      expect(tappedDetail!.isMultiDayDetail, isTrue);
    });

    testWidgets('onLongPressed fires', (tester) async {
      DateTime? longPressedDate;
      TapDetail? longPressedDetail;

      await pumpMonthView(
        tester,
        callbacks: CalendarCallbacks(
          onLongPressed: (date) => longPressedDate = date,
          onLongPressedWithDetail: (details) => longPressedDetail = details,
        ),
      );

      final body = find.byType(MonthBody);

      expect(longPressedDate, isNull);
      expect(longPressedDetail, isNull);

      await tester.longPressAt(tester.getCenter(body));

      expect(longPressedDate, isNotNull);
      expect(longPressedDetail, isNotNull);
      expect(longPressedDetail!.isMultiDayDetail, isTrue);
    });

    testWidgets('drag-to-create fires onEventCreate and onEventCreated', (tester) async {
      CalendarEvent? createdEvent;
      CalendarEvent? createdConfirmed;

      await pumpMonthView(
        tester,
        callbacks: CalendarCallbacks(
          onEventCreate: (event) {
            createdEvent = event;
            return event;
          },
          onEventCreated: (event) => createdConfirmed = event,
        ),
      );

      final body = find.byType(MonthBody);

      expect(createdEvent, isNull);
      expect(createdConfirmed, isNull);

      await tester.dragFrom(tester.getCenter(body), const Offset(100, 0));

      expect(createdEvent, isNotNull);
      expect(createdConfirmed, isNotNull);
    });

    testWidgets('drag-to-create does NOT fire onEventChange/onEventChanged', (tester) async {
      CalendarEvent? changedBefore;
      CalendarEvent? changedAfter;

      await pumpMonthView(
        tester,
        callbacks: CalendarCallbacks(
          onEventCreate: (event) => event,
          onEventCreated: (_) {},
          onEventChange: (event) => changedBefore = event,
          onEventChanged: (_, updated) => changedAfter = updated,
        ),
      );

      final body = find.byType(MonthBody);
      await tester.dragFrom(tester.getCenter(body), const Offset(100, 0));

      expect(changedBefore, isNull);
      expect(changedAfter, isNull);
    });

    testWidgets('drag-to-reschedule fires onEventChange and onEventChanged', (tester) async {
      CalendarEvent? changedBefore;
      CalendarEvent? changedAfter;

      await pumpMonthView(
        tester,
        callbacks: CalendarCallbacks(
          onEventChange: (event) => changedBefore = event,
          onEventChanged: (_, updated) => changedAfter = updated,
        ),
      );

      final id = eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 1, 1))),
      );
      await tester.pumpAndSettle();

      final eventFinder = find.byKey(MultiDayEventTile.tileKey(id));
      expect(eventFinder, findsOneWidget);

      expect(changedBefore, isNull);
      expect(changedAfter, isNull);

      await tester.drag(eventFinder, const Offset(100, 0));

      expect(changedBefore, isNotNull);
      expect(changedAfter, isNotNull);
    });

    testWidgets('onEventTapped fires when tapping an event', (tester) async {
      CalendarEvent? tappedEvent;
      RenderBox? tappedRenderBox;
      TapDetail? tappedDetail;

      await pumpMonthView(
        tester,
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) {
            tappedEvent = event;
            tappedRenderBox = renderBox;
          },
          onEventTappedWithDetail: (event, renderBox, detail) {
            tappedDetail = detail;
          },
        ),
      );

      final id = eventsController.addEvent(
        CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 1, 1))),
      );
      await tester.pumpAndSettle();

      final gestureDetector = find.byKey(MultiDayEventTile.gestureDetectorKey(id));
      expect(gestureDetector, findsOneWidget);

      expect(tappedEvent, isNull);
      expect(tappedRenderBox, isNull);
      expect(tappedDetail, isNull);

      await tester.tap(gestureDetector);
      await tester.pumpAndSettle();

      expect(tappedEvent, isNotNull);
      expect(tappedEvent!.id, id);
      expect(tappedRenderBox, isNotNull);
      expect(tappedDetail, isNotNull);
      expect(tappedDetail!.isMultiDayDetail, isTrue);
    });

    testWidgets('onPageChanged fires when navigating pages', (tester) async {
      DateTimeRange? changedRange;

      await pumpMonthView(
        tester,
        callbacks: CalendarCallbacks(
          onPageChanged: (range) => changedRange = range,
        ),
      );

      expect(changedRange, isNull);

      // Use jumpToDate instead of animateToNextPage to avoid animation that never settles.
      calendarController.jumpToDate(DateTime(2025, 2, 1));
      await tester.pumpAndSettle();

      expect(changedRange, isNotNull);
    });

    testWidgets('onEventCreate returning null falls back to default event', (tester) async {
      CalendarEvent? createdConfirmed;

      await pumpMonthView(
        tester,
        callbacks: CalendarCallbacks(
          onEventCreate: (event) => null, // Return null to use default event
          onEventCreated: (event) => createdConfirmed = event,
        ),
      );

      final body = find.byType(MonthBody);
      await tester.dragFrom(tester.getCenter(body), const Offset(100, 0));

      // When onEventCreate returns null, the library falls back to the default event
      // and onEventCreated still fires.
      expect(createdConfirmed, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Negative Tests
  // ---------------------------------------------------------------------------
  group('Empty Callbacks (negative tests)', () {
    testWidgets('MultiDayView renders and responds without callbacks', (tester) async {
      await pumpMultiDayView(tester, callbacks: const CalendarCallbacks());

      final body = find.byType(MultiDayBody);
      expect(body, findsOneWidget);

      // These interactions should not throw.
      await tester.tapAt(tester.getCenter(body));
      await tester.longPressAt(tester.getCenter(body));
      await tester.dragFrom(tester.getCenter(body), const Offset(0, 100));
    });

    testWidgets('MonthView renders and responds without callbacks', (tester) async {
      await pumpMonthView(tester, callbacks: const CalendarCallbacks());

      final body = find.byType(MonthBody);
      expect(body, findsOneWidget);

      // These interactions should not throw.
      await tester.tapAt(tester.getCenter(body));
      await tester.longPressAt(tester.getCenter(body));
      await tester.dragFrom(tester.getCenter(body), const Offset(100, 0));
    });
  });
}
