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
  static KalenderDateTimeRange get testRange => KalenderDateTimeRange(start: start, end: end);

  /// The events controller for the test.
  final eventsController = DefaultEventsController();

  /// The calendar controller for the test.
  final calendarController = CalendarController();

  static List<CalendarEvent> generate(List<KalenderTimeRange> timeOfDayRanges) {
    assert(timeOfDayRanges.isNotEmpty, 'Time of day ranges must not be empty');

    // Loop through the test range and create events.
    final events = <CalendarEvent>[
      for (var date in InternalDateTimeRange.fromDateTimeRange(testRange).dates()) ...[
        for (var timeOfDayRange in timeOfDayRanges)
          Event(
            dateTimeRange: KalenderDateTimeRange(
              start: timeOfDayRange.start.toInternalDateTime(date),
              end: timeOfDayRange.end.toInternalDateTime(date),
            ),
            title: 'Event',
            description: '${date.year}-${date.month}-${date.day} ${timeOfDayRange.start.hour}',
            color: Colors.primaries[date.day % Colors.primaries.length],
          ),
      ],
    ];

    return events;
  }
}

/// Represents an event with a title and color.
class Event extends CalendarEvent {
  Event({
    super.id,
    required super.dateTimeRange,
    required this.title,
    this.description,
    this.color,
    super.interaction,
    super.multiDayRule,
  });

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event].
  final Color? color;

  @override
  Event copyWithData({required KalenderDateTimeRange dateTimeRange}) {
    return Event(dateTimeRange: dateTimeRange, title: title, description: description, color: color);
  }
}

final timeOfDayRanges = [
  KalenderTimeRange(
    start: const KalenderTime(hour: 5, minute: 0),
    end: const KalenderTime(hour: 6, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 5, minute: 30),
    end: const KalenderTime(hour: 6, minute: 15),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 6, minute: 0),
    end: const KalenderTime(hour: 8, minute: 15),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 8, minute: 0),
    end: const KalenderTime(hour: 9, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 8, minute: 30),
    end: const KalenderTime(hour: 10, minute: 0),
  ),

  /// 5
  KalenderTimeRange(
    start: const KalenderTime(hour: 9, minute: 0),
    end: const KalenderTime(hour: 10, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 10, minute: 0),
    end: const KalenderTime(hour: 11, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 12, minute: 0),
    end: const KalenderTime(hour: 13, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 13, minute: 0),
    end: const KalenderTime(hour: 14, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 8, minute: 0),
    end: const KalenderTime(hour: 14, minute: 0),
  ),

  /// 5
  KalenderTimeRange(
    start: const KalenderTime(hour: 14, minute: 0),
    end: const KalenderTime(hour: 15, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 14, minute: 30),
    end: const KalenderTime(hour: 15, minute: 30),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 15, minute: 0),
    end: const KalenderTime(hour: 16, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 16, minute: 0),
    end: const KalenderTime(hour: 17, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 8, minute: 0),
    end: const KalenderTime(hour: 17, minute: 0),
  ),

  /// 5
  KalenderTimeRange(
    start: const KalenderTime(hour: 17, minute: 0),
    end: const KalenderTime(hour: 18, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 17, minute: 30),
    end: const KalenderTime(hour: 18, minute: 30),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 18, minute: 0),
    end: const KalenderTime(hour: 19, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 19, minute: 0),
    end: const KalenderTime(hour: 20, minute: 0),
  ),
  KalenderTimeRange(
    start: const KalenderTime(hour: 20, minute: 0),
    end: const KalenderTime(hour: 21, minute: 0),
  ),

  /// Additional generated ranges (indices 20–49) so the heavy
  /// 50-events-per-day scenario has enough distinct slots. Spread across the
  /// day with overlapping durations to stress the layout/overlap code.
  ...List.generate(30, (i) {
    final startMinutes = 5 * 60 + (i * 31) % (15 * 60); // 05:00–20:00, prime step for variety
    final durationMinutes = 30 + (i % 4) * 30; // 30/60/90/120
    final endMinutes = startMinutes + durationMinutes;
    return KalenderTimeRange(
      start: KalenderTime(hour: startMinutes ~/ 60, minute: startMinutes % 60),
      end: KalenderTime(hour: endMinutes ~/ 60, minute: endMinutes % 60),
    );
  }),
];
