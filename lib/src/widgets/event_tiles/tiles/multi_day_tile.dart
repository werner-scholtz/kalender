import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class MultiDayEventTile<T extends Object?> extends EventTile<T> {
  const MultiDayEventTile({
    super.key,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.interaction,
    required super.dateTimeRange,
    required super.resizeAxis,
  });

  @override
  EventTileState<T> createState() => EventTileState<T>();

  /// A key used to identify the tile.
  static Key tileKey(int eventId) => Key('MultiDayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('MultiDayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(int eventId) => Key('MultiDayEventTile-GestureDetector-$eventId');

  @override
  void Function(TapUpDetails details, BuildContext context)? get onTapUp => (details, context) {
        // Find the global position and size of the tile.
        final renderObject = context.findRenderObject()! as RenderBox;
        callbacks?.onEventTapped?.call(event, renderObject);
        callbacks?.onEventTappedWithDetail?.call(
          event,
          renderObject,
          MultiDayDetail(
            dateTimeRange: dateTimeRange.asLocal,
            renderBox: renderObject,
            localOffset: details.localPosition,
          ),
        );
      };

  @override
  Key get rescheduleKey => MultiDayEventTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => MultiDayEventTile.gestureDetectorKey(event.id);
}
