import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A Basic [Event] model that extends [CalendarEvent].
///
/// It contains the [title], [description], and [color] of the event.
class Event extends CalendarEvent {
  /// Creates an [Event].
  Event({
    super.id,
    required super.dateTimeRange,
    required this.title,
    this.description,
    this.color,
    super.interaction,
    super.multiDayRule,
  });

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event].
  final Color? color;

  /// Rebuilds the fields this class adds, for a drag or a resize.
  ///
  /// The id, the interaction config and the rule are restored by [CalendarEvent]
  /// afterwards, so they are deliberately not listed here.
  @override
  Event copyWithData({required DateTimeRange dateTimeRange}) {
    return Event(dateTimeRange: dateTimeRange, title: title, description: description, color: color);
  }

  /// A copy with the given fields replaced.
  ///
  /// This is the demo's own method rather than an override, so it takes whatever
  /// parameters are useful here. [carryOver] keeps the copy's identity.
  Event copyWith({DateTimeRange? dateTimeRange, String? title, String? description, Color? color}) {
    return carryOver(
      Event(
        dateTimeRange: dateTimeRange ?? this.dateTimeRange,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      ),
    );
  }

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
