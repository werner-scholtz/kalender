import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/widgets/components/month_day_header.dart';
import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';

/// A class containing custom widget builders for the [MonthBody] and [MonthHeader].
class MonthComponents<T extends Object?> {
  final MonthBodyComponents<T>? bodyComponents;
  final MonthHeaderComponents<T>? headerComponents;

  MonthComponents({this.bodyComponents, this.headerComponents});
}

/// The component builders used by the [MonthBody].
///
/// - Using these will override the respective default components.
class MonthBodyComponents<T extends Object?> {
  /// A function that builds the month grid widget.
  final MonthGridBuilder? monthGridBuilder;

  /// A function that builds the month day header widget.
  final MonthDayHeaderBuilder? monthDayHeaderBuilder;

  /// A function that builds the left trigger widget.
  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;

  /// A function that builds the right trigger widget.
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  final OverlayBuilders<T>? overlayBuilders;

  /// Creates overrides for the default components used by the [MonthBody].
  const MonthBodyComponents({
    this.monthGridBuilder,
    this.monthDayHeaderBuilder,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.overlayBuilders,
  });
}

/// The component builders used by the [MonthHeader].
///
/// - Using these will override the respective default components.
class MonthHeaderComponents<T extends Object?> {
  /// A function that builds the week day header widget.
  final WeekDayHeaderBuilder? weekDayHeaderBuilder;

  /// Creates overrides for the default components used by the [MonthHeader].
  const MonthHeaderComponents({this.weekDayHeaderBuilder});
}
