// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

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
      KalenderDateTimeRange(start: now.copyWith(day: now.day - 365), end: now.copyWith(day: now.day + 365));
  late final kalenderController = KalenderController(
    viewConfiguration: MultiDayViewConfiguration.week(displayRange: displayRange, firstDayOfWeek: 1),
  );
  final controller = RecurrenceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KalenderView(
        eventsController: controller.controller,
        kalenderController: kalenderController,
        callbacks: KalenderCallbacks(
          onEventTapped: (event) => _onEventTapped(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) async {
            final result = await _showDialog(event);
            if (result is! RecurrenceDialogSave) return;
            controller.addEvent(event, result.recurrence);
          },
          onEventChanged: controller.updateEvent,
        ),
        views: [
          MultiDayViewParts(
            header: _header(context, MultiDayHeader(tileComponents: tileComponents(context, body: false))),
            body: MultiDayBody(
              configuration: MultiDayBodyConfiguration(showMultiDayEvents: false),
              tileComponents: tileComponents(context),
            ),
          ),
          MonthViewParts(
            header: _header(context, const MonthHeader()),
            body: MonthBody(tileComponents: tileComponents(context, body: false)),
          ),
          ScheduleViewParts(
            header: _header(context),
            body: ScheduleBody(tileComponents: scheduleTileComponents(context)),
          ),
        ],
      ),
    );
  }

  /// The toolbar above [child].
  Widget _header(BuildContext context, [Widget? child]) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 2,
      child: Column(
        children: [
          CalendarToolBar(kalenderController: kalenderController),
          if (child != null) child,
        ],
      ),
    );
  }

  void _onEventTapped(KalenderEvent event) async {
    kalenderController.selectEvent(event);

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

    kalenderController.deselectEvent();
  }

  Future<RecurrenceDialogResult?> _showDialog(
    KalenderEvent event, {
    RecurrenceGroup? existingGroup,
  }) {
    return showAdaptiveDialog<RecurrenceDialogResult?>(
      context: context,
      builder: (context) => RecurrenceDialog(event, existingGroup: existingGroup),
    );
  }
}
