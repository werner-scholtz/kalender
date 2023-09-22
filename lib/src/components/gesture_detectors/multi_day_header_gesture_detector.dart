import 'package:flutter/material.dart';
import 'package:kalender/kalender_scope.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

class MultiDayHeaderGestureDetector<T> extends StatefulWidget {
  const MultiDayHeaderGestureDetector({
    super.key,
    required this.viewConfiguration,
    required this.visibleDateRange,
    required this.horizontalStep,
    this.verticalStep,
  });

  final DateTimeRange visibleDateRange;
  final ViewConfiguration viewConfiguration;
  final double horizontalStep;
  final double? verticalStep;

  @override
  State<MultiDayHeaderGestureDetector<T>> createState() =>
      _MultiDayHeaderGestureDetectorState<T>();
}

class _MultiDayHeaderGestureDetectorState<T>
    extends State<MultiDayHeaderGestureDetector<T>> {
  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
  CalendarEventHandlers<T> get functions => scope.functions;
  bool get isMobileDevice => scope.platformData.isMobileDevice;
  bool get createEvents => widget.viewConfiguration.createMultiDayEvents;

  Offset cursorOffset = Offset.zero;
  int currentVerticalSteps = 0;
  int currentHorizontalSteps = 0;

  DateTimeRange? initialDateTimeRange;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          createEvents ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Row(
        children: [
          for (final date in widget.visibleDateRange.datesSpanned)
            Expanded(
              child: GestureDetector(
                onTap: () => _onTap(date),
                onPanStart: createEvents
                    ? (details) => _onPanStart(details, date)
                    : null,
                onPanUpdate: createEvents ? _onPanUpdate : null,
                onPanEnd: createEvents ? _onPanEnd : null,
              ),
            ),
        ],
      ),
    );
  }

  void _onTap(DateTime date) async {
    if (controller.selectedEvent != null) {
      controller.deselectEvent();
      return;
    }

    if (!createEvents) return;

    final newCalendarEvent = CalendarEvent<T>(
      dateTimeRange: DateTimeRange(start: date, end: date.endOfDay),
    );

    controller.selectEvent(newCalendarEvent);

    await functions.onCreateEvent?.call(controller.selectedEvent!);

    controller.deselectEvent();
  }

  void _onPanStart(DragStartDetails details, DateTime date) {
    cursorOffset = Offset.zero;
    initialDateTimeRange = DateTimeRange(start: date, end: date.endOfDay);
    final displayEvent = CalendarEvent<T>(
      dateTimeRange: initialDateTimeRange!,
    );
    controller.selectEvent(displayEvent);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    cursorOffset += details.delta;

    final horizontalSteps = (cursorOffset.dx / widget.horizontalStep).round();
    final verticalSteps = widget.verticalStep != null
        ? (cursorOffset.dy / widget.verticalStep!).round()
        : 0;

    if (widget.verticalStep != null &&
        currentHorizontalSteps == horizontalSteps &&
        currentVerticalSteps == verticalSteps) {
      return;
    } else if (widget.verticalStep == null &&
        currentHorizontalSteps == horizontalSteps) {
      return;
    }

    final dHorizontal = const Duration(days: 1) * horizontalSteps;
    final dVertical = const Duration(days: 7) * verticalSteps;

    final newStart =
        initialDateTimeRange!.start.add(dHorizontal).add(dVertical);
    final newEnd = initialDateTimeRange!.end.add(dHorizontal).add(dVertical);

    if (newStart.isBefore(initialDateTimeRange!.start)) {
      final newDateTimeRange = DateTimeRange(
        start: newStart,
        end: initialDateTimeRange!.end,
      );

      controller.selectedEvent!.dateTimeRange = newDateTimeRange;
    } else {
      final newDateTimeRange = DateTimeRange(
        start: initialDateTimeRange!.start,
        end: newEnd,
      );

      controller.selectedEvent!.dateTimeRange = newDateTimeRange;
    }

    currentHorizontalSteps = horizontalSteps;
    currentVerticalSteps = verticalSteps;
  }

  void _onPanEnd(DragEndDetails details) async {
    await functions.onCreateEvent?.call(controller.selectedEvent!);
    controller.deselectEvent();
  }
}
