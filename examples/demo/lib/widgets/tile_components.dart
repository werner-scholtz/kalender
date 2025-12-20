import 'package:demo/widgets/tile/resize_handles.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import 'package:demo/data/event.dart';
import 'package:demo/widgets/tile/tiles.dart';

TileComponents<Event> get multiDayBodyComponents {
  const margin = EdgeInsets.symmetric(horizontal: 1);
  const titlePadding = EdgeInsets.all(8);
  return TileComponents(
    tileBuilder: (event, tileRange) => EventTile(event: event as Event, margin: margin, titlePadding: titlePadding),
    dropTargetTile: (event) => DropTargetTile(event: event as Event, margin: margin),
    tileWhenDraggingBuilder: (event) => TileWhenDragging(event: event as Event, margin: margin),
    feedbackTileBuilder: (event, size) => FeedbackTile(event: event as Event, margin: margin, size: size),
    horizontalResizeHandle: const HorizontalResizeHandle(),
    verticalResizeHandle: const VerticalResizeHandle(),
  );
}

TileComponents<Event> get multiDayHeaderTileComponents {
  const margin = EdgeInsets.symmetric(vertical: 1);
  const titlePadding = EdgeInsets.symmetric(vertical: 1, horizontal: 8);
  return TileComponents(
    tileBuilder: (event, tileRange) => EventTile(event: event as Event, margin: margin, titlePadding: titlePadding),
    dropTargetTile: (event) => DropTargetTile(event: event as Event, margin: margin),
    tileWhenDraggingBuilder: (event) => TileWhenDragging(event: event as Event, margin: margin),
    feedbackTileBuilder: (event, size) => FeedbackTile(event: event as Event, margin: margin, size: size),
    horizontalResizeHandle: const HorizontalResizeHandle(),
    verticalResizeHandle: const VerticalResizeHandle(),
  );
}

ScheduleTileComponents<Event> get scheduleTileComponents {
  const margin = EdgeInsets.symmetric(vertical: 1);
  const titlePadding = EdgeInsets.all(8);
  return ScheduleTileComponents(
    tileBuilder: (event, tileRange) => EventTile(event: event as Event, margin: margin, titlePadding: titlePadding),
    dropTargetTile: (event) => DropTargetTile(event: event as Event, margin: margin),
    tileWhenDraggingBuilder: (event) => TileWhenDragging(event: event as Event, margin: margin),
    feedbackTileBuilder: (event, size) => FeedbackTile(event: event as Event, margin: margin, size: size),
  );
}
