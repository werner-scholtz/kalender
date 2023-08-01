import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_tiles/event_tile.dart';
import 'package:example/widgets/calendar_tiles/tiles_export.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    super.key,
    required this.eventController,
  });

  final CalendarEventController<Event> eventController;

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  late CalendarEventController<Event> eventController;
  late CalendarController calendarController;
  late CalendarComponents<Event> components;

  @override
  void initState() {
    super.initState();
    eventController = widget.eventController;
    calendarController = CalendarController();
    components = CalendarComponents<Event>(
      calendarHeaderBuilder: _calendarHeader,
      eventTileBuilder: _eventTile,
      multiDayEventTileBuilder: _multiDayEventTile,
      monthEventTileBuilder: _monthEventTile,
      scheduleEventTileBuilder: _scheduleEventTile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: SingleDayView<Event>(
            controller: calendarController,
            eventController: eventController,
            components: components,
          ),
        ),
        // Flexible(
        //   flex: 1,
        //   child: MultidDayView(
        //     controller: calendarController,
        //     eventController: eventController,
        //     components: components,
        //   ),
        // ),
      ],
    );
  }

  Widget _calendarHeader(dateTimeRange, viewConfiguration) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: () {
            calendarController.animateToPreviousPage();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        IconButton.filledTonal(
          onPressed: () {
            calendarController.animateToNextPage();
          },
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  Widget _scheduleEventTile(event, date) {
    return ScheduleEventTile(
      event: event,
      date: date,
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
}
