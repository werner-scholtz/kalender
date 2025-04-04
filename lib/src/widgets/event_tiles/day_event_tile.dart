import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class DayEventTile<T extends Object?> extends EventTile<T> {
  /// A key used to identify the tile.
  static ValueKey<String> getKey(int eventId) => ValueKey('DayEventTile-$eventId');

  /// A key used to identify the top resize handle.
  static const topResizeDraggable = ValueKey('TopResizeDraggable');

  /// A key used to identify the bottom resize handle.
  static const bottomResizeDraggable = ValueKey('BottomResizeDraggable');

  /// A key used to identify the reschedule draggable.
  static const rescheduleDraggable = ValueKey('RescheduleDraggable');

  const DayEventTile({
    required super.key,
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
        late final topResizeDetector = ValueListenableBuilder(
          valueListenable: selectedEvent,
          builder: (context, value, child) {
            if (!isMobileDevice) {
              if (controller.internalFocus) return const SizedBox();
            } else {
              if (value != event) return const SizedBox();
            }

            return Draggable<Resize<T>>(
              key: topResizeDraggable,
              data: resizeEvent(ResizeDirection.top),
              feedback: const SizedBox(),
              dragAnchorStrategy: pointerDragAnchorStrategy,
              onDragStarted: selectEvent,
              child: verticalResizeHandle ?? Container(color: Colors.transparent),
            );
          },
        );

        late final bottomResizeDetector = ValueListenableBuilder(
          valueListenable: selectedEvent,
          builder: (context, value, child) {
            if (!isMobileDevice) {
              if (controller.internalFocus) return const SizedBox();
            } else {
              if (value != event) return const SizedBox();
            }

            return Draggable<Resize<T>>(
              key: bottomResizeDraggable,
              data: resizeEvent(ResizeDirection.bottom),
              feedback: const SizedBox(),
              dragAnchorStrategy: pointerDragAnchorStrategy,
              onDragStarted: selectEvent,
              child: verticalResizeHandle ?? Container(color: Colors.transparent),
            );
          },
        );

        late final feedback = ValueListenableBuilder(
          valueListenable: feedbackWidgetSize,
          builder: (context, value, child) {
            final feedbackTile = feedbackTileBuilder?.call(event, value);
            return feedbackTile ?? const SizedBox();
          },
        );

        final tile = tileBuilder.call(event, localDateTimeRange);
        final tileWhenDragging = tileWhenDraggingBuilder?.call(event);
        final isDragging = controller.selectedEventId == event.id && controller.internalFocus;
        late final draggable = isMobileDevice
            ? LongPressDraggable<Reschedule<T>>(
                key: rescheduleDraggable,
                data: rescheduleEvent,
                feedback: feedback,
                childWhenDragging: tileWhenDragging,
                dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
                onDragStarted: selectEvent,
                maxSimultaneousDrags: 1,
                child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
              )
            : Draggable<Reschedule<T>>(
                key: rescheduleDraggable,
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
                  onEventTappedWithDetail?.call(event, renderObject, DayDetail(dateTimeRange.start));
                }
              : null,
          child: canReschedule ? draggable : tile,
        );

        final resizeHandles = tileComponents.verticalHandlePositioner?.call(
              topResizeDetector,
              bottomResizeDetector,
              showStart,
              showEnd,
            ) ??
            VerticalTileResizeHandlePositioner(
              startResizeDetector: topResizeDetector,
              endResizeDetector: bottomResizeDetector,
              showStart: showStart,
              showEnd: showEnd,
            );

        return Stack(
          fit: StackFit.expand,
          children: [
            tileWidget,
            if (interaction.allowResizing) Positioned.fill(child: resizeHandles),
          ],
        );
      },
    );
  }
}
