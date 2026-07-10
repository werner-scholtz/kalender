import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:web_demo/models/demo_configuration.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/providers.dart';

/// A palette of colors for the one-off demo events.
const _eventColors = [
  Color(0xFF6366F1),
  Color(0xFF8B5CF6),
  Color(0xFF06B6D4),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFEC4899),
  Color(0xFF3B82F6),
];

// Fixed colors for the recurring events, so a repeating event reads as the same
// thing every time it shows up.
const _standupColor = Color(0xFF6366F1);
const _meetingColor = Color(0xFF8B5CF6);
const _oneOnOneColor = Color(0xFF06B6D4);
const _personalColor = Color(0xFF10B981);
const _wrapUpColor = Color(0xFFF59E0B);
const _multiDayColor = Color(0xFFEC4899);

/// Titles for the one-off meetings sprinkled through the work week.
const _oneOffTitles = [
  'Design review',
  'Client call',
  'Code review',
  'Product demo',
  'Bug triage',
  'Roadmap review',
  'Budget meeting',
  'Vendor call',
  'Interview',
  'Onboarding session',
  'Coffee with Sam',
  'Dentist appointment',
  'Doctor appointment',
  'Planning workshop',
];

/// Titles for the occasional weekend event.
const _weekendTitles = [
  'Brunch with friends',
  'Hiking trip',
  'Farmers market',
  'Movie night',
  'Family visit',
];

/// Generate a realistic set of demo events around the current date.
///
/// Everything is built relative to today, so the demo always has events near
/// "now" no matter when it runs, and none of them go stale. The mix of a
/// weekday standup, a weekly meeting rhythm, personal blocks, sprinkled one-off
/// items, a few empty days, and a handful of multi-day events gives the views
/// (the schedule especially) something structured to show.
List<CalendarEvent> generateEvents(BuildContext context) {
  final random = Random(2024);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // A window on either side of today, so recent and upcoming days both fill in.
  const daysBefore = 45;
  const daysAfter = 120;

  final events = <CalendarEvent>[];

  Event timed(DateTime day, int hour, int minute, Duration duration, String title, Color color, {String? description}) {
    final start = DateTime(day.year, day.month, day.day, hour, minute);
    return Event(
      dateTimeRange: DateTimeRange(start: start, end: start.add(duration)),
      title: title,
      description: description,
      color: color,
    );
  }

  for (var offset = -daysBefore; offset <= daysAfter; offset++) {
    final day = today.add(Duration(days: offset));
    final weekday = day.weekday; // 1 = Monday ... 7 = Sunday.
    final isWeekend = weekday == DateTime.saturday || weekday == DateTime.sunday;

    if (!isWeekend) {
      // The daily standup anchors every weekday morning.
      events.add(timed(day, 9, 0, const Duration(minutes: 15), 'Daily standup', _standupColor));

      // A weekly rhythm that repeats on the same day each week.
      if (weekday == DateTime.monday) {
        events.add(
          timed(day, 10, 0, const Duration(hours: 1), 'Sprint planning', _meetingColor,
              description: 'Plan the work for the week ahead.'),
        );
      }
      if (weekday == DateTime.wednesday) {
        events.add(timed(day, 15, 0, const Duration(minutes: 30), '1:1 with Alex', _oneOnOneColor));
      }
      if (weekday == DateTime.friday) {
        events.add(timed(day, 16, 0, const Duration(minutes: 45), 'Week wrap-up', _wrapUpColor));
      }

      // A personal block a couple of mornings a week.
      if (weekday == DateTime.tuesday || weekday == DateTime.thursday) {
        events.add(timed(day, 7, 0, const Duration(hours: 1), 'Gym', _personalColor));
      }

      // Sprinkle nought to two one-off meetings, leaving some days lighter.
      final oneOffs = random.nextInt(3);
      for (var i = 0; i < oneOffs; i++) {
        final title = _oneOffTitles[random.nextInt(_oneOffTitles.length)];
        final hour = 11 + random.nextInt(6); // Between 11:00 and 16:00.
        final minute = random.nextBool() ? 0 : 30;
        final duration = Duration(minutes: const [30, 45, 60, 90][random.nextInt(4)]);
        events.add(timed(day, hour, minute, duration, title, _eventColors[random.nextInt(_eventColors.length)]));
      }
    } else if (random.nextInt(3) == 0) {
      // The odd weekend outing, so weekends are mostly, but not always, empty.
      final title = _weekendTitles[random.nextInt(_weekendTitles.length)];
      events.add(timed(day, 10 + random.nextInt(6), 0, const Duration(hours: 2), title, _personalColor));
    }
  }

  // A few multi-day events, positioned relative to today.
  void multiDay(int startOffset, int days, String title, Color color, {String? description}) {
    final start = today.add(Duration(days: startOffset));
    events.add(
      Event(
        dateTimeRange: DateTimeRange(start: start, end: start.add(Duration(days: days))),
        title: title,
        description: description,
        color: color,
      ),
    );
  }

  multiDay(-9, 2, 'Team offsite', _multiDayColor, description: 'Two days away with the team.');
  multiDay(4, 3, 'Flutter conference', _multiDayColor);
  multiDay(14, 1, 'Public holiday', _wrapUpColor);
  multiDay(24, 7, 'Vacation', _personalColor, description: 'Out of office.');

  return events;
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
