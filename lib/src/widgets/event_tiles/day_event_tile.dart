import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/mixins/snap_points.dart';
import 'package:kalender/src/models/providers/multi_day_body_provider.dart';
import 'package:kalender/src/widgets/components/resize_detector.dart';

/// A [StatelessWidget] that displays a single [CalendarEvent] in the [MultiDayBody].
class DayEventTile<T extends Object?> extends StatefulWidget {
  /// The [CalendarEvent] that the [DayEventTile] represents.
  final CalendarEvent<T> event;

  const DayEventTile({
    super.key,
    required this.event,
  });

  @override
  State<DayEventTile<T>> createState() => _DayEventTileState<T>();
}

enum ResizeDirection {
  top,
  bottom,
  none,
}

class _DayEventTileState<T extends Object?> extends State<DayEventTile<T>>
    with SnapPoints {
  CalendarEvent<T> get event => widget.event;

  MultiDayBodyDayProvider<T> get provider =>
      MultiDayBodyDayProvider.of<T>(context);
  EventsController<T> get eventsController => provider.eventsController;
  MultiDayBodyConfiguration get bodyConfiguration => provider.bodyConfiguration;
  CalendarCallbacks<T>? get callbacks => provider.callbacks;
  TileComponents<T> get tileComponents => provider.tileComponents;
  DragAnchorStrategy? get dragAnchorStrategy =>
      tileComponents.dragAnchorStrategy;
  ValueNotifier<Size> get feedbackWidgetSize => provider.feedbackWidgetSize;
  TimeOfDayRange get timeOfDayRange => provider.timeOfDayRange;
  double get dayWidth => provider.dayWidth;
  double get heightPerMinute => provider.heightPerMinuteValue;

  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged =>
      provider.eventBeingDragged;

  ValueNotifier<ResizeDirection> resizingDirection =
      ValueNotifier(ResizeDirection.none);

  @override
  Widget build(BuildContext context) {
    final onTap = callbacks?.onEventTapped;

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

            // TODO: Check if the event continues before
            final topResizeDetector = ResizeDetectorWidget(
              onPanStart: _onPanStart,
              onPanUpdate: (_) => _onPanUpdate(_, ResizeDirection.top),
              onPanEnd: (_) => _onPanEnd(_, ResizeDirection.top),
              child: direction != ResizeDirection.none
                  ? null
                  : tileComponents.verticalResizeHandle ?? const SizedBox(),
            );

            // TODO: Check if the event continues after
            final bottomResizeDetector = ResizeDetectorWidget(
              onPanStart: _onPanStart,
              onPanUpdate: (_) => _onPanUpdate(_, ResizeDirection.bottom),
              onPanEnd: (_) => _onPanEnd(_, ResizeDirection.bottom),
              child: direction != ResizeDirection.none
                  ? null
                  : tileComponents.verticalResizeHandle ?? const SizedBox(),
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

            final isDragging =
                provider.viewController.draggingEventId == event.id;
            late final draggableTile = Draggable<CalendarEvent<T>>(
              data: widget.event,
              feedback: feedback,
              childWhenDragging: dragComponent,
              dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
              child: isDragging && dragComponent != null
                  ? dragComponent
                  : tileComponent,
            );

            final tileWidget = GestureDetector(
              onTap: onTap != null
                  ? () {
                      // Find the global position and size of the tile.
                      final renderObject =
                          context.findRenderObject()! as RenderBox;
                      onTap.call(widget.event, renderObject);
                    }
                  : null,
              child: bodyConfiguration.allowRescheduling
                  ? draggableTile
                  : tileComponent,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: direction != ResizeDirection.none
                      ? dragComponent ?? const SizedBox()
                      : tileWidget,
                ),
                if (bodyConfiguration.allowResizing && showTopResizeHandle)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: resizeHeight,
                    child: topResizeDetector,
                  ),
                if (bodyConfiguration.allowResizing)
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

  /// Updates the snap points when the user starts dragging the event.
  void _onPanStart(Offset delta) {
    if (!bodyConfiguration.snapToOtherEvents) return;
    clearSnapPoints();
    addEventSnapPoints(provider.viewController.visibleEvents.value);
  }

  void _onPanUpdate(Offset delta, ResizeDirection direction) {
    resizingDirection.value = direction;
    final updatedEvent = _updateEvent(delta, direction);
    if (updatedEvent == null) return;
    eventBeingDragged.value = updatedEvent;
  }

  void _onPanEnd(Offset delta, ResizeDirection direction) {
    final updatedEvent = _updateEvent(delta, direction);
    if (updatedEvent == null) return;
    eventsController.updateEvent(
      event: widget.event,
      updatedEvent: updatedEvent,
    );
    eventBeingDragged.value = null;
    resizingDirection.value = ResizeDirection.none;
  }

  /// Updates the [CalendarEvent] based on the [Offset] delta and [ResizeDirection].
  CalendarEvent<T>? _updateEvent(
    Offset delta,
    ResizeDirection direction,
  ) {
    late final now = DateTime.now();
    if (bodyConfiguration.snapToTimeIndicator) addSnapPoint(now);

    final dateTimeRange = switch (direction) {
      ResizeDirection.top => _calculateDateTimeRangeTop(delta),
      ResizeDirection.bottom => _calculateDateTimeRangeBottom(delta),
      ResizeDirection.none => null,
    };

    if (bodyConfiguration.snapToTimeIndicator) removeSnapPoint(now);

    if (dateTimeRange == null) return null;

    return eventBeingDragged.value = event.copyWith(
      dateTimeRange: dateTimeRange,
    );
  }

  /// Calculates the [DateTimeRange] when resizing from the top.
  DateTimeRange _calculateDateTimeRangeTop(Offset delta) {
    // Calculate the delta duration from the offset.
    final deltaDuration = _calculateDeltaDuration(delta);
    var newStart = event.start.add(deltaDuration);

    // Find the snap point for the new start.
    final snapPoint = findSnapPoint(newStart, bodyConfiguration.snapRange);
    if (snapPoint != null) newStart = snapPoint;

    // Clamp the new start to the time of day range.
    if (!timeOfDayRange.isAllDay) newStart = _clampDateTime(newStart);

    // Determine the start and end based on the new start.
    final startIsAfterEnd = newStart.isAfter(event.end);
    var start = startIsAfterEnd ? event.end : newStart;
    final end = startIsAfterEnd ? newStart : event.end;
    final isSameMoment = start.isAtSameMomentAs(end);
    if (isSameMoment) start = start.subtract(const Duration(minutes: 1));

    return DateTimeRange(start: start, end: end);
  }

  /// Calculates the [DateTimeRange] when resizing from the bottom.
  DateTimeRange _calculateDateTimeRangeBottom(Offset delta) {
    // Calculate the delta duration from the offset.
    final deltaDuration = _calculateDeltaDuration(delta);
    var newEnd = event.end.add(deltaDuration);

    // Find the snap point for the new end.
    final snapPoint = findSnapPoint(newEnd, bodyConfiguration.snapRange);
    if (snapPoint != null) newEnd = snapPoint;

    // Clamp the new end to the time of day range.
    if (!timeOfDayRange.isAllDay) newEnd = _clampDateTime(newEnd);

    final endIsBeforeStart = newEnd.isBefore(event.start);
    final start = endIsBeforeStart ? newEnd : event.start;
    var end = endIsBeforeStart ? event.start : newEnd;
    final isSameMoment = start.isAtSameMomentAs(end);
    if (isSameMoment) end = end.add(const Duration(minutes: 1));

    return DateTimeRange(start: start, end: end);
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
    final snapIntervalMinutes = provider.bodyConfiguration.snapIntervalMinutes;
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
