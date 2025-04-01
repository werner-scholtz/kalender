import 'package:flutter/material.dart';
import 'package:kalender/src/models/time_of_day_range.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/month_day_header.dart';
import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';
import 'package:kalender/src/widgets/components/week_number.dart';

/// Widget builders ///


/// The hour lines builder.
///
/// The [heightPerMinute] is the height of each minute.
/// The [timeOfDayRange] is the range of time that the hour lines will be displayed for.
/// The [style] is used to style the hour lines.
typedef HourLinesBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
  HourLinesStyle? style,
);

/// The time line builder.
///
/// The [heightPerMinute] is the height of each minute.
/// The [timeOfDayRange] is the range of time that the time line will be displayed for.
/// The [style] is used to style the time line.
typedef TimeLineBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
  TimelineStyle? style,
);

/// The prototype time line builder.
///
/// The [heightPerMinute] is the height of each minute.
/// The [timeOfDayRange] is the range of time that the time line will be displayed for.
/// The [style] is used to style the time line.
typedef PrototypeTimeLineBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
  TimelineStyle? style,
);

/// The day separator builder.
///
/// The [style] is used to style the day separator.
typedef DaySeparatorBuilder = Widget Function(
  DaySeparatorStyle? style,
);

/// The time indicator builder.
///
/// The [timeOfDayRange] is the range of time that the time indicator will be displayed for.
/// The [heightPerMinute] is the height of each minute.
/// The [timelineWidth] is the width of the timeline.
/// The [style] is used to style the time indicator.
typedef TimeIndicatorBuilder = Widget Function(
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double timelineWidth,
  TimeIndicatorStyle? style,
);

/// The day header builder.
///
/// The [date] is the date that the header will be displayed for.
/// The [style] is used to style the day header.
typedef DayHeaderBuilder = Widget Function(
  DateTime date,
  DayHeaderStyle? style,
);

/// The week number builder.
///
/// The [visibleDateTimeRange] is the range of dates that the week number will be displayed for.
/// The [style] is used to style the week number.
typedef WeekNumberBuilder = Widget Function(
  DateTimeRange visibleDateTimeRange,
  WeekNumberStyle? style,
);

/// The week day header builder.
///
/// The [date] is the date that the header will be displayed for.
/// The [style] is used to style the week day header.
typedef WeekDayHeaderBuilder = Widget Function(
  DateTime date,
  WeekDayHeaderStyle? style,
);

/// The month grid builder.
///
/// The [style] is used to style the month grid.
typedef MonthGridBuilder = Widget Function(
  MonthGridStyle? style,
  int numberOfRows,
);

/// The month day header builder.
typedef MonthDayHeaderBuilder = Widget Function(
  DateTime date,
  MonthDayHeaderStyle? style,
);

/// The trigger widget builder, should be constrained in width.
///
/// The [pageWidth] is the width of the page.
typedef HorizontalTriggerWidgetBuilder = Widget Function(
  double pageWidth,
);

/// The trigger widget builder, should be constrained in height.
///
/// The [viewPortHeight] is the height of the page.
typedef VerticalTriggerWidgetBuilder = Widget Function(
  double viewPortHeight,
);
