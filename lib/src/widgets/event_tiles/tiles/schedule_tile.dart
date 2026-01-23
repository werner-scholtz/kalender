import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class ScheduleEventTile extends EventTile {
  const ScheduleEventTile({
    super.key,
    required super.eventId,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.resizeAxis,
  });

  /// A key used to identify the tile.
  static Key tileKey(int eventId) => Key('ScheduleEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('ScheduleEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(int eventId) => Key('ScheduleEventTile-GestureDetector-$eventId');

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
              MultiDayDetail(
                dateTimeRange: dateTimeRange,
                renderBox: renderObject,
                localOffset: details.localPosition,
              ),
            );
      };

  @override
  Key get rescheduleKey => ScheduleEventTile.rescheduleDraggableKey(eventId);

  @override
  Key get gestureKey => ScheduleEventTile.gestureDetectorKey(eventId);
}
