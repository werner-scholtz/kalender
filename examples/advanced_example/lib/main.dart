import 'package:advanced_example/tiles.dart';
import 'package:advanced_example/timeline.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const MyApp());
}

/// Represents an event with a title and color.
class Event {
  final String title;
  final Color color;

  Event({required this.title, required this.color});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  final eventsController = DefaultEventsController<Event>();
  final calendarController = CalendarController<Event>();
  final viewConfiguration = MultiDayViewConfiguration.singleDay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView<Event>(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: viewConfiguration,
        components: CalendarComponents(
          multiDayComponents: MultiDayComponents(
            bodyComponents: MultiDayBodyComponents(
              timeline: CustomTimeLine.builder,
              prototypeTimeLine: PrototypeTimeline.prototypeBuilder,
            ),
          ),
        ),
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) =>
              calendarController.selectEvent(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) => eventsController.addEvent(event),
        ),
        body: CalendarBody<Event>(
          // TODO: get this to work.
          heightPerMinute: ValueNotifier(2),
          multiDayTileComponents: tileComponents,
          monthTileComponents: multiDayTileComponents,
          scheduleTileComponents: scheduleTileComponents,
        ),
      ),
    );
  }
}
