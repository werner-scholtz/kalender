import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/providers/multi_day_body_provider.dart';
import 'package:kalender/src/models/time_of_day_range.dart';
import 'package:kalender/src/widgets/components/resize_detector.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_body.dart';

/// A [StatelessWidget] that displays a single [CalendarEvent] in the [MultiDayBody].
class EventTile<T extends Object?> extends StatefulWidget {
  /// The [EventsController] is used to update the events when resizing.
  final EventsController<T> eventsController;

  /// The [CalendarEvent] that the [EventTile] represents.
  final CalendarEvent<T> event;

  /// The components used by the [EventTile].
  final MultiDayBodyTileComponents<T> tileComponents;

  /// The callbacks used by the [EventTile].
  final MultiDayBodyCallbacks<T>? callbacks;

  /// The event that is being dragged.
  final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;

  const EventTile({
    super.key,
    required this.eventsController,
    required this.event,
    required this.tileComponents,
    required this.callbacks,
    required this.eventBeingDragged,
  });

  @override
  State<EventTile<T>> createState() => _EventTileState<T>();
}

enum VerticalResize {
  top,
  bottom,
  none,
}

class _EventTileState<T extends Object?> extends State<EventTile<T>> {
  CalendarEvent<T> get event => widget.event;
  EventsController<T> get eventsController => widget.eventsController;

  late final provider = MultiDayBodyProvider.of(context);
  late final viewConfiguration = provider.viewConfiguration;
  late final dayWidth = provider.dayWidth;
  late final heightPerMinute = provider.heightPerMinute;
  late final timeOfDayRange = provider.timeOfDayRange;
  late final visibleDateTimeRange = provider.visibleDateTimeRange.value;
  late final visibleDates = visibleDateTimeRange.datesSpanned;
  late final feedbackWidgetSize = provider.dropTargetWidgetSize;
  late final tileComponents = widget.tileComponents;
  late final dragAnchorStrategy = tileComponents.dragAnchorStrategy;

  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged =>
      widget.eventBeingDragged;

  ValueNotifier<VerticalResize> resizingDirection =
      ValueNotifier(VerticalResize.none);

  @override
  Widget build(BuildContext context) {
    final onTap = widget.callbacks?.onEventTapped;

    late final tileComponent = tileComponents.tileBuilder.call(
      widget.event,
    );

    late final dragComponent = tileComponents.tileWhenDraggingBuilder?.call(
      widget.event,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder(
          valueListenable: resizingDirection,
          builder: (context, direction, child) {
            late final resizeHeight = min(constraints.maxHeight * 0.25, 12.0);
            late final showTopResizeHandle = constraints.maxHeight > 24;

            final topResizeDetector = ResizeDetectorWidget(
              onPanUpdate: (_) => _onPanUpdate(_, VerticalResize.top),
              onPanEnd: (_) => _onPanEnd(_, VerticalResize.top),
              child: direction != VerticalResize.none
                  ? null
                  : tileComponents.resizeHandle ?? const SizedBox(),
            );

            final bottomResizeDetector = ResizeDetectorWidget(
              onPanUpdate: (_) => _onPanUpdate(_, VerticalResize.bottom),
              onPanEnd: (_) => _onPanEnd(_, VerticalResize.bottom),
              child: direction != VerticalResize.none
                  ? null
                  : tileComponents.resizeHandle ?? const SizedBox(),
            );

            late final feedback = ValueListenableBuilder(
              valueListenable: feedbackWidgetSize,
              builder: (context, value, child) {
                final feedbackTile = tileComponents.feedbackTileBuilder?.call(
                  widget.event,
                  value,
                );
                return feedbackTile ?? const SizedBox();
              },
            );

            late final draggableTile = Draggable<CalendarEvent<T>>(
              data: widget.event,
              feedback: feedback,
              childWhenDragging: dragComponent,
              dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
              child: tileComponent,
            );

            final tileWidget = GestureDetector(
              onTap: onTap != null ? () => onTap(widget.event) : null,
              child: viewConfiguration.allowRescheduling
                  ? draggableTile
                  : tileComponent,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: direction != VerticalResize.none
                      ? dragComponent ?? const SizedBox()
                      : tileWidget,
                ),
                if (viewConfiguration.allowResizing && showTopResizeHandle)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: resizeHeight,
                    child: topResizeDetector,
                  ),
                if (viewConfiguration.allowResizing)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: resizeHeight,
                    child: bottomResizeDetector,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _onPanUpdate(Offset delta, VerticalResize direction) {
    resizingDirection.value = direction;
    final updatedEvent = _updateEvent(delta, direction);
    if (updatedEvent == null) return;
    eventBeingDragged.value = updatedEvent;
  }

  void _onPanEnd(Offset delta, VerticalResize direction) {
    final updatedEvent = _updateEvent(delta, direction);
    if (updatedEvent == null) return;
    eventsController.updateEvent(
      event: widget.event,
      updatedEvent: updatedEvent,
    );
    eventBeingDragged.value = null;
    resizingDirection.value = VerticalResize.none;
  }

  /// Updates the [CalendarEvent] based on the [Offset] delta and [VerticalResize].
  CalendarEvent<T>? _updateEvent(
    Offset delta,
    VerticalResize direction,
  ) {
    final dateTimeRange = switch (direction) {
      VerticalResize.top => _calculateDateTimeRangeTop(delta),
      VerticalResize.bottom => _calculateDateTimeRangeBottom(delta),
      VerticalResize.none => null,
    };
    if (dateTimeRange == null) return null;
    return eventBeingDragged.value = event.copyWith(
      dateTimeRange: dateTimeRange,
    );
  }

  /// Calculates the [DateTimeRange] when resizing from the top.
  DateTimeRange _calculateDateTimeRangeTop(
    Offset delta,
  ) {
    final deltaDuration = _calculateDeltaDuration(delta);
    var newStart = event.start.add(deltaDuration);
    if (!timeOfDayRange.isAllDay) newStart = _clampDateTime(newStart);

    if (newStart.isAtSameMomentAs(event.end)) {
      return DateTimeRange(
        start: newStart.subtract(const Duration(minutes: 1)),
        end: event.end,
      );
    } else if (newStart.isAfter(event.end)) {
      return DateTimeRange(
        start: event.end,
        end: newStart,
      );
    } else {
      return DateTimeRange(
        start: newStart,
        end: event.end,
      );
    }
  }

  /// Calculates the [DateTimeRange] when resizing from the bottom.
  DateTimeRange _calculateDateTimeRangeBottom(
    Offset delta,
  ) {
    final deltaDuration = _calculateDeltaDuration(delta);
    var newEnd = event.end.add(deltaDuration);
    if (!timeOfDayRange.isAllDay) newEnd = _clampDateTime(newEnd);

    if (newEnd.isAtSameMomentAs(event.start)) {
      return DateTimeRange(
        start: event.start,
        end: newEnd.add(const Duration(minutes: 1)),
      );
    } else if (newEnd.isBefore(event.start)) {
      return DateTimeRange(
        start: newEnd,
        end: event.start,
      );
    } else {
      return DateTimeRange(
        start: event.start,
        end: newEnd,
      );
    }
  }

  /// Calculates the [Duration] based on the [Offset] delta.
  Duration _calculateDeltaDuration(
    Offset delta,
  ) {
    var horizontalDelta = Duration.zero;
    if (timeOfDayRange.isAllDay) {
      final dayOffset = delta.dx / dayWidth;
      horizontalDelta = Duration(
        days: dayOffset.isNegative ? dayOffset.ceil() : dayOffset.floor(),
      );
    }

    final durationFromStart = delta.dy ~/ heightPerMinute;
    final snapIntervalMinutes = provider.viewConfiguration.snapIntervalMinutes;
    final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();
    final verticalDuration = Duration(
      minutes: snapIntervalMinutes * numberOfIntervals,
    );

    return verticalDuration + horizontalDelta;
  }

  /// Clamps the [DateTime] to the [TimeOfDayRange].
  DateTime _clampDateTime(DateTime dateTime) {
    final timeOfDayStart = timeOfDayRange.start.toDateTime(dateTime);
    final timeOfDayEnd = timeOfDayRange.end.toDateTime(dateTime);

    if (dateTime.isBefore(timeOfDayStart)) {
      return timeOfDayStart;
    } else if (dateTime.isAfter(timeOfDayEnd)) {
      return timeOfDayEnd;
    }

    return dateTime;
  }
}
