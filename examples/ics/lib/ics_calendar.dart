import 'package:enough_icalendar/enough_icalendar.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart' as rr;

import 'ics_event.dart';

/// A master event parsed from an `.ics` file, before recurrence expansion.
class IcsSource {
  const IcsSource({
    required this.uid,
    required this.summary,
    required this.start,
    required this.end,
    required this.isAllDay,
    this.description,
    this.recurrence,
  });

  final String uid;
  final String summary;
  final String? description;
  final DateTime start;
  final DateTime end;

  /// Whether `DTSTART` was date-valued, which is how RFC 5545 says all-day.
  final bool isAllDay;

  /// The recurrence rule, kept as-is so it can be written back out on export.
  final Recurrence? recurrence;
}

/// Parse the master events from `.ics` text.
List<IcsSource> parseIcs(String text) {
  final calendar = VComponent.parse(text) as VCalendar;
  final sources = <IcsSource>[];
  for (final event in calendar.children.whereType<VEvent>()) {
    final start = event.start;
    if (start == null) continue;
    final isAllDay = _isDateValued(event, DateTimeProperty.propertyNameStart);
    sources.add(IcsSource(
      uid: event.uid,
      summary: event.summary ?? 'Untitled',
      description: event.description,
      start: start,
      isAllDay: isAllDay,
      // RFC 5545 makes DTEND exclusive, and an all-day event with none lasts a
      // single day.
      end: event.end ?? start.add(isAllDay ? const Duration(days: 1) : const Duration(hours: 1)),
      recurrence: event.recurrenceRule,
    ));
  }
  return sources;
}

/// Whether [name] carries `VALUE=DATE` rather than a date and time.
///
/// `VEvent.isAllDayEvent` reads `X-MICROSOFT-CDO-ALLDAYEVENT` instead, which
/// most producers never write, so the standard signal has to be read off the
/// property itself.
bool _isDateValued(VEvent event, String name) {
  final property = event.getProperty<DateTimeProperty>(name);
  return (property?[ParameterType.value] as ValueParameter?)?.valueType == ValueType.date;
}

/// Expand [sources] into concrete events that fall within [window].
///
/// Recurring events are expanded lazily with the rrule package: only instances
/// inside the window are produced, so a "repeat forever" rule stays cheap.
List<IcsEvent> expandEvents(List<IcsSource> sources, DateTimeRange window) {
  final events = <IcsEvent>[];
  for (final source in sources) {
    final color = _colorFor(source.uid);
    final duration = source.end.difference(source.start);

    if (source.recurrence == null) {
      if (source.end.isBefore(window.start) || source.start.isAfter(window.end)) continue;
      events.add(_event(source, source.start, source.end, color));
      continue;
    }

    // rrule works in wall-clock UTC and ignores the actual zone, so feed it the
    // start with the same date and time flagged UTC, and read instances back as
    // local wall-clock. Real .ics files carry a TZID; see the README.
    final rule = rr.RecurrenceRule.fromString('RRULE:${source.recurrence}');
    final instances = rule
        .getInstances(start: _utcWall(source.start))
        .map(_localWall)
        .skipWhile((start) => start.add(duration).isBefore(window.start))
        .takeWhile((start) => !start.isAfter(window.end));
    for (final start in instances) {
      events.add(_event(source, start, start.add(duration), color));
    }
  }
  return events;
}

/// Serialize [sources] back to `.ics` text, recurrence rules included.
String exportIcs(List<IcsSource> sources) {
  final calendar = VCalendar()
    ..productId = '-//kalender//ics example//EN'
    ..version = '2.0';
  for (final source in sources) {
    final event = VEvent(parent: calendar)
      ..uid = source.uid
      ..timeStamp = DateTime.now()
      ..summary = source.summary
      ..description = source.description
      ..recurrenceRule = source.recurrence;

    if (source.isAllDay) {
      event
        ..setProperty(_dateProperty(DateTimeProperty.propertyNameStart, source.start))
        ..setProperty(_dateProperty(DateTimeProperty.propertyNameEnd, source.end));
    } else {
      event
        ..start = source.start
        ..end = source.end;
    }

    calendar.children.add(event);
  }
  return calendar.toString();
}

/// A `DTSTART`/`DTEND` written as `VALUE=DATE`, so an all-day event survives a
/// round trip as one.
DateTimeProperty _dateProperty(String name, DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return DateTimeProperty('$name;VALUE=DATE:${date.year}$month$day');
}

IcsEvent _event(IcsSource source, DateTime start, DateTime end, Color color) {
  return IcsEvent(
    dateTimeRange: DateTimeRange(start: start, end: end),
    uid: source.uid,
    title: source.summary,
    description: source.description,
    color: color,
    isAllDay: source.isAllDay,
  );
}

const _palette = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.red,
  Colors.indigo,
];

Color _colorFor(String uid) => _palette[uid.hashCode.abs() % _palette.length];

DateTime _utcWall(DateTime d) => DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second);
DateTime _localWall(DateTime d) => DateTime(d.year, d.month, d.day, d.hour, d.minute, d.second);
