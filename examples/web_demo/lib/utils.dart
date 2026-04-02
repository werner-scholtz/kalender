import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:web_demo/models/demo_configuration.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/providers.dart';

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
  final date = DateTime(now.year, now.month, now.day, now.hour);
  const numOfEvents = 1000;
  return List.generate(numOfEvents, (index) {
    final start = date.add(Duration(days: index - (numOfEvents ~/ 2)));
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
  AppSettings get appSettings => AppSettingsProvider.of(this);
  ValueNotifier<ThemeMode> get themeModeNotifier => appSettings.themeMode;
  ValueNotifier<TextDirection> get textDirectionNotifier => appSettings.textDirection;
  ValueNotifier<Locale> get localeNotifier => appSettings.locale;
  EventsController get eventsController => EventsControllerProvider.of(this);
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  ValueNotifier<Location?> get location => CalendarScope.locationOf(this);
  DemoConfiguration get configuration => CalendarScope.configurationOf(this);
  CalendarController get controller => CalendarScope.controllerOf(this);
}

final isTouch = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
