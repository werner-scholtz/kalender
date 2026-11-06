// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/kalender_time_range.dart';

/// Builds the background of one day column in the multi-day body.
///
/// Called once per day of a page with [DayCellDetails]. The widget fills the column over the whole time of day range,
/// is painted behind the hour lines and the events, and receives no pointer events. The default draws only
/// [DayCellStyle.selectedColor] on a selected day.
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
    required this.isSelected,
    required this.timeOfDayRange,
    required this.heightPerMinute,
  });

  /// The start of the day in the calendar's location.
  final DateTime date;

  /// Whether [date] is today.
  final bool isToday;

  /// Whether [date] is in the selected range of the calendar's controller.
  final bool isSelected;

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
        other.isSelected == isSelected &&
        other.timeOfDayRange == timeOfDayRange &&
        other.heightPerMinute == heightPerMinute;
  }

  @override
  int get hashCode => Object.hash(date, isToday, isSelected, timeOfDayRange, heightPerMinute);

  @override
  String toString() =>
      'DayCellDetails($date, isToday: $isToday, isSelected: $isSelected, $timeOfDayRange, $heightPerMinute)';
}

/// The style of a day cell in the month body and of a day column in the multi-day body.
///
/// {@category Appearance}
class DayCellStyle with Diagnosticable {
  const DayCellStyle({this.selectedColor});

  /// The color of a selected day, drawn by the default cell of the month and multi-day bodies. Null draws nothing.
  final Color? selectedColor;

  /// Creates a copy of this style with the given fields replaced with the new values.
  DayCellStyle copyWith({Color? selectedColor}) => DayCellStyle(selectedColor: selectedColor ?? this.selectedColor);

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  DayCellStyle merge(DayCellStyle? other) {
    if (other == null) return this;
    return DayCellStyle(selectedColor: other.selectedColor ?? selectedColor);
  }

  /// Linearly interpolates between [a] and [b].
  static DayCellStyle? lerp(DayCellStyle? a, DayCellStyle? b, double t) {
    if (identical(a, b)) return a;
    return DayCellStyle(selectedColor: Color.lerp(a?.selectedColor, b?.selectedColor, t));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DayCellStyle && other.selectedColor == selectedColor;
  }

  @override
  int get hashCode => selectedColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('selectedColor', selectedColor, defaultValue: null));
  }
}
