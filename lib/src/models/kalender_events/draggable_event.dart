// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/kalender.dart';

/// A class used by the [DragTargetUtilities] to determine that a [KalenderEvent] is being rescheduled.
class Reschedule {
  /// The [KalenderEvent] that is being rescheduled.
  final KalenderEvent event;

  Reschedule({required this.event});
}

/// A class used by the [DragTargetUtilities] to determine that a [KalenderEvent] is being resized.
class Resize {
  /// The [KalenderEvent] that is being resized.
  final KalenderEvent event;

  /// The direction that the [KalenderEvent] is being resized in.
  final ResizeDirection direction;

  Resize({required this.event, required this.direction});

  bool get verticalResize => direction.vertical;
  bool get horizontalResize => direction.horizontal;

  /// Updates the [Resize]'s [KalenderEvent] with the new [KalenderDateTimeRange].
  Resize updateDateTimeRange(KalenderDateTimeRange dateTimeRange) {
    final updatedEvent = event.withDateTimeRange(dateTimeRange);
    return Resize(event: updatedEvent, direction: direction);
  }
}

/// A class used by the [DragTargetUtilities] to determine that a [KalenderEvent] is being created.
class Create {
  /// The id of the controller that is creating this event.
  final int controllerId;

  Create({required this.controllerId});
}
