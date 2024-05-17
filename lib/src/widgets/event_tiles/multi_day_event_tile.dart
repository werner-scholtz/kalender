import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/multi_day_provider.dart';

class MultiDayEventTile<T extends Object?> extends StatefulWidget {
  /// The [CalendarEvent] that the [MultiDayEventTile] represents.
  final CalendarEvent<T> event;

  const MultiDayEventTile({
    super.key,
    required this.event,
  });

  @override
  State<MultiDayEventTile<T>> createState() => _MultiDayEventTileState<T>();
}

enum HorizontalResize {
  left,
  right,
  none,
}

class _MultiDayEventTileState<T extends Object?>
    extends State<MultiDayEventTile<T>> {
  CalendarEvent<T> get event => widget.event;
  MultiDayProvider<T> get provider => MultiDayProvider.of<T>(context);
  EventsController<T> get eventsController => provider.eventsController;
  CalendarCallbacks<T>? get callbacks => provider.callbacks;
  TileComponents<T> get tileComponents => provider.tileComponents;
  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged =>
      provider.eventBeingDragged;
  ValueNotifier<Size> get feedbackWidgetSize => provider.feedbackWidgetSize;

  ValueNotifier<HorizontalResize> resizingDirection =
      ValueNotifier(HorizontalResize.none);

  bool keepAlive = false;

  @override
  Widget build(BuildContext context) {
    final onTap = callbacks?.onEventTapped;

    late final tileComponent = tileComponents.tileBuilder.call(
      widget.event,
    );

    late final dragComponent = tileComponents.tileWhenDraggingBuilder?.call(
      widget.event,
    );
    late final dragAnchorStrategy = tileComponents.dragAnchorStrategy;

    return ValueListenableBuilder(
      valueListenable: resizingDirection,
      builder: (context, value, child) {
        late final feedback = ValueListenableBuilder(
          valueListenable: feedbackWidgetSize,
          builder: (context, value, child) {
            final feedbackTile = tileComponents.feedbackTileBuilder?.call(
              widget.event,
              value,
            );
            return feedbackTile ?? const SizedBox();
          },
        );

        final isDragging = provider.viewController.draggingEventId == event.id;
        late final draggableTile = Draggable<CalendarEvent<T>>(
          data: widget.event,
          feedback: feedback,
          childWhenDragging: dragComponent,
          dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
          child: isDragging && dragComponent != null
              ? dragComponent
              : tileComponent,
        );

        final tileWidget = GestureDetector(
          onTap: onTap != null
              ? () {
                  // Find the global position and size of the tile.
                  final renderObject = context.findRenderObject()! as RenderBox;
                  onTap.call(widget.event, renderObject);
                }
              : null,
          child: draggableTile,
        );

        return tileWidget;
      },
    );
  }
}
