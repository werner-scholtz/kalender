// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_interaction.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/event_tiles/tile_interaction.dart';

/// A widget that makes the event tile draggable for rescheduling.
class TileDraggable extends StatelessWidget {
  /// The event to be dragged.
  final KalenderEvent event;

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

  const TileDraggable({
    super.key,
    required this.event,
    required this.feedbackTileBuilder,
    required this.tileWhenDraggingBuilder,
    required this.dragAnchorStrategy,
    required this.rescheduleDraggableKey,
    this.dismissOverlay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!event.canReschedule(context.interaction)) return child;

    return switch (context.interaction.modifyEventGesture) {
      EventInteractionGesture.tap => Draggable.new,
      EventInteractionGesture.longPress => LongPressDraggable.new,
    }(
      key: rescheduleDraggableKey,
      data: Reschedule(event: event),
      // The feedback is built into the Overlay, which is not below this widget,
      // so it inherits nothing from here. Capturing carries the themes across,
      // which is why a scoped KalenderTheme reaches the dragged tile.
      feedback: InheritedTheme.captureAll(
        context,
        FeedbackWidget(
          event: event,
          eventsController: context.eventsController,
          feedbackTileBuilder: feedbackTileBuilder,
        ),
      ),
      dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
      onDragStarted: () {
        dismissOverlay?.call();
        context.kalenderController.selectEvent(event, internal: true);
        context.callbacks?.onEventChange?.call(event);
      },
      child: child,
    );
  }
}

/// A widget that provides a feedback widget for event dragging.
class FeedbackWidget extends StatefulWidget {
  /// The event being dragged.
  final KalenderEvent event;

  /// The events controller, used to listen for updates to the event being dragged.
  ///
  /// This is passed explicitly because the feedback widget is rendered in an overlay
  /// which is not a descendant of the [EventsControllerProvider].
  final EventsController eventsController;

  /// The builder used to create the feedback tile.
  final FeedbackTileBuilder? feedbackTileBuilder;

  const FeedbackWidget({super.key, required this.event, required this.eventsController, this.feedbackTileBuilder});

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  Size _size = const Size(0, 0);

  late KalenderEvent _event = widget.event;

  ValueNotifier<Size> get _sizeNotifier => widget.eventsController.feedbackWidgetSize;

  @override
  void initState() {
    super.initState();
    _updateSize();
    _sizeNotifier.addListener(_updateSize);
    widget.eventsController.addListener(_eventsControllerListener);
  }

  @override
  void dispose() {
    _sizeNotifier.removeListener(_updateSize);
    widget.eventsController.removeListener(_eventsControllerListener);
    super.dispose();
  }

  /// Updates the size of the feedback widget.
  void _updateSize() {
    if (!mounted) return;
    if (_sizeNotifier.value == Size.zero) return;
    if (_sizeNotifier.value == _size) return;

    setState(() => _size = _sizeNotifier.value);
  }

  /// The listener for the events controller.
  void _eventsControllerListener() {
    final updatedEvent = widget.eventsController.byId(widget.event.id);
    if (updatedEvent == null) return;
    if (updatedEvent == _event) return;
    if (mounted) setState(() => _event = updatedEvent);
  }

  @override
  Widget build(BuildContext context) {
    final feedbackTile = widget.feedbackTileBuilder?.call(context, _event, _size);
    return feedbackTile ?? const SizedBox();
  }
}
