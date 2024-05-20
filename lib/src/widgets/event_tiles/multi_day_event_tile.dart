import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/providers/multi_day_provider.dart';
import 'package:kalender/src/widgets/components/resize_detector.dart';

class MultiDayEventTile<T extends Object?> extends StatefulWidget {
  /// The [CalendarEvent] that the [MultiDayEventTile] represents.
  final CalendarEvent<T> event;

  const MultiDayEventTile({
    super.key,
    required this.event,
  });

  @override
  State<MultiDayEventTile<T>> createState() => _MultiDayEventTileState<T>();
}

enum ResizeDirection {
  left,
  right,
  none,
}

class _MultiDayEventTileState<T extends Object?>
    extends State<MultiDayEventTile<T>> {
  CalendarEvent<T> get event => widget.event;
  MultiDayProvider<T> get provider => MultiDayProvider.of<T>(context);
  MultiDayHeaderConfiguration get configuration => provider.headerConfiguration;
  EventsController<T> get eventsController => provider.eventsController;
  CalendarCallbacks<T>? get callbacks => provider.callbacks;
  TileComponents<T> get tileComponents => provider.tileComponents;
  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged =>
      provider.eventBeingDragged;
  ValueNotifier<Size> get feedbackWidgetSize => provider.feedbackWidgetSize;

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
    late final dragAnchorStrategy = tileComponents.dragAnchorStrategy;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder(
          valueListenable: resizingDirection,
          builder: (context, direction, child) {
            late final resizeWidth = min(constraints.maxWidth * 0.25, 12.0);

            final leftResize = ResizeDetectorWidget(
              onPanUpdate: (_) => _onPanUpdate(_, ResizeDirection.left),
              onPanEnd: (_) => _onPanEnd(_, ResizeDirection.left),
              child: direction != ResizeDirection.none
                  ? null
                  : tileComponents.horizontalResizeHandle ?? const SizedBox(),
            );

            final rightResize = ResizeDetectorWidget(
              onPanUpdate: (_) => _onPanUpdate(_, ResizeDirection.right),
              onPanEnd: (_) => _onPanEnd(_, ResizeDirection.right),
              child: direction != ResizeDirection.none
                  ? null
                  : tileComponents.horizontalResizeHandle ?? const SizedBox(),
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
              child: draggableTile,
            );

            return Stack(
              children: [
                tileWidget,
                if (configuration.allowResizing)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    width: resizeWidth,
                    child: leftResize,
                  ),
                if (configuration.allowResizing)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: resizeWidth,
                    child: rightResize,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  /// Called when the user is resizing the event.
  void _onPanUpdate(Offset delta, ResizeDirection direction) {
    resizingDirection.value = direction;
    final updatedEvent = _updateEvent(delta, direction);
    if (updatedEvent == null) return;
    eventBeingDragged.value = updatedEvent;
  }

  /// Called when the user has finished resizing the event.
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
    final dateTimeRange = switch (direction) {
      ResizeDirection.left => _calculateDateTimeRangeLeft(delta),
      ResizeDirection.right => _calculateDateTimeRangeRight(delta),
      ResizeDirection.none => null,
    };

    return eventBeingDragged.value = event.copyWith(
      dateTimeRange: dateTimeRange,
    );
  }

  /// Calculates the number of days the event should be resized by.
  int _calculateDeltaDays(Offset delta) {
    final dayOffset = delta.dx / provider.dayWidth;
    return dayOffset.isNegative ? dayOffset.ceil() : dayOffset.floor();
  }

  /// Calculates the [DateTimeRange] when resizing from the left.
  DateTimeRange? _calculateDateTimeRangeLeft(Offset delta) {
    final deltaDays = _calculateDeltaDays(delta);
    final start = event.start.addDays(deltaDays);

    if (start.isSameDay(event.end)) {
      return DateTimeRange(
        start: start.startOfDay,
        end: event.end.endOfDay,
      );
    } else if (start.isAfter(event.end)) {
      return DateTimeRange(
        start: event.end.startOfDay,
        end: start.endOfDay,
      );
    } else {
      return DateTimeRange(
        start: start,
        end: event.end,
      );
    }
  }

  /// Calculates the [DateTimeRange] when resizing from the right.
  DateTimeRange? _calculateDateTimeRangeRight(Offset offset) {
    final deltaDays = _calculateDeltaDays(offset);
    final end = event.end.addDays(deltaDays);

    if (end.isSameDay(event.start)) {
      return DateTimeRange(
        start: event.start.startOfDay,
        end: end.endOfDay,
      );
    } else if (end.isBefore(event.start)) {
      return DateTimeRange(
        start: end.startOfDay,
        end: event.start.startOfDay,
      );
    } else {
      return DateTimeRange(
        start: event.start,
        end: end,
      );
    }
  }
}
