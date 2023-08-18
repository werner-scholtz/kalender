import 'dart:math';

import 'package:example/models/event.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

List<CalendarEvent<Event>> generateCalendarEvents() {
  List<CalendarEvent<Event>> events = [];

  for (var i = -5; i < 5; i++) {
    DateTime now = DateTime.now().add(Duration(days: i * 7));
    DateTime mondayNow = now.subtract(Duration(days: now.weekday - 1));
    DateTime startOfMonday =
        DateTime(mondayNow.year, mondayNow.month, mondayNow.day);
    DateTime startOfTuesday = startOfMonday.add(const Duration(days: 1));
    DateTime startOfWednesday = startOfMonday.add(const Duration(days: 2));
    DateTime startOfThursday = startOfMonday.add(const Duration(days: 3));
    DateTime startOfFriday = startOfMonday.add(const Duration(days: 4));
    DateTime startOfSaturday = startOfMonday.add(const Duration(days: 5));
    DateTime startOfSunday = startOfMonday.add(const Duration(days: 6));

    events.addAll([
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfMonday,
          end: startOfTuesday,
        ),
        eventData: Event(
          title: 'Event 1',
          description: 'This is a description of event 1',
          color: Colors.blueGrey,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfTuesday,
          end: startOfWednesday,
        ),
        eventData: Event(
          title: 'Event 2',
          description: 'This is a description of event 2',
          color: Colors.red,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfTuesday,
          end: startOfWednesday,
        ),
        eventData: Event(
          title: 'Event 3',
          description: 'This is a description of event 3',
          color: Colors.blueGrey,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfMonday.add(Duration(hours: Random().nextInt(5))),
          end: startOfMonday.add(Duration(hours: 6 + Random().nextInt(5))),
        ),
        eventData: Event(
          title: 'Event 4',
          description: 'This is a description of event 4',
          color: Colors.blue,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfTuesday.add(Duration(hours: Random().nextInt(6))),
          end: startOfTuesday.add(Duration(hours: 7 + Random().nextInt(5))),
        ),
        eventData: Event(
          title: 'Event 5',
          description: 'This is a description of event 5',
          color: Colors.blue,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfWednesday.add(Duration(hours: Random().nextInt(6))),
          end: startOfWednesday.add(Duration(hours: 7 + Random().nextInt(5))),
        ),
        eventData: Event(
          title: 'Event 6',
          description: 'This is a description of event 6',
          color: Colors.blue,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfThursday.add(Duration(hours: Random().nextInt(6))),
          end: startOfThursday.add(Duration(hours: 7 + Random().nextInt(6))),
        ),
        eventData: Event(
          title: 'Event 7',
          description: 'This is a description of event 7',
          color: Colors.green,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfFriday.add(Duration(hours: Random().nextInt(6))),
          end: startOfFriday.add(Duration(hours: 8 + Random().nextInt(6))),
        ),
        eventData: Event(
          title: 'Event 8',
          description: 'This is a description of event 8',
          color: Colors.blue,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfSaturday.add(Duration(hours: Random().nextInt(6))),
          end: startOfSaturday.add(Duration(hours: 8 + Random().nextInt(6))),
        ),
        eventData: Event(
          title: 'Event 9',
          description: 'This is a description of event 9',
          color: Colors.blue,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfSaturday.add(Duration(hours: 14 + Random().nextInt(2))),
          end: startOfSaturday.add(Duration(hours: 17 + Random().nextInt(3))),
        ),
        eventData: Event(
          title: 'Event 10',
          description: 'This is a description of event 9',
          color: Colors.blue,
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfSunday.add(Duration(hours: Random().nextInt(6))),
          end: startOfSunday.add(Duration(hours: 12 + Random().nextInt(6))),
        ),
        eventData: Event(
          title: 'Event 11',
          description: 'This is a description of event 10',
          color: Colors.blue,
        ),
      ),
    ]);
  }

  return events;
}
