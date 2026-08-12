import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/recurrence.dart';

class RecurringCalendarEvent extends CalendarEvent {
  final String groupId;

  RecurringCalendarEvent({
    super.id,
    required this.groupId,
    required super.dateTimeRange,
    super.interaction,
    super.multiDayRule,
  });

  /// Rebuilds the group this occurrence belongs to. The rest is restored by
  /// [CalendarEvent].
  @override
  RecurringCalendarEvent copyWithData({required DateTimeRange dateTimeRange}) {
    return RecurringCalendarEvent(dateTimeRange: dateTimeRange, groupId: groupId);
  }

  @override
  bool operator ==(Object other) => super == other && other is RecurringCalendarEvent && other.groupId == groupId;

  @override
  int get hashCode => Object.hash(super.hashCode, groupId);
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
  }) {
    return RecurrenceGroup(
      id: id,
      eventIds: eventIds ?? this.eventIds,
      recurrence: recurrence ?? this.recurrence,
    );
  }
}
