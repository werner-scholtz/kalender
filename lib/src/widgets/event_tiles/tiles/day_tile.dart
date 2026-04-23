import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

class DayEventTile extends EventTile {
  const DayEventTile({
    super.key,
    required super.event,
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
        // Find the global position and size of the tile.
        final renderObject = context.findRenderObject()! as RenderBox;
        final exactTime = _calculateExactTime(details.localPosition, context);
        context.callbacks?.onEventTapped?.call(event, renderObject);
        context.callbacks?.onEventTappedWithDetail?.call(
          event,
          renderObject,
          DayDetail(
            date: exactTime,
            renderBox: renderObject,
            localOffset: details.localPosition,
          ),
        );
      };

  @override
  EventTileOnTapUp? get onSecondaryTapUp => (details, context) {
        // Find the global position and size of the tile.
        final renderObject = context.findRenderObject()! as RenderBox;
        final exactTime = _calculateExactTime(details.localPosition, context);
        context.callbacks?.onEventSecondaryTapped?.call(event, renderObject);
        context.callbacks?.onEventSecondaryTappedWithDetail?.call(
          event,
          renderObject,
          DayDetail(
            date: exactTime,
            renderBox: renderObject,
            localOffset: details.localPosition,
          ),
        );
      };

  DateTime _calculateExactTime(Offset localPosition, BuildContext context) {
    var date = dateTimeRange.start;
    try {
      final heightPerMinute = context.heightPerMinute;
      if (heightPerMinute > 0) {
        final minutes = (localPosition.dy / heightPerMinute).round();
        date = date.add(Duration(minutes: minutes));
      }
    } catch (_) {
      // Fallback if HeightPerMinute provider is not present
    }
    return date.forLocation(location: context.location);
  }

  @override
  Key get rescheduleKey => DayEventTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => DayEventTile.gestureDetectorKey(event.id);
}
