import 'dart:io';

import 'package:example/models/event.dart';
import 'package:example/screens/desktop_screen.dart';
import 'package:example/screens/mobile_screen.dart';
import 'package:example/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Event>(
      controller: CalendarController()..addEvents(generateCalendarEvents()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
        themeMode: ThemeMode.dark,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
            return const DesktopScreen();
          } else {
            return const MobileScreen();
          }
        },
      ),
    );
  }
}

List<CalendarEvent<Event>> generateCalendarEvents() {
  DateTime now = DateTime.now();
  DateTime mondayNow = now.subtract(Duration(days: now.weekday - 1));
  DateTime startOfMonday = DateTime(mondayNow.year, mondayNow.month, mondayNow.day);
  DateTime startOfTuesday = startOfMonday.add(const Duration(days: 1));
  DateTime startOfWednesday = startOfMonday.add(const Duration(days: 2));
  DateTime startOfThursday = startOfMonday.add(const Duration(days: 3));
  DateTime startOfFriday = startOfMonday.add(const Duration(days: 4));
  DateTime startOfSaturday = startOfMonday.add(const Duration(days: 5));
  DateTime startOfSunday = startOfMonday.add(const Duration(days: 6));

  List<CalendarEvent<Event>> events = [
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfMonday.subtract(const Duration(hours: 1)),
        end: startOfTuesday.subtract(const Duration(hours: 1)),
      ),
      eventData: Event(
        title: 'Event 1',
        description: 'This is a description of event 1',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfMonday,
        end: startOfTuesday,
      ),
      eventData: Event(
        title: 'Event 2',
        description: 'This is a description of event 2',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfMonday,
        end: startOfTuesday,
      ),
      eventData: Event(
        title: 'Event 3',
        description: 'This is a description of event 3',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfMonday.add(const Duration(hours: 6)),
        end: startOfMonday.add(const Duration(hours: 10)),
      ),
      eventData: Event(
        title: 'Event 4',
        description: 'This is a description of event 4',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfTuesday.add(const Duration(hours: 6)),
        end: startOfTuesday.add(const Duration(hours: 10)),
      ),
      eventData: Event(
        title: 'Event 5',
        description: 'This is a description of event 5',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfWednesday.add(const Duration(hours: 6)),
        end: startOfWednesday.add(const Duration(hours: 11)),
      ),
      eventData: Event(
        title: 'Event 6',
        description: 'This is a description of event 6',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfThursday.add(const Duration(hours: 6)),
        end: startOfThursday.add(const Duration(hours: 10)),
      ),
      eventData: Event(
        title: 'Event 7',
        description: 'This is a description of event 7',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfFriday.add(const Duration(hours: 6)),
        end: startOfFriday.add(const Duration(hours: 12)),
      ),
      eventData: Event(
        title: 'Event 8',
        description: 'This is a description of event 8',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfSaturday.add(const Duration(hours: 6)),
        end: startOfSaturday.add(const Duration(hours: 12)),
      ),
      eventData: Event(
        title: 'Event 9',
        description: 'This is a description of event 9',
        color: Colors.blue,
      ),
    ),
    CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(
        start: startOfSunday.add(const Duration(hours: 6)),
        end: startOfSunday.add(const Duration(hours: 18)),
      ),
      eventData: Event(
        title: 'Event 10',
        description: 'This is a description of event 10',
        color: Colors.blue,
      ),
    ),
  ];

  return events;
}
