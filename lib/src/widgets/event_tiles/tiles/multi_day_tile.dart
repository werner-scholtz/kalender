import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class MultiDayEventTile extends EventTile {
  const MultiDayEventTile({
    super.key,
    required super.event,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.resizeAxis,
  });

  /// A key used to identify the tile.
  static Key tileKey(String eventId) => Key('MultiDayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(String eventId) => Key('MultiDayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(String eventId) => Key('MultiDayEventTile-GestureDetector-$eventId');

  @override
  void Function(TapUpDetails details, BuildContext context)? get onTapUp => (details, context) {
        // TODO(werner): Maybe add some kind of error handling here ?
        final event = context.eventsController().byId(eventId);
        if (event == null) return;

        // Find the global position and size of the tile.
        final renderObject = context.findRenderObject()! as RenderBox;
        context.callbacks()?.onEventTapped?.call(event, renderObject);
        context.callbacks()?.onEventTappedWithDetail?.call(
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
  Key get rescheduleKey => MultiDayEventTile.rescheduleDraggableKey(eventId);

  @override
  Key get gestureKey => MultiDayEventTile.gestureDetectorKey(eventId);
}
