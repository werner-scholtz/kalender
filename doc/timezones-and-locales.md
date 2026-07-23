# Timezones & Locales

This is part of the [kalender](../README.md) documentation.

## Locale

Kalender uses the [intl](https://pub.dev/packages/intl) package to localize day and month names. Call `initializeDateFormatting()` before `runApp`:

```dart
void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}
```

`CalendarView` has a `locale` property that controls day/month name formatting.

```dart
CalendarView(
  locale: 'af_ZA',
  // ...
)
```

Day and month names come from `intl`. The overlay button that stands in for events
that do not fit is labelled with a plus sign and the count, `+3`, with the number
formatted for the calendar's locale, so it needs no translation. The week number's
tooltip is the one string that still defaults to English:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      KalenderThemeData(
        weekNumberStyle: WeekNumberStyle(tooltip: 'Weeknummer'),
      ),
    ],
  ),
)
```

It can be set either way: on a single `CalendarView` through `CalendarComponents`, or
once for the whole app through [`KalenderThemeData`](appearance.md#theming).

### Custom text

Every string the calendar writes can be replaced with a string builder on the
matching `*Components` class. Each one receives the `BuildContext`, so it can read
the calendar's own locale with `context.calendarLocale`, which is not necessarily
the app's locale:

```dart
CalendarView(
  locale: 'af_ZA',
  components: CalendarComponents(
    multiDayComponents: MultiDayComponents(
      headerComponents: MultiDayHeaderComponents(
        dayHeaderStringBuilder: (context, date) => DateFormat.E(context.calendarLocale).format(date),
      ),
    ),
    overlayBuilders: OverlayBuilders(
      multiDayPortalOverlayButtonStringBuilder: (context, n) => '$n meer',
    ),
  ),
)
```

The builders are `dayHeaderStringBuilder` and `dayHeaderNumberStringBuilder` on
`MultiDayHeaderComponents`, `timelineStringBuilder` on `MultiDayBodyComponents`,
`monthDayHeaderStringBuilder` on `MonthBodyComponents`, `weekDayHeaderStringBuilder`
on `MonthHeaderComponents`, `leadingDateStringBuilder` on `ScheduleComponents`, and
`multiDayPortalOverlayButtonStringBuilder` on `OverlayBuilders`.

---

## Location

`CalendarView` accepts a `Location` from the [timezone](https://pub.dev/packages/timezone) package. The `CalendarEvent` constructor automatically converts `dateTimeRange` values to UTC, so events are always stored in UTC internally and converted to the given location for display.

```dart
import 'package:timezone/timezone.dart' as tz;

CalendarView(
  location: tz.getLocation('America/New_York'),
  eventsController: eventsController,
  calendarController: calendarController,
  viewConfiguration: viewConfiguration,
)
```

Pre-initialize `DefaultEventsController` with the locations you expect to query for best performance:

```dart
final eventsController = DefaultEventsController(
  locations: [
    tz.getLocation('America/New_York'),
    tz.getLocation('Europe/London'),
    tz.getLocation('Asia/Tokyo'),
  ],
);
```

See the [timezone package](https://pub.dev/packages/timezone) for setup instructions per platform. The [web demo](https://github.com/werner-scholtz/kalender/tree/main/examples/web_demo) also provides a working example.

Changing `location` at runtime automatically updates visible date/time ranges. Location identifiers follow the [IANA Time Zone Database](https://www.iana.org/time-zones).

### Events from an external source

When events come from an `.ics` file, a device calendar, or an API, map each source time to the exact instant it represents before building the `CalendarEvent`. The constructor stores the instant as UTC, so what matters is that the `DateTime` you pass points at the right moment.

- **UTC instant** (an `.ics` time ending in `Z`, or an epoch): pass it as-is.
- **Zoned time** (an IANA `TZID`): build a `TZDateTime` in that zone so the instant is correct.

  ```dart
  final start = tz.TZDateTime(tz.getLocation('Europe/London'), 2025, 1, 6, 9);
  final event = CalendarEvent(
    dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(hours: 1))),
  );
  ```

- **Floating time** (no zone, common in `.ics`): decide which zone it should mean, usually the calendar's `location`, and build a `TZDateTime` there.

Then set `CalendarView(location:)` to the zone the calendar should display in. The [ics example](https://github.com/werner-scholtz/kalender/tree/main/examples/ics) shows this end to end.

### Now Callback

By default, the time indicator position and "today" header highlighting are derived from the calendar's `Location`. If your app stores wall-clock times as UTC (e.g. an application where `location: UTC`) but still wants the indicator and today highlight to reflect the user's local time, pass a `NowCallback` on your view configuration:

```dart
MultiDayViewConfiguration.week(
  nowCallback: () => DateTime.now(), // system local time
)
```

The callback's return value is used for:
- Positioning the time indicator on the calendar grid.
- Determining which day is "today" for header highlighting (`DayHeader`, `MonthDayHeader`, `ScheduleDate`).
- Evaluating `EmptyDayBehavior.showOnlyToday` in schedule views.

Any `DateTime` subtype works: `DateTime.now()`, `DateTime.now().toUtc()`, or `TZDateTime.now(location)` for a specific timezone.

When `nowCallback` is `null` (the default), the calendar falls back to its `Location`-based behavior.
