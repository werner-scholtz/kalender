import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/platform.dart' show isMobileDevice;

/// The base class for all event tiles.
///
/// Event tiles are used to display events in the calendar.
abstract class EventTile<T extends Object?> extends StatelessWidget {
  // final CalendarController<T> controller;
  final CalendarEvent<T> event;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;

  final CalendarInteraction interaction;

  /// The dateTimeRange of this tile
  final DateTimeRange dateTimeRange;

  /// Creates a new [EventTile] widget.
  const EventTile({
    super.key,
    // required this.controller,
    required this.callbacks,
    required this.tileComponents,
    required this.event,
    required this.interaction,
    required this.dateTimeRange,
  });

  DateTimeRange get localDateTimeRange => dateTimeRange.asLocal;
  DragAnchorStrategy? get dragAnchorStrategy => tileComponents.dragAnchorStrategy;
  // ValueNotifier<CalendarEvent<T>?> get selectedEvent => controller.selectedEvent;

  OnEventTapped<T>? get onEventTapped => callbacks?.onEventTapped;
  OnEventTappedWithDetail<T>? get onEventTappedWithDetail => callbacks?.onEventTappedWithDetail;

  TileBuilder<T> get tileBuilder => tileComponents.tileBuilder;
  TileBuilder<T> get overlayTileBuilder => tileComponents.overlayTileBuilder ?? tileBuilder;
  TileWhenDraggingBuilder<T>? get tileWhenDraggingBuilder => tileComponents.tileWhenDraggingBuilder;
  FeedbackTileBuilder<T>? get feedbackTileBuilder => tileComponents.feedbackTileBuilder;
  Widget? get verticalResizeHandle => tileComponents.verticalResizeHandle;
  Widget? get horizontalResizeHandle => tileComponents.horizontalResizeHandle;

  bool get continuesBefore => event.startAsUtc.isBefore(dateTimeRange.start);
  bool get continuesAfter => event.endAsUtc.isAfter(dateTimeRange.end);
  bool get showStart => interaction.allowResizing && event.interaction.allowStartResize && !continuesBefore;
  bool get showEnd => interaction.allowResizing && event.interaction.allowEndResize && !continuesAfter;
  bool get canReschedule => interaction.allowRescheduling && event.interaction.allowRescheduling;
}

abstract class EventModification<T extends Object?> extends StatelessWidget {
  final CalendarEvent<T> event;
  final TileComponents<T> tileComponents;
  const EventModification({super.key, required this.event, required this.tileComponents});

  DragAnchorStrategy? get dragAnchorStrategy => tileComponents.dragAnchorStrategy;
  TileBuilder<T> get tileBuilder => tileComponents.tileBuilder;
  TileBuilder<T> get overlayTileBuilder => tileComponents.overlayTileBuilder ?? tileBuilder;
  TileWhenDraggingBuilder<T>? get tileWhenDraggingBuilder => tileComponents.tileWhenDraggingBuilder;
  FeedbackTileBuilder<T>? get feedbackTileBuilder => tileComponents.feedbackTileBuilder;
  Widget? get verticalResizeHandle => tileComponents.verticalResizeHandle;
  Widget? get horizontalResizeHandle => tileComponents.horizontalResizeHandle;

  Reschedule<T> get rescheduleEvent => Reschedule<T>(event: event);

  Resize<T> resizeEvent(ResizeDirection direction) => Resize<T>(event: event, direction: direction);
  void selectEvent(BuildContext context) {
    context.calendarController<T>().selectEvent(event, internal: true);
    context.callbacks<T>()?.onEventChange?.call(event);
  }
}

class EventResize<T extends Object?> extends EventModification<T> {
  final ResizeDirection direction;

  const EventResize({
    super.key,
    required super.event,
    required super.tileComponents,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.calendarController<T>();
    final resizeHandle = direction == ResizeDirection.left || direction == ResizeDirection.right
        ? horizontalResizeHandle
        : verticalResizeHandle;
    return ValueListenableBuilder(
      valueListenable: controller.selectedEvent,
      builder: (context, value, child) {
        if (!isMobileDevice) {
          if (controller.internalFocus) return const SizedBox();
        } else {
          if (value != event) return const SizedBox();
        }
        return child!;
      },
      child: Draggable<Resize<T>>(
        data: resizeEvent(direction),
        feedback: const SizedBox(),
        dragAnchorStrategy: pointerDragAnchorStrategy,
        onDragStarted: () => selectEvent(context),
        child: resizeHandle ?? Container(color: Colors.transparent),
      ),
    );
  }
}

class EventReschedule<T extends Object?> extends EventModification<T> {
  final Widget tile;
  const EventReschedule({
    super.key,
    required super.event,
    required super.tileComponents,
    required this.tile,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.calendarController<T>();
    final isDragging = controller.selectedEventId == event.id && controller.internalFocus;
    final tileWhenDragging = tileWhenDraggingBuilder?.call(event);

    late final feedback = ValueListenableBuilder(
      valueListenable: context.feedbackWidgetSizeNotifier<T>(),
      builder: (context, value, child) {
        final feedbackTile = feedbackTileBuilder?.call(event, value);
        return feedbackTile ?? const SizedBox();
      },
    );

    return isMobileDevice
        ? LongPressDraggable<Reschedule<T>>(
            data: rescheduleEvent,
            feedback: feedback,
            childWhenDragging: tileWhenDragging,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: () => selectEvent(context),
            maxSimultaneousDrags: 1,
            child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
          )
        : Draggable<Reschedule<T>>(
            data: rescheduleEvent,
            feedback: feedback,
            childWhenDragging: tileWhenDragging,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: () => selectEvent(context),
            child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
          );
  }
}
