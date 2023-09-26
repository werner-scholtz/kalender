import 'package:kalender/src/models/calendar/calendar_event.dart';

class ScheduleGroup<T> {
  const ScheduleGroup({
    required this.isFirstOfMonth,
    required this.date,
    required this.events,
  });

  final DateTime date;
  final List<CalendarEvent<T>> events;

  final bool isFirstOfMonth;

  void addEvent(CalendarEvent<T> event) {
    if (!events.contains(event)) {
      events.add(event);
    }
  }
}
