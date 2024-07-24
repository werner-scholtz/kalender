import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/platform.dart';

class DayGestureDetector<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final CalendarCallbacks<T>? callbacks;
  final MultiDayBodyConfiguration bodyConfiguration;
  final DateTimeRange visibleDateTimeRange;
  final TimeOfDayRange timeOfDayRange;
  final double dayWidth;
  final double heightPerMinute;

  const DayGestureDetector({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.bodyConfiguration,
    required this.visibleDateTimeRange,
    required this.timeOfDayRange,
    required this.dayWidth,
    required this.heightPerMinute,
  });

  @override
  State<DayGestureDetector<T>> createState() => _DayGestureDetectorState<T>();
}

class _DayGestureDetectorState<T extends Object?> extends State<DayGestureDetector<T>> {
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get controller => widget.calendarController;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  MultiDayBodyConfiguration get bodyConfiguration => widget.bodyConfiguration;
  Duration get newEventDuration => bodyConfiguration.newEventDuration;
  double get heightPerMinute => widget.heightPerMinute;
  TimeOfDayRange get timeOfDayRange => widget.timeOfDayRange;
  double get dayWidth => widget.dayWidth;


  ValueNotifier<CalendarEvent<T>?> get selectedEvent => controller.selectedEvent;

  DateTime? start;

  void onDown(Offset localPosition) {
    final dateTimeRange = _calculateDateTimeRange(localPosition);
    if (dateTimeRange == null) return;
    start = dateTimeRange.start;

    if (isMobileDevice && selectedEvent.value != null) {
      selectedEvent.value = null;
    } else {
      var newEvent = CalendarEvent<T>(dateTimeRange: dateTimeRange);
      newEvent = callbacks?.onEventCreate?.call(newEvent) ?? newEvent;
      controller.selectEvent(newEvent, internal: true);
    }
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

    controller.selectEvent(CalendarEvent(dateTimeRange: dateTimeRange), internal: true);
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
    final newEvent = selectedEvent.value;
    if (newEvent == null) return;
    eventsController.addEvent(newEvent);
    controller.deselectEvent();
    callbacks?.onEventCreated?.call(newEvent);
  }

  void onCanceled() {
    start = null;
    controller.deselectEvent();
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
    final snapIntervalMinutes = bodyConfiguration.snapIntervalMinutes;
    final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();

    final start = timeOfDayRange.start.toDateTime(date);
    return start.add(
      Duration(minutes: snapIntervalMinutes * numberOfIntervals),
    );
  }

  @override
  Widget build(BuildContext context) {
    final createEventTrigger = bodyConfiguration.createEventTrigger;

    final tap = createEventTrigger == CreateEventTrigger.tap;
    final long = createEventTrigger == CreateEventTrigger.longPress;

    return GestureDetector(
      // Tap
      onTapDown: tap ? (details) => onDown(details.localPosition) : null,
      onTapUp: tap ? (_) => onEnd() : null,
      onTapCancel: tap ? onCanceled : null,

      // Long Press
      onLongPressDown: long ? (details) => onDown(details.localPosition) : null,
      onLongPressMoveUpdate: long ? (details) => onUpdate(details.localPosition) : null,
      onLongPressEnd: long ? (_) => onEnd() : null,
      onLongPressCancel: long ? onCanceled : null,

      // Pan
      onPanStart: isMobileDevice
          ? null
          : tap
              ? (details) => onDown(details.localPosition)
              : null,
      onPanUpdate: isMobileDevice
          ? null
          : tap
              ? (details) => onUpdate(details.localPosition)
              : null,
      onPanEnd: isMobileDevice
          ? null
          : tap
              ? (_) => onEnd()
              : null,
    );
  }
}
