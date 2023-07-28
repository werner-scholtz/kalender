import 'dart:developer';

import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_tiles/event_tile.dart';
import 'package:example/widgets/calendar_tiles/month_event_tile.dart';
import 'package:example/widgets/calendar_tiles/multi_day_event_tile.dart';
import 'package:example/widgets/calendar_tiles/schedule_event_tile.dart';
import 'package:example/widgets/dialogs/event_edit_dialog.dart';
import 'package:example/widgets/dialogs/new_event_dialog.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<CalendarViewState> key = GlobalKey<CalendarViewState>();
    return CalendarView<Event>(
      key: key,
      calendarConfiguration: CalendarConfiguration(
        createNewEvents: true,
      ),
      onEventChanged: (initialDateTimeRange, event) async {
        // Show the snackbar and undo the changes if the user presses the undo button.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${event.eventData?.title} changed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                key.currentState?.controller.updateEvent(
                  newEventData: event.eventData,
                  newDateTimeRange: initialDateTimeRange,
                  test: (other) => other.eventData == event.eventData,
                );
              },
            ),
          ),
        );
      },
      onEventTapped: (event) async {
        // Make a copy of the event to restore it if the user cancels the changes.
        CalendarEvent<Event> copyOfEvent = event.copyWith();

        // Show the edit dialog.
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return EventEditDialog(
              dialogTitle: 'Edit Event',
              event: event,
              deleteEvent: (event) => key.currentState?.controller.removeEvent(event),
              cancelEdit: () => event.repalceWith(event: copyOfEvent),
            );
          },
        );
      },
      onCreateEvent: (newEvent) async {
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

        log(event.toString());

        // return the new event. (if the user cancels the dialog, null is returned)
        return event;
      },
      calendarComponents: CalendarComponents(
        eventTileBuilder: (event, tileType, drawOutline, continuesBefore, continuesAfter) {
          return EventTile(
            event: event,
            tileType: tileType,
            drawOutline: drawOutline,
            continuesBefore: continuesBefore,
            continuesAfter: continuesAfter,
          );
        },
        multiDayEventTileBuilder: (event, tileType, continuesBefore, continuesAfter) {
          return MultiDayEventTile(
            event: event,
            tileType: tileType,
            continuesBefore: continuesBefore,
            continuesAfter: continuesAfter,
          );
        },
        monthEventTileBuilder: (event, tileType, date) {
          return MonthEventTile(
            event: event,
            tileType: tileType,
            date: date,
          );
        },
        scheduleEventTileBuilder: (event, date) {
          return ScheduleEventTile(
            event: event,
            date: date,
          );
        },
      ),
    );
  }
}
