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

A highly customizable Flutter calendar widget with Day, MultiDay, Month, and Schedule views. It supports drag-and-drop rescheduling, event resizing, timezones, and full control over appearance and behavior.

**[Live Demo](https://werner-scholtz.github.io/kalender/)** · **[Benchmarks](https://werner-scholtz.github.io/kalender/dev/bench/)** · **[Migration Guide](MIGRATION.md)**

> [!WARNING]
> This package is still in development. API changes may occur before version 1.0.0, so pin an exact version in your `pubspec.yaml` rather than a caret range like `^0.24.0`.
>
> 1.0.0 is close. If part of the API does not work for you, please [open an issue](https://github.com/werner-scholtz/kalender/issues).

## Features

| Feature | What you get | Guide |
| --- | --- | --- |
| **Views** | Day, Multi-day, Month and Schedule, switched by passing a different configuration. | [Views](doc/views.md) |
| **Extensible events** | Attach custom data (title, color, anything) by subclassing `CalendarEvent`. | [Events](doc/events.md#custom-events) |
| **Reschedule** | Drag and drop events between days and times. | [Interaction](doc/interaction.md) |
| **Resize** | Handles that adapt to mouse, stylus, trackpad or touch input. | [Interaction](doc/interaction.md) |
| **Snapping** | Snap to an interval, to the time indicator, to other events, or to your own strategy. | [Interaction](doc/interaction.md#interaction--snapping) |
| **Zoom** | Change the height per minute to zoom the day in and out. | [Interaction](doc/interaction.md#zoom) |
| **Controllers** | Drive the calendar from code and watch what is on screen. | [Controllers & Callbacks](doc/controllers-and-callbacks.md#controllers) |
| **Callbacks** | React to taps, long presses, event creation and changes. | [Controllers & Callbacks](doc/controllers-and-callbacks.md#callbacks) |
| **Tile components** | Customize the stationary, dragging, feedback and resize-handle tiles. | [Appearance](doc/appearance.md#tile-components) |
| **Theming** | Follows your Material 3 theme, or register a `KalenderThemeData`. | [Appearance](doc/appearance.md#theming) |
| **Custom components** | Replace any default widget, or restyle it without writing one. | [Appearance](doc/appearance.md#appearance--custom-components) |
| **Event layout** | Use a built-in layout strategy or supply your own. | [Layout](doc/layout.md) |
| **Locale** | Localize day and month names via [intl](https://pub.dev/packages/intl), and replace any string. | [Timezones & Locales](doc/timezones-and-locales.md#locale) |
| **Location** | Timezone-aware display via the [timezone](https://pub.dev/packages/timezone) package. | [Timezones & Locales](doc/timezones-and-locales.md#location) |
| **Now callback** | Override what "now" means for the time indicator and today highlighting, for when the calendar's `Location` differs from the user's wall-clock time. | [Timezones & Locales](doc/timezones-and-locales.md#now-callback) |

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
  Widget build(BuildContext context) {
    return CalendarView(
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

- [Views](doc/views.md): the four view families, what carries over when you switch, and each view's configuration class.
- [Events](doc/events.md): attach your own data by subclassing `CalendarEvent`, and what counts as multi-day.
- [Interaction](doc/interaction.md): creating, rescheduling, resizing, snapping and zooming.
- [Controllers & Callbacks](doc/controllers-and-callbacks.md): drive the calendar from code, react to the user, and build a toolbar around it.
- [Appearance](doc/appearance.md): tile builders, theming, and custom components.
- [Layout](doc/layout.md): where tiles are placed and sized. Advanced, only needed for a custom strategy.
- [Timezones & Locales](doc/timezones-and-locales.md): display timezones, localized names, and custom text.

---

## Contributing

Contributions are welcome! Please open an issue or pull request on [GitHub](https://github.com/werner-scholtz/kalender).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
