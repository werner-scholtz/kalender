import 'package:flutter/material.dart';
import 'package:kalender/kalendar_scope.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/tile_configurations/multi_day_tile_configuration.dart';

class MultiDayEventTile<T> extends StatelessWidget {
  const MultiDayEventTile({
    super.key,
    required this.event,
    required this.tileConfiguration,
  });

  final CalendarEvent<T> event;
  final MultiDayTileConfiguration tileConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    return scope.tileComponents.multiDayTileBuilder!(
      event,
      tileConfiguration,
    );
  }
}
