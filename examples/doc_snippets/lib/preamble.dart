// Identifiers the guides use as placeholders, so a snippet can show the line
// that matters without the scaffolding around it.
//
// This file is analyzed like any other, so the stubs stay honest: if a signature
// in the package changes, the stub stops compiling here first.

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/timezone.dart' as tz;

/// The custom event subclass the guides build on, as defined in doc/events.md.
class Event extends KalenderEvent {
  Event({
    super.id,
    required super.start,
    required super.end,
    required this.title,
    this.description,
    this.color,
    super.interaction,
    super.multiDayRule,
    super.isAllDay,
  });

  final String title;
  final String? description;
  final Color? color;

  @override
  Event copyWithData({required DateTime start, required DateTime end}) {
    return Event(start: start, end: end, title: title, description: description, color: color);
  }

  Event copyWith({DateTime? start, DateTime? end, String? title, String? description, Color? color}) {
    return carryOver(
      Event(
        start: start ?? this.start,
        end: end ?? this.end,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return super == other &&
        other is Event &&
        other.title == title &&
        other.description == description &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, title, description, color);
}

/// Stands in for a widget the reader supplies.
Widget CustomWidget() => const SizedBox.shrink();

/// Stands in for the reader's app widget, which several snippets pass to
/// `runApp`. A snippet that declares its own shadows this one.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

final eventsController = DefaultEventsController();
final calendarController = KalenderController();
final viewConfiguration = MultiDayViewConfiguration.week();

final location = tz.getLocation('Etc/UTC');
final range = KalenderDateTimeRange(start: DateTime.utc(2025), end: DateTime.utc(2025, 1, 2));
final event = KalenderEvent(start: range.start, end: range.end);
const someId = 'an-event-id';
