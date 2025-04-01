import 'package:kalender/src/models/components/components.dart';
import 'package:kalender/src/widgets/components/month_day_header.dart';
import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';
import 'package:kalender/src/widgets/month/month_body.dart';
import 'package:kalender/src/widgets/month/month_header.dart';

/// A class containing styles for the [MonthBody] and [MonthHeader].
class MonthComponentStyles {
  final MonthBodyComponentStyles? bodyStyles;
  final MonthHeaderComponentStyles? headerStyles;

  MonthComponentStyles({this.bodyStyles, this.headerStyles});
}

/// The styles of the default components used by the [MonthBody].
class MonthBodyComponentStyles {
  /// The style of the month grid.
  final MonthGridStyle? monthGridStyle;

  /// The style of the day header.
  final MonthDayHeaderStyle? monthDayHeaderStyle;

  /// The styles of the overlay components.
  final OverlayStyles? overlayStyles; 

  /// Creates a override(s) for the default styles used by the [MonthBody].
  const MonthBodyComponentStyles({
    this.monthGridStyle,
    this.monthDayHeaderStyle,
    this.overlayStyles,
  });
}

/// The styles of the default components used by the [MonthHeader].
class MonthHeaderComponentStyles {
  /// The style of the week day header.
  final WeekDayHeaderStyle? weekDayHeaderStyle;

  /// Creates a override(s) for the default styles used by the [MonthHeader].
  const MonthHeaderComponentStyles({this.weekDayHeaderStyle});
}
