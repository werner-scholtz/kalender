import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/widgets/components/month_day_header.dart';
import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';
import 'package:kalender/src/widgets/month/month_body.dart';
import 'package:kalender/src/widgets/month/month_header.dart';

/// A class containing custom widget builders for the [MonthBody] and [MonthHeader].
class MonthComponents<T extends Object?> {
  /// The component builders used by the [MonthBody].
  final MonthBodyComponents<T>? bodyComponents;

  /// The component builders used by the [MonthHeader].
  final MonthHeaderComponents<T>? headerComponents;

  MonthComponents({this.bodyComponents, this.headerComponents});
}

/// The component builders used by the [MonthBody].
///
/// - Using these will override the respective default components.
class MonthBodyComponents<T extends Object?> {
  /// A function that builds the month grid widget.
  final MonthGridBuilder monthGridBuilder;

  /// A function that builds the month day header widget.
  final MonthDayHeaderBuilder monthDayHeaderBuilder;

  /// A function that builds the left trigger widget.
  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;

  /// A function that builds the right trigger widget.
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  /// A group of builders for the overlay widgets.
  final OverlayBuilders<T>? overlayBuilders;

  /// Creates overrides for the default components used by the [MonthBody].
  const MonthBodyComponents({
    this.monthGridBuilder = MonthGrid.builder,
    this.monthDayHeaderBuilder = MonthDayHeader.builder,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.overlayBuilders,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthBodyComponents<T> &&
        other.monthGridBuilder == monthGridBuilder &&
        other.monthDayHeaderBuilder == monthDayHeaderBuilder &&
        other.leftTriggerBuilder == leftTriggerBuilder &&
        other.rightTriggerBuilder == rightTriggerBuilder &&
        other.overlayBuilders == overlayBuilders;
  }

  @override
  int get hashCode => Object.hash(
        monthGridBuilder,
        monthDayHeaderBuilder,
        leftTriggerBuilder,
        rightTriggerBuilder,
        overlayBuilders,
      );
}

/// The component builders used by the [MonthHeader].
///
/// - Using these will override the respective default components.
class MonthHeaderComponents<T extends Object?> {
  /// A function that builds the week day header widget.
  final WeekDayHeaderBuilder weekDayHeaderBuilder;

  /// Creates overrides for the default components used by the [MonthHeader].
  const MonthHeaderComponents({
    this.weekDayHeaderBuilder = WeekDayHeader.builder,
  });
}
