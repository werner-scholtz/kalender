import 'package:kalender/kalender.dart';
import 'package:recurrence/recurring_event.dart';

class RecurrenceController {
  RecurrenceController();
  final controller = DefaultEventsController();

  final Map<String, RecurrenceGroup> groups = {};

  static int _groupCounter = 0;
  String get _nextGroupId => 'group_${_groupCounter++}';

  /// Add a recurring event.
  void addEvent(KalenderEvent event, Recurrence recurrence) {
    final groupId = _nextGroupId;

    // Generate events for the recurrences.
    final events = recurrence.generateEvents(groupId);

    // Add the events to the controller.
    final ids = controller.addEvents(events);

    // Create the group.
    groups.putIfAbsent(groupId, () => RecurrenceGroup(id: groupId, eventIds: ids, recurrence: recurrence));
  }

  void updateEvent(
    KalenderEvent event,
    KalenderEvent updatedEvent,
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

  /// Look up the [RecurrenceGroup] for a given event, or `null` if it's not a recurring event.
  RecurrenceGroup? groupFor(KalenderEvent event) {
    if (event is! RecurringCalendarEvent) return null;
    return groups[event.groupId];
  }

  /// Replace an entire recurrence group with a new [Recurrence].
  ///
  /// Removes old events and creates new ones according to the updated recurrence.
  void replaceRecurrence(String groupId, Recurrence newRecurrence) {
    final group = groups[groupId]!;

    // Remove existing events.
    for (final id in group.eventIds) {
      controller.removeById(id);
    }

    // Generate new events.
    final newEvents = newRecurrence.generateEvents(groupId);
    final newIds = controller.addEvents(newEvents);

    // Update the group.
    groups[groupId] = RecurrenceGroup(id: groupId, eventIds: newIds, recurrence: newRecurrence);
  }

  /// Delete an entire recurrence group and all its events.
  void deleteGroup(String groupId) {
    final group = groups[groupId];
    if (group == null) return;

    for (final id in group.eventIds) {
      controller.removeById(id);
    }
    groups.remove(groupId);
  }
}

enum RecurrenceType {
  none,
  daily,
  weekly;

  /// The interval in days between recurrences.
  int get _intervalDays {
    return switch (this) {
      none => 0,
      daily => 1,
      weekly => 7,
    };
  }

  /// Generate [number] date-time ranges starting from [first], each offset by the recurrence interval.
  /// All DateTimes should be in local time.
  List<KalenderDateTimeRange> generateDateTimeRanges(KalenderDateTimeRange first, int number) {
    if (this == none) return [first];
    return List.generate(number, (i) {
      final offset = Duration(days: _intervalDays * i);
      return KalenderDateTimeRange(start: first.start.add(offset), end: first.end.add(offset));
    });
  }

  /// Compute the first recurrence range: takes the time-of-day from [eventRange]
  /// and the start date from [recurrenceRange]. All DateTimes should be in local time.
  KalenderDateTimeRange firstRecurrence(KalenderDateTimeRange eventRange, KalenderDateTimeRange recurrenceRange) {
    if (this == none) return eventRange;
    final start = recurrenceRange.start.copyWith(
      hour: eventRange.start.hour,
      minute: eventRange.start.minute,
      second: eventRange.start.second,
    );
    final end = start.add(eventRange.duration);
    return KalenderDateTimeRange(start: start, end: end);
  }

  /// Count how many recurrences of [firstEventRange] fit within [dateTimeRange].
  int numberFromDateTimeRange(KalenderDateTimeRange firstEventRange, KalenderDateTimeRange dateTimeRange) {
    if (this == none) return 1;
    var count = 0;
    var current = firstEventRange.start;
    while (_isWithin(current, dateTimeRange) && count < 10000) {
      count++;
      current = firstEventRange.start.add(Duration(days: _intervalDays * count));
    }
    return count;
  }

  bool _isWithin(DateTime date, KalenderDateTimeRange range) {
    return !date.isBefore(range.start) && date.isBefore(range.end);
  }
}

class Recurrence {
  /// The type of recurrence.
  final RecurrenceType type;

  /// The range of the first recurrence (local time).
  late final KalenderDateTimeRange first;

  /// The number of recurrences.
  late final int number;

  Recurrence({
    required this.first,
    required this.number,
    required this.type,
  }) : assert(!first.start.isUtc && !first.end.isUtc);

  /// Create a [Recurrence] from an event's local-time range and a recurrence date range.
  ///
  /// Both [eventRange] and [recurrenceRange] must be in local time.
  Recurrence.fromDateTimeRange({
    required KalenderDateTimeRange eventRange,
    required KalenderDateTimeRange recurrenceRange,
    required this.type,
  }) {
    first = type.firstRecurrence(eventRange, recurrenceRange);
    number = type.numberFromDateTimeRange(first, recurrenceRange);
  }

  /// Generate events for this.
  List<RecurringCalendarEvent> generateEvents(String groupId) {
    final recurrences = type.generateDateTimeRanges(first, number);
    return recurrences.map(
      (recurrence) {
        return RecurringCalendarEvent(start: recurrence.start, end: recurrence.end, groupId: groupId);
      },
    ).toList();
  }

  /// Update this recurrence when an event is updated.
  Recurrence updateWithEvent(KalenderEvent event, KalenderEvent updatedEvent) {
    final (deltaStart, deltaEnd) = Recurrence._calculateDelta(event, updatedEvent);
    return Recurrence(
      first: KalenderDateTimeRange(
        start: first.start.add(deltaStart),
        end: first.end.add(deltaEnd),
      ),
      number: number,
      type: type,
    );
  }

  /// Update an existing group of events.
  List<(KalenderEvent, RecurringCalendarEvent)> updateEvents(String groupId, List<RecurringCalendarEvent> events) {
    final recurrences = type.generateDateTimeRanges(first, number);
    assert(recurrences.length == events.length);

    final results = <(KalenderEvent, RecurringCalendarEvent)>[];
    for (var (index, event) in events.indexed) {
      final updatedEvent = event.withDateTimeRange(recurrences[index]) as RecurringCalendarEvent;
      results.add((event, updatedEvent));
    }

    return results;
  }

  /// Calculate the change in start and end DateTimes.
  static (Duration start, Duration end) _calculateDelta(KalenderEvent event, KalenderEvent updatedEvent) {
    final deltaStart = updatedEvent.internalStart().difference(event.internalStart());
    final deltaEnd = updatedEvent.internalEnd().difference(event.internalEnd());
    return (deltaStart, deltaEnd);
  }
}
