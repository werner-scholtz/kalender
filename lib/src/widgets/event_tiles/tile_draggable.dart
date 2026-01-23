import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// A widget that makes the event tile draggable for rescheduling.
class TileDraggable extends StatelessWidget {
  /// The event to be dragged.
  final int eventId;

  /// The builder used to create the feedback tile.
  final FeedbackTileBuilder? feedbackTileBuilder;

  /// The builder used to create the tile when dragging.
  final TileWhenDraggingBuilder? tileWhenDraggingBuilder;

  /// The drag anchor strategy.
  final DragAnchorStrategy? dragAnchorStrategy;

  /// A function that is called to dismiss any overlay when dragging starts.
  final VoidCallback? dismissOverlay;

  /// A key used to identify the reschedule draggable.
  final Key rescheduleDraggableKey;

  /// The child widget to be made draggable.
  final Widget child;

  /// Creates a tile draggable widget.
  const TileDraggable({
    super.key,
    required this.eventId,
    required this.feedbackTileBuilder,
    required this.tileWhenDraggingBuilder,
    required this.dragAnchorStrategy,
    required this.rescheduleDraggableKey,
    this.dismissOverlay,
    required this.child,
  });

  // /// The data to be passed during the drag.
  // /// TODO(werner): Error handling if event is null ?
  // Reschedule data(BuildContext context) => Reschedule(event: context.eventsController().byId(eventId)!);

  @override
  Widget build(BuildContext context) {
    final event = context.eventsController().byId(eventId);
    if (event == null) return child;

    // If rescheduling is not allowed, return the child directly.
    if (!context.interaction.allowRescheduling || !event.interaction.allowRescheduling) {
      return child;
    }

    return switch (context.interaction.modifyEventGesture) {
      CreateEventGesture.tap => Draggable.new,
      CreateEventGesture.longPress => LongPressDraggable.new,
    }(
      key: rescheduleDraggableKey,
      data: Reschedule(event: event),
      feedback: FeedbackWidget(
        event: event,
        feedbackWidgetSizeNotifier: context.feedbackWidgetSizeNotifier(),
        feedbackTileBuilder: feedbackTileBuilder,
      ),
      dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
      onDragStarted: () {
        dismissOverlay?.call();
        context.calendarController().selectEvent(event, internal: true);
        context.callbacks()?.onEventChange?.call(event);
      },
      child: child,
    );
  }
}

/// A widget that provides a feedback widget for event dragging.
class FeedbackWidget extends StatefulWidget {
  /// The event being dragged.
  final CalendarEvent event;

  /// The builder used to create the feedback tile.
  final FeedbackTileBuilder? feedbackTileBuilder;

  /// A notifier that provides the size of the feedback widget.
  final ValueNotifier<Size> feedbackWidgetSizeNotifier;

  /// Creates a feedback widget for event dragging.
  const FeedbackWidget({
    super.key,
    required this.event,
    this.feedbackTileBuilder,
    required this.feedbackWidgetSizeNotifier,
  });

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

/// The state for the feedback widget.
///
/// This state listens to the size notifier and rebuilds the widget when the size changes.
class _FeedbackWidgetState extends State<FeedbackWidget> {
  /// The size of the feedback widget.
  Size _size = const Size(0, 0);

  @override
  void initState() {
    super.initState();
    _updateSize();
    widget.feedbackWidgetSizeNotifier.addListener(_updateSize);
  }

  @override
  void dispose() {
    widget.feedbackWidgetSizeNotifier.removeListener(_updateSize);
    super.dispose();
  }

  /// Updates the size of the feedback widget.
  void _updateSize() {
    if (!mounted) return;
    if (widget.feedbackWidgetSizeNotifier.value == Size.zero) return;
    if (widget.feedbackWidgetSizeNotifier.value == _size) return;

    // Update the size only if it has changed.
    setState(() => _size = widget.feedbackWidgetSizeNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    final feedbackTile = widget.feedbackTileBuilder?.call(widget.event, _size);
    return feedbackTile ?? const SizedBox();
  }
}
