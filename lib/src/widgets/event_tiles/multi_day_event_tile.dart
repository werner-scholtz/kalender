import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/resize_event.dart';
import 'package:kalender/src/platform.dart';

class MultiDayEventTile<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;

  final CalendarEvent<T> event;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;

  /// Whether the event can be resized.
  final bool allowResizing;

  /// Creates a new [MultiDayEventTile].
  const MultiDayEventTile({
    super.key,
    required this.eventsController,
    required this.controller,
    required this.event,
    required this.tileComponents,
    required this.allowResizing,
    required this.callbacks,
  });

  @override
  State<MultiDayEventTile<T>> createState() => _MultiDayEventTileState<T>();
}

class _MultiDayEventTileState<T extends Object?> extends State<MultiDayEventTile<T>> {
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get controller => widget.controller;
  ViewController<T> get viewController => controller.viewController!;
  CalendarEvent<T> get event => widget.event;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  TileComponents<T> get tileComponents => widget.tileComponents;
  bool get allowResizing => widget.allowResizing;

  EventModification<T> get modify => controller.eventModification;
  ValueNotifier<CalendarEvent<T>?> get eventBeingModified => modify.eventBeingModified;

  ValueNotifier<Size> get feedbackWidgetSize {
    return eventsController.feedbackWidgetSize;
  }

  @override
  Widget build(BuildContext context) {
    final onTap = callbacks?.onEventTapped;
    late final tileComponent = tileComponents.tileBuilder.call(widget.event);
    late final dragComponent = tileComponents.tileWhenDraggingBuilder?.call(widget.event);
    late final dragAnchorStrategy = tileComponents.dragAnchorStrategy;

    return LayoutBuilder(
      builder: (context, constraints) {
        late final resizeWidth = min(constraints.maxWidth * 0.25, 12.0);

        // TODO: Check if the event continues before, if it does do not show the resize handle.
        late final leftResizeEvent = ResizeEvent(event, ResizeDirection.left);
        late final leftResize = Draggable<ResizeEvent<T>>(
          data: leftResizeEvent,
          feedback: const SizedBox(),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          child: tileComponents.verticalResizeHandle ?? const SizedBox(),
          onDragStarted: () => modify.selectEvent(event),
        );

        // TODO: Check if the event continues after, if it does do not show the resize handle.
        late final rightResizeEvent = ResizeEvent(event, ResizeDirection.right);
        late final rightResize = Draggable<ResizeEvent<T>>(
          data: rightResizeEvent,
          feedback: const SizedBox(),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          child: tileComponents.verticalResizeHandle ?? const SizedBox(),
          onDragStarted: () => modify.selectEvent(event),
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

        final isDragging = modify.eventBeingDraggedId == event.id;
        late final draggableTile = Draggable<CalendarEvent<T>>(
          data: widget.event,
          feedback: feedback,
          childWhenDragging: dragComponent,
          dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
          child: isDragging && dragComponent != null ? dragComponent : tileComponent,
        );

        final tileWidget = GestureDetector(
          onTap: onTap != null
              ? () {
                  // Find the global position and size of the tile.
                  final renderObject = context.findRenderObject()! as RenderBox;
                  onTap.call(widget.event, renderObject);
                }
              : null,
          child: draggableTile,
        );

        return Stack(
          children: [
            tileWidget,
            if (allowResizing && event.canModify)
              if (!isMobileDevice)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  width: resizeWidth,
                  child: ValueListenableBuilder(
                    valueListenable: eventBeingModified,
                    builder: (context, value, child) {
                      if (value == null) return leftResize;
                      return const SizedBox();
                    },
                  ),
                ),
            if (allowResizing && event.canModify)
              if (!isMobileDevice)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  width: resizeWidth,
                  child: ValueListenableBuilder(
                    valueListenable: eventBeingModified,
                    builder: (context, value, child) {
                      if (value == null) return rightResize;
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
