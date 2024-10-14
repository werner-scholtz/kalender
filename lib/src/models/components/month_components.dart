import 'package:kalender/kalender.dart';
import 'package:kalender/src/type_definitions.dart';

class MonthComponents {
  final MonthBodyComponents bodyComponents;
  final MonthHeaderComponents headerComponents;

  MonthComponents({
    required this.bodyComponents,
    required this.headerComponents,
  });
}

/// The component builders used by the [MonthBody].
///
/// - Using these will override the respective default components.
class MonthBodyComponents {
  /// A function that builds the month grid widget.
  final MonthGridBuilder? monthGridBuilder;

  /// A function that builds the left trigger widget.
  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;

  /// A function that builds the right trigger widget.
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  /// Creates overrides for the default components used by the [MonthBody].
  const MonthBodyComponents({
    this.monthGridBuilder,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
  });
}

/// The component builders used by the [MonthHeader].
///
/// - Using these will override the respective default components.
class MonthHeaderComponents {
  /// A function that builds the week day header widget.
  final WeekDayHeaderBuilder? weekDayHeaderBuilder;

  /// Creates overrides for the default components used by the [MonthHeader].
  const MonthHeaderComponents({this.weekDayHeaderBuilder});
}
