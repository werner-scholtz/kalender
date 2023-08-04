import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MultiDayGestureDetector<T> extends StatefulWidget {
  const MultiDayGestureDetector({
    super.key,
    required this.pageWidth,
    required this.cellWidth,
    required this.height,
    required this.multidayEventHeight,
    required this.numberOfRows,
    required this.visibleDates,
  });

  final double pageWidth;
  final double cellWidth;
  final double height;
  final double multidayEventHeight;
  final int numberOfRows;
  final List<DateTime> visibleDates;

  @override
  State<MultiDayGestureDetector<T>> createState() => _MultiDayGestureDetectorState<T>();
}

class _MultiDayGestureDetectorState<T> extends State<MultiDayGestureDetector<T>> {
  late double pageWidth;
  late double dayWidth;
  late double height;
  late double multidayEventHeight;
  late int numberOfRows;
  late int numberOfColums;
  late List<DateTime> visibleDates;

  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
  CalendarEventHandlers<T> get functions => scope.functions;

  bool get gestureDisabled => isMobileDevice || !createNewEvents;
  bool get createNewEvents => scope.state.createNewEvents;
  bool get isMobileDevice => scope.platformData.isMobileDevice;

  double cursorOffset = 0;
  int numberOfSlotsSelected = 0;

  @override
  void initState() {
    super.initState();
    pageWidth = widget.pageWidth;
    dayWidth = widget.cellWidth;
    height = widget.height;
    multidayEventHeight = widget.multidayEventHeight;
    numberOfRows = widget.numberOfRows;
    visibleDates = widget.visibleDates;
    numberOfColums = visibleDates.length;
  }

  @override
  void didUpdateWidget(covariant MultiDayGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    pageWidth = widget.pageWidth;
    dayWidth = widget.cellWidth;
    height = widget.height;
    multidayEventHeight = widget.multidayEventHeight;
    numberOfRows = widget.numberOfRows;
    visibleDates = widget.visibleDates;
    numberOfColums = visibleDates.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int r = 0; r < numberOfRows; r++)
          Row(
            children: <Widget>[
              for (int c = 0; c < numberOfColums; c++)
                MouseRegion(
                  cursor: createNewEvents ? SystemMouseCursors.click : SystemMouseCursors.basic,
                  child: SizedBox(
                    width: dayWidth,
                    height: multidayEventHeight,
                    child: GestureDetector(
                      onTap: createNewEvents ? () => _onTap(visibleDates[c].dayRange) : null,
                      onHorizontalDragStart: gestureDisabled
                          ? null
                          : (DragStartDetails details) =>
                              _onHorizontalDragStart(details, visibleDates[c].dayRange),
                      onHorizontalDragUpdate: gestureDisabled
                          ? null
                          : (DragUpdateDetails details) =>
                              _onHorizontalDragUpdate(details, visibleDates[c].dayRange),
                      onHorizontalDragEnd: createNewEvents ? _onHorizontalDragEnd : null,
                    ),
                  ),
                )
            ],
          )
      ],
    );
  }

  void _onTap(DateTimeRange dateTimeRange) async {
    CalendarEvent<T> newCalendarEvent = CalendarEvent<T>(
      dateTimeRange: dateTimeRange,
    );

    // Set the chaning event to the new event.
    controller.chaningEvent = newCalendarEvent;
    controller.isMultidayEvent = true;

    CalendarEvent<T>? newEvent = await functions.onCreateEvent?.call(controller.chaningEvent!);

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
    CalendarEvent<T>? newEvent = await functions.onCreateEvent?.call(controller.chaningEvent!);
    if (newEvent == null) {
      controller.chaningEvent = null;
    } else {
      controller.addEvent(newEvent);
      controller.chaningEvent = null;
    }
    controller.isMultidayEvent = false;
  }
}
