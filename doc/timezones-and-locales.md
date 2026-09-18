# Timezones & Locales

This is part of the [kalender](README.md) documentation.

## Locale

Kalender uses the [intl](https://pub.dev/packages/intl) package to localize day and month names. Call `initializeDateFormatting()` before `runApp`:

<!-- snippet: file -->
```dart
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}
```

The function comes from `date_symbol_data_local.dart`, not from `intl.dart`. The intl package compiles in the `en_US` data only, so every other locale needs this call, including `en`. Without it, kalender throws an error naming the locale that failed and the call to add.

`KalenderView` has a `locale` property that controls day/month name formatting. It takes a `Locale`, and `Localizations.localeOf(context)` gives you the app's.

<!-- snippet: expression -->
```dart
KalenderView(
  locale: const Locale('af', 'ZA'),
  eventsController: eventsController,
  kalenderController: kalenderController,
  viewConfiguration: viewConfiguration,
)
```

The week number tooltip is the one string that defaults to English:

<!-- snippet: expression -->
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

See [Theming](appearance.md#theming).

### Custom text

Apart from the week number tooltip, every string the calendar writes can be
replaced with a string builder on the matching `*Components` class. Each one
receives the `BuildContext`, so it can read
the calendar's own locale with `context.kalenderLocale`, which is not necessarily
the app's locale. intl takes a string, so pass `toLanguageTag()`:

<!-- snippet: expression -->
```dart
import 'package:intl/intl.dart';

KalenderView(
  locale: const Locale('af', 'ZA'),
  eventsController: eventsController,
  kalenderController: kalenderController,
  viewConfiguration: viewConfiguration,
  components: KalenderComponents(
    multiDayComponents: MultiDayComponents(
      headerComponents: MultiDayHeaderComponents(
        dayHeaderStringBuilder: (context, date) => DateFormat.E(context.kalenderLocale?.toLanguageTag()).format(date),
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

The timeline follows `MaterialLocalizations` when the app installs them, so it
uses the device's 12-hour or 24-hour setting. Otherwise it follows the calendar's
`locale`. Fix the format with `timelineStringBuilder`:

<!-- snippet: expression -->
```dart
MultiDayBodyComponents(
  timelineStringBuilder: (context, time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
)
```

---

## Location

`KalenderView` accepts a `Location` from the [timezone](https://pub.dev/packages/timezone) package. The `KalenderEvent` constructor automatically converts `start` and `end` to UTC, so events are always stored in UTC internally and converted to the given location for display.

<!-- snippet: expression -->
```dart
import 'package:timezone/timezone.dart' as tz;

KalenderView(
  location: tz.getLocation('America/New_York'),
  eventsController: eventsController,
  kalenderController: kalenderController,
  viewConfiguration: viewConfiguration,
)
```

Pre-initialize `DefaultEventsController` with the locations you expect to query for best performance:

<!-- snippet: statements -->
```dart
import 'package:timezone/timezone.dart' as tz;

final eventsController = DefaultEventsController(
  locations: [
    tz.getLocation('America/New_York'),
    tz.getLocation('Europe/London'),
    tz.getLocation('Asia/Tokyo'),
  ],
);
```

See the [timezone package](https://pub.dev/packages/timezone) for setup instructions per platform. The [web demo](../examples/web_demo) also provides a working example.

Changing `location` at runtime automatically updates visible date/time ranges. Location identifiers follow the [IANA Time Zone Database](https://www.iana.org/time-zones).

### Events from an external source

When events come from an `.ics` file, a device calendar, or an API, map each source time to the exact instant it represents before building the `KalenderEvent`. The constructor stores the instant as UTC, so what matters is that the `DateTime` you pass points at the right moment.

- **UTC instant** (an `.ics` time ending in `Z`, or an epoch): pass it as-is.
- **Zoned time** (an IANA `TZID`): build a `TZDateTime` in that zone so the instant is correct.

  <!-- snippet: statements -->
  ```dart
  import 'package:timezone/timezone.dart' as tz;

  final start = tz.TZDateTime(tz.getLocation('Europe/London'), 2025, 1, 6, 9);
  final event = KalenderEvent(
    start: start, end: start.add(const Duration(hours: 1)),
  );
  ```

- **Floating time** (no zone, common in `.ics`): decide which zone it should mean, usually the calendar's `location`, and build a `TZDateTime` there.

Then set `KalenderView(location:)` to the zone the calendar should display in. The [ics example](../examples/ics) shows this end to end.

### Now Callback

By default, the time indicator position and "today" header highlighting are derived from the calendar's `Location`. To resolve "now" differently from the calendar's `Location`, pass a `NowCallback`:

<!-- snippet: expression -->
```dart
MultiDayViewConfiguration.week(
  nowCallback: DateTime.now, // system local time
)
```

The callback's return value is used for:
- Positioning the time indicator on the calendar grid.
- Determining which day is "today" for header highlighting (`DayHeader`, `MonthDayHeader`, `ScheduleDate`).
- Evaluating `EmptyDayBehavior.showOnlyToday` in schedule views.

Any `DateTime` subtype works, so the callback can return UTC or a `TZDateTime` in a
specific zone.

`nowCallback` is included in `==`, so store a closure rather than writing it inline.

When `nowCallback` is `null` (the default), the calendar falls back to its `Location`-based behavior.
