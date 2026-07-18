import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A calendar event that carries the data mapped from an `.ics` VEVENT.
///
/// One recurring VEVENT expands into many [IcsEvent]s that share a [uid].
class IcsEvent extends CalendarEvent {
  IcsEvent({
    required super.dateTimeRange,
    required this.uid,
    required this.title,
    required this.color,
    this.description,
    super.interaction,
  });

  final String uid;
  final String title;
  final String? description;
  final Color color;

  @override
  IcsEvent copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? uid,
    String? title,
    String? description,
    Color? color,
  }) {
    final copy = IcsEvent(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
    copy.id = id;
    return copy;
  }

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is IcsEvent &&
      other.uid == uid &&
      other.title == title &&
      other.description == description &&
      other.color == color;

  @override
  int get hashCode => Object.hash(super.hashCode, uid, title, description, color);
}
