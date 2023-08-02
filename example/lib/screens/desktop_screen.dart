import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_header.dart';
import 'package:example/widgets/calendar_tiles/tiles_export.dart';
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
  late CalendarEventsController<Event> eventController;

  // The calendar controller.
  // This is used to control events.
  late CalendarController<Event> calendarController;
  late CalendarComponents components;

  // The current view configuration.
  late ViewConfiguration currentConfiguration = viewConfigurations.first;

  // The list of view configurations.
  List<ViewConfiguration> viewConfigurations = [
    const DayConfiguration(),
    const WeekConfiguration(),
    const WorkWeekConfiguration(),
    const ThreeDayConfiguration(),
  ];

  @override
  void initState() {
    super.initState();
    eventController = widget.eventController;
    calendarController = CalendarController();
    components = CalendarComponents(
      calendarHeaderBuilder: _calendarHeader,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (currentConfiguration is SingleDayViewConfiguration) {
          return SingleDayView<Event>(
            controller: calendarController,
            eventsController: eventController,
            components: components,
            eventTileBuilder: _eventTile,
            multiDayEventTileBuilder: _multiDayEventTile,
            viewConfiguration: currentConfiguration as SingleDayViewConfiguration,
          );
        } else if (currentConfiguration is MultiDayViewConfiguration) {
          return MultiDayView<Event>(
            controller: calendarController,
            eventsController: eventController,
            components: components,
            eventsTileBuilder: _eventTile,
            multiDayEventTileBuilder: _multiDayEventTile,
            viewConfiguration: currentConfiguration as MultiDayViewConfiguration,
          );
        } else if (currentConfiguration is MonthViewConfiguration) {
          return Container();
        } else if (currentConfiguration is ScheduleViewConfiguration) {
          return Container();
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
}
