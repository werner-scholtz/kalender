import 'package:flutter/widgets.dart';

import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_body.dart';

/// The components used by the [MultiDayBody] to render the event tiles.
///
/// See [Draggable] for more information on how the components are used.
/// - [tileBuilder]
/// - [tileWhenDraggingBuilder]
/// - [feedbackTileBuilder]
/// - [dragAnchorStrategy]
///
/// The [dropTargetTile] is an extra component used to display where the event will be dropped.
/// The [verticalResizeHandle] is an extra component used to display the resize handle.
class TileComponents<T extends Object?> {
  /// The default builder for stationary event tiles.
  final TileBuilder<T> tileBuilder;

  /// The builder for the standard event tile. (When dragging)
  final TileWhenDraggingBuilder<T>? tileWhenDraggingBuilder;

  /// The builder for the feedback tile. (When dragging)
  final FeedbackTileBuilder<T>? feedbackTileBuilder;

  /// The dragAnchorStrategy used by the [feedbackTileBuilder].
  final DragAnchorStrategy? dragAnchorStrategy;

  /// The builder for the drop target event tile.
  final TileDropTargetBuilder<T>? dropTargetTile;

  /// The vertical resize handle.
  final Widget? verticalResizeHandle;

  /// The horizontal resize handle.
  final Widget? horizontalResizeHandle;

  const TileComponents({
    required this.tileBuilder,
    this.dropTargetTile,
    this.tileWhenDraggingBuilder,
    this.feedbackTileBuilder,
    this.dragAnchorStrategy,
    this.verticalResizeHandle,
    this.horizontalResizeHandle,
  });
}
