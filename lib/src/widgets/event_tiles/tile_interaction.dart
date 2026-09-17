// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/src/models/floating_date_time_range.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_interaction.dart';
import 'package:timezone/timezone.dart';

/// What a tile lets the user do, from the calendar's [KalenderInteraction] and the event's own [EventInteraction].
extension TileInteraction on KalenderEvent {
  /// Whether the tile can be dragged to another time.
  bool canReschedule(KalenderInteraction interaction) {
    return interaction.allowRescheduling && this.interaction.allowRescheduling;
  }

  /// Whether the tile shows a start resize handle, given the [range] the tile covers.
  bool canResizeStart(KalenderInteraction interaction, FloatingDateTimeRange range, {Location? location}) {
    return interaction.allowResizing &&
        this.interaction.allowStartResize &&
        !floatingStart(location: location).isBefore(range.start);
  }

  /// Whether the tile shows an end resize handle, given the [range] the tile covers.
  bool canResizeEnd(KalenderInteraction interaction, FloatingDateTimeRange range, {Location? location}) {
    return interaction.allowResizing &&
        this.interaction.allowEndResize &&
        !floatingEnd(location: location).isAfter(range.end);
  }
}
