// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/kalender_callbacks.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/tile_taps.dart';

/// {@category Appearance}
class MultiDayEventOverlayTile extends EventTile {
  const MultiDayEventOverlayTile({
    super.key,
    required super.event,
    required super.tileComponents,
    required super.floatingRange,
    required super.resizeAxis,
    required super.dismissOverlay,
  });

  /// A key used to identify the tile.
  static Key tileKey(String eventId) => Key('MultiDayOverlayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(String eventId) => Key('MultiDayOverlayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(String eventId) => Key('MultiDayOverlayEventTile-GestureDetector-$eventId');

  @override
  TileBuilder get effectiveTileBuilder => tileComponents.overlayTileBuilder ?? tileComponents.tileBuilder;

  @override
  EventTileOnTapUp? get onTapUp => reportEventTap(event, _detail);

  @override
  EventTileOnTapUp? get onSecondaryTapUp => reportEventTap(event, _detail, secondary: true);

  MultiDayDetail _detail(Offset localPosition, BuildContext context, RenderBox renderBox) =>
      multiDayTapDetail(floatingRange, localPosition, context, renderBox);

  @override
  Key get rescheduleKey => MultiDayEventOverlayTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => MultiDayEventOverlayTile.gestureDetectorKey(event.id);
}
