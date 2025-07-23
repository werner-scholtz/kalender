import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class DayEventTile<T extends Object?> extends EventTile<T> {
  const DayEventTile({
    super.key,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.interaction,
  });

  /// A key used to identify the tile.
  static Key tileKey(int eventId) => Key('DayEventTile-$eventId');

  /// A key used to identify the top resize handle.
  static Key topResizeDraggableKey(int eventId) => Key('DayEventTile-StartResizeDraggable-$eventId');

  /// A key used to identify the bottom resize handle.
  static Key bottomResizeDraggableKey(int eventId) => Key('DayEventTile-BottomResizeDraggable-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('DayEventTile-RescheduleDraggable-$eventId');

  @override
  Widget build(BuildContext context) {
    late final topResizeDetector = EventResize<T>(
      key: DayEventTile.topResizeDraggableKey(event.id),
      event: event,
      tileComponents: tileComponents,
      direction: ResizeDirection.top,
    );
    late final bottomResizeDetector = EventResize<T>(
      key: DayEventTile.bottomResizeDraggableKey(event.id),
      event: event,
      tileComponents: tileComponents,
      direction: ResizeDirection.bottom,
    );
    final tile = tileBuilder.call(event, localDateTimeRange);
    late final reschedule = EventReschedule<T>(
      key: DayEventTile.rescheduleDraggableKey(event.id),
      event: event,
      tileComponents: tileComponents,
      tile: tile,
    );

    late final resizeHandles = tileComponents.verticalHandlePositioner?.call(
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
        GestureDetector(
          onTap: onEventTapped != null
              ? () {
                  // Find the global position and size of the tile.
                  final renderObject = context.findRenderObject()! as RenderBox;
                  onEventTapped!.call(event, renderObject);
                  onEventTappedWithDetail?.call(event, renderObject, DayDetail(dateTimeRange.start));
                }
              : null,
          child: canReschedule ? reschedule : tile,
        ),
        if (interaction.allowResizing) Positioned.fill(child: resizeHandles),
      ],
    );
  }
}