import 'package:flutter/material.dart';
import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';

/// The component builders used by the [MultiDayHeader].
///
/// - Using these will override the respective default components.
class MultiDayHeaderComponents {
  final DayHeaderBuilder? dayHeaderBuilder;
  final WeekNumberBuilder? weekNumberBuilder;

  final Widget? leftPageTriggerWidget;
  final Widget? rightPageTriggerWidget;

  const MultiDayHeaderComponents({
    this.dayHeaderBuilder,
    this.weekNumberBuilder,
    this.leftPageTriggerWidget,
    this.rightPageTriggerWidget,
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

  final Widget? leftPageTriggerWidget;
  final Widget? rightPageTriggerWidget;
  final Widget? topScrollTriggerWidget;
  final Widget? bottomScrollTriggerWidget;

  const MultiDayBodyComponents({
    this.hourLines,
    this.timeline,
    this.daySeparator,
    this.timeIndicator,
    this.leftPageTriggerWidget,
    this.rightPageTriggerWidget,
    this.topScrollTriggerWidget,
    this.bottomScrollTriggerWidget,
  });
}
