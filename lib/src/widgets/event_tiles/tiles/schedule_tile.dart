import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class ScheduleEventTile extends EventTile {
  const ScheduleEventTile({
    super.key,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.interaction,
    required super.dateTimeRange,
  });

  @override
  EventTileState createState() => EventTileState();

  /// A key used to identify the tile.
  static Key tileKey(int eventId) => Key('ScheduleEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('ScheduleEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(int eventId) => Key('ScheduleEventTile-GestureDetector-$eventId');

  @override
  EventTileOnTapUp? get onTapUp => (details, context) {
        // Find the global position and size of the tile.
        final renderObject = context.findRenderObject()! as RenderBox;
        callbacks?.onEventTapped?.call(event, renderObject);
        callbacks?.onEventTappedWithDetail?.call(
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
  Key get rescheduleKey => ScheduleEventTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => ScheduleEventTile.gestureDetectorKey(event.id);
}
