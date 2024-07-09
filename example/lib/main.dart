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
      title: 'Kalender Example',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class Event {
  final String title;
  final Color? color;

  Event(this.title, this.color);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Create [EventsController]
  final eventsController = EventsController<Event>();

  /// Create [CalendarController]
  final calendarController = CalendarController<Event>();

  /// Create a [ViewConfiguration]
  ///
  /// Options:
  /// - [MultiDayViewConfiguration.singleDay]
  /// - [MultiDayViewConfiguration.week]
  /// - [MultiDayViewConfiguration.workWeek]
  /// - [MultiDayViewConfiguration.custom]
  final viewConfiguration = MultiDayViewConfiguration.singleDay();

  @override
  void initState() {
    super.initState();

    /// Add events to the [EventsController]
    final now = DateTime.now();
    eventsController.addEvents(
      [
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: now,
            end: now.add(const Duration(hours: 1)),
          ),
          data: Event('My Event', Colors.red),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: now,
            end: now.add(const Duration(hours: 1)),
          ),
          data: Event('My Event', Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create your tile components.
    final tileComponents = TileComponents<Event>(
      tileBuilder: (event) => Container(color: Colors.green),
    );

    final calendar = CalendarView<Event>(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: viewConfiguration,
      header: CalendarHeader<Event>(
        multiDayTileComponents: tileComponents,
      ),
      body: CalendarBody<Event>(
        multiDayTileComponents: tileComponents,
        monthTileComponents: tileComponents,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Kalender'),
      ),
      body: calendar,
    );
  }
}
