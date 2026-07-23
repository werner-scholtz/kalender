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
> This package is still in development. API changes may occur before version 1.0.0, so pin an exact version in your `pubspec.yaml` rather than a caret range.
>
> 1.0.0 is getting close. If part of the API does not work for you, please [open an issue](https://github.com/werner-scholtz/kalender/issues).

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Features

* **Views:** Day, Multi-day, Month and Schedule. [find out more](doc/views.md#views)
* **Extensible events:** Attach custom data (title, color, etc.) by subclassing `CalendarEvent`. [find out more](doc/events.md#custom-events)
* **Tile components:** Fully customize event tiles: stationary, dragging, feedback, and resize handles. [find out more](doc/appearance.md#tile-components)
* **Reschedule:** Drag and drop events between days and times.
* **Resize:** Resize events with input-precision-aware handles (mouse/stylus/trackpad vs touch).
* **Controllers:** Manage your calendar with dedicated controllers. [find out more](doc/views.md#controllers)
* **Callbacks:** React to taps, long presses, event creation and changes. [find out more](doc/views.md#callbacks)
* **Configuration:** Fine-grained control over interaction, snapping, scroll physics, and layout. [find out more](doc/views.md#configuration--interaction)
* **Appearance:** Style default components or supply custom builders. [find out more](doc/appearance.md#appearance--custom-components)
* **Event layout:** Built-in strategies or bring your own. [find out more](doc/events.md#event-layout)
* **Locale:** Localize day/month names via the [intl](https://pub.dev/packages/intl) package. [find out more](doc/timezones-and-locales.md#locale)
* **Location:** Timezone-aware display via the [timezone](https://pub.dev/packages/timezone) package. [find out more](doc/timezones-and-locales.md#location)
* **Now callback:** Override what "now" means for the time indicator and today highlighting. Useful when the calendar's `Location` differs from the user's wall-clock time. [find out more](doc/timezones-and-locales.md#now-callback)

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
      viewConfiguration: MultiDayViewConfiguration.singleDay(),
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

## Documentation

The detailed guides live in `doc/`:

- [Events](doc/events.md): attach your own data by subclassing `CalendarEvent`, and control how event tiles are laid out.
- [Views & Interaction](doc/views.md): view configurations, controllers, callbacks, and interaction settings like snapping and zoom.
- [Appearance](doc/appearance.md): tile builders, theming, and custom components.
- [Timezones & Locales](doc/timezones-and-locales.md): display timezones, localized names, and custom text.

---

## Contributing

Contributions are welcome! Please open an issue or pull request on [GitHub](https://github.com/werner-scholtz/kalender).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
