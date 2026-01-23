import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A Basic [Event] model that extends [CalendarEvent].
///
/// It contains the [title], [description], and [color] of the event.
class Event extends CalendarEvent {
  /// Creates an [Event].
  Event({required super.dateTimeRange, required this.title, this.description, this.color, super.interaction});

  /// Creates an [Event] from a [CalendarEvent].
  factory Event.fromCalendarEvent(CalendarEvent event) {
    if (event is Event) return event;
    return Event(
      dateTimeRange: event.dateTimeRange,
      interaction: event.interaction,
      title: '',
    )..id = event.id; // TODO(werner): Is there a better way to do this ?
  }

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event].
  final Color? color;

  @override
  Event copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? title,
    String? description,
    Color? color,
  }) =>
      Event(
        dateTimeRange: dateTimeRange ?? this.dateTimeRange,
        interaction: interaction ?? this.interaction,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      )..id = id;

  // TODO(werner): People will have to override equality in their own models...
  //  add this to the documentaion.
  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    return super == (other) &&
        other is Event &&
        other.title == title &&
        other.description == description &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, title, description, color);
}
