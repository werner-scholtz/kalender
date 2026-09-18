// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/kalender_callbacks.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// Reports a tap on [event] to [KalenderCallbacks.onEventTapped] and [KalenderCallbacks.onEventTappedWithDetail], or
/// to their secondary counterparts when [secondary] is true.
EventTileOnTapUp reportEventTap(
  KalenderEvent event,
  TapDetail Function(Offset localPosition, BuildContext context, RenderBox renderBox) detail, {
  bool secondary = false,
}) {
  return (details, context) {
    final tapDetail = detail(details.localPosition, context, context.findRenderObject()! as RenderBox);
    final callbacks = context.callbacks;
    if (secondary) {
      callbacks?.onEventSecondaryTapped?.call(event);
      callbacks?.onEventSecondaryTappedWithDetail?.call(event, tapDetail);
    } else {
      callbacks?.onEventTapped?.call(event);
      callbacks?.onEventTappedWithDetail?.call(event, tapDetail);
    }
  };
}

/// The detail of a tap on a tile spanning [floatingRange] across day columns, with the range of the day under the tap.
MultiDayDetail multiDayTapDetail(
  FloatingDateTimeRange floatingRange,
  Offset localPosition,
  BuildContext context,
  RenderBox renderBox,
) {
  var date = floatingRange.start;
  final size = renderBox.size;
  if (size.width > 0) {
    final percentage = (localPosition.dx / size.width).clamp(0.0, 1.0);
    final daysOffset = (floatingRange.duration.inDays * percentage).truncate();
    date = date.add(Duration(days: daysOffset));
  }
  final range = FloatingDateTimeRange(start: date.startOfDay, end: date.endOfDay);
  return MultiDayDetail(
    dateTimeRange: range.forLocation(location: context.location),
    renderBox: renderBox,
    localOffset: localPosition,
  );
}
