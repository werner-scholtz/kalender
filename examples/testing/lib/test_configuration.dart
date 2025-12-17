import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class TestConfiguration {
  final ViewConfiguration viewConfiguration;

  TestConfiguration({required this.viewConfiguration});

  TestConfiguration.week()
    : viewConfiguration = MultiDayViewConfiguration.week(
        displayRange: testRange,
        initialDateTime: initialDateTime,
      );

  TestConfiguration.month()
    : viewConfiguration = MonthViewConfiguration.singleMonth(
        displayRange: testRange,
        initialDateTime: initialDateTime,
      );

  TestConfiguration.schedule()
    : viewConfiguration = ScheduleViewConfiguration.continuous(
        displayRange: testRange,
        initialDateTime: initialDateTime,
      );

  static final initialDateTime = DateTime(2024, 6, 1);
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

final timeOfDayRanges = [
  TimeOfDayRange(
    start: const TimeOfDay(hour: 5, minute: 0),
    end: const TimeOfDay(hour: 6, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 5, minute: 30),
    end: const TimeOfDay(hour: 6, minute: 15),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 6, minute: 0),
    end: const TimeOfDay(hour: 8, minute: 15),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 0),
    end: const TimeOfDay(hour: 9, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 30),
    end: const TimeOfDay(hour: 10, minute: 0),
  ),

  /// 5
  TimeOfDayRange(
    start: const TimeOfDay(hour: 9, minute: 0),
    end: const TimeOfDay(hour: 10, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 10, minute: 0),
    end: const TimeOfDay(hour: 11, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 12, minute: 0),
    end: const TimeOfDay(hour: 13, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 13, minute: 0),
    end: const TimeOfDay(hour: 14, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 0),
    end: const TimeOfDay(hour: 14, minute: 0),
  ),

  /// 5
  TimeOfDayRange(
    start: const TimeOfDay(hour: 14, minute: 0),
    end: const TimeOfDay(hour: 15, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 14, minute: 30),
    end: const TimeOfDay(hour: 15, minute: 30),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 15, minute: 0),
    end: const TimeOfDay(hour: 16, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 16, minute: 0),
    end: const TimeOfDay(hour: 17, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 0),
    end: const TimeOfDay(hour: 17, minute: 0),
  ),

  /// 5
  TimeOfDayRange(
    start: const TimeOfDay(hour: 17, minute: 0),
    end: const TimeOfDay(hour: 18, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 17, minute: 30),
    end: const TimeOfDay(hour: 18, minute: 30),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 18, minute: 0),
    end: const TimeOfDay(hour: 19, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 19, minute: 0),
    end: const TimeOfDay(hour: 20, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 20, minute: 0),
    end: const TimeOfDay(hour: 21, minute: 0),
  ),
];
