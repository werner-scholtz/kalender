import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_body.dart';

/// A class containing custom widget builders for the [MultiDayBody] and [MultiDayHeader].
class MultiDayComponents {
  final MultiDayHeaderComponents? headerComponents;
  final MultiDayBodyComponents? bodyComponents;

  MultiDayComponents({this.bodyComponents, this.headerComponents});
}

/// The component builders used by the [MultiDayHeader].
///
/// - Using these will override the respective default components.
class MultiDayHeaderComponents {
  final DayHeaderBuilder? dayHeaderBuilder;
  final WeekNumberBuilder? weekNumberBuilder;

  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  /// Creates overrides for the default components used by the [MultiDayHeader].
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

  /// Creates overrides for the default components used by the [MultiDayBody].
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
