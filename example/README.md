# Example

A complete calendar, using only the base `KalenderEvent` class with no custom fields.
Tapping an empty slot creates an event, which takes a long press on a phone or tablet. Events can be dragged and resized.

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
  final kalenderController = KalenderController();

  @override
  void dispose() {
    kalenderController.dispose();
    eventsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KalenderView(
      eventsController: eventsController,
      kalenderController: kalenderController,
      viewConfiguration: MultiDayViewConfiguration.week(
        // Without this the day opens at midnight.
        initialTimeOfDay: const KalenderTime(hour: 7, minute: 0),
      ),
      callbacks: KalenderCallbacks(
        onEventCreated: (event) => eventsController.addEvent(event),
      ),
      header: KalenderHeader(),
      body: KalenderBody(),
    );
  }
}
```

For a real app you almost always want custom fields on your events. The
[Events guide](https://github.com/werner-scholtz/kalender/blob/main/doc/events.md#custom-events)
covers subclassing `KalenderEvent`, and the
[documentation index](https://github.com/werner-scholtz/kalender/blob/main/doc/README.md)
lists the rest.

## Runnable examples

The [examples index](https://github.com/werner-scholtz/kalender/blob/main/examples/README.md)
lists all ten with what each one shows.
