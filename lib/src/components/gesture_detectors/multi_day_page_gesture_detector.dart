import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';

/// This widget is used to detect gestures on the [MultiDayPageWidget].
class MultiDayPageGestureDetector<T> extends StatefulWidget {
  const MultiDayPageGestureDetector({
    super.key,
    required this.viewConfiguration,
    required this.visibleDates,
    required this.heightPerMinute,
    required this.verticalStep,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final List<DateTime> visibleDates;

  /// The height per minute.
  final double heightPerMinute;
  final double verticalStep;

  @override
  State<MultiDayPageGestureDetector<T>> createState() =>
      _MultiDayPageGestureDetectorState<T>();
}

class _MultiDayPageGestureDetectorState<T>
    extends State<MultiDayPageGestureDetector<T>> {
  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
  MultiDayViewConfiguration get viewConfiguration => widget.viewConfiguration;

  bool get isMobileDevice => scope.platformData.isMobileDevice;
  bool get createEvents => viewConfiguration.createEvents;

  int get newEventDurationInMinutes {
    return viewConfiguration.newEventDuration.inMinutes;
  }

  CreateEventTrigger get createEventTrigger {
    return viewConfiguration.createEventTrigger;
  }

  double cursorOffset = 0;
  int currentVerticalSteps = 0;

  @override
  Widget build(BuildContext context) {
    final tap = createEventTrigger == CreateEventTrigger.tap;
    final longPress = createEventTrigger == CreateEventTrigger.longPress;

    final numberOfSlots =
        ((viewConfiguration.endHour * 60) / newEventDurationInMinutes).ceil();

    final cursor =
        createEvents ? SystemMouseCursors.click : SystemMouseCursors.basic;

    final rows = List.generate(
      widget.visibleDates.length,
      (index) {
        final date = widget.visibleDates[index];

        final items = List.generate(
          numberOfSlots,
          (index) {
            final gestureDetector = GestureDetector(
              onLongPress: () => longPress
                  ? _createNewEvent(date, index)
                  : controller.deselectEvent(),
              onTap: () => tap
                  ? _createNewEvent(date, index)
                  : controller.deselectEvent(),
              onVerticalDragStart: isMobileDevice || !createEvents
                  ? null
                  : (details) => _onVerticalDragStart(details, date, index),
              onVerticalDragUpdate: isMobileDevice || !createEvents
                  ? null
                  : (details) => _onVerticalDragUpdate(details, date, index),
              onVerticalDragEnd:
                  isMobileDevice || !createEvents ? null : _onVerticalDragEnd,
            );

            return Expanded(
              child: gestureDetector,
            );
          },
        );

        return Expanded(
          child: Column(
            children: items,
          ),
        );
      },
    );

    return MouseRegion(
      cursor: cursor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: rows,
      ),
    );
  }

  /// Creates new event.
  void _createNewEvent(DateTime date, int slotIndex) async {
    // If the create events flag is false, return.
    if (!createEvents) return;

    // Call the onEventCreate callback.
    final newEvent = scope.functions.onCreateEvent?.call(
      calculateSlotDateTimeRange(date, slotIndex),
    );

    // If the new event is null, return.
    if (newEvent == null) return;

    // Call the onEventCreated callback.
    await scope.functions.onEventCreated?.call(
      newEvent,
    );
  }

  /// Handles the vertical drag start event.
  void _onVerticalDragStart(
    DragStartDetails details,
    DateTime date,
    int slotIndex,
  ) {
    cursorOffset = 0;
    currentVerticalSteps = 0;

    final slotRange = calculateSlotDateTimeRange(date, slotIndex);

    // Call the onEventCreate callback.
    final newEvent = scope.functions.onCreateEvent?.call(
      slotRange,
    );

    // If the new event is null, return.
    if (newEvent == null) return;

    scope.eventsController.selectEvent(
      newEvent,
    );
  }

  /// Handles the vertical drag update event.
  void _onVerticalDragUpdate(
    DragUpdateDetails details,
    DateTime date,
    int slotIndex,
  ) {
    if (scope.eventsController.selectedEvent == null) return;

    cursorOffset += details.delta.dy;

    final verticalSteps = cursorOffset ~/ widget.verticalStep;
    if (verticalSteps == currentVerticalSteps) return;

    final initialSlotRange = calculateSlotDateTimeRange(date, slotIndex);

    DateTime start;
    DateTime end;

    if (currentVerticalSteps.isNegative) {
      end = initialSlotRange.end;
      start = initialSlotRange.start.add(
        Duration(minutes: newEventDurationInMinutes * currentVerticalSteps),
      );

      if (viewConfiguration.startHour != 0) {
        final earliestTime = date.copyWith(hour: viewConfiguration.startHour);
        if (start.isBefore(earliestTime)) {
          start = earliestTime;
        }
      }
    } else {
      start = initialSlotRange.start;
      end = initialSlotRange.end.add(
        Duration(minutes: newEventDurationInMinutes * currentVerticalSteps),
      );

      if (viewConfiguration.endHour != 0) {
        final latestTime = date.copyWith(hour: viewConfiguration.endHour);
        if (end.isAfter(latestTime)) {
          end = latestTime;
        }
      }
    }

    final dateTimeRange = DateTimeRange(start: start, end: end);

    scope.eventsController.selectedEvent?.dateTimeRange = dateTimeRange;

    currentVerticalSteps = verticalSteps;
  }

  /// Handles the vertical drag end event.
  void _onVerticalDragEnd(DragEndDetails details) async {
    if (scope.eventsController.selectedEvent == null) return;

    cursorOffset = 0;

    final selectedEvent = scope.eventsController.selectedEvent!;

    await scope.functions.onEventCreated?.call(
      selectedEvent,
    );
  }

  DateTimeRange calculateSlotDateTimeRange(DateTime date, int slotIndex) {
    final start = date.add(
      Duration(minutes: slotIndex * newEventDurationInMinutes),
    );

    final end = start.add(
      widget.viewConfiguration.newEventDuration,
    );

    return DateTimeRange(start: start, end: end);
  }
}
