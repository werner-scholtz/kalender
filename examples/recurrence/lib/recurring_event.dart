import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/recurrence.dart';

class RecurringCalendarEvent extends CalendarEvent {
  final String groupId;

  RecurringCalendarEvent({
    required this.groupId,
    required super.dateTimeRange,
    super.interaction,
  });

  factory RecurringCalendarEvent.fromCalendarEvent(CalendarEvent event, String groupId) {
    return RecurringCalendarEvent(
      dateTimeRange: event.internalRange(),
      groupId: groupId,
    );
  }

  /// Copy the [CalendarEvent] with the new values.
  @override
  RecurringCalendarEvent copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
  }) {
    return RecurringCalendarEvent(
      dateTimeRange: dateTimeRange ?? internalRange(),
      groupId: groupId,
      interaction: interaction ?? this.interaction,
    );
  }
}

class RecurrenceGroup {
  /// Group id,
  final String id;

  /// Id's of events that are part of this group.
  final List<String> eventIds;

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
    List<String>? eventIds,
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
