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

  /// Creates a copy of this with the given fields replaced.
  MultiDayComponentStyles copyWith({
    MultiDayHeaderComponentStyles? headerStyles,
    MultiDayBodyComponentStyles? bodyStyles,
  }) {
    return MultiDayComponentStyles(
      headerStyles: headerStyles ?? this.headerStyles,
      bodyStyles: bodyStyles ?? this.bodyStyles,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayComponentStyles && other.headerStyles == headerStyles && other.bodyStyles == bodyStyles;
  }

  @override
  int get hashCode => Object.hash(headerStyles, bodyStyles);
}

/// The styles of the default components used by the [MultiDayHeader].
class MultiDayHeaderComponentStyles {
  /// The styles of the day header.
  final DayHeaderStyle dayHeaderStyle;

  /// The styles of the week number.
  final WeekNumberStyle weekNumberStyle;

  /// The styles of the overlay widgets.
  final OverlayStyles? overlayStyles;

  /// Creates a override for the default styles used by the [MultiDayHeader].
  const MultiDayHeaderComponentStyles({
    this.dayHeaderStyle = const DayHeaderStyle(),
    this.weekNumberStyle = const WeekNumberStyle(),
    this.overlayStyles,
  });

  /// Creates a copy of this with the given fields replaced.
  MultiDayHeaderComponentStyles copyWith({
    DayHeaderStyle? dayHeaderStyle,
    WeekNumberStyle? weekNumberStyle,
    OverlayStyles? overlayStyles,
  }) {
    return MultiDayHeaderComponentStyles(
      dayHeaderStyle: dayHeaderStyle ?? this.dayHeaderStyle,
      weekNumberStyle: weekNumberStyle ?? this.weekNumberStyle,
      overlayStyles: overlayStyles ?? this.overlayStyles,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayHeaderComponentStyles &&
        other.dayHeaderStyle == dayHeaderStyle &&
        other.weekNumberStyle == weekNumberStyle &&
        other.overlayStyles == overlayStyles;
  }

  @override
  int get hashCode => Object.hash(dayHeaderStyle, weekNumberStyle, overlayStyles);
}

/// The styles of the default components used by the [MultiDayBody].
class MultiDayBodyComponentStyles {
  /// The styles of the day separator.
  final DaySeparatorStyle daySeparatorStyle;

  /// The styles of the time indicator.
  final TimeIndicatorStyle timeIndicatorStyle;

  /// The styles of the hour lines.
  final HourLinesStyle hourLinesStyle;

  /// The styles of the timeline.
  final TimelineStyle timelineStyle;

  /// Creates a override for the default styles used by the [MultiDayBody].
  const MultiDayBodyComponentStyles({
    this.daySeparatorStyle = const DaySeparatorStyle(),
    this.timeIndicatorStyle = const TimeIndicatorStyle(),
    this.hourLinesStyle = const HourLinesStyle(),
    this.timelineStyle = const TimelineStyle(),
  });

  /// Creates a copy of this with the given fields replaced.
  MultiDayBodyComponentStyles copyWith({
    DaySeparatorStyle? daySeparatorStyle,
    TimeIndicatorStyle? timeIndicatorStyle,
    HourLinesStyle? hourLinesStyle,
    TimelineStyle? timelineStyle,
  }) {
    return MultiDayBodyComponentStyles(
      daySeparatorStyle: daySeparatorStyle ?? this.daySeparatorStyle,
      timeIndicatorStyle: timeIndicatorStyle ?? this.timeIndicatorStyle,
      hourLinesStyle: hourLinesStyle ?? this.hourLinesStyle,
      timelineStyle: timelineStyle ?? this.timelineStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayBodyComponentStyles &&
        other.daySeparatorStyle == daySeparatorStyle &&
        other.timeIndicatorStyle == timeIndicatorStyle &&
        other.hourLinesStyle == hourLinesStyle &&
        other.timelineStyle == timelineStyle;
  }

  @override
  int get hashCode => Object.hash(daySeparatorStyle, timeIndicatorStyle, hourLinesStyle, timelineStyle);
}
