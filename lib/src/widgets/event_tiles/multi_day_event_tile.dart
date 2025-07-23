import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class MultiDayEventTile<T extends Object?> extends EventTile<T> {
  const MultiDayEventTile({
    super.key,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.interaction,
  });

  /// A key used to identify the tile.
  static Key tileKey(int eventId) => Key('MultiDayEventTile-$eventId');

  /// A key used to identify the left resize handle.
  static Key leftResizeDraggableKey(int eventId) => Key('MultiDayEventTile-StartResizeDraggable-$eventId');

  /// A key used to identify the right resize handle.
  static Key rightResizeDraggableKey(int eventId) => Key('MultiDayEventTile-BottomResizeDraggable-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('MultiDayEventTile-RescheduleDraggable-$eventId');

  @override
  Widget build(BuildContext context) {
    late final leftResize = EventResize<T>(
      key: MultiDayEventTile.leftResizeDraggableKey(event.id),
      event: event,
      tileComponents: tileComponents,
      direction: ResizeDirection.left,
    );

    late final rightResize = EventResize<T>(
      key: MultiDayEventTile.rightResizeDraggableKey(event.id),
      event: event,
      tileComponents: tileComponents,
      direction: ResizeDirection.right,
    );

    final tile = tileBuilder.call(event, localDateTimeRange);
    late final reschedule = EventReschedule<T>(
      key: MultiDayEventTile.rescheduleDraggableKey(event.id),
      event: event,
      tileComponents: tileComponents,
      tile: tile,
    );

    final resizeHandles = tileComponents.horizontalHandlePositioner?.call(
          leftResize,
          rightResize,
          showStart,
          showEnd,
        ) ??
        HorizontalTileResizeHandlePositioner(
          key: Key('MultiDayEventTile-ResizeHandles-${event.id}'),
          startResizeDetector: leftResize,
          endResizeDetector: rightResize,
          showStart: showStart,
          showEnd: showEnd,
        );

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: onEventTapped != null
              ? () {
                  // Find the global position and size of the tile.
                  final renderObject = context.findRenderObject()! as RenderBox;
                  onEventTapped!.call(event, renderObject);
                  onEventTappedWithDetail?.call(event, renderObject, MultiDayDetail(dateTimeRange));
                }
              : null,
          child: canReschedule ? reschedule : tile,
        ),
        Positioned.fill(child: resizeHandles),
      ],
    );
  }
}
