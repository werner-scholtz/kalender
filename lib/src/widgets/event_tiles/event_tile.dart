// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/event_tiles/resize_handle.dart';
import 'package:kalender/src/widgets/event_tiles/tile.dart';
import 'package:kalender/src/widgets/event_tiles/tile_draggable.dart';
import 'package:kalender/src/widgets/event_tiles/tile_gesture_detector.dart';
import 'package:kalender/src/widgets/event_tiles/tile_interaction.dart';

import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// The function that is called when the event is tapped.
typedef EventTileOnTapUp = void Function(TapUpDetails details, BuildContext context);

/// Base class for event tiles in every view.
///
/// Builds the tile from [TileComponents] with tap, drag and resize handling. Subclasses are [DayEventTile],
/// [MultiDayEventTile] and [ScheduleEventTile].
abstract class EventTile extends StatelessWidget {
  final KalenderEvent event;

  /// The components used to build the tile.
  final TileComponents tileComponents;

  /// The range the event spans.
  final FloatingDateTimeRange floatingRange;

  /// The function that is called when the overlay needs to be dismissed.
  ///
  /// Currently used to dismiss the overlay when the tile is rendered with the [MultiDayEventOverlayTile]
  final VoidCallback? dismissOverlay;

  /// The axis along which the event can be resized.
  ///
  /// - [Axis.vertical] for day/multi-day views.
  /// - [Axis.horizontal] for multi-day headers.
  /// - null for views that do not support resizing.
  final Axis? resizeAxis;

  const EventTile({
    super.key,
    required this.event,
    required this.tileComponents,
    required this.floatingRange,
    this.resizeAxis,
    this.dismissOverlay,
  });

  /// The function that is called when the event is tapped.
  EventTileOnTapUp? get onTapUp;

  /// The function that is called when the event is secondary tapped.
  EventTileOnTapUp? get onSecondaryTapUp;

  /// The key of the reschedule draggable, unique per tile type.
  Key get rescheduleKey;

  /// The key of the gesture detector, unique per tile type.
  Key get gestureKey;

  /// The builder used to render the tile content.
  ///
  /// Subclasses override this to select a different builder from [tileComponents].
  TileBuilder get effectiveTileBuilder => tileComponents.tileBuilder;

  @override
  Widget build(BuildContext context) {
    final draggable = TileDraggable(
      event: event,
      feedbackTileBuilder: tileComponents.feedbackTileBuilder,
      tileWhenDraggingBuilder: tileComponents.tileWhenDraggingBuilder,
      dragAnchorStrategy: tileComponents.dragAnchorStrategy,
      rescheduleDraggableKey: rescheduleKey,
      dismissOverlay: dismissOverlay,
      child: Tile(
        initialEvent: event,
        tileBuilder: effectiveTileBuilder,
        tileWhenDraggingBuilder: tileComponents.tileWhenDraggingBuilder,
        floatingRange: floatingRange,
      ),
    );

    // Skip the resize handle's mouse region, listener and size read when resizing is off.
    final interaction = context.interaction;
    final showResizeHandles = resizeAxis != null && interaction.allowResizing;

    final tile = TileGestureDetector(
      gestureDetectorKey: gestureKey,
      onTapUp: onTapUp,
      onSecondaryTapUp: onSecondaryTapUp,
      child: !showResizeHandles
          ? draggable
          : Stack(
              children: [
                Positioned.fill(child: draggable),
                Positioned.fill(
                  child: ResizeHandleWidget(event: event, floatingRange: floatingRange, axis: resizeAxis!),
                ),
              ],
            ),
    );

    final location = context.location;
    final canResize =
        showResizeHandles &&
        (event.canResizeStart(interaction, floatingRange, location: location) ||
            event.canResizeEnd(interaction, floatingRange, location: location));
    if (event.canReschedule(interaction) || canResize) return tile;
    return TranslucentPointer(child: tile);
  }
}
