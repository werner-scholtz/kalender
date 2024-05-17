import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/providers/day_provider.dart';
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

enum VerticalResize {
  top,
  bottom,
  none,
}

class _DayEventTileState<T extends Object?> extends State<DayEventTile<T>> {
  CalendarEvent<T> get event => widget.event;

  DayProvider<T> get provider => DayProvider.of<T>(context);
  EventsController<T> get eventsController => provider.eventsController;
  MultiDayViewConfiguration get viewConfiguration => provider.viewConfiguration;
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

  ValueNotifier<VerticalResize> resizingDirection =
      ValueNotifier(VerticalResize.none);

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
