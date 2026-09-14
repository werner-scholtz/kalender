// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

mixin NewDraggableWidget {
  KalenderController get controller;
  KalenderCallbacks? get callbacks;

  /// Calculate the initial floatingRange of a new event.
  ///
  /// [date] is the date the draggable is located at.
  /// [localPosition] is the last known position of the cursor.
  FloatingDateTimeRange calculateFloatingRange(FloatingDateTime date, Offset localPosition);

  /// Create a TapDetail for the new event.
  ///
  /// [range] is the floatingRange of the new event.
  /// [localPosition] is the last known position of the cursor.
  TapDetail createTapDetail(BuildContext context, FloatingDateTimeRange range, Offset localPosition);

  /// Create the new event and select it where needed.
  void createNewEvent(BuildContext context, FloatingDateTime date, Offset localPosition) {
    final floatingRange = calculateFloatingRange(date, localPosition);
    final range = floatingRange.forLocation(location: context.location);
    final newEvent = KalenderEvent(start: range.start, end: range.end);

    KalenderEvent? event;
    if (callbacks?.onEventCreateWithDetail != null) {
      final detail = createTapDetail(context, floatingRange, localPosition);
      event = callbacks?.onEventCreateWithDetail?.call(newEvent, detail);
    } else if (callbacks?.onEventCreate != null) {
      event = callbacks?.onEventCreate?.call(newEvent);
    }

    event ??= newEvent;
    controller.setNewEvent(event);
    controller.selectEvent(event);
  }

  /// Deselect the new event.
  // ignore: strict_top_level_inference
  void onDragFinished([_, __]) => controller.clearNewEvent();
}
