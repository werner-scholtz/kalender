import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:web_demo/models/event.dart';

/// A palette of colors for demo events.
const _eventColors = [
  Color(0xFF6366F1),
  Color(0xFF8B5CF6),
  Color(0xFF06B6D4),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFEC4899),
  Color(0xFF3B82F6),
];

/// Generate a list of events for the demo.
List<CalendarEvent> generateEvents(BuildContext context) {
  final now = DateTime.now();
  const numOfEvents = 1000;
  return List.generate(numOfEvents, (index) {
    final start = now.add(Duration(days: index - (numOfEvents ~/ 2)));
    final end = start.add(Duration(hours: Random().nextInt(3) + 1));
    return Event(
      dateTimeRange: DateTimeRange(start: start, end: end),
      title: 'Event $index',
      color: _eventColors[index % _eventColors.length],
    );
  });
}

extension BuildContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  String get localeTag => Localizations.localeOf(this).toLanguageTag();
}
