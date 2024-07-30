import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/resize_event.dart';
import 'package:kalender/src/platform.dart';

import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

// TODO: more detailed documentation.
// Simplify the boolean logic to an enum if possible.

class DayEventTile<T extends Object?> extends EventTile<T> {
  const DayEventTile({
    super.key,
    required super.controller,
    required super.eventsController,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.allowRescheduling,
    required super.allowResizing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        late final showTop = constraints.maxHeight > kMinInteractiveDimension;
        late final resizeHeight = min(constraints.maxHeight * 0.25, 12.0);

        late final topResizeDetector = Draggable<ResizeEvent<T>>(
          data: resizeEvent(ResizeDirection.top),
          feedback: const SizedBox(),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          onDragStarted: selectEvent,
          child: verticalResizeHandle ?? const SizedBox(),
        );

        late final bottomResizeDetector = Draggable<ResizeEvent<T>>(
          data: resizeEvent(ResizeDirection.bottom),
          feedback: const SizedBox(),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          onDragStarted: selectEvent,
          child: verticalResizeHandle ?? const SizedBox(),
        );

        late final feedback = ValueListenableBuilder(
          valueListenable: feedbackWidgetSize,
          builder: (context, value, child) {
            final feedbackTile = feedbackTileBuilder?.call(event, value);
            return feedbackTile ?? const SizedBox();
          },
        );

        final tile = tileBuilder.call(event, dateTimeRange);
        final tileWhenDragging = tileWhenDraggingBuilder?.call(event);
        final isDragging = controller.selectedEventId == event.id && controller.internalFocus;
        late final draggable = isMobileDevice
            ? LongPressDraggable(
                data: event,
                feedback: feedback,
                childWhenDragging: tileWhenDragging,
                dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
                onDragStarted: selectEvent,
                maxSimultaneousDrags: 1,
                child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
              )
            : Draggable<CalendarEvent<T>>(
                data: event,
                feedback: feedback,
                childWhenDragging: tileWhenDragging,
                dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
                onDragStarted: selectEvent,
                child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
              );

        final tileWidget = GestureDetector(
          onTap: onEventTapped != null
              ? () {
                  // Find the global position and size of the tile.
                  final renderObject = context.findRenderObject()! as RenderBox;
                  onEventTapped!.call(event, renderObject);
                }
              : null,
          child: canReschedule ? draggable : tile,
        );

        return Stack(
          children: [
            Positioned.fill(child: tileWidget),
            // Desktop
            if (showTop && showStart)
              if (!isMobileDevice)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: resizeHeight,
                  child: ValueListenableBuilder(
                    valueListenable: selectedEvent,
                    builder: (context, value, child) {
                      if (value == null) return topResizeDetector;
                      if (!controller.internalFocus) return topResizeDetector;
                      return const SizedBox();
                    },
                  ),
                )
              else
                Positioned(
                  top: 0,
                  right: 0,
                  width: resizeHeight,
                  height: resizeHeight,
                  child: ValueListenableBuilder(
                    valueListenable: selectedEvent,
                    builder: (context, value, child) {
                      if (value == event) return topResizeDetector;
                      return const SizedBox();
                    },
                  ),
                ),
            if (showEnd)
              if (!isMobileDevice)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: resizeHeight,
                  child: ValueListenableBuilder(
                    valueListenable: selectedEvent,
                    builder: (context, value, child) {
                      if (value == null) return bottomResizeDetector;
                      if (!controller.internalFocus) return bottomResizeDetector;
                      return const SizedBox();
                    },
                  ),
                )
              else
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: resizeHeight,
                  height: resizeHeight,
                  child: ValueListenableBuilder(
                    valueListenable: selectedEvent,
                    builder: (context, value, child) {
                      if (value == event) return bottomResizeDetector;
                      return const SizedBox();
                    },
                  ),
                ),
          ],
        );
      },
    );
  }
}
