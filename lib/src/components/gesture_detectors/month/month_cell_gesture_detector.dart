import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// A widget that detects gestures on a month cell.
/// TODO: Create a builder for a [MonthCellGestureDetector].
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
  bool get gestureDisabled => isMobileDevice;

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
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        onPanStart: gestureDisabled ? null : _onPanStart,
        onPanUpdate: gestureDisabled ? null : _onPanUpdate,
        onPanEnd: gestureDisabled ? null : _onPanEnd,
      ),
    );
  }

  /// TODO: figure something out.
  void _onTap() async {
    if (isMobileDevice) {
      scope.functions.onDateTapped?.call(date);
    } else {
      // Create a new [CalendarEvent] with the [dateTimeRange].
      CalendarEvent<T> newCalendarEvent = CalendarEvent<T>(
        dateTimeRange: date.dayRange,
      );

      controller.selectEvent(newCalendarEvent);

      await functions.onCreateEvent?.call(controller.selectedEvent!);

      scope.eventsController.deselectEvent();
    }
  }

  void _onPanStart(DragStartDetails details) {
    // Create a new [CalendarEvent] with the [dateTimeRange].
    CalendarEvent<T> newCalendarEvent = CalendarEvent<T>(
      dateTimeRange: date.dayRange,
    );

    initialDateTimeRange = newCalendarEvent.dateTimeRange;

    controller.selectEvent(newCalendarEvent);

    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;
  }

  void _onPanEnd(DragEndDetails details) async {
    cursorOffset = Offset.zero;
    currentVerticalSteps = 0;
    currentHorizontalSteps = 0;

    await functions.onCreateEvent?.call(controller.selectedEvent!);

    scope.eventsController.deselectEvent();
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

      controller.selectedEvent!.dateTimeRange = newDateTimeRange;
    } else {
      DateTimeRange newDateTimeRange = DateTimeRange(
        start: initialDateTimeRange!.start,
        end: newEnd,
      );

      controller.selectedEvent!.dateTimeRange = newDateTimeRange;
    }
  }
}
