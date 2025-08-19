import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class MultiDayOverlayEventTile<T extends Object?> extends EventTile<T> {
  /// The function that is called when the overlay needs to be dismissed.
  final VoidCallback dismissOverlay;

  const MultiDayOverlayEventTile({
    super.key,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.interaction,
    required this.dismissOverlay,
  });

  @override
  Widget build(BuildContext context) {
    final tile = overlayTileBuilder.call(event, localDateTimeRange);
    late final reschedule = EventReschedule<T>(
      event: event,
      tile: tile,
      tileComponents: tileComponents,
      dismissOverlay: dismissOverlay,
    );
    final child = canReschedule ? reschedule : tile;

    if (hasOnEventTapped) {
      return GestureDetector(
        onTap: () {
          // Find the global position and size of the tile.
          final renderObject = context.findRenderObject()! as RenderBox;
          onEventTapped!.call(event, renderObject);
          onEventTappedWithDetail?.call(event, renderObject, MultiDayDetail(dateTimeRange));
        },
        child: child,
      );
    } else {
      return child;
    }
  }
}
