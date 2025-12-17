import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/recurrence.dart';

class RecurringCalendarEvent<Event> extends CalendarEvent<Event> {
  final int groupId;
  RecurringCalendarEvent({
    required this.groupId,
    required super.dateTimeRange,
    super.interaction,
    super.data,
    super.canModify,
  });

  factory RecurringCalendarEvent.fromCalendarEvent(CalendarEvent<Event> event, int groupId) {
    return RecurringCalendarEvent(
      dateTimeRange: event.internalRange(),
      groupId: groupId,
      data: event.data,
      canModify: event.canModify,
    );
  }

  /// Copy the [CalendarEvent] with the new values.
  @override
  RecurringCalendarEvent<Event> copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    Event? data,
    bool? canModify,
  }) {
    return RecurringCalendarEvent<Event>(
      data: data ?? this.data,
      dateTimeRange: dateTimeRange ?? internalRange(),
      groupId: groupId,
      canModify: canModify ?? this.canModify,
      interaction: interaction ?? this.interaction,
    );
  }
}

class RecurrenceGroup {
  /// Group id,
  final int id;

  /// Id's of events that are part of this group.
  final List<int> eventIds;

  /// The recurrence of this group.
  final Recurrence recurrence;

  /// Check if this group contains more than one event.
  bool get hasMultiple => eventIds.length > 1;

  const RecurrenceGroup({
    required this.id,
    required this.eventIds,
    required this.recurrence,
  });

  RecurrenceGroup copyWith({
    List<int>? eventIds,
    Recurrence? recurrence,
    DateTimeRange? originalRange,
  }) {
    return RecurrenceGroup(
      id: id,
      eventIds: eventIds ?? this.eventIds,
      recurrence: recurrence ?? this.recurrence,
    );
  }
}
