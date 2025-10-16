import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/components/week_number.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_body.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';

/// A class containing styles for the [MultiDayBody] and [MultiDayHeader].
class MultiDayComponentStyles {
  /// The styles of the default components used by the [MultiDayHeader].
  final MultiDayHeaderComponentStyles headerStyles;

  /// The styles of the default components used by the [MultiDayBody].
  final MultiDayBodyComponentStyles bodyStyles;

  const MultiDayComponentStyles({
    this.headerStyles = const MultiDayHeaderComponentStyles(),
    this.bodyStyles = const MultiDayBodyComponentStyles(),
  });
}

/// The styles of the default components used by the [MultiDayHeader].
class MultiDayHeaderComponentStyles {
  /// The styles of the day header.
  final DayHeaderStyle? dayHeaderStyle;

  /// The styles of the week number.
  final WeekNumberStyle? weekNumberStyle;

  /// The styles of the overlay widgets.
  final OverlayStyles? overlayStyles;

  /// Creates a override for the default styles used by the [MultiDayHeader].
  const MultiDayHeaderComponentStyles({
    this.dayHeaderStyle,
    this.weekNumberStyle,
    this.overlayStyles,
  });
}

/// The styles of the default components used by the [MultiDayBody].
class MultiDayBodyComponentStyles {
  /// The styles of the day separator.
  final DaySeparatorStyle? daySeparatorStyle;

  /// The styles of the time indicator.
  final TimeIndicatorStyle? timeIndicatorStyle;

  /// The styles of the hour lines.
  final HourLinesStyle? hourLinesStyle;

  /// The styles of the timeline.
  final TimelineStyle? timelineStyle;

  /// Creates a override for the default styles used by the [MultiDayBody].
  const MultiDayBodyComponentStyles({
    this.daySeparatorStyle,
    this.timeIndicatorStyle,
    this.hourLinesStyle,
    this.timelineStyle,
  });
}
