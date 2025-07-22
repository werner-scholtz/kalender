import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class MultiDayOverlayEventTile<T extends Object?> extends EventTile<T> {
  /// The function that is called when the overlay needs to be dismissed.
  final VoidCallback dismissOverlay;

  const MultiDayOverlayEventTile({
    super.key,
    required super.controller,
    required super.eventsController,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.interaction,
    required this.dismissOverlay,
  });

  @override
  Widget build(BuildContext context) {
    /// TODO: Check that removing interaction listener does not break anything.
    late final feedback = ValueListenableBuilder(
      valueListenable: feedbackWidgetSize,
      builder: (context, value, child) {
        final feedbackTile = feedbackTileBuilder?.call(event, value);
        return feedbackTile ?? const SizedBox();
      },
    );

    final tile = overlayTileBuilder.call(event, localDateTimeRange);
    final isDragging = controller.selectedEventId == event.id;
    late final draggableTile = isMobileDevice
        ? LongPressDraggable<Reschedule<T>>(
            data: rescheduleEvent,
            feedback: feedback,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: () {
              selectEvent();
              dismissOverlay();
            },
            maxSimultaneousDrags: 1,
            child: isDragging ? const SizedBox.shrink() : tile,
          )
        : Draggable<Reschedule<T>>(
            data: rescheduleEvent,
            feedback: feedback,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: () {
              selectEvent();
              dismissOverlay();
            },
            child: isDragging ? const SizedBox.shrink() : tile,
          );

    return GestureDetector(
      onTap: onEventTapped != null
          ? () {
              // Find the global position and size of the tile.
              final renderObject = context.findRenderObject()! as RenderBox;
              onEventTapped!.call(event, renderObject);
              onEventTappedWithDetail?.call(event, renderObject, MultiDayDetail(dateTimeRange));
            }
          : null,
      child: canReschedule ? draggableTile : tile,
    );
  }
}
