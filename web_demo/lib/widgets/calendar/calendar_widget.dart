import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/dialogs/event_edit_dialog.dart';
import 'package:web_demo/widgets/dialogs/new_event_dialog.dart';
import 'package:web_demo/widgets/event_tiles/event_tile.dart';
import 'package:web_demo/widgets/event_tiles/multi_day_event_tile.dart';
import 'package:web_demo/widgets/event_tiles/schedule_event_tile.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.calendarComponents,
    required this.calendarStyle,
    required this.calendarLayoutDelegates,
    required this.currentConfiguration,
    required this.onDateTapped,
  });

  final CalendarEventsController<Event> eventsController;
  final CalendarController<Event> calendarController;
  final CalendarComponents calendarComponents;
  final CalendarStyle calendarStyle;
  final CalendarLayoutDelegates<Event> calendarLayoutDelegates;

  final ViewConfiguration currentConfiguration;
  final VoidCallback onDateTapped;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return CalendarView<Event>(
      controller: widget.calendarController,
      eventsController: widget.eventsController,
      viewConfiguration: widget.currentConfiguration,
      tileBuilder: _tileBuilder,
      multiDayTileBuilder: _multiDayTileBuilder,
      scheduleTileBuilder: _scheduleTileBuilder,
      components: widget.calendarComponents,
      style: widget.calendarStyle,
      layoutDelegates: widget.calendarLayoutDelegates,
      eventHandlers: CalendarEventHandlers<Event>(
        onEventChanged: onEventChanged,
        onEventTapped: onEventTapped,
        onCreateEvent: onCreateEvent,
        onDateTapped: onDateTapped,
      ),
    );
  }

  /// This function is called when a new event is created.
  Future<void> onCreateEvent(CalendarEvent<Event> newEvent) async {
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
      widget.eventsController.addEvent(event);
    } else {
      widget.eventsController.deselectEvent();
    }
  }

  /// This function is called when an event is tapped.
  Future<void> onEventTapped(CalendarEvent<Event> event) async {
    // Make a copy of the event to restore it if the user cancels the changes.
    CalendarEvent<Event> copyOfEvent = event.copyWith();

    // Show the edit dialog.
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventEditDialog(
          dialogTitle: 'Edit Event',
          event: event,
          deleteEvent: widget.eventsController.removeEvent,
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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the snackbar and undo the changes if the user presses the undo button.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event.eventData?.title} changed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            widget.eventsController.updateEvent(
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
    // If the current view is not the single day view, change the view to the single day view.
    if (widget.currentConfiguration is! DayConfiguration) {
      // Set the selected date to the tapped date.
      // widget.calendarController.selectedDate = date;
      widget.onDateTapped();
      // widget.currentConfiguration = widget.viewConfigurations.first;
    }
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

  Widget _scheduleTileBuilder(
    CalendarEvent<Event> event,
    DateTime date,
  ) {
    return ScheduleTile(
      event: event,
      date: date,
    );
  }
}
