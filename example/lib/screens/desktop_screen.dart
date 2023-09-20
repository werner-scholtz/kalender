import 'dart:developer';

import 'package:example/widgets/calendar_customization/calendar_customization.dart';
import 'package:example/widgets/components/calendar_header_desktop.dart';
import 'package:flutter/material.dart';
import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_tiles/tiles_export.dart';
import 'package:example/widgets/dialogs/event_edit_dialog.dart';
import 'package:example/widgets/dialogs/new_event_dialog.dart';
import 'package:kalender/kalender.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    super.key,
    required this.eventsController,
  });

  final CalendarEventsController<Event> eventsController;

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  late CalendarEventsController<Event> eventsController;
  late CalendarController<Event> calendarController;
  late CalendarComponents components;
  late CalendarLayoutControllers<Event> layoutControllers;
  late CalendarStyle style;

  /// The current view configuration.
  late ViewConfiguration currentConfiguration = viewConfigurations[1];

  /// The list of view configurations that can be used.
  late List<ViewConfiguration> viewConfigurations = [
    const MultiDayConfiguration(
      name: 'Day',
      numberOfDays: 1,
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
      name: 'Multiday',
      numberOfDays: 2,
      eventSnapping: true,
      timeIndicatorSnapping: true,
    ),
    const MonthConfiguration(
      enableRezising: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    eventsController = widget.eventsController;
    calendarController = CalendarController();
    components = CalendarComponents(
      calendarHeaderBuilder: _calendarHeaderBuilder,
    );
    layoutControllers = CalendarLayoutControllers();
    style = const CalendarStyle();
  }

  @override
  void didUpdateWidget(covariant DesktopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.eventsController != oldWidget.eventsController) {
      eventsController = widget.eventsController;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CalendarView<Event>(
            controller: calendarController,
            eventsController: eventsController,
            viewConfiguration: currentConfiguration,
            tileBuilder: _tileBuilder,
            multiDayTileBuilder: _multiDayTileBuilder,
            monthTileBuilder: _monthEventTileBuilder,
            components: components,
            layoutControllers: layoutControllers,
            style: style,
            eventHandlers: CalendarEventHandlers<Event>(
              onEventChanged: onEventChanged,
              onEventTapped: onEventTapped,
              onCreateEvent: onCreateEvent,
              onDateTapped: onDateTapped,
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: CalendarCustomization(
                currentConfiguration: currentConfiguration,
                components: components,
                layoutControllers: layoutControllers,
                style: style,
                onComponentChange: (components) =>
                    setState(() => this.components = components),
                onLayoutControllerChange: (layoutControllers) =>
                    setState(() => this.layoutControllers = layoutControllers),
                onStyleChange: (style) => setState(() => this.style = style),
                onConfigurationChange: (configuration) => setState(
                  () {
                    currentConfiguration = configuration;
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// This function is called when a new event is created.
  Future<void> onCreateEvent(newEvent) async {
    newEvent.eventData = Event(
      title: 'New Event',
      color: Colors.blue,
    );

    // Show the new event dialog.
    CalendarEvent<Event>? event = await showDialog<CalendarEvent<Event>>(
      context: context,
      builder: (BuildContext context) {
        return NewEventDialog(
          dialogTitle: 'Create Event',
          event: newEvent,
        );
      },
    );

    /// Add the event to the events controller.
    if (event != null) {
      eventsController.addEvent(event);
    } else {
      eventsController.deselectEvent();
    }
  }

  /// This function is called when an event is tapped.
  Future<void> onEventTapped(event) async {
    // Make a copy of the event to restore it if the user cancels the changes.
    CalendarEvent<Event> copyOfEvent = event.copyWith();

    // Show the edit dialog.
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventEditDialog(
          dialogTitle: 'Edit Event',
          event: event,
          deleteEvent: (event) => eventsController.removeEvent(event),
          cancelEdit: () => event.eventData = copyOfEvent.eventData,
        );
      },
    );
  }

  /// This function is called when an event is changed.
  Future<void> onEventChanged(
    DateTimeRange initialDateTimeRange,
    CalendarEvent<Event> event,
  ) async {
    eventsController.deselectEvent();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    // Show the snackbar and undo the changes if the user presses the undo button.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event.eventData?.title} changed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            eventsController.updateEvent(
              newEventData: event.eventData,
              newDateTimeRange: initialDateTimeRange,
              test: (other) => other.eventData == event.eventData,
            );
          },
        ),
      ),
    );
  }

  /// This function is called when a date is tapped.
  void onDateTapped(date) {
    log('message');
    // If the current view is not the single day view, change the view to the single day view.
    if (currentConfiguration is! DayConfiguration) {
      setState(() {
        // Set the selected date to the tapped date.
        calendarController.selectedDate = date;
        currentConfiguration = viewConfigurations.first;
      });
    }
  }

  Widget _calendarHeaderBuilder(dateTimeRange) {
    return CalendarHeaderDesktop(
      calendarController: calendarController,
      viewConfigurations: viewConfigurations,
      currentConfiguration: currentConfiguration,
      onViewConfigurationChanged: (viewConfiguration) {
        setState(() {
          currentConfiguration = viewConfiguration;
        });
      },
      dateTimeRange: dateTimeRange,
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<Event> event,
    MultiDayTileConfiguration tileConfiguration,
  ) {
    return MultiDayEventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }

  Widget _tileBuilder(
    CalendarEvent<Event> event,
    TileConfiguration tileConfiguration,
  ) {
    return EventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      drawOutline: tileConfiguration.drawOutline,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }

  Widget _monthEventTileBuilder(
    CalendarEvent<Event> event,
    MonthTileConfiguration tileConfiguration,
  ) {
    return MonthEventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      date: tileConfiguration.date,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }
}
