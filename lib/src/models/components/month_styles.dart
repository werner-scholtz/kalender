import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/widgets/components/month_day_header.dart';
import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';
import 'package:kalender/src/widgets/components/week_number.dart';
import 'package:kalender/src/widgets/month/month_body.dart';
import 'package:kalender/src/widgets/month/month_header.dart';

/// A class containing styles for the [MonthBody] and [MonthHeader].
class MonthComponentStyles {
  /// The styles of the default components used by the [MonthHeader].
  final MonthBodyComponentStyles bodyStyles;

  /// The styles of the default components used by the [MonthBody].
  final MonthHeaderComponentStyles headerStyles;

  const MonthComponentStyles({
    this.bodyStyles = const MonthBodyComponentStyles(),
    this.headerStyles = const MonthHeaderComponentStyles(),
  });

  /// Creates a copy of this with the given fields replaced.
  MonthComponentStyles copyWith({
    MonthBodyComponentStyles? bodyStyles,
    MonthHeaderComponentStyles? headerStyles,
  }) {
    return MonthComponentStyles(
      bodyStyles: bodyStyles ?? this.bodyStyles,
      headerStyles: headerStyles ?? this.headerStyles,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthComponentStyles && other.bodyStyles == bodyStyles && other.headerStyles == headerStyles;
  }

  @override
  int get hashCode => Object.hash(bodyStyles, headerStyles);
}

/// The styles of the default components used by the [MonthBody].
class MonthBodyComponentStyles {
  /// The style of the month grid.
  final MonthGridStyle monthGridStyle;

  /// The style of the day header.
  final MonthDayHeaderStyle monthDayHeaderStyle;

  /// The style of the week number.
  final WeekNumberStyle weekNumberStyle;

  /// The styles of the overlay components.
  final OverlayStyles? overlayStyles;

  /// Creates a override(s) for the default styles used by the [MonthBody].
  const MonthBodyComponentStyles({
    this.monthGridStyle = const MonthGridStyle(),
    this.monthDayHeaderStyle = const MonthDayHeaderStyle(),
    this.weekNumberStyle = const WeekNumberStyle(),
    this.overlayStyles,
  });

  /// Creates a copy of this with the given fields replaced.
  MonthBodyComponentStyles copyWith({
    MonthGridStyle? monthGridStyle,
    MonthDayHeaderStyle? monthDayHeaderStyle,
    WeekNumberStyle? weekNumberStyle,
    OverlayStyles? overlayStyles,
  }) {
    return MonthBodyComponentStyles(
      monthGridStyle: monthGridStyle ?? this.monthGridStyle,
      monthDayHeaderStyle: monthDayHeaderStyle ?? this.monthDayHeaderStyle,
      weekNumberStyle: weekNumberStyle ?? this.weekNumberStyle,
      overlayStyles: overlayStyles ?? this.overlayStyles,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthBodyComponentStyles &&
        other.monthGridStyle == monthGridStyle &&
        other.monthDayHeaderStyle == monthDayHeaderStyle &&
        other.weekNumberStyle == weekNumberStyle &&
        other.overlayStyles == overlayStyles;
  }

  @override
  int get hashCode => Object.hash(monthGridStyle, monthDayHeaderStyle, weekNumberStyle, overlayStyles);
}

/// The styles of the default components used by the [MonthHeader].
class MonthHeaderComponentStyles {
  /// The style of the week day header.
  final WeekDayHeaderStyle weekDayHeaderStyle;

  /// Creates a override(s) for the default styles used by the [MonthHeader].
  const MonthHeaderComponentStyles({this.weekDayHeaderStyle = const WeekDayHeaderStyle()});

  /// Creates a copy of this with the given fields replaced.
  MonthHeaderComponentStyles copyWith({WeekDayHeaderStyle? weekDayHeaderStyle}) {
    return MonthHeaderComponentStyles(weekDayHeaderStyle: weekDayHeaderStyle ?? this.weekDayHeaderStyle);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthHeaderComponentStyles && other.weekDayHeaderStyle == weekDayHeaderStyle;
  }

  @override
  int get hashCode => weekDayHeaderStyle.hashCode;
}
