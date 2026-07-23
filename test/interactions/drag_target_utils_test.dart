import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:timezone/data/latest_10y.dart';

/// A minimal [DragTargetUtilities] host used to exercise the mixin's pure
/// range-math helpers. Members that require a live widget tree throw, so only
/// the context-free helpers may be called against this harness.
class _DragUtilsHarness with DragTargetUtilities {
  _DragUtilsHarness({CalendarController? controller}) : controller = controller ?? CalendarController();

  @override
  BuildContext get context => throw UnimplementedError();

  @override
  final CalendarController controller;

  @override
  EventsController get eventsController => throw UnimplementedError();

  @override
  CalendarCallbacks? get callbacks => null;

  @override
  double get dayWidth => 0;

  @override
  List<DateTime> get visibleDates => const [];

  @override
  bool get multiDayDragTarget => false;

  @override
  CalendarEvent? rescheduleEvent(CalendarEvent event, InternalDateTime cursorDateTime) => throw UnimplementedError();

  @override
  CalendarEvent? resizeEvent(CalendarEvent event, ResizeDirection direction, InternalDateTime cursorDateTime) =>
      throw UnimplementedError();

  @override
  InternalDateTime? calculateCursorDateTime(Offset offset, {Offset feedbackWidgetOffset = Offset.zero}) =>
      throw UnimplementedError();
}

void main() {
  initializeTimeZones();

  final harness = _DragUtilsHarness();
  final range = DateTimeRange(start: DateTime.utc(2024, 1, 15, 10), end: DateTime.utc(2024, 1, 15, 12));

  CalendarEvent eventWithId(String id) {
    return CalendarEvent(
      id: id,
      dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 10)),
    );
  }

  // ─── calculateDateTimeRangeFromStart ─────────────────────────────────────────

  group('calculateDateTimeRangeFromStart', () {
    test('new start before end keeps the end and moves the start', () {
      final result = harness.calculateDateTimeRangeFromStart(range, DateTime.utc(2024, 1, 15, 9));
      expect(result.start.isAtSameMomentAs(DateTime.utc(2024, 1, 15, 9)), isTrue);
      expect(result.end.isAtSameMomentAs(DateTime.utc(2024, 1, 15, 12)), isTrue);
    });

    test('new start equal to end returns the original range', () {
      final result = harness.calculateDateTimeRangeFromStart(range, DateTime.utc(2024, 1, 15, 12));
      expect(result.start.isAtSameMomentAs(range.start), isTrue);
      expect(result.end.isAtSameMomentAs(range.end), isTrue);
    });

    test('new start after end swaps the boundaries', () {
      final result = harness.calculateDateTimeRangeFromStart(range, DateTime.utc(2024, 1, 15, 13));
      expect(result.start.isAtSameMomentAs(DateTime.utc(2024, 1, 15, 12)), isTrue);
      expect(result.end.isAtSameMomentAs(DateTime.utc(2024, 1, 15, 13)), isTrue);
    });
  });

  // ─── calculateDateTimeRangeFromEnd ───────────────────────────────────────────

  group('calculateDateTimeRangeFromEnd', () {
    test('new end after start keeps the start and moves the end', () {
      final result = harness.calculateDateTimeRangeFromEnd(range, DateTime.utc(2024, 1, 15, 13));
      expect(result.start.isAtSameMomentAs(DateTime.utc(2024, 1, 15, 10)), isTrue);
      expect(result.end.isAtSameMomentAs(DateTime.utc(2024, 1, 15, 13)), isTrue);
    });

    test('new end equal to start returns the original range', () {
      final result = harness.calculateDateTimeRangeFromEnd(range, DateTime.utc(2024, 1, 15, 10));
      expect(result.start.isAtSameMomentAs(range.start), isTrue);
      expect(result.end.isAtSameMomentAs(range.end), isTrue);
    });

    test('new end before start swaps the boundaries', () {
      final result = harness.calculateDateTimeRangeFromEnd(range, DateTime.utc(2024, 1, 15, 9));
      expect(result.start.isAtSameMomentAs(DateTime.utc(2024, 1, 15, 9)), isTrue);
      expect(result.end.isAtSameMomentAs(DateTime.utc(2024, 1, 15, 10)), isTrue);
    });
  });

  // ─── handleDragDetails (static dispatcher) ───────────────────────────────────

  group('handleDragDetails', () {
    String dispatch(Object? data, {CalendarEvent Function(CalendarEvent)? resolveEvent}) {
      return DragTargetUtilities.handleDragDetails<String, Object?>(
        DragTargetDetails(data: data, offset: Offset.zero),
        onCreate: (controllerId) => 'create:$controllerId',
        onResize: (event, direction) => 'resize:${event.id}:${direction.name}',
        onReschedule: (event) => 'reschedule:${event.id}',
        onOther: () => 'other',
        resolveEvent: resolveEvent,
      );
    }

    test('routes Create data to onCreate with the controller id', () {
      expect(dispatch(Create(controllerId: 42)), equals('create:42'));
    });

    test('routes Resize data to onResize with the event and direction', () {
      final data = Resize(event: eventWithId('e1'), direction: ResizeDirection.bottom);
      expect(dispatch(data), equals('resize:e1:bottom'));
    });

    test('routes Reschedule data to onReschedule with the event', () {
      expect(dispatch(Reschedule(event: eventWithId('e2'))), equals('reschedule:e2'));
    });

    test('routes unknown data to onOther', () {
      expect(dispatch('not-a-drag-payload'), equals('other'));
      expect(dispatch(null), equals('other'));
    });

    test('applies resolveEvent to the latest event for Resize/Reschedule', () {
      // resolveEvent swaps the stale event for the "live" one looked up by id.
      final live = eventWithId('live');
      CalendarEvent resolve(CalendarEvent _) => live;

      expect(
        dispatch(Resize(event: eventWithId('stale'), direction: ResizeDirection.top), resolveEvent: resolve),
        equals('resize:live:top'),
      );
      expect(dispatch(Reschedule(event: eventWithId('stale')), resolveEvent: resolve), equals('reschedule:live'));
    });

    test('falls back to the payload event when resolveEvent is null', () {
      expect(dispatch(Reschedule(event: eventWithId('payload'))), equals('reschedule:payload'));
    });
  });

  // ─── Create guard (foreign controller id) ────────────────────────────────────
  //
  // onAcceptWithDetails' onCreate handler must ignore Create payloads from a
  // *different* controller: the guard returns before reaching
  // calculateCursorDateTime (which throws in this harness), so a foreign create
  // completes without touching the widget tree. A regression here (e.g. a
  // `controllerId != controllerId` self-comparison) would fall through and
  // throw UnimplementedError.

  group('Create guard ignores a foreign controller id', () {
    test('onAcceptWithDetails returns normally for a foreign create', () {
      final host = _DragUtilsHarness();
      final foreign = Create(controllerId: host.controller.id + 1);
      expect(
        () => host.onAcceptWithDetails(DragTargetDetails(data: foreign, offset: Offset.zero)),
        returnsNormally,
      );
    });
  });
}
