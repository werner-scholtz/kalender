import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class MultiDayGestureDetector<T extends Object?> extends StatefulWidget {
  const MultiDayGestureDetector({
    super.key,
    required this.pageWidth,
    required this.dayWidth,
    required this.height,
    required this.multidayEventHeight,
    required this.numberOfRows,
    required this.visibleDates,
    required this.controller,
  });

  final CalendarController<T> controller;
  final double pageWidth;
  final double dayWidth;
  final double height;
  final double multidayEventHeight;
  final int numberOfRows;
  final List<DateTime> visibleDates;

  @override
  State<MultiDayGestureDetector<T>> createState() => _MultiDayGestureDetectorState<T>();
}

class _MultiDayGestureDetectorState<T extends Object?> extends State<MultiDayGestureDetector<T>> {
  late CalendarController<T> controller;
  late double pageWidth;
  late double dayWidth;
  late double height;
  late double multidayEventHeight;
  late int numberOfRows;
  late int numberOfColums;
  late List<DateTime> visibleDates;

  double cursorOffset = 0;
  int numberOfSlotsSelected = 0;

  @override
  void initState() {
    super.initState();
    pageWidth = widget.pageWidth;
    dayWidth = widget.dayWidth;
    height = widget.height;
    multidayEventHeight = widget.multidayEventHeight;
    numberOfRows = widget.numberOfRows;
    visibleDates = widget.visibleDates;
    numberOfColums = visibleDates.length;
    controller = widget.controller;
  }

  @override
  void didUpdateWidget(covariant MultiDayGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    pageWidth = widget.pageWidth;
    dayWidth = widget.dayWidth;
    height = widget.height;
    multidayEventHeight = widget.multidayEventHeight;
    numberOfRows = widget.numberOfRows;
    visibleDates = widget.visibleDates;
    numberOfColums = visibleDates.length;
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileDevice = CalendarInternals.of<T>(context).configuration.isMobileDevice;
    return Column(
      children: <Widget>[
        for (int r = 0; r < numberOfRows; r++)
          Row(
            children: <Widget>[
              for (int c = 0; c < numberOfColums; c++)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SizedBox(
                    width: dayWidth,
                    height: multidayEventHeight,
                    child: GestureDetector(
                      onTap: () => _onTap(visibleDates[c].dayRange),
                      onHorizontalDragStart: !isMobileDevice
                          ? (DragStartDetails details) =>
                              _onHorizontalDragStart(details, visibleDates[c].dayRange)
                          : null,
                      onHorizontalDragUpdate: !isMobileDevice
                          ? (DragUpdateDetails details) =>
                              _onHorizontalDragUpdate(details, visibleDates[c].dayRange)
                          : null,
                      onHorizontalDragEnd: !isMobileDevice ? _onHorizontalDragEnd : null,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                )
            ],
          )
      ],
    );
  }

  void _onTap(DateTimeRange dateTimeRange) async {
    if (!CalendarInternals.of<T>(context).configuration.createNewEvents) return;

    CalendarEvent<T> newCalendarEvent = CalendarEvent<T>(
      dateTimeRange: dateTimeRange,
    );

    // Set the chaning event to the new event.
    controller.chaningEvent = newCalendarEvent;
    controller.isMultidayEvent = true;

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

    controller.isMultidayEvent = false;
  }

  void _onHorizontalDragStart(DragStartDetails details, DateTimeRange dateTimeRange) {
    cursorOffset = 0;
    controller.isMultidayEvent = true;
    CalendarEvent<T> displayEvent = CalendarEvent<T>(
      dateTimeRange: dateTimeRange,
    );
    controller.chaningEvent = displayEvent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, DateTimeRange initialDateTimeRange) {
    cursorOffset += details.delta.dx;

    int newNumberOfSlotsSelected = cursorOffset ~/ dayWidth;

    if (newNumberOfSlotsSelected != numberOfSlotsSelected) {
      numberOfSlotsSelected = newNumberOfSlotsSelected;
      DateTimeRange dateTimeRange;
      if (numberOfSlotsSelected.isNegative) {
        dateTimeRange = DateTimeRange(
          start: initialDateTimeRange.start.add(Duration(days: 1 * numberOfSlotsSelected)),
          end: initialDateTimeRange.end,
        );
      } else {
        dateTimeRange = DateTimeRange(
          start: initialDateTimeRange.start,
          end: initialDateTimeRange.end.add(Duration(days: 1 * numberOfSlotsSelected)),
        );
      }

      controller.chaningEvent?.dateTimeRange = dateTimeRange;
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
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
    controller.isMultidayEvent = false;
  }
}
