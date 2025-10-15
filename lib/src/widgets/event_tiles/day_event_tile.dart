import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class DayEventTile<T extends Object?> extends EventTile<T> {
  const DayEventTile({
    super.key,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.interaction,
  });

  /// A key used to identify the tile.
  static Key tileKey(int eventId) => Key('DayEventTile-$eventId');

  // /// A key used to identify the top resize handle.
  // static Key topResizeDraggableKey(int eventId) => Key('DayEventTile-StartResizeDraggable-$eventId');

  // /// A key used to identify the bottom resize handle.
  // static Key bottomResizeDraggableKey(int eventId) => Key('DayEventTile-BottomResizeDraggable-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(int eventId) => Key('DayEventTile-RescheduleDraggable-$eventId');

  @override
  Widget build(BuildContext context) {
    final tile = tileBuilder.call(event, localDateTimeRange);
    late final reschedule = EventReschedule<T>(
      key: DayEventTile.rescheduleDraggableKey(event.id),
      event: event,
      tileComponents: tileComponents,
      tile: tile,
    );
    final child = canReschedule ? reschedule : tile;

    final heighPerMinute = HeightPerMinute.of(context);
    final durationOnDate = event.dateTimeRangeAsUtc.dateTimeRangeOnDate(dateTimeRange.start)?.duration ?? Duration.zero;
    final length = CalendarEvent.calculateHeight(durationOnDate, heighPerMinute);
    final resizeHandles = tileComponents.resizeHandleBuilder?.call(
          event,
          interaction,
          tileComponents,
          dateTimeRange,
          Axis.vertical,
          length,
        ) ??
        DefaultResizeHandles<T>(
          event: event,
          axis: Axis.vertical,
          interaction: interaction,
          tileComponents: tileComponents,
          dateTimeRange: dateTimeRange,
          verticalLength: length,
        );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasOnEventTapped)
          GestureDetector(
            onTapUp: (details) {
              // Find the global position and size of the tile.
              final renderObject = context.findRenderObject()! as RenderBox;
              onEventTapped?.call(event, renderObject);
              onEventTappedWithDetail?.call(
                event,
                renderObject,
                DayDetail(date: dateTimeRange.start, renderBox: renderObject, localOffset: details.localPosition),
              );
            },
            child: child,
          )
        else
          child,
        Positioned.fill(child: resizeHandles),
      ],
    );
  }
}
