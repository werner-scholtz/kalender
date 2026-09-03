import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart'
    show
        CalendarEvent,
        MultiDayBody,
        MonthBody,
        ScheduleBody,
        ResizeHandleDetails,
        ResizeHandlePositioner,
        ScheduleComponents;
import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/widgets/components/default_tile_components.dart';
import 'package:kalender/src/widgets/components/resize_handles.dart' show DefaultResizeHandles;

/// The components used by the [MultiDayBody]/[MonthBody] to render the event tiles.
///
/// See [Draggable] for more information on how the components are used.
/// - [tileBuilder]
/// - [tileWhenDraggingBuilder]
/// - [feedbackTileBuilder]
/// - [dragAnchorStrategy]
///
/// The [dropTargetTile] is an extra component used to display where the event will be dropped.
/// The [verticalResizeHandle] is an extra component used to display the resize handle.
class TileComponents {
  /// The default builder for stationary event tiles.
  final TileBuilder tileBuilder;

  /// The builder used when events are displayed in a [Overlay].
  ///
  /// If this is not provided, the [tileBuilder] will be used instead.
  final TileBuilder? overlayTileBuilder;

  /// The builder for the stationary event tile. (When dragging)
  final TileWhenDraggingBuilder? tileWhenDraggingBuilder;

  /// The builder for the feedback tile. (When dragging)
  final FeedbackTileBuilder? feedbackTileBuilder;

  /// The builder for the drop target event tile.
  final TileDropTargetBuilder? dropTargetTile;

  /// The dragAnchorStrategy used by the [feedbackTileBuilder].
  final DragAnchorStrategy? dragAnchorStrategy;

  /// The dragAnchorStrategy used by the resize handles.
  ///
  /// Defaults to a pointer anchor for vertical resizing. Setting
  /// `childDragAnchorStrategy` makes a vertical resize flip to the neighboring
  /// day on the smallest sideways move.
  final DragAnchorStrategy? resizeDragAnchorStrategy;

  /// The widget that positions and sizes the resize handles.
  final ResizeHandlePositioner? resizeHandlePositioner;

  /// The vertical resize handle.
  final Widget? verticalResizeHandle;

  /// The horizontal resize handle.
  final Widget? horizontalResizeHandle;

  const TileComponents({
    required this.tileBuilder,
    this.dropTargetTile,
    this.tileWhenDraggingBuilder,
    this.feedbackTileBuilder,
    this.overlayTileBuilder,
    this.dragAnchorStrategy,
    this.resizeDragAnchorStrategy,
    this.resizeHandlePositioner,
    this.verticalResizeHandle,
    this.horizontalResizeHandle,
  });

  static TileComponents defaultComponents() {
    return const TileComponents(
      tileBuilder: defaultTileBuilder,
      tileWhenDraggingBuilder: defaultTileWhenDraggingBuilder,
      feedbackTileBuilder: defaultFeedbackTileBuilder,
      dropTargetTile: defaultDropTargetBuilder,
    );
  }

  /// Positions the resize handles, with [resizeHandlePositioner] when set.
  Widget buildResizeHandles(BuildContext context, ResizeHandleDetails details) {
    return resizeHandlePositioner?.call(context, details) ?? DefaultResizeHandles(details: details);
  }

  /// Compares the builders, so components built with the same ones are equal.
  ///
  /// A builder written as an inline closure is a new object on every build and
  /// never compares equal. Pass a top-level or static function to keep two
  /// instances equal, which is what stops the tiles rebuilding.
  ///
  /// [ScheduleTileComponents] restricts several of these to null, so the types
  /// are compared too rather than only the fields.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TileComponents &&
        other.runtimeType == runtimeType &&
        other.tileBuilder == tileBuilder &&
        other.overlayTileBuilder == overlayTileBuilder &&
        other.tileWhenDraggingBuilder == tileWhenDraggingBuilder &&
        other.feedbackTileBuilder == feedbackTileBuilder &&
        other.dropTargetTile == dropTargetTile &&
        other.dragAnchorStrategy == dragAnchorStrategy &&
        other.resizeDragAnchorStrategy == resizeDragAnchorStrategy &&
        other.resizeHandlePositioner == resizeHandlePositioner &&
        other.verticalResizeHandle == verticalResizeHandle &&
        other.horizontalResizeHandle == horizontalResizeHandle;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        tileBuilder,
        overlayTileBuilder,
        tileWhenDraggingBuilder,
        feedbackTileBuilder,
        dropTargetTile,
        dragAnchorStrategy,
        resizeDragAnchorStrategy,
        resizeHandlePositioner,
        verticalResizeHandle,
        horizontalResizeHandle,
      );
}

/// The components used by the [ScheduleBody] to render the event tiles.
class ScheduleTileComponents extends TileComponents {
  @override
  ResizeHandlePositioner? get resizeHandlePositioner => null;
  @override
  Widget? get verticalResizeHandle => null;
  @override
  Widget? get horizontalResizeHandle => null;
  @override
  DragAnchorStrategy? get resizeDragAnchorStrategy => null;

  /// The schedule view has no overflow overlay.
  @override
  TileBuilder? get overlayTileBuilder => null;

  /// The schedule view marks the drop target by highlighting the row, built by
  /// [ScheduleComponents.scheduleTileHighlightBuilder].
  @override
  TileDropTargetBuilder? get dropTargetTile => null;

  const ScheduleTileComponents({
    required super.tileBuilder,
    super.tileWhenDraggingBuilder,
    super.feedbackTileBuilder,
    super.dragAnchorStrategy,
  });

  static ScheduleTileComponents defaultComponents() {
    return const ScheduleTileComponents(
      tileBuilder: defaultTileBuilder,
    );
  }
}

/// The default builder for the event tiles.
///
/// [event] is the event that the tile will be built for.
///
/// [tileRange] is the wall-clock [KalenderDateTimeRange] of the view the tile will be displayed in.
/// The values are local [DateTime]s (or `TZDateTime`s when a timezone location is set).
typedef TileBuilder = Widget Function(
  BuildContext context,
  CalendarEvent event,
  KalenderDateTimeRange tileRange,
);

/// The builder for the event tile when dragging.
///
/// [event] is the event that the tile will be built for.
typedef TileWhenDraggingBuilder = Widget Function(
  BuildContext context,
  CalendarEvent event,
);

/// The builder for the feedback tile. (When dragging)
///
/// [event] is the event that the tile will be built for.
/// [dropTargetWidgetSize] is the size of the drop target widget.
typedef FeedbackTileBuilder = Widget Function(
  BuildContext context,
  CalendarEvent event,
  Size dropTargetWidgetSize,
);

/// The builder for the drop target event tile.
///
/// [event] is the event that the tile will be built for.
typedef TileDropTargetBuilder = Widget Function(
  BuildContext context,
  CalendarEvent event,
);
