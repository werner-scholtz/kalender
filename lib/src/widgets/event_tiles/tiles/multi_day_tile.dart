// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/tile_taps.dart';

class MultiDayEventTile extends EventTile {
  const MultiDayEventTile({
    super.key,
    required super.event,
    required super.tileComponents,
    required super.floatingRange,
    required super.resizeAxis,
  });

  /// A key used to identify the tile.
  static Key tileKey(String eventId) => Key('MultiDayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(String eventId) => Key('MultiDayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(String eventId) => Key('MultiDayEventTile-GestureDetector-$eventId');

  @override
  EventTileOnTapUp? get onTapUp => reportEventTap(event, _detail);

  @override
  EventTileOnTapUp? get onSecondaryTapUp => reportEventTap(event, _detail, secondary: true);

  MultiDayDetail _detail(Offset localPosition, BuildContext context, RenderBox renderBox) =>
      multiDayTapDetail(floatingRange, localPosition, context, renderBox);

  @override
  Key get rescheduleKey => MultiDayEventTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => MultiDayEventTile.gestureDetectorKey(event.id);
}
