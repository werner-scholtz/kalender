import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// Builds the background of a single day cell in the month body.
///
/// The builder is called once per cell with [MonthDayCellDetails] describing the
/// cell's date, whether it is today, and whether it belongs to the focused month
/// (as opposed to a leading/trailing day from an adjacent month). The returned
/// widget is painted behind the grid, the day's number and the events, so it is
/// well suited to styling the cell background, for example graying out
/// adjacent-month days.
///
/// This is a background layer and does not receive pointer events. The event
/// and drag layers sit above it. The default builder renders nothing, leaving
/// the cell background unchanged.
typedef MonthDayCellBuilder = Widget Function(MonthDayCellDetails details);

/// Details describing a single day cell, passed to a [MonthDayCellBuilder].
class MonthDayCellDetails {
  const MonthDayCellDetails({
    required this.date,
    required this.isToday,
    required this.isInFocusedMonth,
  });

  /// The cell's date, as a wall-clock [DateTime] in the calendar's configured
  /// location (via `.forLocation()`), so comparisons against `DateTime.now()`
  /// behave correctly.
  final DateTime date;

  /// Whether [date] is today.
  final bool isToday;

  /// Whether [date] falls within the focused month.
  ///
  /// `false` for the leading and trailing days that belong to the previous or
  /// next month but are shown to fill out the grid.
  final bool isInFocusedMonth;
}

/// Renders the background of a single day cell in the month body.
///
/// The default is an empty cell. Provide a [MonthDayCellBuilder] via
/// [MonthBodyComponents.monthDayCellBuilder] to customize it.
class MonthDayCell extends StatelessWidget {
  const MonthDayCell({super.key});

  /// The default [MonthDayCellBuilder] renders nothing.
  static Widget builder(MonthDayCellDetails details) => const MonthDayCell();

  /// A ready-made [MonthDayCellBuilder] that shades the leading and trailing
  /// adjacent-month days, leaving the focused month's days unchanged.
  ///
  /// Pass [color] to set the shade. When omitted it defaults to a low-opacity
  /// [ColorScheme.onSurface] overlay (the Material 3 way to express a greyed-out
  /// or de-emphasized surface), read from the ambient theme, so it adapts to
  /// light and dark modes and to any custom [ColorScheme]. Enable it with:
  ///
  /// ```dart
  /// MonthBodyComponents(monthDayCellBuilder: MonthDayCell.shadeAdjacentMonths())
  /// ```
  static MonthDayCellBuilder shadeAdjacentMonths({Color? color}) {
    return (details) => details.isInFocusedMonth ? const MonthDayCell() : _AdjacentMonthShade(color: color);
  }

  /// Builds the day cell for [date] using the configured [MonthDayCellBuilder].
  static Widget fromContext(
    BuildContext context,
    InternalDateTime date, {
    required bool isInFocusedMonth,
  }) {
    final builder = context.components.monthComponents.bodyComponents.monthDayCellBuilder;
    return builder(
      MonthDayCellDetails(
        date: date.forLocation(location: context.location),
        isToday: context.isToday(date),
        isInFocusedMonth: isInFocusedMonth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Background shade for an adjacent-month day, used by
/// [MonthDayCell.shadeAdjacentMonths]. Falls back to a low-opacity
/// [ColorScheme.onSurface] overlay, read at build time, so the default shade
/// reads as "greyed out" and follows the active [ColorScheme] in light and
/// dark modes.
class _AdjacentMonthShade extends StatelessWidget {
  const _AdjacentMonthShade({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08));
  }
}
