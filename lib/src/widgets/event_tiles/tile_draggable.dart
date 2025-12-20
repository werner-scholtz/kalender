import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// A widget that makes the event tile draggable for rescheduling.
class TileDraggable<T extends Object?> extends StatelessWidget {
  /// The event to be dragged.
  final CalendarEvent event;

  /// The interaction state of the calendar.
  final CalendarInteraction interaction;

  /// The builder used to create the feedback tile.
  final FeedbackTileBuilder<T>? feedbackTileBuilder;

  /// The builder used to create the tile when dragging.
  final TileWhenDraggingBuilder<T>? tileWhenDraggingBuilder;

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
    required this.interaction,
    required this.event,
    required this.feedbackTileBuilder,
    required this.tileWhenDraggingBuilder,
    required this.dragAnchorStrategy,
    required this.rescheduleDraggableKey,
    this.dismissOverlay,
    required this.child,
  });

  /// The data to be passed during the drag.
  Reschedule<T> get data => Reschedule<T>(event: event);

  @override
  Widget build(BuildContext context) {
    // If rescheduling is not allowed, return the child directly.
    if (!interaction.allowRescheduling || !event.interaction.allowRescheduling) {
      return child;
    }

    return switch (interaction.modifyEventGesture) {
      CreateEventGesture.tap => Draggable.new,
      CreateEventGesture.longPress => LongPressDraggable.new,
    }(
      key: rescheduleDraggableKey,
      data: data,
      feedback: FeedbackWidget(
        event: event,
        feedbackWidgetSizeNotifier: context.feedbackWidgetSizeNotifier<T>(),
        feedbackTileBuilder: feedbackTileBuilder,
      ),
      dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
      onDragStarted: () {
        dismissOverlay?.call();
        context.calendarController<T>().selectEvent(event, internal: true);
        context.callbacks<T>()?.onEventChange?.call(event);
      },
      child: child,
    );
  }
}

/// A widget that provides a feedback widget for event dragging.
class FeedbackWidget<T extends Object?> extends StatefulWidget {
  /// The event being dragged.
  final CalendarEvent event;

  /// The builder used to create the feedback tile.
  final FeedbackTileBuilder<T>? feedbackTileBuilder;

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
  State<FeedbackWidget<T>> createState() => _FeedbackWidgetState<T>();
}

/// The state for the feedback widget.
///
/// This state listens to the size notifier and rebuilds the widget when the size changes.
class _FeedbackWidgetState<T extends Object?> extends State<FeedbackWidget<T>> {
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
