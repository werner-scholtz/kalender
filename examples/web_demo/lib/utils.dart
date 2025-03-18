import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';


/// Generate a list of events for the demo.
List<CalendarEvent<Event>> generateEvents(BuildContext context) {
  final now = DateTime.now();
  return List.generate(14, (index) {
    final start = now.add(Duration(days: index - 7));
    final end = start.add(Duration(hours: Random().nextInt(3) + 1));
    return CalendarEvent(
      data: Event(
        title: 'Event $index',
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      dateTimeRange: DateTimeRange(start: start, end: end),
    );
  });
}
