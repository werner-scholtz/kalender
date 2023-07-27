import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_controller.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/providers/calendar_internals.dart';
import 'package:kalender/src/extentions.dart';

class DayGestureDetector<T extends Object?> extends StatefulWidget {
  const DayGestureDetector({
    super.key,
    required this.controller,
    required this.height,
    required this.dayWidth,
    required this.heightPerMinute,
    required this.visibleDateRange,
    required this.minuteSlotSize,
  });

  final CalendarController<T> controller;
  final double height;
  final double dayWidth;
  final double heightPerMinute;
  final DateTimeRange visibleDateRange;
  final MinuteSlotSize minuteSlotSize;

  @override
  State<DayGestureDetector<T>> createState() => _DayGestureDetectorState<T>();
}

class _DayGestureDetectorState<T extends Object?> extends State<DayGestureDetector<T>> {
  late CalendarController<T> controller;
  late double heightPerMinute;
  late double height;
  late double dayWidth;
  late List<DateTime> visibleDates;
  late MinuteSlotSize minuteSlotSize;
  late double heightPerSlot = minuteSlotSize.minutes * heightPerMinute;
  late int slots = (hoursADay * 60) ~/ minuteSlotSize.minutes;

  double cursorOffset = 0;
  int numberOfSlotsSelected = 0;

  @override
  void initState() {
    super.initState();
    height = widget.height;
    dayWidth = widget.dayWidth;
    heightPerMinute = widget.heightPerMinute;
    visibleDates = widget.visibleDateRange.datesSpanned;
    minuteSlotSize = widget.minuteSlotSize;
    controller = widget.controller;
  }

  @override
  void didUpdateWidget(covariant DayGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    height = widget.height;
    dayWidth = widget.dayWidth;
    heightPerMinute = widget.heightPerMinute;
    visibleDates = widget.visibleDateRange.datesSpanned;
    minuteSlotSize = widget.minuteSlotSize;
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    bool isMobileDevice = CalendarInternals.of<T>(context).configuration.isMobileDevice;
    bool createNewEvents = CalendarInternals.of<T>(context).configuration.createNewEvents;

    return SizedBox(
      width: dayWidth,
      height: height,
      child: Stack(
        children: <Widget>[
          for (int day = 0; day < visibleDates.length; day++)
            for (int i = 0; i < slots; i++)
              Positioned(
                left: (dayWidth * day),
                top: heightPerSlot * i,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => onTap(calculateDateTimeRange(visibleDates[day], i)),
                  onVerticalDragStart: isMobileDevice || !createNewEvents
                      ? null
                      : (DragStartDetails details) => _onVerticalDragStart(
                            details,
                            calculateDateTimeRange(visibleDates[day], i),
                          ),
                  onVerticalDragEnd: isMobileDevice || !createNewEvents ? null : _onVerticalDragEnd,
                  onVerticalDragUpdate: isMobileDevice || !createNewEvents
                      ? null
                      : (DragUpdateDetails details) => _onVerticalDragUpdate(
                            details,
                            calculateDateTimeRange(visibleDates[day], i),
                          ),
                  child: SizedBox(
                    width: dayWidth,
                    height: heightPerSlot,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  void onTap(DateTimeRange dateTimeRange) {
    if (!CalendarInternals.of<T>(context).configuration.createNewEvents) return;
    if (CalendarInternals.of<T>(context).configuration.isMobileDevice) {
      createNewEventMobile(dateTimeRange);
    } else {
      createNewEventDesktop(dateTimeRange);
    }
  }

  void _onVerticalDragStart(DragStartDetails details, DateTimeRange initialDateTimeRange) {
    cursorOffset = 0;
    controller.isNewEvent = true;
    CalendarEvent<T> displayEvent = CalendarEvent<T>(
      dateTimeRange: initialDateTimeRange,
    );
    controller.chaningEvent = displayEvent;
  }

  void _onVerticalDragEnd(DragEndDetails details) async {
    cursorOffset = 0;

    CalendarEvent<T>? newEvent = await CalendarInternals.of<T>(context)
        .functions
        .onCreateEvent
        ?.call(controller.chaningEvent!);
    if (newEvent == null) {
      controller.chaningEvent = null;
    } else {
      controller.addEvent(newEvent);
      controller.chaningEvent = null;
    }
    controller.isNewEvent = false;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, DateTimeRange initialDateTimeRange) {
    cursorOffset += details.delta.dy;

    int newNumberOfSlotsSelected = cursorOffset ~/ heightPerSlot;
    if (newNumberOfSlotsSelected != numberOfSlotsSelected) {
      numberOfSlotsSelected = newNumberOfSlotsSelected;

      DateTimeRange dateTimeRange;
      if (numberOfSlotsSelected.isNegative) {
        dateTimeRange = DateTimeRange(
          start: initialDateTimeRange.start.add(
            Duration(minutes: minuteSlotSize.minutes * numberOfSlotsSelected),
          ),
          end: initialDateTimeRange.end,
        );
      } else {
        dateTimeRange = DateTimeRange(
          start: initialDateTimeRange.start,
          end: initialDateTimeRange.end.add(
            Duration(minutes: minuteSlotSize.minutes * numberOfSlotsSelected),
          ),
        );
      }

      controller.chaningEvent?.dateTimeRange = dateTimeRange;
    }
  }

  /// Creates a new event on desktop.
  void createNewEventDesktop(DateTimeRange dateTimeRange) async {
    // Create a new [CalendarEvent] with the [dateTimeRange].
    CalendarEvent<T> newCalendarEvent = CalendarEvent<T>(
      dateTimeRange: dateTimeRange,
    );

    // Set the chaning event to the new event.
    controller.chaningEvent = newCalendarEvent;

    // Set the [isNewEvent] to true.
    controller.isNewEvent = true;

    CalendarEvent<T>? newEvent = await CalendarInternals.of<T>(context)
        .functions
        .onCreateEvent
        ?.call(controller.chaningEvent!);

    // If the [newEvent] is null then set the [chaningEvent] to null.
    if (newEvent == null) {
      controller.chaningEvent = null;
    } else {
      // Add the [newEvent] to the [CalendarController].
      controller.addEvent(newEvent);
      controller.chaningEvent = null;
    }

    // Set the [isNewEvent] to false.
    controller.isNewEvent = false;
  }

  /// Creates a new event on mobile.
  void createNewEventMobile(DateTimeRange dateTimeRange) async {
    CalendarEvent<T> displayEvent = CalendarEvent<T>(
      dateTimeRange: dateTimeRange,
    );

    controller.isNewEvent = true;
    controller.chaningEvent = displayEvent;

    CalendarEvent<T>? newEvent =
        await CalendarInternals.of<T>(context).functions.onCreateEvent?.call(displayEvent);

    if (newEvent == null) {
      controller.chaningEvent = null;
    } else {
      controller.addEvent(newEvent);
      controller.chaningEvent = null;
    }
    controller.isNewEvent = false;
  }

  /// Calculate the [DateTimeRange] of a slot.
  DateTimeRange calculateDateTimeRange(DateTime date, int i) => DateTimeRange(
        start: DateTime(
          date.year,
          date.month,
          date.day,
          0,
          minuteSlotSize.minutes * i,
        ),
        end: DateTime(
          date.year,
          date.month,
          date.day,
          0,
          minuteSlotSize.minutes * (i + 1),
        ),
      );
}
