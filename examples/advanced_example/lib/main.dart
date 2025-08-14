import 'package:advanced_example/layout_strategy.dart';
import 'package:advanced_example/tiles.dart';
import 'package:advanced_example/zoom.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart' hide TimeLine, PrototypeTimeline;

void main() {
  runApp(const MyApp());
}

/// Represents an event with a title and color.
class Event {
  final String title;
  final Person person;
  final Color color;

  Event({required this.title, required this.color, required this.person});
}

class Person {
  final String name;
  const Person({required this.name});

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const people = [Person(name: "Person A"), Person(name: "Person B")];

class _MyHomePageState extends State<MyHomePage> {
  final eventsController = DefaultEventsController<Event>();
  final calendarController = CalendarController<Event>();
  final viewConfiguration = MultiDayViewConfiguration.singleDay(initialHeightPerMinute: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView<Event>(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: viewConfiguration,
        components: CalendarComponents(),
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) => calendarController.selectEvent(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) => eventsController.addEvent(event),
        ),
        header: Column(children: [CalendarHeader<Event>(), const Divider(), const PeopleWidget()]),
        body: ZoomDetector(
          controller: calendarController,
          child: CalendarBody<Event>(
            multiDayTileComponents: tileComponents,
            monthTileComponents: multiDayTileComponents,
            scheduleTileComponents: scheduleTileComponents,
            multiDayBodyConfiguration: MultiDayBodyConfiguration(
              eventLayoutStrategy:
                  (events, date, timeOfDayRange, heightPerMinute, minimumTileHeight, cache) {
                    return CustomSideBySideLayoutDelegate(
                      events: events,
                      heightPerMinute: heightPerMinute,
                      date: date,
                      timeOfDayRange: timeOfDayRange,
                      minimumTileHeight: minimumTileHeight,
                      layoutCache: cache ?? EventLayoutDelegateCache(),
                    );
                  },
            ),
          ),
        ),
      ),
    );
  }
}

class PeopleWidget extends StatelessWidget {
  const PeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: people.map((person) => PersonWidget(person: person)).toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class PersonWidget extends StatelessWidget {
  final Person person;
  const PersonWidget({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(person.name, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
