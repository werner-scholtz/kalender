// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/kalender_callbacks.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/tile_taps.dart';

class ScheduleEventTile extends EventTile {
  const ScheduleEventTile({
    super.key,
    required super.event,
    required super.tileComponents,
    required super.floatingRange,
    required super.resizeAxis,
  });

  /// A key used to identify the tile.
  static Key tileKey(String eventId) => Key('ScheduleEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(String eventId) => Key('ScheduleEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(String eventId) => Key('ScheduleEventTile-GestureDetector-$eventId');

  @override
  EventTileOnTapUp? get onTapUp => reportEventTap(event, _detail);

  @override
  EventTileOnTapUp? get onSecondaryTapUp => reportEventTap(event, _detail, secondary: true);

  MultiDayDetail _detail(Offset localPosition, BuildContext context, RenderBox renderBox) => MultiDayDetail(
    dateTimeRange: floatingRange.forLocation(location: context.location),
    renderBox: renderBox,
    localOffset: localPosition,
  );

  @override
  Key get rescheduleKey => ScheduleEventTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => ScheduleEventTile.gestureDetectorKey(event.id);
}
