import 'package:flutter/material.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class MultiDayOverlayEventTile extends EventTile {
  const MultiDayOverlayEventTile({
    super.key,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.interaction,
    required super.dateTimeRange,
    required super.dismissOverlay,
  });

  @override
  EventTileState createState() => EventTileState();

  /// A key used to identify the tile.
  static Key tileKey(int eventId) => Key('MultiDayOverlayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('MultiDayOverlayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(int eventId) => Key('MultiDayOverlayEventTile-GestureDetector-$eventId');

  @override
  EventTileOnTapUp? get onTapUp => (details, context) {
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
  Key get rescheduleKey => MultiDayOverlayEventTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => MultiDayOverlayEventTile.gestureDetectorKey(event.id);
}
