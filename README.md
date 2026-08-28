<p align="center">
  <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/banner.png" width="100%" style="border-radius:6px; margin-top:8px; margin-bottom:8px;" />
</p>

<p align="center">
  <a href="https://pub.dev/packages/kalender"><img src="https://img.shields.io/pub/v/kalender.svg" alt="pub.dev version"></a>
  <a href="https://github.com/werner-scholtz/kalender/actions"><img src="https://github.com/werner-scholtz/kalender/actions/workflows/flutter_analyze_and_test.yml/badge.svg" alt="build status"></a>
  <a href="https://werner-scholtz.github.io/kalender/"><img src="https://img.shields.io/badge/demo-live-blueviolet.svg" alt="live demo"></a>
  <a href="https://werner-scholtz.github.io/kalender/dev/bench/"><img src="https://img.shields.io/badge/benchmarks-live-blueviolet.svg" alt="benchmarks"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="license: MIT"></a>
</p>

# Kalender

A highly customizable Flutter calendar widget with Day, Multi-day, Month and Schedule views. It supports drag-and-drop rescheduling, event resizing, timezones, and full control over appearance and behavior.

**[Live Demo](https://werner-scholtz.github.io/kalender/)** · **[Benchmarks](https://werner-scholtz.github.io/kalender/dev/bench/)** · **[Migration Guide](MIGRATION.md)**

> [!WARNING]
> This package is still in development, so breaking changes land in minor releases until 1.0.0. The caret range `flutter pub add` writes keeps you on one minor version, which is where fixes land. Every minor bump has an entry in the [migration guide](MIGRATION.md).
>
> If part of the API does not work for you, please [open an issue](https://github.com/werner-scholtz/kalender/issues).

<p align="center">
  <img src="readme_assets/desktop_light.png" alt="Week view on desktop, light theme" width="74%" />
  <img src="readme_assets/mobile_light.png" alt="Three-day view on mobile, light theme" width="23%" />
</p>
<p align="center">
  <img src="readme_assets/desktop_dark.png" alt="Week view on desktop, dark theme" width="74%" />
  <img src="readme_assets/mobile_dark.png" alt="Three-day view on mobile, dark theme" width="23%" />
</p>

## Features

- **Four views, one widget.** Day, Multi-day, Month and Schedule.
- **Reschedule by hand.** Drag, resize and zoom, on mouse, stylus, trackpad or touch.
- **Snapping you control.** To an interval, the time indicator, other events, or your own rule.
- **No fixed event model.** Subclass `CalendarEvent` and read your own fields anywhere.
- **Controllers and callbacks.** Navigate from code, and react to taps, creation and changes.
- **Replaceable, not just configurable.** Swap any widget, or keep it and restyle it.
- **Material 3 by default.** Follows your app's theme with no setup.
- **Timezone aware.** Events stored as UTC, shown in any IANA location. Tested under a matrix of timezones.
- **Localized.** Day and month names from intl, and every string replaceable.
- **MIT licensed.** No commercial license to buy.

## Installation

```bash
flutter pub add kalender
```

If you plan to use [location/timezones](doc/timezones-and-locales.md#location) support, also add:

```bash
flutter pub add timezone
```

If you plan to use [locale](doc/timezones-and-locales.md#locale) support, also add:

```bash
flutter pub add intl
```

---

## Quick Start

The minimal setup, using only the base `CalendarEvent` class with no custom fields:

<!-- snippet: file -->
```dart
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: MyCalendar()),
    );
  }
}

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();

  @override
  void dispose() {
    calendarController.dispose();
    eventsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KalenderView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MultiDayViewConfiguration.week(
        // Without this the day opens at midnight.
        initialTimeOfDay: const TimeOfDay(hour: 7, minute: 0),
      ),
      callbacks: CalendarCallbacks(
        onEventCreated: (event) => eventsController.addEvent(event),
      ),
      header: CalendarHeader(),
      body: CalendarBody(),
    );
  }
}
```

For a real app you almost always want custom fields on your events. See [Custom Events](doc/events.md#custom-events).

---

## Examples

Runnable apps in [`examples/`](examples/README.md):

| Example | Shows |
| --- | --- |
| [Basic](https://github.com/werner-scholtz/kalender/tree/main/examples/example) | All view types with a toolbar, sample events, and custom tiles. Start here. |
| [Advanced](https://github.com/werner-scholtz/kalender/tree/main/examples/advanced_example) | A custom event layout with a lane per person, zoom, and tap-location-aware event creation. |
| [Recurrence](https://github.com/werner-scholtz/kalender/tree/main/examples/recurrence) | Recurring events built on top of the package, which has no recurrence of its own. |
| [ICS](https://github.com/werner-scholtz/kalender/tree/main/examples/ics) | Importing and exporting `.ics` files, expanding `RRULE` recurrence lazily over the visible range. |
| [Riverpod](https://github.com/werner-scholtz/kalender/tree/main/examples/riverpod) | Sharing the controllers and the selected view through providers. |
| [Web demo](https://github.com/werner-scholtz/kalender/tree/main/examples/web_demo) | The source behind the [live demo](https://werner-scholtz.github.io/kalender/): every option, theming, locales, and a split view. |

---

## Documentation

The detailed guides live in [`doc/`](doc/README.md):

- **[Views](doc/views.md).** Multi-day (day, week, work week, custom day counts, free scroll), month and schedule. What carries over on a view switch: the focused date, the scroll position, the zoom level.
- **[Events](doc/events.md).** Subclassing `CalendarEvent` to attach your own data, updating events through the controller, and what puts an event in the multi-day header rather than the day timeline: the `MultiDayRule`, or `isAllDay` on the event itself.
- **[Interaction](doc/interaction.md).** Creating, rescheduling and resizing, set separately for the header and the body and lockable per event. Snapping to an interval, the time indicator, other events, or your own strategy. Zoom driven from the controller.
- **[Controllers & Callbacks](doc/controllers-and-callbacks.md).** Jumping and animating to a date or an event, switching views, reacting to taps, creation, resizing and rescheduling, and building a navigation toolbar.
- **[Appearance](doc/appearance.md).** A `ThemeExtension` with Material 3 defaults that follows your app's `ThemeData`, and replacing components outright: event tiles, day headers, the timeline gutter, the time indicator, the multi-day overflow overlay.
- **[Layout](doc/layout.md).** Where tiles are placed and sized, and how overlapping events share a column. Only needed for a custom layout strategy, such as one lane per person.
- **[Timezones & Locales](doc/timezones-and-locales.md).** Events stored as UTC and displayed in any IANA location, across daylight saving changes and midnight. Day and month names from intl in the calendar's locale, right-to-left layouts, and replacing any string.

---

## Contributing

Contributions are welcome. Please open an issue or pull request on [GitHub](https://github.com/werner-scholtz/kalender).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
