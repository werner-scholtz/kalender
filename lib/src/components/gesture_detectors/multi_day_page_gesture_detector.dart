import 'package:flutter/material.dart';
import 'package:kalender/kalender_scope.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/constants.dart';

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
  bool get isMobileDevice => scope.platformData.isMobileDevice;
  bool get createEvents => widget.viewConfiguration.createEvents;

  int get newEventDurationInMinutes =>
      widget.viewConfiguration.newEventDuration.inMinutes;

  double cursorOffset = 0;
  int currentVerticalSteps = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          createEvents ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final date in widget.visibleDates)
            Expanded(
              child: Column(
                children: List.generate(
                  (hoursADay * 60) ~/ newEventDurationInMinutes,
                  (slotIndex) => Expanded(
                    child: SizedBox.expand(
                      child: GestureDetector(
                        onTap: () => _onTap(
                          calculateNewEventDateTimeRange(date, slotIndex),
                        ),
                        onVerticalDragStart: isMobileDevice || !createEvents
                            ? null
                            : (details) => _onVerticalDragStart(
                                  details,
                                  calculateNewEventDateTimeRange(
                                    date,
                                    slotIndex,
                                  ),
                                ),
                        onVerticalDragEnd: isMobileDevice || !createEvents
                            ? null
                            : _onVerticalDragEnd,
                        onVerticalDragUpdate: isMobileDevice || !createEvents
                            ? null
                            : (details) => _onVerticalDragUpdate(
                                  details,
                                  calculateNewEventDateTimeRange(
                                    date,
                                    slotIndex,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Handles the onTap event.
  void _onTap(DateTimeRange dateTimeRange) async {
    // If the selected event is not null, deselect it.
    if (controller.selectedEvent != null) {
      controller.deselectEvent();
      return;
    }

    if (!createEvents) return;

    // Set the selected event to a new event.
    scope.eventsController.selectEvent(
      CalendarEvent<T>(
        dateTimeRange: dateTimeRange,
      ),
    );

    scope.eventsController.isMoving = true;

    // Call the onCreateEvent callback.
    await scope.functions.onCreateEvent?.call(
      scope.eventsController.selectedEvent!,
    );

    scope.eventsController.isMoving = false;
  }

  /// Handles the vertical drag start event.
  void _onVerticalDragStart(
    DragStartDetails details,
    DateTimeRange initialDateTimeRange,
  ) {
    cursorOffset = 0;
    currentVerticalSteps = 0;
    scope.eventsController.isResizing = true;
    scope.eventsController.selectEvent(
      CalendarEvent<T>(
        dateTimeRange: initialDateTimeRange,
      ),
    );
  }

  /// Handles the vertical drag update event.
  void _onVerticalDragUpdate(
    DragUpdateDetails details,
    DateTimeRange initialDateTimeRange,
  ) {
    cursorOffset += details.delta.dy;

    final verticalSteps = cursorOffset ~/ widget.verticalStep;
    if (verticalSteps == currentVerticalSteps) return;

    DateTimeRange dateTimeRange;
    if (currentVerticalSteps.isNegative) {
      dateTimeRange = DateTimeRange(
        start: initialDateTimeRange.start.add(
          Duration(
            minutes: newEventDurationInMinutes * currentVerticalSteps,
          ),
        ),
        end: initialDateTimeRange.end,
      );
    } else {
      dateTimeRange = DateTimeRange(
        start: initialDateTimeRange.start,
        end: initialDateTimeRange.end.add(
          Duration(
            minutes: newEventDurationInMinutes * currentVerticalSteps,
          ),
        ),
      );
    }

    scope.eventsController.selectedEvent?.dateTimeRange = dateTimeRange;

    currentVerticalSteps = verticalSteps;
  }

  /// Handles the vertical drag end event.
  void _onVerticalDragEnd(DragEndDetails details) async {
    cursorOffset = 0;

    final selectedEvent = scope.eventsController.selectedEvent!;

    scope.eventsController.isResizing = false;
    scope.eventsController.deselectEvent();

    await scope.functions.onCreateEvent?.call(
      selectedEvent,
    );
  }

  ///
  DateTimeRange calculateNewEventDateTimeRange(DateTime date, int slotIndex) {
    final start = date.add(
      Duration(
        minutes: slotIndex * newEventDurationInMinutes,
      ),
    );
    final end = start.add(
      widget.viewConfiguration.newEventDuration,
    );
    return DateTimeRange(start: start, end: end);
  }
}
