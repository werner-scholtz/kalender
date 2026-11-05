// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/kalender_time_range.dart';

/// Builds the background of one day column in the multi-day body.
///
/// Called once per day of a page with [DayCellDetails]. The widget fills the column over the whole time of day range,
/// is painted behind the hour lines and the events, and receives no pointer events. The default builds nothing.
///
/// {@category Appearance}
typedef DayCellBuilder = Widget Function(BuildContext context, DayCellDetails details);

/// Details describing one day column, passed to a [DayCellBuilder].
///
/// {@category Appearance}
@immutable
class DayCellDetails {
  const DayCellDetails({
    required this.date,
    required this.isToday,
    required this.timeOfDayRange,
    required this.heightPerMinute,
  });

  /// The start of the day in the calendar's location.
  final DateTime date;

  /// Whether [date] is today.
  final bool isToday;

  /// The time of day at the top and the bottom of the column.
  final KalenderTimeRange timeOfDayRange;

  /// The height of one minute, so a builder can place a widget at a time of day.
  final double heightPerMinute;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DayCellDetails &&
        other.date == date &&
        other.isToday == isToday &&
        other.timeOfDayRange == timeOfDayRange &&
        other.heightPerMinute == heightPerMinute;
  }

  @override
  int get hashCode => Object.hash(date, isToday, timeOfDayRange, heightPerMinute);

  @override
  String toString() => 'DayCellDetails($date, isToday: $isToday, $timeOfDayRange, $heightPerMinute)';
}
