import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show EventInteraction;
import 'package:kalender/kalender_extensions.dart';

/// TODO: Redo documentation.
///
/// A class representing a object that can be displayed by the calendar.
///
/// A calendar event requires a [DateTimeRange] this is used by the [CalendarView] to render the event.
///
/// Any calculations done with the [_dateTimeRange] should be done in utc time and then converted back to local time.
class CalendarEvent<T extends Object?> {
  /// The data of the [CalendarEvent].
  T? data;

  /// The start [DateTime] of the [CalendarEvent].
  final DateTime start;

  /// The end [DateTime] of the [CalendarEvent].
  final DateTime end;

  /// Whether this [CalendarEvent] can be modified.
  /// *This will be deprecated in the future.
  /// TODO: Depricate this in 1.0.0
  final bool canModify;

  /// The interaction for the [CalendarEvent].
  ///
  /// * This will override the behavior from [canModify] property.
  final EventInteraction interaction;

  // TODO: make this final in 1.0.0 and use special copyWith to set id.
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
  })  : start = dateTimeRange.start.toUtc(),
        end = dateTimeRange.end.toUtc(),
        interaction = interaction ?? EventInteraction.fromCanModify(canModify);

  /// The [DateTimeRange] of the [CalendarEvent].
  DateTimeRange get dateTimeRange => DateTimeRange(start: start, end: end);

  InternalDateTime internalStart({Location? location}) => InternalDateTime.fromDateTime(start.forLocation(location));
  InternalDateTime internalEnd({Location? location}) => InternalDateTime.fromDateTime(end.forLocation(location));
  InternalDateTimeRange internalRange({Location? location}) {
    return InternalDateTimeRange(start: internalStart(location: location), end: internalEnd(location: location));
  }

  /// The total duration of the [CalendarEvent] this uses utc time for the calculation.
  Duration get duration => dateTimeRange.toUtc().duration;

  /// Whether the [CalendarEvent] is longer than a day.
  bool get isMultiDayEvent => duration.inDays > 0;

  /// TODO: This must return internal date times.
  /// The [DateTime]s that the [CalendarEvent] spans.
  List<DateTime> datesSpanned({Location? location}) => internalRange(location: location).dates();

  /// Copy the [CalendarEvent] with the new values.
  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? data,
    bool? canModify,
    EventInteraction? interaction,
  }) {
    return CalendarEvent<T>(
      data: data ?? this.data,
      dateTimeRange: dateTimeRange ?? DateTimeRange(start: start, end: end),
      canModify: canModify ?? this.canModify,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  String toString() {
    return 'CalendarEvent<$T> ($id):'
        '\nstart:  $start'
        '\nend: $end'
        '\ndata: ${data.toString()}';
  }

  /// Check if the [CalendarEvent] is equal to another [CalendarEvent].
  @override
  bool operator ==(Object other) {
    return other is CalendarEvent<T> &&
        other.id == id &&
        other.start == start &&
        other.end == end &&
        other.data == data &&
        other.canModify == canModify &&
        other.interaction == interaction;
  }

  @override
  int get hashCode => Object.hash(id, start, end, data, canModify, interaction);
}
