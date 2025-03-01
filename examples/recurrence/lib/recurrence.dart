import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/recurring_event.dart';

class RecurrenceController {
  RecurrenceController();
  final controller = EventsController();

  final Map<int, RecurrenceGroup> groups = {};

  int _lastGroupId = 0;
  int get _nextGroupId {
    _lastGroupId++;
    return _lastGroupId;
  }

  /// Add a recurring event.
  void addEvent(CalendarEvent event, Recurrence recurrence) {
    final groupId = _nextGroupId;

    // Generate events for the recurrences.
    final events = recurrence.generateEvents(groupId);

    // Add the events to the controller.
    final ids = controller.addEvents(events);

    // Create the group.
    groups.putIfAbsent(groupId, () => RecurrenceGroup(id: groupId, eventIds: ids, recurrence: recurrence));
  }

  void updateEvent(
    CalendarEvent event,
    CalendarEvent updatedEvent,
  ) {
    // Get the groupId of the event.
    final groupId = (event as RecurringCalendarEvent).groupId;
    final group = groups[groupId]!;

    // Update the recurrence.
    final updatedRecurrence = group.recurrence.updateWithEvent(event, updatedEvent);
    groups.update(groupId, (e) => e.copyWith(recurrence: updatedRecurrence));

    // Grab all the existing events so they can be rescheduled.
    final events = group.eventIds.map((id) => controller.byId(id)! as RecurringCalendarEvent).toList();

    // Update the events.
    final updates = updatedRecurrence.updateEvents(groupId, events);
    for (var item in updates) {
      controller.updateEvent(event: item.$1, updatedEvent: item.$2);
    }
  }
}

enum RecurrenceType {
  none,
  daily;

  /// TODO: test this
  List<DateTimeRange> generateDateTimeRanges(DateTimeRange first, int number) {
    switch (this) {
      case none:
        return [first];
      case daily:
        final ranges = <DateTimeRange>[];
        for (var i = 0; i < number; i++) {
          final start = first.start.asUtc.add(Duration(days: 1 * i));
          final end = first.end.asUtc.add(Duration(days: 1 * i));
          ranges.add(DateTimeRange(start: start, end: end));
        }
        return ranges;
    }
  }

  /// TODO: test this
  DateTimeRange firstRecurrence(DateTimeRange eventRange, DateTimeRange recurrenceRange) {
    switch (this) {
      case none:
        return eventRange;
      case daily:
        final event = eventRange.asUtc;
        final range = recurrenceRange.asUtc;

        final start = range.start.copyWith(
          hour: event.start.hour,
          minute: event.start.minute,
          second: event.start.second,
        );
        final end = start.add(event.duration);
        return DateTimeRange(start: start, end: end).asLocal;
    }
  }

  /// TODO: test this
  int numberFromDateTimeRange(DateTimeRange firstEventRange, DateTimeRange dateTimeRange) {
    switch (this) {
      case none:
        return 1;
      case daily:
        final first = firstEventRange.asUtc;
        final range = dateTimeRange.asUtc;
        var number = 0;
        var currentValue = first.start;

        while (_startIsDuring(currentValue, range) && number < 10000) {
          number++;
          currentValue = first.start.add(Duration(days: 1 * number));
        }

        return number;
    }
  }

  bool _startIsDuring(DateTime date, DateTimeRange dateTimeRange) {
    return (date.isAfter(dateTimeRange.start) || date.isAtSameMomentAs(dateTimeRange.start)) &&
        date.isBefore(dateTimeRange.end);
  }
}

class Recurrence {
  /// The type of recurrence.
  final RecurrenceType type;

  /// The range of the first recurrence. (local time)
  late final DateTimeRange first;

  /// The number of recurrences.
  late final int number;

  Recurrence({
    required this.first,
    required this.number,
    required this.type,
  }) : assert(!first.start.isUtc && !first.end.isUtc);

  /// TODO: test this
  Recurrence.fromDateTimeRange({
    required DateTimeRange eventRange,
    required DateTimeRange recurrenceRange,
    required this.type,
  }) {
    first = type.firstRecurrence(eventRange, recurrenceRange);
    number = type.numberFromDateTimeRange(first, recurrenceRange);
  }

  /// Generate events for this.
  List<RecurringCalendarEvent> generateEvents(int groupId) {
    final recurrences = type.generateDateTimeRanges(first, number);
    return recurrences.map(
      (recurrence) {
        return RecurringCalendarEvent(dateTimeRange: recurrence, groupId: groupId);
      },
    ).toList();
  }

  /// Update this recurrence when an event is updated.
  Recurrence updateWithEvent(CalendarEvent event, CalendarEvent updatedEvent) {
    final (deltaStart, deltaEnd) = Recurrence._calculateDelta(event, updatedEvent);
    return Recurrence(
      first: DateTimeRange(
        start: first.start.asUtc.add(deltaStart).asLocal,
        end: first.end.asUtc.add(deltaEnd).asLocal,
      ),
      number: number,
      type: type,
    );
  }

  /// Update an existing group of events.
  List<(CalendarEvent, RecurringCalendarEvent)> updateEvents(int groupId, List<RecurringCalendarEvent> events) {
    final recurrences = type.generateDateTimeRanges(first, number);
    assert(recurrences.length == events.length);

    final results = <(CalendarEvent, RecurringCalendarEvent)>[];
    for (var (index, event) in events.indexed) {
      final updatedEvent = event.copyWith(dateTimeRange: recurrences[index]);
      results.add((event, updatedEvent));
    }

    return results;
  }

  /// Calculate the change in start and end DateTimes.
  static (Duration start, Duration end) _calculateDelta(CalendarEvent event, CalendarEvent updatedEvent) {
    final deltaStart = updatedEvent.startAsUtc.toUtc().difference(event.startAsUtc.toUtc());
    final deltaEnd = updatedEvent.endAsUtc.toUtc().difference(event.endAsUtc.toUtc());
    return (deltaStart, deltaEnd);
  }
}
