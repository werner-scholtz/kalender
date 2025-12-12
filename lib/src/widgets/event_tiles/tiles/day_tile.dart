import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class DayEventTile<T extends Object?> extends EventTile<T> {
  const DayEventTile({
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

  /// A key used to identify the [DayEventTile].
  static Key tileKey(int eventId) => Key('DayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('DayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(int eventId) => Key('DayEventTile-GestureDetector-$eventId');

  @override
  EventTileOnTapUp? get onTapUp => (details, context) {
        // Find the global position and size of the tile.
        final renderObject = context.findRenderObject()! as RenderBox;
        callbacks?.onEventTapped?.call(event, renderObject);
        callbacks?.onEventTappedWithDetail?.call(
          event,
          renderObject,
          DayDetail(
            date: dateTimeRange.start.asLocal,
            renderBox: renderObject,
            localOffset: details.localPosition,
          ),
        );
      };

  @override
  Key get rescheduleKey => DayEventTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => DayEventTile.gestureDetectorKey(event.id);
}
