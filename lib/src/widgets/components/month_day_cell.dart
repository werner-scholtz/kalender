// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:kalender/src/widgets/components/day_cell.dart';
import 'package:kalender/src/widgets/internal_components/day_selection.dart';

/// Builds the background of a single day cell in the month body.
///
/// Called once per cell with [MonthDayCellDetails]. The widget is painted behind the grid, the day number and the
/// events, and receives no pointer events. The default builds nothing.
///
/// {@category Appearance}
typedef MonthDayCellBuilder = Widget Function(BuildContext context, MonthDayCellDetails details);

/// Details describing a single day cell, passed to a [MonthDayCellBuilder].
///
/// {@category Appearance}
@immutable
class MonthDayCellDetails {
  const MonthDayCellDetails({
    required this.date,
    required this.isToday,
    required this.isInFocusedMonth,
    this.isSelected = false,
  });

  /// The cell's date, as a wall-clock [DateTime] in the calendar's configured location (via `.forLocation()`), so
  /// comparisons against `DateTime.now()` behave correctly.
  final DateTime date;

  /// Whether [date] is today.
  final bool isToday;

  /// Whether [date] falls within the focused month.
  ///
  /// `false` for the leading and trailing days that belong to the previous or next month but are shown to fill out the
  /// grid.
  final bool isInFocusedMonth;

  /// Whether [date] is in the selected range of the calendar's controller.
  final bool isSelected;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthDayCellDetails &&
        other.date == date &&
        other.isToday == isToday &&
        other.isInFocusedMonth == isInFocusedMonth &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode => Object.hash(date, isToday, isInFocusedMonth, isSelected);

  @override
  String toString() =>
      'MonthDayCellDetails($date, isToday: $isToday, isInFocusedMonth: $isInFocusedMonth, isSelected: $isSelected)';
}

/// Renders the background of a single day cell in the month body.
///
/// Draws [DayCellStyle.selectedColor] when [isSelected], and nothing otherwise.
///
/// {@category Appearance}
class MonthDayCell extends StatelessWidget {
  const MonthDayCell({super.key, this.isSelected = false});

  final bool isSelected;

  /// A ready-made [MonthDayCellBuilder] that shades the leading and trailing adjacent-month days, leaving the focused
  /// month's days unchanged.
  ///
  /// Pass [color] to set the shade. When omitted it defaults to a low-opacity [ColorScheme.onSurface] overlay (the
  /// Material 3 way to express a greyed-out or de-emphasized surface), read from the ambient theme, so it adapts to
  /// light and dark modes and to any custom [ColorScheme]. Enable it with:
  ///
  /// ```dart
  /// MonthBodyComponents(monthDayCellBuilder: MonthDayCell.shadeAdjacentMonths())
  /// ```
  static MonthDayCellBuilder shadeAdjacentMonths({Color? color}) {
    return (context, details) =>
        details.isInFocusedMonth ? MonthDayCell(isSelected: details.isSelected) : _AdjacentMonthShade(color: color);
  }

  @override
  Widget build(BuildContext context) => DefaultDayCell(isSelected: isSelected);
}

class _AdjacentMonthShade extends StatelessWidget {
  const _AdjacentMonthShade({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08));
  }
}
