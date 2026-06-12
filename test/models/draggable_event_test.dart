import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';

void main() {
  CalendarEvent makeEvent({String id = 'e1'}) => CalendarEvent(
        id: id,
        dateTimeRange: DateTimeRange(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 10)),
      );

  // ─── ResizeDirection ─────────────────────────────────────────────────────────

  group('ResizeDirection', () {
    test('top and bottom are vertical, not horizontal', () {
      for (final direction in [ResizeDirection.top, ResizeDirection.bottom]) {
        expect(direction.vertical, isTrue, reason: '$direction should be vertical');
        expect(direction.horizontal, isFalse, reason: '$direction should not be horizontal');
      }
    });

    test('left and right are horizontal, not vertical', () {
      for (final direction in [ResizeDirection.left, ResizeDirection.right]) {
        expect(direction.horizontal, isTrue, reason: '$direction should be horizontal');
        expect(direction.vertical, isFalse, reason: '$direction should not be vertical');
      }
    });
  });

  // ─── Resize ──────────────────────────────────────────────────────────────────

  group('Resize', () {
    test('verticalResize / horizontalResize mirror the direction', () {
      final vertical = Resize(event: makeEvent(), direction: ResizeDirection.top);
      expect(vertical.verticalResize, isTrue);
      expect(vertical.horizontalResize, isFalse);

      final horizontal = Resize(event: makeEvent(), direction: ResizeDirection.right);
      expect(horizontal.horizontalResize, isTrue);
      expect(horizontal.verticalResize, isFalse);
    });

    test('updateDateTimeRange returns a new Resize with the updated event and same direction', () {
      final original = Resize(event: makeEvent(id: 'keep-me'), direction: ResizeDirection.bottom);
      final newRange = DateTimeRange(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 12));

      final updated = original.updateDateTimeRange(newRange);

      expect(updated.direction, equals(ResizeDirection.bottom));
      expect(updated.event.start, equals(newRange.start));
      expect(updated.event.end, equals(newRange.end));
      // copyWith preserves the id so layout/selection lookups stay stable.
      expect(updated.event.id, equals('keep-me'));
      // The original is left untouched.
      expect(original.event.end, equals(DateTime.utc(2024, 1, 15, 10)));
    });
  });

  // ─── Create / Reschedule ─────────────────────────────────────────────────────

  group('Create / Reschedule', () {
    test('Create carries the controller id', () {
      expect(Create(controllerId: 7).controllerId, equals(7));
    });

    test('Reschedule carries the event', () {
      final event = makeEvent();
      expect(Reschedule(event: event).event, same(event));
    });
  });
}
