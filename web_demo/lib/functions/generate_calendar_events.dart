import 'dart:math';
import 'package:web_demo/models/event.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

List<CalendarEvent<Event>> generateCalendarEvents() {
  List<CalendarEvent<Event>> events = [];

  List<Color> colors = [
    Colors.blue,
    Colors.indigo,
    Colors.green,
  ];

  Color getRadomColor() {
    return colors[Random().nextInt(3)];
  }

  int x = 1;

  String getID() {
    x++;
    return x.toString();
  }

  for (var i = -50; i < 50; i++) {
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
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfTuesday,
          end: startOfWednesday,
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfTuesday,
          end: startOfWednesday,
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfMonday.add(Duration(hours: Random().nextInt(5))),
          end: startOfMonday.add(Duration(hours: 6 + Random().nextInt(5))),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Forced Height',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfTuesday.add(Duration(hours: Random().nextInt(6))),
          end: startOfTuesday.add(Duration(hours: 7 + Random().nextInt(5))),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfWednesday.add(Duration(hours: Random().nextInt(6))),
          end: startOfWednesday.add(Duration(hours: 7 + Random().nextInt(5))),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfThursday
              .add(Duration(hours: Random().nextInt(6), minutes: 4)),
          end: startOfThursday
              .add(Duration(hours: 7 + Random().nextInt(6), minutes: 4)),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfFriday
              .add(Duration(hours: Random().nextInt(6), minutes: 7)),
          end: startOfFriday
              .add(Duration(hours: 8 + Random().nextInt(6), minutes: 7)),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfSaturday
              .add(Duration(hours: Random().nextInt(6), minutes: 10)),
          end: startOfSaturday
              .add(Duration(hours: 8 + Random().nextInt(6), minutes: 10)),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfSaturday.add(Duration(hours: 14 + Random().nextInt(2))),
          end: startOfSaturday.add(Duration(hours: 17 + Random().nextInt(3))),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfSunday
              .add(Duration(hours: Random().nextInt(6), minutes: 5)),
          end: startOfSunday
              .add(Duration(hours: 12 + Random().nextInt(6), minutes: 5)),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: startOfSunday
              .add(Duration(hours: Random().nextInt(6), minutes: 5)),
          end: startOfSunday
              .add(Duration(hours: 12 + Random().nextInt(6), minutes: 5)),
        ),
        eventData: Event(
          title: 'Event ${getID()}',
          description: 'Description',
          color: getRadomColor(),
        ),
      ),
    ]);
  }

  return events;
}
