import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class Event extends CalendarEvent {
  Event({
    required super.dateTimeRange,
    required this.title,
    this.description,
    this.color,
    super.interaction,
  });

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
  }) {
    // 1. Create the new instance using provided or existing values
    final newEvent = Event(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );

    // 2. Preserve the internal ID from the current instance
    newEvent.id = id;

    return newEvent;
  }
}
