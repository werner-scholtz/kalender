import 'package:flutter/widgets.dart';

import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_body.dart';

/// The components used by the [MultiDayBody] to render the event tiles.
///
/// See [Draggable] for more information on how the components are used.
/// - [tileBuilder]
/// - [tileWhenDraggingBuilder]
/// - [feedbackTileBuilder]
/// - [dragAnchorStrategy]
///
/// The [dropTargetTile] is an extra component used to display where the event will be dropped.
/// The [resizeHandle] is an extra component used to display the resize handle.
class DayTileComponents<T extends Object?> {
  final TileBuilder<T> tileBuilder;
  final TileWhenDraggingBuilder<T>? tileWhenDraggingBuilder;
  final FeedbackTileBuilder<T>? feedbackTileBuilder;
  final DragAnchorStrategy? dragAnchorStrategy;
  final TileDropTargetBuilder<T> dropTargetTile;
  final Widget? resizeHandle;

  const DayTileComponents({
    required this.tileBuilder,
    required this.dropTargetTile,
    this.tileWhenDraggingBuilder,
    this.feedbackTileBuilder,
    this.dragAnchorStrategy,
    this.resizeHandle,
  });
}
