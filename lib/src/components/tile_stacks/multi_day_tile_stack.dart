import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day_gesture_detector.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day_tile_gesture_detector.dart';
import 'package:kalender/src/components/tile_stacks/chaning_multi_day_tile_stack.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class PositionedMultiDayTileStack<T extends Object?> extends StatelessWidget {
  const PositionedMultiDayTileStack({
    super.key,
    required this.pageWidth,
    required this.dayWidth,
    required this.multiDayEventLayout,
  });

  /// The width of the page.
  final double pageWidth;

  /// The width a single day.
  final double dayWidth;

  /// The [MultiDayLayoutController]
  final MultiDayLayoutController<T> multiDayEventLayout;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);
    CalendarEventController<T> controller = scope.eventController;
    CalendarViewState state = scope.state;
    CalendarComponents<T> components = scope.components;
    CalendarFunctions<T> functions = scope.functions;

    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          /// Arrange the events.
          List<PositionedMultiDayTileData<T>> arragedEvents = multiDayEventLayout.arrageEvents(
            controller.getMultidayEventsFromDateRange(
              state.visibleDateTimeRange.value,
            ),
            selectedEvent: controller.chaningEvent,
          );

          return SizedBox(
            width: pageWidth,
            height: multiDayEventLayout.stackHeight,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        components.daySepratorBuilder(
                          15,
                          dayWidth,
                          state.visibleDateTimeRange.value.duration.inDays,
                        ),
                      ],
                    ),
                  ],
                ),
                MultiDayGestureDetector<T>(
                  pageWidth: pageWidth,
                  height: multiDayEventLayout.stackHeight,
                  dayWidth: dayWidth,
                  multidayEventHeight: multiDayEventLayout.tileHeight,
                  numberOfRows: multiDayEventLayout.numberOfRows,
                  visibleDates: state.visibleDateTimeRange.value.datesSpanned,
                ),
                ...arragedEvents.map(
                  (PositionedMultiDayTileData<T> e) {
                    return MultidayTileStack<T>(
                      controller: scope.eventController,
                      onEventChanged: functions.onEventChanged,
                      onEventTapped: functions.onEventTapped,
                      visibleDateRange: state.visibleDateTimeRange.value,
                      multiDayEventLayout: multiDayEventLayout,
                      arragnedEvent: e,
                      dayWidth: dayWidth,
                      horizontalDurationStep: const Duration(days: 1),
                    );
                  },
                ).toList(),
                ChaningMultiDayTileStack<T>(
                  multiDayEventLayout: multiDayEventLayout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MultidayTileStack<T extends Object?> extends StatelessWidget {
  const MultidayTileStack({
    super.key,
    required this.controller,
    required this.onEventTapped,
    required this.onEventChanged,
    required this.visibleDateRange,
    required this.multiDayEventLayout,
    required this.arragnedEvent,
    required this.dayWidth,
    required this.horizontalDurationStep,
  });

  final CalendarEventController<T> controller;

  /// The [Function] called when the event is changed.
  final Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)? onEventChanged;

  /// The [Function] called when the event is tapped.
  final Function(CalendarEvent<T> event)? onEventTapped;

  final DateTimeRange visibleDateRange;
  final MultiDayLayoutController<T> multiDayEventLayout;
  final PositionedMultiDayTileData<T> arragnedEvent;

  final double dayWidth;
  final Duration horizontalDurationStep;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        bool isMoving = controller.chaningEvent == arragnedEvent.event;
        return Stack(
          children: <Widget>[
            Positioned(
              top: arragnedEvent.top,
              left: arragnedEvent.left,
              width: arragnedEvent.width,
              height: arragnedEvent.height,
              child: MultiDayTileGestureDetector(
                horizontalDurationStep: horizontalDurationStep,
                dayWidth: dayWidth,
                initialDateTimeRange: arragnedEvent.event.dateTimeRange,
                onTap: _onTap,
                onHorizontalDragStart: _onHorizontalDragStart,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                rescheduleEvent: _rescheduleEvent,
                child: CalendarScope.of<T>(context).components.multiDayEventTileBuilder(
                      arragnedEvent.event,
                      isMoving ? TileType.ghost : TileType.normal,
                      arragnedEvent.continuesBefore,
                      arragnedEvent.continuesAfter,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onTap() async {
    controller.isMultidayEvent = true;
    controller.chaningEvent = arragnedEvent.event;
    await onEventTapped?.call(controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMultidayEvent = false;
  }

  void _onHorizontalDragStart() {
    controller.isMultidayEvent = true;
    controller.chaningEvent = arragnedEvent.event;
  }

  void _onHorizontalDragEnd() {
    onEventChanged?.call(arragnedEvent.dateRange, controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMultidayEvent = false;
  }

  void _rescheduleEvent(DateTimeRange newDateTimeRange) {
    if (controller.chaningEvent == null) return;

    if (newDateTimeRange.start.isWithin(visibleDateRange) ||
        newDateTimeRange.end.isWithin(visibleDateRange)) {
      controller.chaningEvent?.dateTimeRange = newDateTimeRange;
    }
  }
}
