import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' show CalendarEvent;

class Event extends CalendarEvent<Event> {
  Event({
    required this.title,
    this.description,
    this.color,
    required super.dateTimeRange,
  });

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event] tile.
  final Color? color;

  @override
  Event copyWith({
    String? title,
    String? description,
    Color? color,
    DateTimeRange? dateTimeRange,
  }) {
    return Event(
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
    );
  }

  @override
  bool get canModify => true;
}
