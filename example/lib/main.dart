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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CalendarController<Event> controller = CalendarController();
  final CalendarEventsController<Event> eventController =
      CalendarEventsController<Event>();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    eventController.addEvents([
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now,
          end: now.add(const Duration(hours: 1)),
        ),
      ),
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now.add(const Duration(hours: 2)),
          end: now.add(const Duration(hours: 5)),
        ),
      ),
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now,
          end: now.add(const Duration(days: 1)),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView<Event>(
        controller: controller,
        eventsController: eventController,
        viewConfiguration: const WeekConfiguration(),
        tileBuilder: _tileBuilder,
        multiDayTileBuilder: _multiDayTileBuilder,
        scheduleTileBuilder: _scheduleTileBuilder,
      ),
    );
  }

  Widget _tileBuilder(
    CalendarEvent<Event> event,
    TileConfiguration configuration,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _getTileColor(
          event.eventData?.color ?? Colors.blue,
          configuration.tileType,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.title ?? 'New Event')
            : null,
      ),
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<Event> event,
    MultiDayTileConfiguration configuration,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _getTileColor(
          event.eventData?.color ?? Colors.blue,
          configuration.tileType,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.title ?? 'New Event')
            : null,
      ),
    );
  }

  Widget _scheduleTileBuilder(CalendarEvent<Event> event, DateTime date) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: event.eventData?.color ?? Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(event.eventData?.title ?? 'New Event'),
    );
  }

  Color _getTileColor(Color color, TileType tileType) {
    switch (tileType) {
      case TileType.normal:
        return color.withAlpha(200);
      case TileType.selected:
        return color;
      case TileType.ghost:
        return color.withAlpha(100);
      default:
        return color;
    }
  }
}

class Event {
  Event({
    required this.title,
    this.description,
    this.color,
  });

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event] tile.
  final Color? color;
}
