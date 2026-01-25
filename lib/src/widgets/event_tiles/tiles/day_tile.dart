import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class DayEventTile extends EventTile {
  const DayEventTile({
    super.key,
    required super.eventId,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.resizeAxis,
  });

  /// A key used to identify the [DayEventTile].
  static Key tileKey(String eventId) => Key('DayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(String eventId) => Key('DayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(String eventId) => Key('DayEventTile-GestureDetector-$eventId');

  @override
  EventTileOnTapUp? get onTapUp => (details, context) {
        // TODO(werner): Maybe add some kind of error handling here ?
        final event = context.eventsController().byId(eventId);
        if (event == null) return;

        // Find the global position and size of the tile.
        final renderObject = context.findRenderObject()! as RenderBox;
        context.callbacks()?.onEventTapped?.call(event, renderObject);
        context.callbacks()?.onEventTappedWithDetail?.call(
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
  Key get rescheduleKey => DayEventTile.rescheduleDraggableKey(eventId);

  @override
  Key get gestureKey => DayEventTile.gestureDetectorKey(eventId);
}
