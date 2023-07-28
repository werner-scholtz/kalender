import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_tiles/event_tile.dart';
import 'package:example/widgets/calendar_tiles/month_event_tile.dart';
import 'package:example/widgets/calendar_tiles/multi_day_event_tile.dart';
import 'package:example/widgets/calendar_tiles/schedule_event_tile.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    super.key,
    required this.controller,
  });

  final CalendarController<Event> controller;
  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  late CalendarController<Event> controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  void didUpdateWidget(covariant DesktopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView<Event>(
      calendarConfiguration: CalendarConfiguration(),
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
