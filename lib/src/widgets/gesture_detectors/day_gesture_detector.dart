import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/providers/multi_day_body_provider.dart';

class DayGestureDetector<T extends Object?> extends StatefulWidget {
  final DateTimeRange visibleDateTimeRange;

  const DayGestureDetector({
    super.key,
    required this.visibleDateTimeRange,
  });

  @override
  State<DayGestureDetector<T>> createState() => _DayGestureDetectorState<T>();
}

class _DayGestureDetectorState<T extends Object?>
    extends State<DayGestureDetector<T>> {
  MultiDayBodyDayProvider<T> get provider =>
      MultiDayBodyDayProvider.of<T>(context);
  EventsController<T> get eventsController => provider.eventsController;
  CalendarCallbacks<T>? get callbacks => provider.callbacks;
  Duration get newEventDuration => provider.bodyConfiguration.newEventDuration;
  double get heightPerMinute => provider.heightPerMinuteValue;
  TimeOfDayRange get timeOfDayRange => provider.timeOfDayRange;
  double get dayWidth => provider.dayWidth;

  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged =>
      provider.eventBeingDragged;

  DateTime? start;

  void onDown(Offset localPosition) {
    final dateTimeRange = _calculateDateTimeRange(localPosition);
    if (dateTimeRange == null) return;
    start = dateTimeRange.start;

    eventBeingDragged.value = CalendarEvent(dateTimeRange: dateTimeRange);
  }

  void onUpdate(Offset localPosition) {
    final start = this.start;
    if (start == null) return;

    final currentDateTime = _calculateTimeAndDate(localPosition);
    if (currentDateTime == null) return;

    // Create a dateTimeRange from the start and currentDateTime.
    var dateTimeRange = currentDateTime.isBefore(start)
        ? DateTimeRange(start: currentDateTime, end: start)
        : DateTimeRange(start: start, end: currentDateTime);

    if (!timeOfDayRange.isAllDay) {
      // Clamp the dateTimeRange to the timeOfDayRange.
      dateTimeRange = _clampDateTimeRange(dateTimeRange, start);
    }

    this.eventBeingDragged.value = CalendarEvent(dateTimeRange: dateTimeRange);
  }

  DateTimeRange _clampDateTimeRange(
    DateTimeRange dateTimeRange,
    DateTime start,
  ) {
    var clampedStart = dateTimeRange.start;
    var clampedEnd = dateTimeRange.end;

    if (clampedStart.isBefore(timeOfDayRange.start.toDateTime(start))) {
      clampedStart = timeOfDayRange.start.toDateTime(start);
    }

    if (clampedEnd.isAfter(timeOfDayRange.end.toDateTime(start))) {
      clampedEnd = timeOfDayRange.end.toDateTime(start);
    }

    return DateTimeRange(start: clampedStart, end: clampedEnd);
  }

  void onEnd() {
    start = null;
    final newEvent = eventBeingDragged.value;
    if (newEvent == null) return;

    eventsController.addEvent(newEvent);
    callbacks?.onEventCreated?.call(newEvent);
    eventBeingDragged.value = null;
  }

  DateTimeRange? _calculateDateTimeRange(Offset position) {
    final start = _calculateTimeAndDate(position);
    if (start == null) return null;
    return DateTimeRange(start: start, end: start.add(newEventDuration));
  }

  DateTime? _calculateTimeAndDate(Offset position) {
    /// Calculate the date of the position.
    final visibleDates = widget.visibleDateTimeRange.datesSpanned;
    final cursorDate = (position.dx / dayWidth);
    final cursorDateIndex = cursorDate.floor();
    if (cursorDateIndex < 0) return null;
    final date = visibleDates.elementAtOrNull(cursorDateIndex);
    if (date == null) return null;

    // Calculate the duration from the start of the day to the position.
    final durationFromStart = position.dy ~/ heightPerMinute;
    final snapIntervalMinutes = provider.bodyConfiguration.snapIntervalMinutes;
    final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();

    final start = timeOfDayRange.start.toDateTime(date);
    return start.add(
      Duration(minutes: snapIntervalMinutes * numberOfIntervals),
    );
  }

  @override
  Widget build(BuildContext context) {
    final createEventTrigger = provider.bodyConfiguration.createEventTrigger;

    final tap = createEventTrigger == CreateEventTrigger.tap;
    final long = createEventTrigger == CreateEventTrigger.longPress;

    return GestureDetector(
      onTapDown: tap ? (details) => onDown(details.localPosition) : null,
      onTapUp: tap ? (_) => onEnd() : null,
      onPanStart: tap ? (details) => onDown(details.localPosition) : null,
      onPanUpdate: tap ? (details) => onUpdate(details.localPosition) : null,
      onPanEnd: tap ? (_) => onEnd() : null,
      onLongPressDown: long ? (details) => onDown(details.localPosition) : null,
      onLongPressMoveUpdate:
          long ? (details) => onUpdate(details.localPosition) : null,
      onLongPressEnd: long ? (_) => onEnd() : null,
    );
  }
}
