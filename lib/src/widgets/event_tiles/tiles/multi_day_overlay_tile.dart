import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class MultiDayEventOverlayTile extends EventTile {
  const MultiDayEventOverlayTile({
    super.key,
    required super.event,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.resizeAxis,
    required super.dismissOverlay,
  });

  /// A key used to identify the tile.
  static Key tileKey(String eventId) => Key('MultiDayOverlayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(String eventId) => Key('MultiDayOverlayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(String eventId) => Key('MultiDayOverlayEventTile-GestureDetector-$eventId');

  @override
  EventTileOnTapUp? get onTapUp => (details, context) {
        // Find the global position and size of the tile.
        final renderObject = context.findRenderObject()! as RenderBox;
        context.callbacks()?.onEventTapped?.call(event, renderObject);
        context.callbacks()?.onEventTappedWithDetail?.call(
              event,
              renderObject,
              MultiDayDetail(
                dateTimeRange: dateTimeRange,
                renderBox: renderObject,
                localOffset: details.localPosition,
              ),
            );
      };

  @override
  Key get rescheduleKey => MultiDayEventOverlayTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => MultiDayEventOverlayTile.gestureDetectorKey(event.id);
}
