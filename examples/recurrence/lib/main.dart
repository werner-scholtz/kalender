import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/components.dart';
import 'package:recurrence/dialog.dart';

import 'package:recurrence/recurrence.dart';
import 'package:recurrence/recurring_event.dart';
import 'package:recurrence/toolbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Recurrence Example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
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
          onEventTapped: (event, renderBox) => _onEventTapped(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) async {
            final result = await _showDialog(event);
            if (result is! RecurrenceDialogSave) return;
            controller.addEvent(event, result.recurrence);
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

  void _onEventTapped(CalendarEvent event) async {
    calendarController.selectEvent(event);

    final group = event is RecurringCalendarEvent ? controller.groupFor(event) : null;
    final result = await _showDialog(event, existingGroup: group);

    if (result is RecurrenceDialogSave) {
      if (group != null) {
        // Editing an existing group — replace all events.
        controller.replaceRecurrence(group.id, result.recurrence);
      } else {
        // Non-recurring event tapped — create a new recurrence from it.
        controller.addEvent(event, result.recurrence);
      }
    } else if (result is RecurrenceDialogDelete && group != null) {
      controller.deleteGroup(group.id);
    }

    calendarController.deselectEvent();
  }

  Future<RecurrenceDialogResult?> _showDialog(
    CalendarEvent event, {
    RecurrenceGroup? existingGroup,
  }) {
    return showAdaptiveDialog<RecurrenceDialogResult?>(
      context: context,
      builder: (context) => RecurrenceDialog(event, existingGroup: existingGroup),
    );
  }
}
