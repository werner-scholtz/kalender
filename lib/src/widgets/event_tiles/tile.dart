import 'package:flutter/material.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The tile widget that displays the user-defined event content.
///
/// This widget manages the visual transition between normal and dragging states
/// by switching between [tileBuilder] and [tileWhenDraggingBuilder] based on
/// the current drag state from [CalendarController].
class Tile<T extends Object?> extends StatefulWidget {
  /// The event associated with the tile.
  final CalendarEvent event;

  /// The builder that builds the tile widget.
  final TileBuilder<T> tileBuilder;

  /// The builder that builds the tile widget when dragging.
  final TileWhenDraggingBuilder<T>? tileWhenDraggingBuilder;

  /// The DateTimeRange that the current view is displaying.
  final DateTimeRange dateTimeRange;

  /// Creates an instance of [Tile].
  const Tile({
    super.key,
    required this.event,
    required this.tileBuilder,
    required this.tileWhenDraggingBuilder,
    required this.dateTimeRange,
  });

  @override
  State<Tile<T>> createState() => _TileState<T>();
}

/// The state for the Tile widget.
///
/// This state listens to the calendar controller to determine if the event is being dragged,
/// and rebuilds the widget accordingly.
class _TileState<T extends Object?> extends State<Tile<T>> {
  /// The calendar controller.
  CalendarController<T>? _controller;

  /// Whether the event is being dragged.
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller = context.calendarController<T>();
      _controller?.selectedEvent.addListener(_listener);
    });
  }

  @override
  void dispose() {
    _controller?.selectedEvent.removeListener(_listener);
    super.dispose();
  }

  /// The listener for the calendar controller's selected event.
  void _listener() {
    // Check if the dragging state has changed.
    final isDragging = _controller?.selectedEventId == widget.event.id && (_controller?.internalFocus ?? false);
    if (_isDragging == isDragging) return;
    if (mounted) setState(() => _isDragging = isDragging);
  }

  @override
  Widget build(BuildContext context) {
    return _isDragging && widget.tileWhenDraggingBuilder != null
        ? widget.tileWhenDraggingBuilder!.call(widget.event)
        : widget.tileBuilder.call(widget.event, widget.dateTimeRange.asLocal);
  }
}
