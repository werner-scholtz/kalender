import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/test_configuration.dart';
import 'package:testing/tiles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final TestConfiguration? config;
  const MyApp({super.key, this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Profiling',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: Home(config: config),
    );
  }
}

class Home extends StatefulWidget {
  final TestConfiguration? config;
  const Home({super.key, this.config});
  static getTileKey(int id) => Key('tile-$id');

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final TestConfiguration config = widget.config ?? TestConfiguration.week();
  EventsController<Event> get eventsController => config.eventsController;
  CalendarController<Event> get calendarController => config.calendarController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView<Event>(
        eventsController: config.eventsController,
        calendarController: config.calendarController,
        viewConfiguration: config.viewConfiguration,
        components: CalendarComponents(),
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) => calendarController.selectEvent(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) => eventsController.addEvent(event),
        ),
        header: CalendarHeader<Event>(multiDayTileComponents: _multiDayTileComponents),
        body: CalendarBody<Event>(
          multiDayTileComponents: _tileComponents,
          monthTileComponents: _multiDayTileComponents,
          scheduleTileComponents: _scheduleTileComponents,
        ),
      ),
    );
  }

  TileComponents<Event> get _tileComponents {
    return TileComponents<Event>(
      tileBuilder: EventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
    );
  }

  TileComponents<Event> get _multiDayTileComponents {
    return TileComponents<Event>(
      tileBuilder: MultiDayEventTile.builder,
      overlayTileBuilder: OverlayEventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
    );
  }

  ScheduleTileComponents<Event> get _scheduleTileComponents {
    return ScheduleTileComponents<Event>(
      tileBuilder: MultiDayEventTile.builder,
      overlayTileBuilder: OverlayEventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
    );
  }
}
