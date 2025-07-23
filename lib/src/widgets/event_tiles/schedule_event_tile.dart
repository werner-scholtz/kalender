import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class ScheduleEventTile<T extends Object?> extends EventTile<T> {
  const ScheduleEventTile({
    super.key,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.interaction,
  });

  /// A key used to identify the tile.
  static Key tileKey(int eventId) => Key('ScheduleEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('ScheduleEventTile-RescheduleDraggable-$eventId');

  @override
  Widget build(BuildContext context) {
    final tile = tileBuilder.call(event, localDateTimeRange);
    late final reschedule = EventReschedule<T>(
      event: event,
      tile: tile,
      tileComponents: tileComponents,
    );

    return GestureDetector(
      onTap: onEventTapped != null
          ? () {
              // Find the global position and size of the tile.
              final renderObject = context.findRenderObject()! as RenderBox;
              onEventTapped!.call(event, renderObject);
              onEventTappedWithDetail?.call(event, renderObject, MultiDayDetail(dateTimeRange));
            }
          : null,
      child: canReschedule ? reschedule : tile,
    );
  }
}
