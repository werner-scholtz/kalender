import 'package:example/models/event.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class ScheduleEventTile extends StatelessWidget {
  const ScheduleEventTile({
    super.key,
    required this.event,
    required this.date,
  });

  final CalendarEvent<Event> event;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: event.eventData?.color ??
          Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 108,
              child: Text(event.isMultidayEvent
                  ? 'All Day'
                  : '${event.start.hour}:${event.start.minute} - ${event.end.hour}:${event.end.minute}'),
            ),
            Text(
              event.eventData?.title ?? '',
            ),
            if (event.hasDateCounter)
              Text(
                '(${event.dayNumber(date)}/${event.daySpan})',
              ),
          ],
        ),
      ),
    );
  }
}
