// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';

/// Whether [details] carries a [Create], [Resize] or [Reschedule], printing a debug message naming [target] when not.
bool isKalenderPayload(DragTargetDetails<Object?> details, String target) {
  final data = details.data;
  if (data is Create || data is Resize || data is Reschedule) return true;
  debugPrint('$target: cannot use details: $details because of unknown data type');
  return false;
}

/// The date of the day column at [dx], for columns [dayWidth] wide that follow the text direction of [context].
FloatingDateTime? dateAtColumn(BuildContext context, List<FloatingDateTime> dates, double dx, double dayWidth) {
  final index = (dx / dayWidth).floor().clamp(0, dates.length - 1);
  return Directionality.of(context) == TextDirection.ltr
      ? dates.elementAtOrNull(index)
      : dates.elementAtOrNull(dates.length - index - 1);
}
