import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/resize_handle.dart';
import 'package:kalender/src/widgets/event_tiles/tile.dart';
import 'package:kalender/src/widgets/event_tiles/tile_draggable.dart';
import 'package:kalender/src/widgets/event_tiles/tile_gesture_detector.dart';

import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_overlay_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';

/// The function that is called when the event is tapped.
typedef EventTileOnTapUp = void Function(TapUpDetails details, BuildContext context);

/// Base class for all event tiles in the Kalender package.
///
/// [EventTile] is the foundational widget for displaying calendar events across all view types
/// (day, multi-day, month, and schedule views). It provides a unified interface for:
/// - Rendering tile state widgets from [TileComponents].
/// - Handling user interactions
///   - [TileGestureDetector] for tap detection
///   - [TileDraggable] for drag-and-drop rescheduling
///   - [ResizeHandleWidget] for resizing events
///
/// The [EventTile] follows a composition pattern where different tile types extend this base class:
/// - [DayEventTile] - For day and multi-day views with vertical resizing.
/// - [MultiDayEventTile] - For multi-day headers with horizontal resizing.
/// - [ScheduleEventTile] - For schedule views (drag-only, no resize).
abstract class EventTile<T extends Object?> extends StatefulWidget {
  /// The event to be displayed in the tile.
  final CalendarEvent<T> event;

  /// The callbacks for the calendar.
  final CalendarCallbacks<T>? callbacks;

  /// The components used to build the tile.
  final TileComponents<T> tileComponents;

  /// The interaction state of the tile.
  final CalendarInteraction interaction;

  /// The date time range for the tile.
  final DateTimeRange dateTimeRange;

  /// The function that is called when the overlay needs to be dismissed.
  ///
  /// Currently used to dismiss the overlay when the tile is rendered with the [MultiDayOverlayEventTile]
  final VoidCallback? dismissOverlay;

  /// The axis along which the event can be resized.
  ///
  /// - [Axis.vertical] for day/multi-day views.
  /// - [Axis.horizontal] for multi-day headers.
  /// - null for views that do not support resizing.
  final Axis? resizeAxis;

  const EventTile({
    super.key,
    required this.callbacks,
    required this.tileComponents,
    required this.event,
    required this.interaction,
    required this.dateTimeRange,
    this.resizeAxis,
    this.dismissOverlay,
  });

  @override
  State<EventTile<T>> createState() => EventTileState<T>();

  /// The function that is called when the event is tapped.
  ///
  /// Concrete implementations should override this to provide view-specific
  /// tap handling, such as calling [CalendarCallbacks.onEventTapped] with
  /// appropriate detail objects.
  EventTileOnTapUp? get onTapUp;

  /// A key used to identify the reschedule draggable.
  ///
  /// Each tile type provides a unique key pattern for testing and debugging.
  Key get rescheduleKey;

  /// A key used to identify the gesture detector.
  ///
  /// Each tile type provides a unique key pattern for testing and debugging.
  Key get gestureKey;
}

class EventTileState<T extends Object?> extends State<EventTile<T>> {
  /// Whether gesture detection is enabled based on the provided callbacks.
  bool get enableGestureDetection =>
      (widget.callbacks?.onEventTapped != null) || (widget.callbacks?.onEventTappedWithDetail != null);

  @override
  Widget build(BuildContext context) {
    final draggable = TileDraggable<T>(
      interaction: widget.interaction,
      event: widget.event,
      feedbackTileBuilder: widget.tileComponents.feedbackTileBuilder,
      tileWhenDraggingBuilder: widget.tileComponents.tileWhenDraggingBuilder,
      dragAnchorStrategy: widget.tileComponents.dragAnchorStrategy,
      rescheduleDraggableKey: widget.rescheduleKey,
      dismissOverlay: widget.dismissOverlay,
      child: Tile<T>(
        event: widget.event,
        tileBuilder: widget.tileComponents.tileBuilder,
        tileWhenDraggingBuilder: widget.tileComponents.tileWhenDraggingBuilder,
        dateTimeRange: widget.dateTimeRange,
      ),
    );

    return TileGestureDetector(
      gestureDetectorKey: widget.gestureKey,
      onTapUp: enableGestureDetection ? widget.onTapUp : null,
      child: (widget.resizeAxis == null)
          ? draggable
          : Stack(
              children: [
                Positioned.fill(child: draggable),
                Positioned.fill(
                  child: ResizeHandleWidget<T>(
                    event: widget.event,
                    interaction: widget.interaction,
                    tileComponents: widget.tileComponents,
                    dateTimeRange: widget.dateTimeRange,
                    axis: widget.resizeAxis!,
                  ),
                ),
              ],
            ),
    );
  }
}
