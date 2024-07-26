import 'package:kalender/kalender.dart';
import 'package:kalender/src/type_definitions.dart';

/// The component builders used by the [MonthBody].
///
/// - Using these will override the respective default components.
class MonthBodyComponents {
  final MonthGridBuilder? monthGridBuilder;

  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

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
  final WeekDayHeaderBuilder? weekDayHeaderBuilder;

  const MonthHeaderComponents({
    this.weekDayHeaderBuilder,
  });
}
