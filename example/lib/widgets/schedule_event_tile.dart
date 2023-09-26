import 'package:example/models/event.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class ScheduleTile extends StatelessWidget {
  const ScheduleTile({
    super.key,
    required this.event,
    required this.date,
  });
  final CalendarEvent<Event> event;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: event.eventData?.color ?? Colors.blue,
      child: ListTile(
        title: Text(event.eventData?.title ?? ''),
        subtitle: Text(
          event.eventData?.description ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        mouseCursor: SystemMouseCursors.click,
        dense: true,
      ),
    );
  }
}
