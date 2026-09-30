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
import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:timezone/timezone.dart';

/// The tile widget that displays the user-defined event content.
///
/// This widget manages the visual transition between normal and dragging states by switching between [tileBuilder] and
/// [tileWhenDraggingBuilder] based on the current drag state from [KalenderController].
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
  EventsController? _eventsController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final eventsController = context.eventsController;
    if (eventsController != _eventsController) {
      _eventsController?.removeListener(_eventsControllerListener);
      _eventsController = eventsController;
      _eventsController?.addListener(_eventsControllerListener);
    }
  }

  @override
  void dispose() {
    _eventsController?.removeListener(_eventsControllerListener);
    super.dispose();
  }

  void _eventsControllerListener() {
    final updatedEvent = _eventsController?.byId(widget.initialEvent.id);
    if (updatedEvent == null) return;
    if (updatedEvent == _event) return;
    if (mounted) setState(() => _event = updatedEvent);
  }

  @override
  Widget build(BuildContext context) =>
      SelectionModel.of(context, widget.initialEvent.id).moving && widget.tileWhenDraggingBuilder != null
      ? widget.tileWhenDraggingBuilder!.call(context, _event)
      : widget.tileBuilder.call(context, _event, _convertedRange(widget.floatingRange, context.location));
}

/// Tile ranges converted for a location. The tiles of one column share a range object, so it converts once per column.
final _convertedRanges = Expando<(Location?, KalenderDateTimeRange)>();

KalenderDateTimeRange _convertedRange(FloatingDateTimeRange range, Location? location) {
  final cached = _convertedRanges[range];
  if (cached != null && cached.$1 == location) return cached.$2;
  final converted = range.forLocation(location: location);
  _convertedRanges[range] = (location, converted);
  return converted;
}
