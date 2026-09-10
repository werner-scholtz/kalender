import 'package:flutter/material.dart';
import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/models/components/string_builders.dart';
import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/widgets/components/month_day_cell.dart';
import 'package:kalender/src/widgets/components/month_day_header.dart';
import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';
import 'package:kalender/src/widgets/components/week_number.dart';
import 'package:kalender/src/widgets/month/month_body.dart';
import 'package:kalender/src/widgets/month/month_header.dart';

/// A class containing custom widget builders for the [MonthBody] and [MonthHeader].
class MonthComponents {
  /// The component builders used by the [MonthBody].
  final MonthBodyComponents bodyComponents;

  /// The component builders used by the [MonthHeader].
  final MonthHeaderComponents headerComponents;

  const MonthComponents({
    this.bodyComponents = const MonthBodyComponents(),
    this.headerComponents = const MonthHeaderComponents(),
  });

  /// Creates a copy of this with the given fields replaced.
  MonthComponents copyWith({
    MonthBodyComponents? bodyComponents,
    MonthHeaderComponents? headerComponents,
  }) {
    return MonthComponents(
      bodyComponents: bodyComponents ?? this.bodyComponents,
      headerComponents: headerComponents ?? this.headerComponents,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthComponents &&
        other.bodyComponents == bodyComponents &&
        other.headerComponents == headerComponents;
  }

  @override
  int get hashCode => Object.hash(bodyComponents, headerComponents);
}

/// The component builders used by the [MonthBody].
///
/// - Using these will override the respective default components.
class MonthBodyComponents {
  /// A function that builds the month grid widget.
  /// Null uses [MonthGrid].
  final MonthGridBuilder? monthGridBuilder;

  /// A function that builds the month day header widget.
  /// Null uses [MonthDayHeader].
  final MonthDayHeaderBuilder? monthDayHeaderBuilder;

  /// Builds the day number displayed by the month day header.
  ///
  /// Defaults to [DateTime.day].
  final DateStringBuilder? monthDayHeaderStringBuilder;

  /// A function that builds the background of each day cell.
  ///
  /// Called once per cell; use it to style individual days, e.g. to gray out
  /// days that fall outside the focused month. Null leaves the cell empty.
  final MonthDayCellBuilder? monthDayCellBuilder;

  /// A function that builds the week number widget.
  ///
  /// Null uses [WeekNumber].
  final WeekNumberBuilder? weekNumberBuilder;

  /// A function that returns the width of the week number column.
  ///
  /// Null uses [defaultWeekNumberWidth]. The month body and the month header
  /// both read the one value this returns, so a custom [weekNumberBuilder] wider
  /// than the default needs this set too.
  final WeekNumberWidthBuilder? weekNumberWidth;

  /// A function that builds the left trigger widget.
  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;

  /// A function that builds the right trigger widget.
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  /// A group of builders for the overlay widgets.
  final OverlayBuilders? overlayBuilders;

  /// Creates overrides for the default components used by the [MonthBody].
  const MonthBodyComponents({
    this.monthGridBuilder,
    this.monthDayHeaderBuilder,
    this.monthDayHeaderStringBuilder,
    this.monthDayCellBuilder,
    this.weekNumberBuilder,
    this.weekNumberWidth,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.overlayBuilders,
  });

  /// Builds the month grid, with [monthGridBuilder] when set.
  Widget buildMonthGrid(BuildContext context, int numberOfRows) {
    return monthGridBuilder?.call(context, numberOfRows) ?? MonthGrid(numberOfRows: numberOfRows);
  }

  /// Builds a month day header, with [monthDayHeaderBuilder] when set.
  Widget buildMonthDayHeader(BuildContext context, DateTime date) {
    return monthDayHeaderBuilder?.call(context, date) ?? MonthDayHeader(date: date);
  }

  /// Builds a day cell background, with [monthDayCellBuilder] when set.
  Widget buildMonthDayCell(BuildContext context, MonthDayCellDetails details) {
    return monthDayCellBuilder?.call(context, details) ?? const MonthDayCell();
  }

  /// Resolves the width of the week number column, with [weekNumberWidth] when set.
  double buildWeekNumberWidth(BuildContext context) {
    return weekNumberWidth?.call(context) ?? defaultWeekNumberWidth(context);
  }

  /// Builds a week number, with [weekNumberBuilder] when set.
  Widget buildWeekNumber(BuildContext context, KalenderDateTimeRange visibleDateTimeRange) {
    return weekNumberBuilder?.call(context, visibleDateTimeRange) ??
        WeekNumber(visibleDateTimeRange: visibleDateTimeRange);
  }

  /// Creates a copy of this with the given fields replaced.
  MonthBodyComponents copyWith({
    MonthGridBuilder? monthGridBuilder,
    MonthDayHeaderBuilder? monthDayHeaderBuilder,
    DateStringBuilder? monthDayHeaderStringBuilder,
    MonthDayCellBuilder? monthDayCellBuilder,
    WeekNumberBuilder? weekNumberBuilder,
    WeekNumberWidthBuilder? weekNumberWidth,
    HorizontalTriggerWidgetBuilder? leftTriggerBuilder,
    HorizontalTriggerWidgetBuilder? rightTriggerBuilder,
    OverlayBuilders? overlayBuilders,
  }) {
    return MonthBodyComponents(
      monthGridBuilder: monthGridBuilder ?? this.monthGridBuilder,
      monthDayHeaderBuilder: monthDayHeaderBuilder ?? this.monthDayHeaderBuilder,
      monthDayHeaderStringBuilder: monthDayHeaderStringBuilder ?? this.monthDayHeaderStringBuilder,
      monthDayCellBuilder: monthDayCellBuilder ?? this.monthDayCellBuilder,
      weekNumberBuilder: weekNumberBuilder ?? this.weekNumberBuilder,
      weekNumberWidth: weekNumberWidth ?? this.weekNumberWidth,
      leftTriggerBuilder: leftTriggerBuilder ?? this.leftTriggerBuilder,
      rightTriggerBuilder: rightTriggerBuilder ?? this.rightTriggerBuilder,
      overlayBuilders: overlayBuilders ?? this.overlayBuilders,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthBodyComponents &&
        other.monthGridBuilder == monthGridBuilder &&
        other.monthDayHeaderBuilder == monthDayHeaderBuilder &&
        other.monthDayHeaderStringBuilder == monthDayHeaderStringBuilder &&
        other.monthDayCellBuilder == monthDayCellBuilder &&
        other.weekNumberBuilder == weekNumberBuilder &&
        other.weekNumberWidth == weekNumberWidth &&
        other.leftTriggerBuilder == leftTriggerBuilder &&
        other.rightTriggerBuilder == rightTriggerBuilder &&
        other.overlayBuilders == overlayBuilders;
  }

  @override
  int get hashCode => Object.hash(
        monthGridBuilder,
        monthDayHeaderBuilder,
        monthDayHeaderStringBuilder,
        monthDayCellBuilder,
        weekNumberBuilder,
        weekNumberWidth,
        leftTriggerBuilder,
        rightTriggerBuilder,
        overlayBuilders,
      );
}

/// The component builders used by the [MonthHeader].
///
/// - Using these will override the respective default components.
class MonthHeaderComponents {
  /// A function that builds the week day header widget.
  /// Null uses [WeekDayHeader].
  final WeekDayHeaderBuilder? weekDayHeaderBuilder;

  /// Builds the day name displayed by the week day header.
  ///
  /// Defaults to the full day name in the calendar's locale.
  final DateStringBuilder? weekDayHeaderStringBuilder;

  /// Creates overrides for the default components used by the [MonthHeader].
  const MonthHeaderComponents({
    this.weekDayHeaderBuilder,
    this.weekDayHeaderStringBuilder,
  });

  /// Builds a week day header, with [weekDayHeaderBuilder] when set.
  Widget buildWeekDayHeader(BuildContext context, DateTime date) {
    return weekDayHeaderBuilder?.call(context, date) ?? WeekDayHeader(date: date);
  }

  /// Creates a copy of this with the given fields replaced.
  MonthHeaderComponents copyWith({
    WeekDayHeaderBuilder? weekDayHeaderBuilder,
    DateStringBuilder? weekDayHeaderStringBuilder,
  }) {
    return MonthHeaderComponents(
      weekDayHeaderBuilder: weekDayHeaderBuilder ?? this.weekDayHeaderBuilder,
      weekDayHeaderStringBuilder: weekDayHeaderStringBuilder ?? this.weekDayHeaderStringBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthHeaderComponents &&
        other.weekDayHeaderBuilder == weekDayHeaderBuilder &&
        other.weekDayHeaderStringBuilder == weekDayHeaderStringBuilder;
  }

  @override
  int get hashCode => Object.hash(weekDayHeaderBuilder, weekDayHeaderStringBuilder);
}
