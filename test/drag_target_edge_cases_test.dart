import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/drag_targets/vertical_drag_target.dart';

import 'utilities.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Jan 6, 2025 is a Monday, so a week-view initialized here shows
/// Monday Jan 6 → Sunday Jan 12 in [visibleDates], giving deterministic
/// date assertions in all cursor-position tests.
final _weekInitialDate = DateTime(2025, 1, 6);

final _displayRange = DateTimeRange(start: DateTime(2025), end: DateTime(2026));

/// A calendar with year 2025 display range and initialDate safely inside it.
Future<dynamic> _pumpWeekView(
  WidgetTester tester, {
  EventsController? eventsController,
  TimeOfDayRange? timeOfDayRange,
}) async {
  await pumpAndSettleWithMaterialApp(
    tester,
    CalendarView(
      eventsController: eventsController ?? DefaultEventsController(),
      calendarController: CalendarController(),
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: _displayRange,
        initialDateTime: _weekInitialDate,
        timeOfDayRange: timeOfDayRange,
        initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
      ),
      body: const CalendarBody(),
    ),
  );
  return tester.state<State>(find.byType(VerticalDragTarget)) as dynamic;
}

/// Restricted time range 09:00–17:00 for boundary-clamping tests.
final _restrictedRange = TimeOfDayRange(
  start: const TimeOfDay(hour: 9, minute: 0),
  end: const TimeOfDay(hour: 17, minute: 0),
);

/// A single-day event (2 h) on Jan 6, 2025.
CalendarEvent _singleDayEvent({DateTime? start, DateTime? end}) => CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: start ?? DateTime(2025, 1, 6, 10, 0),
        end: end ?? DateTime(2025, 1, 6, 12, 0),
      ),
    );

/// A midnight-to-midnight event (always isMultiDayEvent).
CalendarEvent _multiDayEvent() => CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: DateTime(2025, 1, 6, 0, 0),
        end: DateTime(2025, 1, 7, 0, 0),
      ),
    );

DragTargetDetails<Object?> _dragDetails(Object? data) => DragTargetDetails(data: data, offset: Offset.zero);

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ────────────────────────────────────────────────────────────────────────────
  // 1. HorizontalDragTarget.onWillAcceptWithDetails  (pure unit tests – the
  //    static method never touches viewController so no widget is needed)
  // ────────────────────────────────────────────────────────────────────────────
  group('HorizontalDragTarget.onWillAcceptWithDetails', () {
    final controller = CalendarController();

    // MultiDayHeaderConfiguration: allowSingleDayEvents = false
    const headerConfig = MultiDayHeaderConfiguration();

    // MonthBodyConfiguration: allowSingleDayEvents = true
    final monthConfig = MonthBodyConfiguration();

    test('Create with matching controller id → true', () {
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Create(controllerId: controller.id)),
          controller,
          headerConfig,
        ),
        isTrue,
      );
    });

    test('Create with mismatched controller id → false', () {
      final other = CalendarController();
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Create(controllerId: other.id)),
          controller,
          headerConfig,
        ),
        isFalse,
      );
    });

    test('Resize right (horizontal) → true', () {
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Resize(event: _singleDayEvent(), direction: ResizeDirection.right)),
          controller,
          headerConfig,
        ),
        isTrue,
      );
    });

    test('Resize left (horizontal) → true', () {
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Resize(event: _singleDayEvent(), direction: ResizeDirection.left)),
          controller,
          headerConfig,
        ),
        isTrue,
      );
    });

    test('Resize bottom (vertical) → false', () {
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Resize(event: _singleDayEvent(), direction: ResizeDirection.bottom)),
          controller,
          headerConfig,
        ),
        isFalse,
      );
    });

    test('Reschedule single-day event, header config (allowSingleDayEvents=false) → false', () {
      final event = _singleDayEvent();
      expect(event.isMultiDayEvent, isFalse);
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Reschedule(event: event)),
          controller,
          headerConfig,
        ),
        isFalse,
      );
    });

    test('Reschedule single-day event, month body config (allowSingleDayEvents=true) → true', () {
      final event = _singleDayEvent();
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Reschedule(event: event)),
          controller,
          monthConfig,
        ),
        isTrue,
      );
    });

    test('Reschedule multi-day event, header config → true', () {
      final event = _multiDayEvent();
      expect(event.isMultiDayEvent, isTrue);
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Reschedule(event: event)),
          controller,
          headerConfig,
        ),
        isTrue,
      );
    });

    test('Unknown data type → false', () {
      expect(
        HorizontalDragTarget.onWillAcceptWithDetails(
          _dragDetails('not-a-recognized-drag-payload'),
          controller,
          headerConfig,
        ),
        isFalse,
      );
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // 2. VerticalDragTarget.onWillAcceptWithDetails  (widget tests – the static
  //    method reads viewController from the live controller)
  // ────────────────────────────────────────────────────────────────────────────
  group('VerticalDragTarget.onWillAcceptWithDetails', () {
    CalendarView weekCalendarView(CalendarController controller) => CalendarView(
          eventsController: DefaultEventsController(),
          calendarController: controller,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: _displayRange,
            initialDateTime: _weekInitialDate,
          ),
          body: const CalendarBody(),
        );

    testWidgets('Create with matching controller id → true', (tester) async {
      final controller = CalendarController();
      await pumpAndSettleWithMaterialApp(tester, weekCalendarView(controller));
      const config = MultiDayBodyConfiguration();

      expect(
        VerticalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Create(controllerId: controller.id)),
          controller,
          config,
        ),
        isTrue,
      );
    });

    testWidgets('Create with mismatched controller id → false', (tester) async {
      final controller = CalendarController();
      await pumpAndSettleWithMaterialApp(tester, weekCalendarView(controller));
      const config = MultiDayBodyConfiguration();
      final other = CalendarController();

      expect(
        VerticalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Create(controllerId: other.id)),
          controller,
          config,
        ),
        isFalse,
      );
    });

    testWidgets('Resize bottom (vertical) → true', (tester) async {
      final controller = CalendarController();
      await pumpAndSettleWithMaterialApp(tester, weekCalendarView(controller));
      const config = MultiDayBodyConfiguration();

      expect(
        VerticalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Resize(event: _singleDayEvent(), direction: ResizeDirection.bottom)),
          controller,
          config,
        ),
        isTrue,
      );
    });

    testWidgets('Resize left (horizontal) → false', (tester) async {
      final controller = CalendarController();
      await pumpAndSettleWithMaterialApp(tester, weekCalendarView(controller));
      const config = MultiDayBodyConfiguration();

      expect(
        VerticalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Resize(event: _singleDayEvent(), direction: ResizeDirection.left)),
          controller,
          config,
        ),
        isFalse,
      );
    });

    testWidgets('Reschedule event whose duration exceeds restricted timeOfDayRange → false', (tester) async {
      // Time range 09:00–17:00 has duration = 8h 1min.
      // An event from 08:00–18:00 (10 h) exceeds that, so it should be rejected.
      final controller = CalendarController();
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: DefaultEventsController(),
          calendarController: controller,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: _displayRange,
            initialDateTime: _weekInitialDate,
            timeOfDayRange: _restrictedRange,
          ),
          body: const CalendarBody(),
        ),
      );
      const config = MultiDayBodyConfiguration();

      // 10-hour event (> 8h 1min range duration) — still a single-day event
      final hugeEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(2025, 1, 6, 8, 0),
          end: DateTime(2025, 1, 6, 18, 0),
        ),
      );
      expect(hugeEvent.isMultiDayEvent, isFalse);

      expect(
        VerticalDragTarget.onWillAcceptWithDetails(
          _dragDetails(Reschedule(event: hugeEvent)),
          controller,
          config,
        ),
        isFalse,
      );
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // 3. VerticalDragTarget cursor clamping & positioning
  //
  //    Week view: initialDateTime = Jan 6, 2025 (Monday)
  //    → visibleDates = [Jan 6, Jan 7, Jan 8, Jan 9, Jan 10, Jan 11, Jan 12]
  // ────────────────────────────────────────────────────────────────────────────
  group('VerticalDragTarget cursor clamping', () {
    testWidgets('negative x (over timeline) clamps to first visible day (Jan 6)', (tester) async {
      final state = await _pumpWeekView(tester);
      final renderBox = tester.renderObject(find.byType(VerticalDragTarget)) as RenderBox;
      final origin = renderBox.localToGlobal(Offset.zero);

      final result = state.calculateCursorDateTime(Offset(origin.dx - 100, origin.dy + 50)) as InternalDateTime?;
      expect(result, isNotNull);
      expect(result!.year, equals(2025));
      expect(result.month, equals(1));
      expect(result.day, equals(6), reason: 'Should clamp to Jan 6 (first visible Monday)');
    });

    testWidgets('far-right x clamps to last visible day (Jan 12)', (tester) async {
      final state = await _pumpWeekView(tester);
      final renderBox = tester.renderObject(find.byType(VerticalDragTarget)) as RenderBox;
      final origin = renderBox.localToGlobal(Offset.zero);

      final result = state.calculateCursorDateTime(Offset(origin.dx + 10000, origin.dy + 50)) as InternalDateTime?;
      expect(result, isNotNull);
      expect(result!.year, equals(2025));
      expect(result.month, equals(1));
      expect(result.day, equals(12), reason: 'Should clamp to Jan 12 (last visible Sunday)');
    });

    testWidgets('all positions left of origin map to the same first day', (tester) async {
      final state = await _pumpWeekView(tester);
      final renderBox = tester.renderObject(find.byType(VerticalDragTarget)) as RenderBox;
      final origin = renderBox.localToGlobal(Offset.zero);

      for (final dx in [-1.0, -10.0, -50.0, -100.0, -500.0]) {
        final result = state.calculateCursorDateTime(Offset(origin.dx + dx, origin.dy + 50)) as InternalDateTime?;
        expect(result, isNotNull, reason: 'dx=$dx should return a date');
        expect(result!.day, equals(6), reason: 'dx=$dx should map to Jan 6 (first visible day)');
      }
    });

    testWidgets('column-centre positions map to correct days Jan 6–12', (tester) async {
      final state = await _pumpWeekView(tester);
      final renderBox = tester.renderObject(find.byType(VerticalDragTarget)) as RenderBox;
      final origin = renderBox.localToGlobal(Offset.zero);
      final dayWidth = state.dayWidth as double;

      // Expected: [Mon Jan 6, Tue Jan 7, ..., Sun Jan 12]
      const expectedDays = [6, 7, 8, 9, 10, 11, 12];

      for (var col = 0; col < 7; col++) {
        final cx = origin.dx + (col + 0.5) * dayWidth;
        final result = state.calculateCursorDateTime(Offset(cx, origin.dy + 50)) as InternalDateTime?;
        expect(result, isNotNull, reason: 'col=$col');
        expect(result!.month, equals(1), reason: 'col=$col should be January');
        expect(result.day, equals(expectedDays[col]), reason: 'col=$col should be Jan ${expectedDays[col]}');
      }
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // 4. VerticalDragTarget.resizeEvent
  // ────────────────────────────────────────────────────────────────────────────
  group('VerticalDragTarget resizeEvent', () {
    final eventStart = DateTime(2025, 1, 6, 10, 0);
    final eventEnd = DateTime(2025, 1, 6, 12, 0);

    testWidgets('ResizeDirection.bottom (vertical) extends event end → non-null', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(_singleDayEvent(start: eventStart, end: eventEnd));
      final state = await _pumpWeekView(tester, eventsController: ec);

      final event = ec.events.first;
      final cursor = InternalDateTime(2025, 1, 6, 14, 0);
      final result = state.resizeEvent(event, ResizeDirection.bottom, cursor);

      expect(result, isNotNull);
      expect(
        result.dateTimeRange.end.isAfter(event.dateTimeRange.end),
        isTrue,
        reason: 'End should move later with bottom resize',
      );
    });

    testWidgets('ResizeDirection.top (vertical) changes event start → non-null', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(_singleDayEvent(start: eventStart, end: eventEnd));
      final state = await _pumpWeekView(tester, eventsController: ec);

      final event = ec.events.first;
      // Place cursor at 11:00 (between original start and end)
      final cursor = InternalDateTime(2025, 1, 6, 11, 0);
      final result = state.resizeEvent(event, ResizeDirection.top, cursor);

      expect(result, isNotNull);
      expect(
        result.dateTimeRange.start.isAfter(event.dateTimeRange.start),
        isTrue,
        reason: 'Start should move later with top resize',
      );
    });

    testWidgets('ResizeDirection.left (horizontal) → null', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(_singleDayEvent(start: eventStart, end: eventEnd));
      final state = await _pumpWeekView(tester, eventsController: ec);

      final event = ec.events.first;
      final cursor = InternalDateTime(2025, 1, 6, 14, 0);
      expect(state.resizeEvent(event, ResizeDirection.left, cursor), isNull);
    });

    testWidgets('ResizeDirection.right (horizontal) → null', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(_singleDayEvent(start: eventStart, end: eventEnd));
      final state = await _pumpWeekView(tester, eventsController: ec);

      final event = ec.events.first;
      final cursor = InternalDateTime(2025, 1, 6, 14, 0);
      expect(state.resizeEvent(event, ResizeDirection.right, cursor), isNull);
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // 5. HorizontalDragTarget cursor clamping (month view)  (was 6)
  //
  //    Month view January 2025, initialDateTime = Jan 1.
  //    The first week row covers Mon Dec 30, 2024 → Sun Jan 5, 2025.
  //    find.byType(HorizontalDragTarget).first → that first row.
  // ────────────────────────────────────────────────────────────────────────────
  group('HorizontalDragTarget cursor clamping', () {
    Future<void> pumpMonthView(WidgetTester tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: DefaultEventsController(),
          calendarController: CalendarController(),
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: _displayRange,
            initialDateTime: DateTime(2025, 1, 1),
          ),
          body: const CalendarBody(),
        ),
      );
    }

    testWidgets('negative x clamps to first date in week row (Dec 30, 2024)', (tester) async {
      await pumpMonthView(tester);
      final finder = find.byType(HorizontalDragTarget);
      expect(finder, findsWidgets, reason: 'Month view should contain HorizontalDragTarget rows');

      final state = tester.state<State>(finder.first) as dynamic;
      final renderBox = tester.renderObject(finder.first) as RenderBox;
      final origin = renderBox.localToGlobal(Offset.zero);

      final result = state.calculateCursorDateTime(Offset(origin.dx - 100, origin.dy + 10)) as InternalDateTime?;
      expect(result, isNotNull);
      // First visible row of Jan 2025 starts on Dec 30, 2024 (Monday)
      expect(result!.day, equals(30));
      expect(result.month, equals(12));
      expect(result.year, equals(2024));
    });

    testWidgets('far-right x clamps to last date in week row (Jan 5, 2025)', (tester) async {
      await pumpMonthView(tester);
      final finder = find.byType(HorizontalDragTarget);
      final state = tester.state<State>(finder.first) as dynamic;
      final renderBox = tester.renderObject(finder.first) as RenderBox;
      final origin = renderBox.localToGlobal(Offset.zero);

      final result = state.calculateCursorDateTime(Offset(origin.dx + 10000, origin.dy + 10)) as InternalDateTime?;
      expect(result, isNotNull);
      // Last date of first row = Jan 5, 2025 (Sunday)
      expect(result!.day, equals(5));
      expect(result.month, equals(1));
      expect(result.year, equals(2025));
    });

    testWidgets('column-centre positions map to Dec 30 – Jan 5', (tester) async {
      await pumpMonthView(tester);
      final finder = find.byType(HorizontalDragTarget);
      final state = tester.state<State>(finder.first) as dynamic;
      final renderBox = tester.renderObject(finder.first) as RenderBox;
      final origin = renderBox.localToGlobal(Offset.zero);
      final dayWidth = state.dayWidth as double;

      // First row: [Dec 30, Dec 31, Jan 1, Jan 2, Jan 3, Jan 4, Jan 5]
      const expectedDays = [30, 31, 1, 2, 3, 4, 5];
      const expectedMonths = [12, 12, 1, 1, 1, 1, 1];

      for (var col = 0; col < 7; col++) {
        final cx = origin.dx + (col + 0.5) * dayWidth;
        final result = state.calculateCursorDateTime(Offset(cx, origin.dy + 10)) as InternalDateTime?;
        expect(result, isNotNull, reason: 'col=$col');
        expect(result!.day, equals(expectedDays[col]), reason: 'col=$col should be day ${expectedDays[col]}');
        expect(result.month, equals(expectedMonths[col]), reason: 'col=$col should be month ${expectedMonths[col]}');
      }
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // 6. HorizontalDragTarget.rescheduleEvent (month view)
  //    Verifies that rescheduling preserves the event's time-of-day and only
  //    changes the date, and that the allowSingleDayEvents guard is respected.
  // ────────────────────────────────────────────────────────────────────────────
  group('HorizontalDragTarget rescheduleEvent (month view)', () {
    Future<dynamic> pumpMonthState(WidgetTester tester, {EventsController? ec}) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: ec ?? DefaultEventsController(),
          calendarController: CalendarController(),
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: _displayRange,
            initialDateTime: DateTime(2025, 1, 1),
          ),
          body: const CalendarBody(),
        ),
      );
      return tester.state<State>(find.byType(HorizontalDragTarget).first) as dynamic;
    }

    testWidgets('single-day event: date changes but time-of-day is preserved', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(
        _singleDayEvent(
          start: DateTime(2025, 1, 6, 10, 0),
          end: DateTime(2025, 1, 6, 12, 0),
        ),
      );
      final state = await pumpMonthState(tester, ec: ec);

      final event = ec.events.first;
      // Move to Jan 9
      final cursor = InternalDateTime(2025, 1, 9);
      final result = state.rescheduleEvent(event, cursor) as CalendarEvent?;

      expect(result, isNotNull);
      expect(result!.dateTimeRange.start.day, equals(9), reason: 'Event date should change to Jan 9');
      expect(result.dateTimeRange.start.hour, equals(10), reason: 'Original 10:00 start hour should be preserved');
    });

    testWidgets('multi-day event: date changes but duration is preserved', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(_multiDayEvent());
      final state = await pumpMonthState(tester, ec: ec);

      final event = ec.events.first;
      expect(event.isMultiDayEvent, isTrue);

      final cursor = InternalDateTime(2025, 1, 9);
      final result = state.rescheduleEvent(event, cursor) as CalendarEvent?;

      expect(result, isNotNull);
      expect(
        result!.duration,
        equals(event.duration),
        reason: 'Duration should be preserved when moving a multi-day event',
      );
    });

    testWidgets('single-day event moved to a different week row → correct day', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(
        _singleDayEvent(
          start: DateTime(2025, 1, 6, 9, 30),
          end: DateTime(2025, 1, 6, 10, 30),
        ),
      );
      final state = await pumpMonthState(tester, ec: ec);

      final event = ec.events.first;
      // Jump to Jan 20
      final cursor = InternalDateTime(2025, 1, 20);
      final result = state.rescheduleEvent(event, cursor) as CalendarEvent?;

      expect(result, isNotNull);
      expect(result!.dateTimeRange.start.day, equals(20));
      expect(result.dateTimeRange.start.hour, equals(9));
      expect(result.dateTimeRange.start.minute, equals(30));
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // 7. Resize leave/re-enter regression
  //
  //    When a resize drag leaves a DragTarget, onLeave calls deselectEvent()
  //    which clears CalendarController.selectedEventId.  On re-entry,
  //    onWillAcceptWithDetails must call selectEvent() so that
  //    _DayDropTargetColumnState.build() can locate the event by id and
  //    *replace* it in-place rather than inserting a duplicate at position 0.
  //    A duplicate caused OverlapLayoutDelegate to crash with
  //    "Each child must be laid out exactly once".
  // ────────────────────────────────────────────────────────────────────────────
  group('Resize leave/re-enter restores selectedEventId (regression)', () {
    DragTarget<Object?> findDragTargetOf<T extends Widget>(WidgetTester tester) {
      return tester.widget<DragTarget<Object?>>(
        find
            .descendant(
              of: find.byType(T),
              matching: find.byWidgetPredicate((w) => w is DragTarget),
            )
            .first,
      );
    }

    testWidgets(
        'VerticalDragTarget: onLeave clears selectedEventId; '
        're-entry with Resize data restores it', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(_singleDayEvent());
      final controller = CalendarController();

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: ec,
          calendarController: controller,
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: _displayRange,
            initialDateTime: _weekInitialDate,
          ),
          body: const CalendarBody(),
        ),
      );

      final liveEvent = ec.events.first;

      // ── Step 1: simulate drag start ──────────────────────────────────────
      controller.selectEvent(liveEvent, internal: true);
      expect(controller.selectedEventId, equals(liveEvent.id));

      // ── Step 2: cursor leaves the widget (onLeave → deselectEvent) ───────
      final state = tester.state<State>(find.byType(VerticalDragTarget)) as dynamic;
      state.onLeave(Resize(event: liveEvent, direction: ResizeDirection.bottom));

      expect(controller.selectedEventId, isNull, reason: 'onLeave must clear selectedEventId');

      // ── Step 3: cursor re-enters with the same Resize data ───────────────
      // Before the fix the onResize handler in onWillAcceptWithDetails was a
      // no-op, so selectedEventId stayed null and _DayDropTargetColumnState
      // inserted a duplicate event, causing the layout delegate to crash.
      findDragTargetOf<VerticalDragTarget>(tester).onWillAcceptWithDetails!(
        _dragDetails(Resize(event: liveEvent, direction: ResizeDirection.bottom)),
      );

      expect(
        controller.selectedEventId,
        equals(liveEvent.id),
        reason: 'selectedEventId must be restored on re-entry so that '
            '_DayDropTargetColumnState does not insert a duplicate event',
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'HorizontalDragTarget: onLeave clears selectedEventId; '
        're-entry with Resize data restores it', (tester) async {
      final ec = DefaultEventsController();
      // Multi-day event so it lives in the HorizontalDragTarget (header/month).
      ec.addEvent(_multiDayEvent());
      final controller = CalendarController();

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: ec,
          calendarController: controller,
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: _displayRange,
            initialDateTime: DateTime(2025, 1, 1),
          ),
          body: const CalendarBody(),
        ),
      );

      final liveEvent = ec.events.first;

      // ── Step 1: simulate drag start ──────────────────────────────────────
      controller.selectEvent(liveEvent, internal: true);
      expect(controller.selectedEventId, equals(liveEvent.id));

      // ── Step 2: cursor leaves ────────────────────────────────────────────
      final state = tester.state<State>(find.byType(HorizontalDragTarget).first) as dynamic;
      state.onLeave(Resize(event: liveEvent, direction: ResizeDirection.right));

      expect(controller.selectedEventId, isNull, reason: 'onLeave must clear selectedEventId');

      // ── Step 3: cursor re-enters ─────────────────────────────────────────
      findDragTargetOf<HorizontalDragTarget>(tester).onWillAcceptWithDetails!(
        _dragDetails(Resize(event: liveEvent, direction: ResizeDirection.right)),
      );

      expect(controller.selectedEventId, equals(liveEvent.id), reason: 'selectedEventId must be restored on re-entry');

      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  // ────────────────────────────────────────────────────────────────────────────
  // 8. ScheduleDragTarget smoke tests
  // ────────────────────────────────────────────────────────────────────────────
  group('ScheduleDragTarget', () {
    testWidgets('continuous schedule view renders without exception', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 1, 6, 10),
            end: DateTime(2025, 1, 6, 12),
          ),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: ec,
          calendarController: CalendarController(),
          viewConfiguration: ScheduleViewConfiguration.continuous(
            displayRange: _displayRange,
            initialDateTime: DateTime(2025, 1, 6),
          ),
          body: const CalendarBody(),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('paginated schedule view renders without exception', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: DefaultEventsController(),
          calendarController: CalendarController(),
          viewConfiguration: ScheduleViewConfiguration.paginated(
            displayRange: _displayRange,
            initialDateTime: DateTime(2025, 1, 6),
          ),
          body: const CalendarBody(),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
