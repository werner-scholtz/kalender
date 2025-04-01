import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/components/week_number.dart';

/// A class containing custom widget builders for the [MultiDayBody] and [MultiDayHeader].
class MultiDayComponents<T extends Object?> {
  final MultiDayHeaderComponents<T>? headerComponents;
  final MultiDayBodyComponents<T>? bodyComponents;

  MultiDayComponents({this.bodyComponents, this.headerComponents});
}

/// The component builders used by the [MultiDayHeader].
///
/// - Using these will override the respective default components.
class MultiDayHeaderComponents<T> {
  final DayHeaderBuilder? dayHeaderBuilder;
  final WeekNumberBuilder? weekNumberBuilder;
  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;
  final OverlayBuilders<T>? overlayBuilders;

  /// Creates overrides for the default components used by the [MultiDayHeader].
  const MultiDayHeaderComponents({
    this.dayHeaderBuilder,
    this.weekNumberBuilder,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.overlayBuilders,
  });
}

/// The component builders used by the [MultiDayBody].
///
/// - Using these will override the respective default components.
class MultiDayBodyComponents<T> {
  final HourLinesBuilder? hourLines;
  final TimeLineBuilder? timeline;
  final PrototypeTimeLineBuilder? prototypeTimeLine;
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
    this.prototypeTimeLine,
    this.daySeparator,
    this.timeIndicator,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.topTriggerBuilder,
    this.bottomTriggerBuilder,
  });
}
