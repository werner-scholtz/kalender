import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:web_demo/models/event.dart';

/// Generate a list of events for the demo.
List<CalendarEvent<Event>> generateEvents(BuildContext context) {
  final now = DateTime.now();
  const numOfEvents = 1000;
  return List.generate(numOfEvents, (index) {
    final start = now.add(Duration(days: index - (numOfEvents ~/ 2)));
    final end = start.add(Duration(hours: Random().nextInt(3) + 1));
    return CalendarEvent(
      data: Event(
        title: 'Event $index',
        color: Colors.blue,
      ),
      dateTimeRange: DateTimeRange(start: start, end: end),
    );
  });
}


extension BuildContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  String get localeTag => Localizations.localeOf(this).toLanguageTag();
}