// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math' as math;

import 'package:kalender/kalender.dart';
import 'package:material_ui/material_ui.dart';

/// The background of a day column: shades Saturday, Sunday and the hours outside 09:00 to 17:00, and tints today.
class WorkingHoursCell extends StatelessWidget {
  const WorkingHoursCell(this.details, {super.key});

  static const startHour = 9;
  static const endHour = 17;

  final DayCellDetails details;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final shade = ColoredBox(color: colors.onSurface.withValues(alpha: 0.06));
    final isWeekend = details.date.weekday >= DateTime.saturday;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (details.isToday) ColoredBox(color: colors.primary.withValues(alpha: 0.1)),
        if (isWeekend)
          shade
        else ...[
          Positioned(top: 0, left: 0, right: 0, height: _offset(startHour), child: shade),
          Positioned(top: _offset(endHour), left: 0, right: 0, bottom: 0, child: shade),
        ],
      ],
    );
  }

  /// The distance from the top of the column to the start of [hour], within the column.
  double _offset(int hour) {
    final range = details.timeOfDayRange;
    final minutes = hour * 60 - (range.start.hour * 60 + range.start.minute);
    final height = range.duration.inMinutes * details.heightPerMinute;
    return math.min(height, math.max(0, minutes * details.heightPerMinute));
  }
}
