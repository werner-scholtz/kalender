import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart'
    show CalendarEvent, MultiDayBody, MonthBody, ScheduleBody, ResizeHandlePositioner;
import 'package:kalender/src/widgets/components/default_tile_components.dart';

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
class TileComponents<T extends Object?> {
  /// The default builder for stationary event tiles.
  final TileBuilder<T> tileBuilder;

  /// The builder used when events are displayed in a [Overlay].
  ///
  /// If this is not provided, the [tileBuilder] will be used instead.
  final TileBuilder<T>? overlayTileBuilder;

  /// The builder for the stationary event tile. (When dragging)
  final TileWhenDraggingBuilder<T>? tileWhenDraggingBuilder;

  /// The builder for the feedback tile. (When dragging)
  final FeedbackTileBuilder<T>? feedbackTileBuilder;

  /// The builder for the drop target event tile.
  final TileDropTargetBuilder<T>? dropTargetTile;

  /// The dragAnchorStrategy used by the [feedbackTileBuilder].
  final DragAnchorStrategy? dragAnchorStrategy;

  /// The widget that positions and sizes the resize handles.
  final ResizeHandlePositioner<T>? resizeHandlePositioner;

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
    this.resizeHandlePositioner,
    this.verticalResizeHandle,
    this.horizontalResizeHandle,
  });

  static TileComponents<T> defaultComponents<T extends Object?>() {
    return TileComponents<T>(
      tileBuilder: defaultTileBuilder,
      tileWhenDraggingBuilder: defaultTileWhenDraggingBuilder,
      feedbackTileBuilder: defaultFeedbackTileBuilder,
      dropTargetTile: defaultDropTargetBuilder,
    );
  }
}

/// The components used by the [ScheduleBody] to render the event tiles.
class ScheduleTileComponents<T extends Object?> extends TileComponents<T> {
  /// The builder for the empty day.
  final EmptyItemBuilder? emptyItemBuilder;

  /// The builder for the month tile.
  final MonthItemBuilder? monthItemBuilder;

  @override
  ResizeHandlePositioner<T>? get resizeHandlePositioner => null;
  @override
  Widget? get verticalResizeHandle => null;
  @override
  Widget? get horizontalResizeHandle => null;

  const ScheduleTileComponents({
    required super.tileBuilder,
    super.dropTargetTile,
    super.tileWhenDraggingBuilder,
    super.feedbackTileBuilder,
    super.overlayTileBuilder,
    super.dragAnchorStrategy,
    this.emptyItemBuilder,
    this.monthItemBuilder,
  });

  static ScheduleTileComponents<T> defaultComponents<T extends Object?>() {
    return ScheduleTileComponents<T>(
      tileBuilder: defaultTileBuilder,
    );
  }
}

/// The default builder for the event tiles.
///
/// [event] is the event that the tile will be built for.
///
/// [tileRange] is the [DateTimeRange] of the view the tile will be displayed in.
/// * (This can be compared to the [CalendarEvent.dateTimeRangeAsUtc] to determine on which day it falls.)
typedef TileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  DateTimeRange tileRange,
);

/// The builder for the event tile when dragging.
///
/// [event] is the event that the tile will be built for.
typedef TileWhenDraggingBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
);

/// The builder for the feedback tile. (When dragging)
///
/// [event] is the event that the tile will be built for.
/// [dropTargetWidgetSize] is the size of the drop target widget.
typedef FeedbackTileBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
  Size dropTargetWidgetSize,
);

/// The builder for the drop target event tile.
///
/// [event] is the event that the tile will be built for.
typedef TileDropTargetBuilder<T extends Object?> = Widget Function(
  CalendarEvent<T> event,
);

/// The builder for the empty item.
///
/// [tileRange] is the [DateTimeRange] of the ListTile where this widget will be displayed.
typedef EmptyItemBuilder = Widget Function(DateTimeRange tileRange);

/// The builder for the month item.
///
/// [monthRange] is the [DateTimeRange] of the month.
typedef MonthItemBuilder = Widget Function(DateTimeRange monthRange);
