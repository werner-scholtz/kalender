import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

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
