import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A calendar event that carries the data mapped from an `.ics` VEVENT.
///
/// One recurring VEVENT expands into many [IcsEvent]s that share a [uid].
class IcsEvent extends CalendarEvent {
  IcsEvent({
    super.id,
    required super.dateTimeRange,
    required this.uid,
    required this.title,
    required this.color,
    this.description,
    super.interaction,
    super.multiDayRule,
  });

  final String uid;
  final String title;
  final String? description;
  final Color color;

  @override
  IcsEvent copyWithData({required DateTimeRange dateTimeRange}) {
    return IcsEvent(
      dateTimeRange: dateTimeRange,
      uid: uid,
      title: title,
      description: description,
      color: color,
    );
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
