import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const MyApp());
}

class TestConfiguration {
  final ViewConfiguration viewConfiguration;

  TestConfiguration({required this.viewConfiguration});

  TestConfiguration.week()
    : viewConfiguration = MultiDayViewConfiguration.week(
        displayRange: testRange,
        selectedDate: selectedDate,
      );

  TestConfiguration.month()
    : viewConfiguration = MonthViewConfiguration.singleMonth(
        displayRange: testRange,
        selectedDate: selectedDate,
      );

  TestConfiguration.schedule()
    : viewConfiguration = ScheduleViewConfiguration.continuous(
        displayRange: testRange,
        selectedDate: selectedDate,
      );

  static final selectedDate = DateTime(2024, 6, 1);
  static final start = DateTime(2024, 1, 1);
  static final end = DateTime(2024, 12, 31);
  static DateTimeRange get testRange => DateTimeRange(start: start, end: end);

  /// The events controller for the test.
  final eventsController = DefaultEventsController<Event>();

  /// The calendar controller for the test.
  final calendarController = CalendarController<Event>();

  static List<CalendarEvent<Event>> generate(List<TimeOfDayRange> timeOfDayRanges) {
    assert(timeOfDayRanges.isNotEmpty, 'Time of day ranges must not be empty');

    // Loop through the test range and create events.
    final events = <CalendarEvent<Event>>[
      for (var date in testRange.dates()) ...[
        for (var timeOfDayRange in timeOfDayRanges)
          CalendarEvent<Event>(
            dateTimeRange: DateTimeRange(
              start: timeOfDayRange.start.toDateTime(date),
              end: timeOfDayRange.end.toDateTime(date),
            ),
            data: Event(
              title: 'Event',
              description: '${date.year}-${date.month}-${date.day} ${timeOfDayRange.start.hour}',
              color: Colors.primaries[date.day % Colors.primaries.length],
            ),
          ),
      ],
    ];

    return events;
  }
}

/// Represents an event with a title and color.
class Event {
  final String title;
  final Color color;
  final String description;

  Event({required this.title, required this.color, required this.description});
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
        header: CalendarHeader<Event>(),
        body: CalendarBody<Event>(
          multiDayTileComponents: TileComponents(
            tileBuilder: (event, tileRange) {
              return Container(key: Home.getTileKey(event.id), color: event.data?.color);
            },
          ),
        ),
      ),
    );
  }
}
