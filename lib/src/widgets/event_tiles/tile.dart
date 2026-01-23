import 'package:flutter/material.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

// TODO(werner): Update docs.

/// The tile widget that displays the user-defined event content.
///
/// This widget manages the visual transition between normal and dragging states
/// by switching between [tileBuilder] and [tileWhenDraggingBuilder] based on
/// the current drag state from [CalendarController].
class Tile extends StatefulWidget {
  /// The event associated with the tile.
  final CalendarEvent initialEvent;

  /// The builder that builds the tile widget.
  final TileBuilder tileBuilder;

  /// The builder that builds the tile widget when dragging.
  final TileWhenDraggingBuilder? tileWhenDraggingBuilder;

  /// The DateTimeRange that the current view is displaying.
  final DateTimeRange dateTimeRange;

  /// Creates an instance of [Tile].
  const Tile({
    super.key,
    required this.initialEvent,
    required this.tileBuilder,
    required this.tileWhenDraggingBuilder,
    required this.dateTimeRange,
  });

  @override
  State<Tile> createState() => _TileState();
}

/// The state for the Tile widget.
///
/// This state listens to the calendar controller to determine if the event is being dragged,
/// and rebuilds the widget accordingly.
class _TileState extends State<Tile> {
  /// The current event associated with the tile.
  late CalendarEvent _event = widget.initialEvent;

  /// The calendar controller.
  CalendarController? _controller;

  /// The events controller.
  EventsController? _eventsController;

  /// Whether the event is being dragged.
  bool _isDragging = false;

  @override
  void didChangeDependencies() {
    _controller = context.calendarController();
    _controller?.selectedEvent.addListener(_controllerListener);

    _eventsController = context.eventsController();
    _eventsController?.addListener(_eventsControllerListener);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller?.selectedEvent.removeListener(_controllerListener);
    _eventsController?.removeListener(_eventsControllerListener);
    super.dispose();
  }

  /// The listener for the calendar controller's selected event.
  void _controllerListener() {
    // Check if the dragging state has changed.
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
  Widget build(BuildContext context) {
    return _isDragging && widget.tileWhenDraggingBuilder != null
        ? widget.tileWhenDraggingBuilder!.call(_event)
        : widget.tileBuilder.call(_event, widget.dateTimeRange.asLocal);
  }
}
