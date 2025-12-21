import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/components/week_number.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_body.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';

/// A class containing custom widget builders for the [MultiDayBody] and [MultiDayHeader].
class MultiDayComponents {
  /// The component builders used by the [MultiDayBody].
  final MultiDayHeaderComponents headerComponents;

  /// The component builders used by the [MultiDayHeader].
  final MultiDayBodyComponents bodyComponents;

  const MultiDayComponents({
    this.bodyComponents = const MultiDayBodyComponents(),
    this.headerComponents = const MultiDayHeaderComponents(),
  });
}

/// The component builders used by the [MultiDayHeader].
///
/// - Using these will override the respective default components.
class MultiDayHeaderComponents {
  /// A function that builds the day header widget.
  final DayHeaderBuilder dayHeaderBuilder;

  /// A function that builds the week number widget.
  final WeekNumberBuilder weekNumberBuilder;

  /// A function that builds the left trigger widget.
  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;

  /// A function that builds the right trigger widget.
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  /// A group of builders for the overlay widgets.
  final OverlayBuilders? overlayBuilders;

  /// Creates overrides for the default components used by the [MultiDayHeader].
  const MultiDayHeaderComponents({
    this.dayHeaderBuilder = DayHeader.builder,
    this.weekNumberBuilder = WeekNumber.builder,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.overlayBuilders,
  });
}

/// The component builders used by the [MultiDayBody].
///
/// - Using these will override the respective default components.
class MultiDayBodyComponents {
  /// A function that builds the hour lines widget.
  final HourLinesBuilder hourLines;

  /// A function that builds the timeline widget.
  ///
  /// If you override this, you must ensure that you also override the [prototypeTimeLine] builder,
  /// and ensure that the two widgets resolve to the same width.
  /// Otherwise, you might encounter alignment issues between the header and body.
  final TimeLineBuilder timeline;

  /// A function that builds the prototype timeline widget.
  final PrototypeTimeLineBuilder prototypeTimeLine;

  /// A function that builds the day separator widget.
  final DaySeparatorBuilder daySeparator;

  /// A function that builds the time indicator widget.
  final TimeIndicatorBuilder timeIndicator;

  /// A function that builds the left trigger widget.
  final HorizontalTriggerWidgetBuilder? leftTriggerBuilder;

  /// A function that builds the right trigger widget.
  final HorizontalTriggerWidgetBuilder? rightTriggerBuilder;

  /// A function that builds the top trigger widget.
  final VerticalTriggerWidgetBuilder? topTriggerBuilder;

  /// A function that builds the bottom trigger widget.
  final VerticalTriggerWidgetBuilder? bottomTriggerBuilder;

  /// Creates overrides for the default components used by the [MultiDayBody].
  const MultiDayBodyComponents({
    this.hourLines = HourLines.builder,
    this.timeline = TimeLine.builder,
    this.prototypeTimeLine = PrototypeTimeline.prototypeBuilder,
    this.daySeparator = DaySeparator.builder,
    this.timeIndicator = TimeIndicator.builder,
    this.leftTriggerBuilder,
    this.rightTriggerBuilder,
    this.topTriggerBuilder,
    this.bottomTriggerBuilder,
  });
}
