import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/resize_event.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

// TODO: more detailed documentation.
// Simplify the boolean logic to an enum if possible.

class MultiDayEventTileV2<T extends Object?> extends EventTile<T> {
  const MultiDayEventTileV2({
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
        late final resizeWidth = min(constraints.maxWidth * 0.25, 24.0);

        late final leftResize = Draggable<ResizeEvent<T>>(
          data: resizeEvent(ResizeDirection.left),
          feedback: const SizedBox(),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          onDragStarted: selectEvent,
          child: verticalResizeHandle ?? const SizedBox(),
        );

        late final rightResize = Draggable<ResizeEvent<T>>(
          data: resizeEvent(ResizeDirection.right),
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
        final isDragging = controller.selectedEventId == event.id;
        late final draggableTile = isMobileDevice
            ? LongPressDraggable<CalendarEvent<T>>(
                data: event,
                feedback: feedback,
                childWhenDragging: tileWhenDragging,
                dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
                onDragStarted: () => controller.selectEvent(event, internal: true),
                child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
              )
            : Draggable<CalendarEvent<T>>(
                data: event,
                feedback: feedback,
                childWhenDragging: tileWhenDragging,
                dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
                onDragStarted: () => controller.selectEvent(event, internal: true),
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
          child: canReschedule ? draggableTile : tile,
        );

        return Stack(
          children: [
            Positioned.fill(child: tileWidget),
            if (showStart && !isMobileDevice)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: resizeWidth,
                child: ValueListenableBuilder(
                  valueListenable: selectedEvent,
                  builder: (context, value, child) {
                    if (value == null) return leftResize;
                    if (!controller.internalFocus) return leftResize;
                    return const SizedBox();
                  },
                ),
              ),
            if (showEnd && !isMobileDevice)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                width: resizeWidth,
                child: ValueListenableBuilder(
                  valueListenable: selectedEvent,
                  builder: (context, value, child) {
                    if (value == null) return rightResize;
                    if (!controller.internalFocus) return rightResize;
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