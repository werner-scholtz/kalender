import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Until 0.26.0 a subclass overrode `copyWith` and had to forward by hand every
/// field [CalendarEvent] carries but takes no parameter for, which was `id` and,
/// from 0.24.0, `multiDayRule`. Forgetting one produced a copy the calendar read
/// as a different event, or one that lost its rule, and adding a field to the
/// base class broke every subclass at once without a compile error.
///
/// A subclass now overrides [CalendarEvent.copyWithData] and rebuilds only what
/// it added. `withDateTimeRange` restores the base state afterwards.

/// Rebuilds only its own field, as the documentation shows.
class _Task extends CalendarEvent {
  _Task({
    required super.dateTimeRange,
    required this.title,
    super.interaction,
    super.multiDayRule,
  });

  final String title;

  @override
  _Task copyWithData({required DateTimeRange dateTimeRange}) {
    return _Task(dateTimeRange: dateTimeRange, title: title);
  }

  /// A copy method of the subclass's own, which is no longer an override and so
  /// can take whatever parameters it likes.
  _Task copyWith({String? title}) {
    return carryOver(_Task(dateTimeRange: dateTimeRange, title: title ?? this.title));
  }
}

/// Ignores the analyzer warning and writes no hook at all, so the base
/// implementation returns a plain [CalendarEvent].
// ignore: missing_override_of_must_be_overridden
class _NoHook extends CalendarEvent {
  _NoHook({required super.dateTimeRange});
}

void main() {
  final range = DateTimeRange(start: DateTime.utc(2025, 1, 6, 9), end: DateTime.utc(2025, 1, 6, 10));
  final moved = DateTimeRange(start: DateTime.utc(2025, 1, 6, 11), end: DateTime.utc(2025, 1, 6, 12));

  group('withDateTimeRange', () {
    test('moves a base event and keeps its identity and rule', () {
      final event = CalendarEvent(dateTimeRange: range, multiDayRule: const MultiDayRule.calendarDays());
      final copy = event.withDateTimeRange(moved);

      expect(copy.dateTimeRange, equals(moved));
      expect(copy.id, equals(event.id));
      expect(copy.multiDayRule, equals(event.multiDayRule));
    });

    test('keeps the state a subclass never mentions', () {
      final event = _Task(
        dateTimeRange: range,
        title: 'standup',
        multiDayRule: const MultiDayRule.calendarDays(),
        interaction: EventInteraction.fromCanModify(false),
      );

      final copy = event.withDateTimeRange(moved) as _Task;

      expect(copy.title, equals('standup'), reason: 'the hook rebuilds this');
      expect(copy.id, equals(event.id), reason: 'carryOver restores this');
      expect(copy.multiDayRule, equals(event.multiDayRule), reason: 'carryOver restores this');
      expect(copy.interaction, equals(event.interaction), reason: 'carryOver restores this');
      expect(copy.dateTimeRange, equals(moved));
    });

    test('returns the subclass type, not the base one', () {
      final event = _Task(dateTimeRange: range, title: 'standup');
      expect(event.withDateTimeRange(moved), isA<_Task>());
    });

    test('a subclass with no hook is reported by name', () {
      final event = _NoHook(dateTimeRange: range);

      expect(
        () => event.withDateTimeRange(moved),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            allOf(contains('_NoHook'), contains('copyWithData')),
          ),
        ),
      );
    });
  });

  group('carryOver', () {
    test('a copyWith of the subclass keeps the base state too', () {
      final event = _Task(
        dateTimeRange: range,
        title: 'standup',
        multiDayRule: const MultiDayRule.calendarDays(),
      );

      final renamed = event.copyWith(title: 'retro');

      expect(renamed.title, equals('retro'));
      expect(renamed.id, equals(event.id));
      expect(renamed.multiDayRule, equals(event.multiDayRule));
    });
  });

  group('the calendar reads a moved event as the same one', () {
    test('a drag does not change the id the controller looks up', () {
      final controller = DefaultEventsController();
      addTearDown(controller.dispose);

      final event = _Task(dateTimeRange: range, title: 'standup');
      controller.addEvent(event);

      final moved0 = event.withDateTimeRange(moved);
      controller.updateEvent(event: event, updatedEvent: moved0);

      expect(controller.byId(event.id), isNotNull);
      expect((controller.byId(event.id)! as _Task).title, equals('standup'));
    });
  });
}
