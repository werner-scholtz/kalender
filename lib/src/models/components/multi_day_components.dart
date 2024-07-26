import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';

/// The component builders used by the [MultiDayHeader].
///
/// - Using these will override the respective default components.
class MultiDayHeaderComponents {
  final DayHeaderBuilder? dayHeaderBuilder;
  final WeekNumberBuilder? weekNumberBuilder;

  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  const MultiDayHeaderComponents({
    this.dayHeaderBuilder,
    this.weekNumberBuilder,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
  });
}

/// The component builders used by the [MultiDayBody].
///
/// - Using these will override the respective default components.
class MultiDayBodyComponents {
  final HourLinesBuilder? hourLines;
  final TimeLineBuilder? timeline;
  final DaySeparatorBuilder? daySeparator;
  final TimeIndicatorBuilder? timeIndicator;

  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;
  final VerticalTriggerWidgetBuilder? topTriggerBuilder;
  final VerticalTriggerWidgetBuilder? bottomTriggerBuilder;

  const MultiDayBodyComponents({
    this.hourLines,
    this.timeline,
    this.daySeparator,
    this.timeIndicator,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.topTriggerBuilder,
    this.bottomTriggerBuilder,
  });
}
