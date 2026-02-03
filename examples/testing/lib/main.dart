import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/test_configuration.dart';
import 'package:testing/tiles.dart';

void main() {
  final config = TestConfiguration.week();
  config.eventsController.addEvents(
    TestConfiguration.generate(timeOfDayRanges.take(10).toList()),
  );
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final TestConfiguration config;
  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Profiling',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Home(config: config),
    );
  }
}

class Home extends StatefulWidget {
  final TestConfiguration? config;
  const Home({super.key, this.config});
  static Key getTileKey(int id) => Key('tile-$id');

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final TestConfiguration config =
      widget.config ?? TestConfiguration.week();
  EventsController get eventsController => config.eventsController;
  CalendarController get calendarController => config.calendarController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView(
        eventsController: config.eventsController,
        calendarController: config.calendarController,
        viewConfiguration: config.viewConfiguration,
        components: CalendarComponents(),
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) =>
              calendarController.selectEvent(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) => eventsController.addEvent(event),
          onEventChanged: (event, updatedEvent) => eventsController.updateEvent(
            event: event,
            updatedEvent: updatedEvent,
          ),
        ),
        header: CalendarHeader(multiDayTileComponents: _multiDayTileComponents),
        body: CalendarBody(
          multiDayTileComponents: _tileComponents,
          monthTileComponents: _multiDayTileComponents,
          scheduleTileComponents: _scheduleTileComponents,
        ),
      ),
    );
  }

  TileComponents get _tileComponents {
    return TileComponents(
      tileBuilder: (event, range) => EventTile.builder(event as Event, range),
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) =>
          FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) =>
          TileWhenDragging.builder(event as Event),
    );
  }

  TileComponents get _multiDayTileComponents {
    return TileComponents(
      tileBuilder: (event, range) =>
          MultiDayEventTile.builder(event as Event, range),
      overlayTileBuilder: (event, range) =>
          OverlayEventTile.builder(event as Event, range),
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) =>
          FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) =>
          TileWhenDragging.builder(event as Event),
    );
  }

  ScheduleTileComponents get _scheduleTileComponents {
    return ScheduleTileComponents(
      tileBuilder: (event, range) =>
          MultiDayEventTile.builder(event as Event, range),
      overlayTileBuilder: (event, range) =>
          OverlayEventTile.builder(event as Event, range),
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) =>
          FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) =>
          TileWhenDragging.builder(event as Event),
    );
  }
}
