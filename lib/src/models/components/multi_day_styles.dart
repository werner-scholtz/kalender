import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/components/week_number.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_body.dart';

/// A class containing styles for the [MultiDayBody] and [MultiDayHeader].
class MultiDayComponentStyles {
  final MultiDayHeaderComponentStyles? headerStyles;
  final MultiDayBodyComponentStyles? bodyStyles;

  MultiDayComponentStyles({this.headerStyles, this.bodyStyles});
}

/// The styles of the default components used by the [MultiDayHeader].
class MultiDayHeaderComponentStyles {
  final DayHeaderStyle? dayHeaderStyle;
  final WeekNumberStyle? weekNumberStyle;

  /// Creates a override for the default styles used by the [MultiDayHeader].
  const MultiDayHeaderComponentStyles({this.dayHeaderStyle, this.weekNumberStyle});
}

/// The styles of the default components used by the [MultiDayBody].
class MultiDayBodyComponentStyles {
  final DaySeparatorStyle? daySeparatorStyle;
  final TimeIndicatorStyle? timeIndicatorStyle;
  final HourLinesStyle? hourLinesStyle;
  final TimelineStyle? timelineStyle;

  /// Creates a override for the default styles used by the [MultiDayBody].
  const MultiDayBodyComponentStyles({
    this.daySeparatorStyle,
    this.timeIndicatorStyle,
    this.hourLinesStyle,
    this.timelineStyle,
  });
}
