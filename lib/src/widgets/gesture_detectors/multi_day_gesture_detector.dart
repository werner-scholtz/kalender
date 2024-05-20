import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/providers/multi_day_provider.dart';

class MultiDayGestureDetector<T extends Object?> extends StatefulWidget {
  final DateTimeRange visibleDateTimeRange;

  const MultiDayGestureDetector({
    super.key,
    required this.visibleDateTimeRange,
  });

  @override
  State<MultiDayGestureDetector<T>> createState() =>
      _MultiDayGestureDetectorState<T>();
}

class _MultiDayGestureDetectorState<T extends Object?>
    extends State<MultiDayGestureDetector<T>> {
  MultiDayProvider<T> get provider => MultiDayProvider.of<T>(context);
  EventsController<T> get eventsController => provider.eventsController;
  CalendarCallbacks<T>? get callbacks => provider.callbacks;
  double get dayWidth => provider.dayWidth;
  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged =>
      provider.eventBeingDragged;

  DateTime? start;

  @override
  Widget build(BuildContext context) {
    final createEventTrigger = provider.headerConfiguration.createEventTrigger;

    final tap = createEventTrigger == CreateEventTrigger.tap;
    final long = createEventTrigger == CreateEventTrigger.longPress;

    return MouseRegion(
      child: GestureDetector(
        onTapDown: tap ? (details) => onDown(details.localPosition) : null,
        onTapUp: tap ? (_) => onEnd() : null,
        onPanStart: tap ? (details) => onDown(details.localPosition) : null,
        onPanUpdate: tap ? (details) => onUpdate(details.localPosition) : null,
        onPanEnd: tap ? (_) => onEnd() : null,
        onLongPressDown:
            long ? (details) => onDown(details.localPosition) : null,
        onLongPressMoveUpdate:
            long ? (details) => onUpdate(details.localPosition) : null,
        onLongPressEnd: long ? (_) => onEnd() : null,
      ),
    );
  }

  void onDown(Offset localPosition) {
    final dateTimeRange = _calculateDateTimeRange(localPosition);

    if (dateTimeRange == null) return;
    start = dateTimeRange.start;

    eventBeingDragged.value = CalendarEvent(dateTimeRange: dateTimeRange);
  }

  void onUpdate(Offset localPosition) {
    if (start == null) return;

    var currentDate = _calculateTimeAndDate(localPosition);
    if (currentDate == null) return;

    if (currentDate == start) {
      currentDate = currentDate.endOfDay;
    }

    // Create a dateTimeRange from the start and currentDateTime.
    final dateTimeRange = currentDate.isBefore(start!)
        ? DateTimeRange(start: currentDate, end: start!)
        : DateTimeRange(start: start!, end: currentDate);

    eventBeingDragged.value = CalendarEvent(dateTimeRange: dateTimeRange);
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
    return DateTimeRange(start: start, end: start.endOfDay);
  }

  DateTime? _calculateTimeAndDate(Offset position) {
    // Calculate the date of the position.
    final visibleDates = widget.visibleDateTimeRange.datesSpanned;
    final cursorDate = (position.dx / dayWidth);
    final cursorDateIndex = cursorDate.floor();
    if (cursorDateIndex < 0) return null;
    final date = visibleDates.elementAtOrNull(cursorDateIndex);
    if (date == null) return null;

    return date;
  }
}
