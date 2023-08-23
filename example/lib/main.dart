import 'dart:io';

import 'package:example/functions/generate_calendar_eventsd.dart';
import 'package:example/models/event.dart';
import 'package:example/screens/desktop_screen.dart';
import 'package:example/screens/mobile_screen.dart';
import 'package:example/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import 'shortcuts/shortcuts.dart';

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
    return Shortcuts(
      shortcuts: shortcuts,
      child: Scaffold(
        body: LayoutBuilder(
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
        ),
      ),
    );
  }
}
