import 'dart:io';

import 'package:example/functions/generate_calendar_eventsd.dart';
import 'package:example/models/event.dart';
import 'package:example/screens/desktop_screen.dart';
import 'package:example/screens/mobile_screen.dart';
import 'package:example/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.dark;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      themeMode: themeMode,
      home: MyHomePage(
        toggleTheme: toggleTheme,
      ),
    );
  }

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.toggleTheme,
  });
  final void Function() toggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CalendarEventsController<Event> eventController;

  @override
  void initState() {
    super.initState();
    eventController = CalendarEventsController<Event>();
    eventController.addEvents(generateCalendarEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
            return DesktopScreen(
              eventsController: eventController,
              viewConfigurations: viewConfigurations,
            );
          } else {
            return MobileScreen(
              eventsController: eventController,
              viewConfigurations: viewConfigurations,
            );
          }
        },
      ),
    );
  }

  /// The list of view configurations that can be used.
  List<ViewConfiguration> viewConfigurations = [
    const DayConfiguration(
      eventSnapping: true,
      timeIndicatorSnapping: true,
    ),
    const WeekConfiguration(
      eventSnapping: true,
      timeIndicatorSnapping: true,
    ),
    const WorkWeekConfiguration(
      eventSnapping: true,
      timeIndicatorSnapping: true,
    ),
    const MultiDayConfiguration(
      name: 'Two Day',
      numberOfDays: 2,
      eventSnapping: true,
      timeIndicatorSnapping: true,
    ),
    const MultiDayConfiguration(
      name: 'Three Day',
      numberOfDays: 3,
      eventSnapping: true,
      timeIndicatorSnapping: true,
    ),
    const MultiDayConfiguration(
      name: 'Four Day',
      numberOfDays: 4,
      eventSnapping: true,
      timeIndicatorSnapping: true,
    ),
    const MonthConfiguration(
      enableRezising: true,
    ),
  ];
}
