import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class MonthCellGestureDetector<T> extends StatefulWidget {
  const MonthCellGestureDetector({
    super.key,
    required this.date,
    required this.visibleDateRange,
    required this.verticalDurationStep,
    required this.verticalStep,
    required this.horizontalDurationStep,
    required this.horizontalStep,
  });

  final DateTime date;

  /// The visible date range.
  final DateTimeRange visibleDateRange;

  /// The duration of the vertical step when dragging/resizing an event.
  final Duration verticalDurationStep;

  /// The pixel value of the vertical step.
  final double verticalStep;

  /// The duration of the horizontal step when dragging an event.
  final Duration horizontalDurationStep;

  /// The pixel value of the horizontal step.
  final double horizontalStep;

  @override
  State<MonthCellGestureDetector<T>> createState() =>
      _MonthCellGestureDetectorState<T>();
}

class _MonthCellGestureDetectorState<T>
    extends State<MonthCellGestureDetector<T>> {
  late final DateTime date;

  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
  CalendarEventHandlers<T> get functions => scope.functions;
  bool get isMobileDevice => scope.platformData.isMobileDevice;
  bool get createNewEvents => scope.state.viewConfiguration.createNewEvents;
  bool get gestureDisabled => isMobileDevice || !createNewEvents;

  DateTimeRange? initialDateTimeRange;
  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  @override
  void initState() {
    super.initState();
    date = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          createNewEvents ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: createNewEvents ? _onTap : null,
        onPanStart: gestureDisabled ? null : _onPanStart,
        onPanUpdate: gestureDisabled ? null : _onPanUpdate,
        onPanEnd: gestureDisabled ? null : _onPanEnd,
      ),
    );
  }

  void _onTap() async {
    if (isMobileDevice) {
      scope.functions.onDateTapped?.call(date);
    } else {
      // Create a new [CalendarEvent] with the [dateTimeRange].
      CalendarEvent<T> newCalendarEvent = CalendarEvent<T>(
        dateTimeRange: date.dayRange,
      );

      // Set the chaning event to the new event.
      controller.chaningEvent = newCalendarEvent;

      // Set the [isNewEvent] to true.
      controller.isNewEvent = true;

      CalendarEvent<T>? newEvent =
          await functions.onCreateEvent?.call(controller.chaningEvent!);

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
  }

  void _onPanStart(DragStartDetails details) {
    // Create a new [CalendarEvent] with the [dateTimeRange].
    CalendarEvent<T> newCalendarEvent = CalendarEvent<T>(
      dateTimeRange: date.dayRange,
    );

    // Set the chaning event to the new event.
    controller.chaningEvent = newCalendarEvent;
    initialDateTimeRange = newCalendarEvent.dateTimeRange;

    // Set the [isNewEvent] to true.
    controller.isNewEvent = true;

    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;
  }

  void _onPanEnd(DragEndDetails details) async {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;
    CalendarEvent<T>? newEvent =
        await functions.onCreateEvent?.call(controller.chaningEvent!);
    // If the [newEvent] is null then set the [chaningEvent] to null.
    if (newEvent == null) {
      controller.chaningEvent = null;
    } else {
      // Add the [newEvent] to the [CalendarController].
      controller.addEvent(newEvent);
      controller.chaningEvent = null;
    }

    controller.chaningEvent = null;
    // Set the [isNewEvent] to false.
    controller.isNewEvent = false;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta;

    int verticalSteps = (cursorOffset.dy / widget.verticalStep).round();
    if (verticalSteps != currentVerticalSteps) {
      currentVerticalSteps = verticalSteps;
    }

    int horizontalSteps = (cursorOffset.dx / widget.horizontalStep).round();
    if (horizontalSteps != currentHorizontalSteps) {
      currentHorizontalSteps = horizontalSteps;
    }

    DateTime newStart = initialDateTimeRange!.start
        .add(widget.horizontalDurationStep * horizontalSteps)
        .add(widget.verticalDurationStep * verticalSteps);

    DateTime newEnd = initialDateTimeRange!.end
        .add(widget.horizontalDurationStep * horizontalSteps)
        .add(widget.verticalDurationStep * verticalSteps);

    if (newStart.isBefore(initialDateTimeRange!.start)) {
      DateTimeRange newDateTimeRange = DateTimeRange(
        start: newStart,
        end: initialDateTimeRange!.end,
      );

      controller.chaningEvent!.dateTimeRange = newDateTimeRange;
    } else {
      DateTimeRange newDateTimeRange = DateTimeRange(
        start: initialDateTimeRange!.start,
        end: newEnd,
      );

      controller.chaningEvent!.dateTimeRange = newDateTimeRange;
    }
  }
}
