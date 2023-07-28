import 'dart:developer';

import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_tiles/tiles_export.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  @override
  Widget build(BuildContext context) {
    return CalendarView<Event>(
      calendarConfiguration: CalendarConfiguration(
        createNewEvents: true,
      ),
      onCreateEvent: (newEvent) async {
        log('onCreateEvent');
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
