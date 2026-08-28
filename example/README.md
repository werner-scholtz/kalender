# Example

A complete calendar, using only the base `CalendarEvent` class with no custom fields.
Tapping an empty slot creates an event, and events can be dragged and resized.

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

For a real app you almost always want custom fields on your events. The
[Events guide](https://github.com/werner-scholtz/kalender/blob/main/doc/events.md#custom-events)
covers subclassing `CalendarEvent`, and the
[documentation index](https://github.com/werner-scholtz/kalender/blob/main/doc/README.md)
lists the rest.

## Runnable examples

| Example | Shows |
| --- | --- |
| [Basic](https://github.com/werner-scholtz/kalender/tree/main/examples/example) | All view types with a toolbar, sample events, and custom tiles. Start here. |
| [Advanced](https://github.com/werner-scholtz/kalender/tree/main/examples/advanced_example) | A custom event layout with a lane per person, zoom, and tap-location-aware event creation. |
| [Recurrence](https://github.com/werner-scholtz/kalender/tree/main/examples/recurrence) | Recurring events built on top of the package, which has no recurrence of its own. |
| [ICS](https://github.com/werner-scholtz/kalender/tree/main/examples/ics) | Importing and exporting `.ics` files, expanding `RRULE` recurrence lazily over the visible range. |
| [Riverpod](https://github.com/werner-scholtz/kalender/tree/main/examples/riverpod) | Sharing the controllers and the selected view through providers. |
| [Web demo](https://github.com/werner-scholtz/kalender/tree/main/examples/web_demo) | The source behind the [live demo](https://werner-scholtz.github.io/kalender/): every option, theming, locales, and a split view. |
