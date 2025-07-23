import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/kalender_extensions.dart';

/// TODO: consider a abstract class for CalendarEvent that needs to be implemented by users.
///
/// A class representing a object that can be displayed by the calendar.
///
/// A calendar event requires a [DateTimeRange] this is used by the [CalendarView] to render the event.
///
/// Any calculations done with the [_dateTimeRange] should be done in utc time and then converted back to local time.
class CalendarEvent<T extends Object?> {
  /// The data of the [CalendarEvent].
  T? data;

  /// The [DateTimeRange] of the [CalendarEvent] stored in local time.
  final DateTimeRange _dateTimeRange;

  /// Whether this [CalendarEvent] can be modified.
  /// *This will be deprecated in the future.
  /// TODO: Depricate this in 1.0.0
  final bool canModify;

  /// The interaction for the [CalendarEvent].
  ///
  /// * This will override the behavior from [canModify] property.
  final EventInteraction interaction;

  /// The id of the [CalendarEvent].
  /// Do not set this value manually as this is set by the [EventsController].
  int _id = -1;
  int get id => _id;
  set id(int value) {
    if (_id != -1) return;
    _id = value;
  }

  CalendarEvent({
    required DateTimeRange dateTimeRange,
    this.data,
    this.canModify = true,
    EventInteraction? interaction,
  })  : _dateTimeRange = dateTimeRange.isUtc ? dateTimeRange.toLocal() : dateTimeRange,
        interaction = interaction ?? EventInteraction.fromCanModify(canModify);

  /// The [DateTimeRange] of the [CalendarEvent] in the local timezone.
  DateTimeRange get dateTimeRange => _dateTimeRange;

  /// The start [DateTime] of the [CalendarEvent] in the local timezone.
  DateTime get start => _dateTimeRange.start;

  /// The end [DateTime] of the [CalendarEvent] in the local timezone.
  DateTime get end => _dateTimeRange.end;

  /// The [DateTimeRange] of the [CalendarEvent] in utc time.
  DateTimeRange get dateTimeRangeAsUtc => _dateTimeRange.asUtc;

  /// The start [DateTime] of the [CalendarEvent] in utc time.
  DateTime get startAsUtc => dateTimeRangeAsUtc.start;

  /// The end [DateTime] of the [CalendarEvent] in utc time.
  DateTime get endAsUtc => dateTimeRangeAsUtc.end;

  /// The total duration of the [CalendarEvent] this uses utc time for the calculation.
  Duration get duration => dateTimeRangeAsUtc.duration;

  /// Whether the [CalendarEvent] is longer than a day.
  bool get isMultiDayEvent => duration.inDays > 0;

  /// The [DateTime]s that the [CalendarEvent] spans. This uses utc time.
  List<DateTime> get datesSpanned => dateTimeRangeAsUtc.dates();

  /// Copy the [CalendarEvent] with the new values.
  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? data,
    bool? canModify,
    EventInteraction? interaction,
  }) {
    return CalendarEvent<T>(
      data: data ?? this.data,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      canModify: canModify ?? this.canModify,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  String toString() {
    return 'CalendarEvent<$T> ($id):'
        '\nstart:  $startAsUtc'
        '\nend: $endAsUtc'
        '\ndata: ${data.toString()}';
  }

  /// Check if the [CalendarEvent] is equal to another [CalendarEvent].
  @override
  bool operator ==(Object other) {
    return other is CalendarEvent<T> &&
        other.id == id &&
        other._dateTimeRange == _dateTimeRange &&
        other.data == data &&
        other.canModify == canModify &&
        other.interaction == interaction;
  }

  @override
  int get hashCode => Object.hash(id, _dateTimeRange, data, canModify, interaction);
}
