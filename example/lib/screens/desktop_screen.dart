import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_header.dart';
import 'package:example/widgets/calendar_tiles/tiles_export.dart';
import 'package:example/widgets/dialogs/event_edit_dialog.dart';
import 'package:example/widgets/dialogs/new_event_dialog.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    super.key,
    required this.eventController,
  });

  final CalendarEventsController<Event> eventController;

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  // The event controller.
  // This is used to control the calendar such as,
  // jump/animate to a specific date/event.
  late CalendarEventsController<Event> eventsController;

  // The calendar controller.
  // This is used to control events.
  late CalendarController<Event> calendarController;
  late CalendarComponents components;
  late CalendarFunctions<Event> functions;

  // The current view configuration.
  late ViewConfiguration currentConfiguration = viewConfigurations.first;

  // The list of view configurations.
  List<ViewConfiguration> viewConfigurations = [
    const DayConfiguration(),
    const WeekConfiguration(),
    const WorkWeekConfiguration(),
    const ThreeDayConfiguration(),
    const MonthConfiguration(),
  ];

  @override
  void initState() {
    super.initState();
    eventsController = widget.eventController;
    calendarController = CalendarController();
    components = CalendarComponents(
      calendarHeaderBuilder: _calendarHeader,
    );
    functions = CalendarFunctions<Event>(
      onEventChanged: onEventChanged,
      onEventTapped: onEventTapped,
      onCreateEvent: onCreateEvent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (currentConfiguration is SingleDayViewConfiguration) {
          return SingleDayView<Event>(
            controller: calendarController,
            eventsController: eventsController,
            components: components,
            eventTileBuilder: _eventTile,
            multiDayEventTileBuilder: _multiDayEventTile,
            viewConfiguration: currentConfiguration as SingleDayViewConfiguration,
            functions: functions,
          );
        } else if (currentConfiguration is MultiDayViewConfiguration) {
          return MultiDayView<Event>(
            controller: calendarController,
            eventsController: eventsController,
            components: components,
            eventsTileBuilder: _eventTile,
            multiDayEventTileBuilder: _multiDayEventTile,
            viewConfiguration: currentConfiguration as MultiDayViewConfiguration,
            functions: functions,
          );
        } else if (currentConfiguration is MonthViewConfiguration) {
          return MonthView<Event>(
            controller: calendarController,
            eventsController: eventsController,
            monthEventTileBuilder: _monthEventTile,
            components: components,
            viewConfiguration: currentConfiguration as MonthViewConfiguration,
            functions: functions,
          );
        }
        return Container();
      },
    );
  }

  Widget _calendarHeader(dateTimeRange) {
    return CalendarHeader(
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

  Widget _multiDayEventTile(event, tileType, continuesBefore, continuesAfter) {
    return MultiDayEventTile(
      event: event,
      tileType: tileType,
      continuesBefore: continuesBefore,
      continuesAfter: continuesAfter,
    );
  }

  Widget _eventTile(event, tileType, drawOutline, continuesBefore, continuesAfter) {
    return EventTile(
      event: event,
      tileType: tileType,
      drawOutline: drawOutline,
      continuesBefore: continuesBefore,
      continuesAfter: continuesAfter,
    );
  }

  Widget _monthEventTile(event, tileType, date, continuesBefore, continuesAfter) {
    return MonthEventTile(
      event: event,
      tileType: tileType,
      date: date,
      continuesBefore: continuesBefore,
      continuesAfter: continuesAfter,
    );
  }

  Future<CalendarEvent<Event>?> onCreateEvent(newEvent) async {
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

    // return the new event. (if the user cancels the dialog, null is returned)
    return event;
  }

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
          cancelEdit: () => event.repalceWith(event: copyOfEvent),
        );
      },
    );
  }

  Future<void> onEventChanged(initialDateTimeRange, event) async {
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
}
