import 'package:advanced_example/layout_strategy.dart';
import 'package:advanced_example/tiles.dart';
import 'package:advanced_example/zoom.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const MyApp());
}

/// Represents an event with a title and color.
class Event extends CalendarEvent {
  final String title;
  final Person person;

  Event({
    required super.dateTimeRange,
    required this.title,
    required this.person,
    super.interaction,
  });

  @override
  Event copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    Person? person,
    String? title,
  }) {
    final newEvent = Event(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      title: title ?? this.title,
      person: person ?? this.person,
    );
    newEvent.id = id;

    return newEvent;
  }
}

class Person {
  final String name;
  final Color color;
  const Person({required this.name, required this.color});

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

const people = [
  Person(name: "Person A", color: Colors.blue),
  Person(name: "Person B", color: Colors.amber),
];

class _MyHomePageState extends State<MyHomePage> {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();
  late MultiDayViewConfiguration _viewConfiguration = _viewConfigurations.first;
  final _viewConfigurations = [
    MultiDayViewConfiguration.singleDay(initialHeightPerMinute: 2),
    MultiDayViewConfiguration.week(initialHeightPerMinute: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: _viewConfiguration,
        components: CalendarComponents(),
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) =>
              calendarController.selectEvent(event),
          onEventCreateWithDetail: (calendarEvent, detail) {
            if (detail is MultiDayDetail) {
              throw Exception(
                'MultiDayDetail is not supported in this example.',
              );
            }

            final event = calendarEvent as Event;

            final dayWidth = detail.renderBox.size.width;
            final tapLocation = detail.localOffset;
            final person = people[tapLocation.dx ~/ (dayWidth / people.length)];
            return event.copyWith(title: 'title', person: person);
          },
          onEventCreated: (event) => eventsController.addEvent(event),
        ),
        header: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 8),
                DropdownMenu(
                  dropdownMenuEntries: _viewConfigurations.map((e) {
                    return DropdownMenuEntry(value: e, label: e.name);
                  }).toList(),
                  initialSelection: _viewConfiguration,
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        _viewConfiguration = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            CalendarHeader(
              multiDayHeaderConfiguration: MultiDayHeaderConfiguration(
                showTiles: false,
              ),
            ),
            const Divider(),
            PeopleWidget(viewConfiguration: _viewConfiguration),
            const Divider(),
          ],
        ),
        body: ZoomDetector(
          controller: calendarController,
          child: CalendarBody(
            multiDayTileComponents: tileComponents,
            monthTileComponents: multiDayTileComponents,
            scheduleTileComponents: scheduleTileComponents,
            multiDayBodyConfiguration: MultiDayBodyConfiguration(
              eventLayoutStrategy:
                  (
                    events,
                    date,
                    timeOfDayRange,
                    heightPerMinute,
                    minimumTileHeight,
                    cache,
                    location,
                  ) {
                    return CustomSideBySideLayoutDelegate(
                      events: events,
                      heightPerMinute: heightPerMinute,
                      date: date,
                      timeOfDayRange: timeOfDayRange,
                      minimumTileHeight: minimumTileHeight,
                      layoutCache: cache ?? EventLayoutDelegateCache(),
                      people: people,
                      location: location,
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
  final MultiDayViewConfiguration viewConfiguration;
  const PeopleWidget({super.key, required this.viewConfiguration});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Needed for proper spacing.
        PrototypeTimeline.prototypeBuilder(
          0.7,
          TimeOfDayRange.allDay(),
          TimelineStyle(),
        ),
        ...List.generate(
          viewConfiguration.numberOfDays,
          (index) => Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: people
                  .map(
                    (person) => Expanded(child: PersonWidget(person: person)),
                  )
                  .toList(growable: false),
            ),
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
