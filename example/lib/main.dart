import 'dart:io';

import 'package:example/models/event.dart';
import 'package:example/functions/generate_calendar_events.dart';
import 'package:example/screens/desktop.dart';
import 'package:example/screens/mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
          if (constraints.maxWidth < 500) {
            return MobileScreen(
              eventsController: eventController,
            );
          }
          return DesktopScreen(
            eventsController: eventController,
          );
        } else {
          return MobileScreen(
            eventsController: eventController,
          );
        }
      },
    );
  }
}
