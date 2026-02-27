import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/components.dart';
import 'package:recurrence/dialog.dart';

import 'package:recurrence/recurrence.dart';
import 'package:recurrence/toolbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Recurrence',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
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
  final now = DateTime.now();
  late final displayRange =
      DateTimeRange(start: now.copyWith(day: now.day - 365), end: now.copyWith(day: now.day + 365));
  final calendarController = CalendarController();
  final controller = RecurrenceController();
  late ViewConfiguration viewConfiguration = MultiDayViewConfiguration.week(
    displayRange: displayRange,
    firstDayOfWeek: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView(
        eventsController: controller.controller,
        calendarController: calendarController,
        viewConfiguration: viewConfiguration,
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) => calendarController.selectEvent(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) async {
            final recurrence = await showRecurrenceDialog(event);
            if (recurrence == null) return;
            controller.addEvent(event, recurrence);
          },
          onEventChanged: controller.updateEvent,
        ),
        header: Material(
          color: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: 2,
          child: Column(
            children: [
              CalendarToolBar(calendarController: calendarController),
              CalendarHeader(multiDayTileComponents: tileComponents(context, body: false)),
            ],
          ),
        ),
        body: CalendarBody(
          multiDayTileComponents: tileComponents(context),
          monthTileComponents: tileComponents(context, body: false),
          scheduleTileComponents: scheduleTileComponents(context),
          multiDayBodyConfiguration: MultiDayBodyConfiguration(showMultiDayEvents: false),
          monthBodyConfiguration: MonthBodyConfiguration(),
        ),
      ),
    );
  }

  Future<Recurrence?> showRecurrenceDialog(CalendarEvent event) async {
    return showAdaptiveDialog<Recurrence?>(
      context: context,
      builder: (context) => RecurrenceDialog(event),
    );
  }
}
