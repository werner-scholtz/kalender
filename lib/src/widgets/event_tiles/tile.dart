// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/controllers/kalender_controller.dart';
import 'package:kalender/src/models/floating_date_time_range.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// The tile widget that displays the user-defined event content.
///
/// This widget manages the visual transition between normal and dragging states
/// by switching between [tileBuilder] and [tileWhenDraggingBuilder] based on
/// the current drag state from [KalenderController].
class Tile extends StatefulWidget {
  /// The event associated with the tile.
  final KalenderEvent initialEvent;

  /// The builder that builds the tile widget.
  final TileBuilder tileBuilder;

  /// The builder that builds the tile widget when dragging.
  final TileWhenDraggingBuilder? tileWhenDraggingBuilder;

  /// The [FloatingDateTimeRange] that the current view is displaying.
  final FloatingDateTimeRange floatingRange;

  /// Creates an instance of [Tile].
  const Tile({
    super.key,
    required this.initialEvent,
    required this.tileBuilder,
    required this.tileWhenDraggingBuilder,
    required this.floatingRange,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  late KalenderEvent _event = widget.initialEvent;
  KalenderController? _controller;
  EventsController? _eventsController;
  bool _isDragging = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = context.kalenderController;
    if (controller != _controller) {
      _controller?.selectedEvent.removeListener(_calendarControllerListener);
      _controller = controller;
      _controller?.selectedEvent.addListener(_calendarControllerListener);
    }

    final eventsController = context.eventsController;
    if (eventsController != _eventsController) {
      _eventsController?.removeListener(_eventsControllerListener);
      _eventsController = eventsController;
      _eventsController?.addListener(_eventsControllerListener);
    }
  }

  @override
  void dispose() {
    _controller?.selectedEvent.removeListener(_calendarControllerListener);
    _eventsController?.removeListener(_eventsControllerListener);
    super.dispose();
  }

  /// The listener for the calendar controller's selected event.
  void _calendarControllerListener() {
    final isDragging = _controller?.selectedEventId == widget.initialEvent.id && (_controller?.internalFocus ?? false);
    if (_isDragging == isDragging) return;
    if (mounted) setState(() => _isDragging = isDragging);
  }

  void _eventsControllerListener() {
    final updatedEvent = _eventsController?.byId(widget.initialEvent.id);
    if (updatedEvent == null) return;
    if (updatedEvent == widget.initialEvent) return;
    if (mounted) setState(() => _event = updatedEvent);
  }

  @override
  Widget build(BuildContext context) => _isDragging && widget.tileWhenDraggingBuilder != null
      ? widget.tileWhenDraggingBuilder!.call(context, _event)
      : widget.tileBuilder.call(context, _event, widget.floatingRange.forLocation(location: context.location));
}
