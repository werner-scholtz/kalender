import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class DayGestureDetector<T extends Object?> extends StatefulWidget {
  const DayGestureDetector({
    super.key,
    required this.height,
    required this.dayWidth,
    required this.heightPerMinute,
    required this.visibleDateRange,
    required this.minuteSlotSize,
  });

  /// The height of the day.
  final double height;

  /// The width of a day.
  final double dayWidth;

  /// The height per minute.
  final double heightPerMinute;

  /// The visible date range.
  final DateTimeRange visibleDateRange;

  /// The size of a slot.
  final SlotSize minuteSlotSize;

  @override
  State<DayGestureDetector<T>> createState() => _DayGestureDetectorState<T>();
}

class _DayGestureDetectorState<T extends Object?> extends State<DayGestureDetector<T>> {
  late double heightPerMinute;
  late double height;
  late double dayWidth;
  late List<DateTime> visibleDates;
  late SlotSize minuteSlotSize;

  /// The height of a slot.
  late double heightPerSlot = minuteSlotSize.minutes * heightPerMinute;

  /// The number of slots in a day.
  late int slots = (hoursADay * 60) ~/ minuteSlotSize.minutes;

  /// The offset of the cursor.
  double cursorOffset = 0;

  /// The number of slots selected.
  int numberOfSlotsSelected = 0;

  @override
  void initState() {
    super.initState();
    height = widget.height;
    dayWidth = widget.dayWidth;
    heightPerMinute = widget.heightPerMinute;
    visibleDates = widget.visibleDateRange.datesSpanned;
    minuteSlotSize = widget.minuteSlotSize;
  }

  @override
  void didUpdateWidget(covariant DayGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    height = widget.height;
    dayWidth = widget.dayWidth;
    heightPerMinute = widget.heightPerMinute;
    visibleDates = widget.visibleDateRange.datesSpanned;
    minuteSlotSize = widget.minuteSlotSize;
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: createNewEvents
                      ? () => onTap(calculateDateTimeRange(visibleDates[day], i))
                      : null,
                  onVerticalDragStart: gestureDisabled
                      ? null
                      : (DragStartDetails details) => _onVerticalDragStart(
                            details,
                            calculateDateTimeRange(visibleDates[day], i),
                          ),
                  onVerticalDragEnd: gestureDisabled ? null : _onVerticalDragEnd,
                  onVerticalDragUpdate: gestureDisabled
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

  /// Handles the onTap event.
  /// If the device is a mobile device then [createNewEventMobile] is called.
  /// If the device is not a mobile device then [createNewEventDesktop] is called.
  void onTap(DateTimeRange dateTimeRange) {
    if (isMobileDevice) {
      createNewEventMobile(dateTimeRange);
    } else {
      createNewEventDesktop(dateTimeRange);
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

    CalendarEvent<T>? newEvent = await functions.onCreateEvent?.call(controller.chaningEvent!);

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
  /// TODO: Add a way to change the [CalendarEvent] on mobile.
  ///
  void createNewEventMobile(DateTimeRange dateTimeRange) async {
    CalendarEvent<T> displayEvent = CalendarEvent<T>(
      dateTimeRange: dateTimeRange,
    );

    controller.isNewEvent = true;
    controller.chaningEvent = displayEvent;

    CalendarEvent<T>? newEvent = await functions.onCreateEvent?.call(displayEvent);

    if (newEvent == null) {
      controller.chaningEvent = null;
    } else {
      controller.addEvent(newEvent);
      controller.chaningEvent = null;
    }
    controller.isNewEvent = false;
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

    CalendarEvent<T>? newEvent = await functions.onCreateEvent?.call(controller.chaningEvent!);
    
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

  bool get gestureDisabled => isMobileDevice || !createNewEvents;
  bool get createNewEvents => true; //CalendarScope.of<T>(context).configuration.createNewEvents;
  bool get isMobileDevice => false; //CalendarScope.of<T>(context).configuration.isMobileDevice;
  CalendarEventController<T> get controller => CalendarScope.of<T>(context).eventController;
  CalendarFunctions<T> get functions => CalendarScope.of<T>(context).functions;
}
