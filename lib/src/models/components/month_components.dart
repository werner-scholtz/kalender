import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/models/components/string_builders.dart';
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
  final MonthGridBuilder monthGridBuilder;

  /// A function that builds the month day header widget.
  final MonthDayHeaderBuilder monthDayHeaderBuilder;

  /// Builds the day number displayed by the month day header.
  ///
  /// Defaults to [DateTime.day].
  final DateStringBuilder? monthDayHeaderStringBuilder;

  /// A function that builds the background of each day cell.
  ///
  /// Called once per cell; use it to style individual days, e.g. to gray out
  /// days that fall outside the focused month. Defaults to an empty cell.
  final MonthDayCellBuilder monthDayCellBuilder;

  /// A function that builds the week number widget.
  final WeekNumberBuilder weekNumberBuilder;

  /// A function that builds the left trigger widget.
  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;

  /// A function that builds the right trigger widget.
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  /// A group of builders for the overlay widgets.
  final OverlayBuilders? overlayBuilders;

  /// Creates overrides for the default components used by the [MonthBody].
  const MonthBodyComponents({
    this.monthGridBuilder = MonthGrid.builder,
    this.monthDayHeaderBuilder = MonthDayHeader.builder,
    this.monthDayHeaderStringBuilder,
    this.monthDayCellBuilder = MonthDayCell.builder,
    this.weekNumberBuilder = WeekNumber.builder,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.overlayBuilders,
  });

  /// Creates a copy of this with the given fields replaced.
  MonthBodyComponents copyWith({
    MonthGridBuilder? monthGridBuilder,
    MonthDayHeaderBuilder? monthDayHeaderBuilder,
    DateStringBuilder? monthDayHeaderStringBuilder,
    MonthDayCellBuilder? monthDayCellBuilder,
    WeekNumberBuilder? weekNumberBuilder,
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
  final WeekDayHeaderBuilder weekDayHeaderBuilder;

  /// Builds the day name displayed by the week day header.
  ///
  /// Defaults to the full day name in the calendar's locale.
  final DateStringBuilder? weekDayHeaderStringBuilder;

  /// Creates overrides for the default components used by the [MonthHeader].
  const MonthHeaderComponents({
    this.weekDayHeaderBuilder = WeekDayHeader.builder,
    this.weekDayHeaderStringBuilder,
  });

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
