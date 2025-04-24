import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class ScheduleEventTile<T extends Object?> extends EventTile<T> {
  const ScheduleEventTile({
    super.key,
    required super.controller,
    required super.eventsController,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.interaction,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: interaction,
      builder: (context, interaction, child) {
        late final feedback = ValueListenableBuilder(
          valueListenable: feedbackWidgetSize,
          builder: (context, value, child) {
            final feedbackTile = feedbackTileBuilder?.call(event, value);
            return feedbackTile ?? const SizedBox();
          },
        );

        final tile = tileBuilder.call(event, localDateTimeRange);
        final tileWhenDragging = tileWhenDraggingBuilder?.call(event);
        final isDragging = controller.selectedEventId == event.id;
        late final draggableTile = isMobileDevice
            ? LongPressDraggable<Reschedule<T>>(
                data: rescheduleEvent,
                feedback: feedback,
                childWhenDragging: tileWhenDragging,
                dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
                onDragStarted: selectEvent,
                maxSimultaneousDrags: 1,
                child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
              )
            : Draggable<Reschedule<T>>(
                data: rescheduleEvent,
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
                  onEventTappedWithDetail?.call(event, renderObject, MultiDayDetail(dateTimeRange));
                }
              : null,
          child: canReschedule ? draggableTile : tile,
        );

        return tileWidget;
      },
    );
  }
}
