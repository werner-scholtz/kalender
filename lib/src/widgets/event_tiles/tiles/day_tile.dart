// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/tile_taps.dart';

class DayEventTile extends EventTile {
  const DayEventTile({
    super.key,
    required super.event,
    required super.tileComponents,
    required super.floatingRange,
    required super.resizeAxis,
  });

  /// A key used to identify the [DayEventTile].
  static Key tileKey(String eventId) => Key('DayEventTile-$eventId');

  /// A key used to identify the reschedule draggable.
  static Key rescheduleDraggableKey(String eventId) => Key('DayEventTile-RescheduleDraggable-$eventId');

  /// A key used to identify the gesture detector.
  static Key gestureDetectorKey(String eventId) => Key('DayEventTile-GestureDetector-$eventId');

  @override
  EventTileOnTapUp? get onTapUp => reportEventTap(event, _detail);

  @override
  EventTileOnTapUp? get onSecondaryTapUp => reportEventTap(event, _detail, secondary: true);

  DayDetail _detail(Offset localPosition, BuildContext context, RenderBox renderBox) {
    var date = floatingRange.start;
    final heightPerMinute = context.heightPerMinute;
    if (heightPerMinute > 0) {
      final minutes = (localPosition.dy / heightPerMinute).round();
      date = date.add(Duration(minutes: minutes));
    }
    return DayDetail(
      date: date.forLocation(location: context.location),
      renderBox: renderBox,
      localOffset: localPosition,
    );
  }

  @override
  Key get rescheduleKey => DayEventTile.rescheduleDraggableKey(event.id);

  @override
  Key get gestureKey => DayEventTile.gestureDetectorKey(event.id);
}
