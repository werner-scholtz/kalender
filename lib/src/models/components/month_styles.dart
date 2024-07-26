import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';
import 'package:kalender/src/widgets/month/month_body.dart';
import 'package:kalender/src/widgets/month/month_header.dart';


/// The styles of the default components used by the [MonthBody].
class MonthBodyComponentStyles {
  /// The style of the month grid.
  final MonthGridStyle? monthGridStyle;

  /// Creates a override(s) for the default styles used by the [MonthBody].
  const MonthBodyComponentStyles({this.monthGridStyle});
}

/// The styles of the default components used by the [MonthHeader].
class MonthHeaderComponentStyles {
  /// The style of the week day header.
  final WeekDayHeaderStyle? weekDayHeaderStyle;

  /// Creates a override(s) for the default styles used by the [MonthHeader].
  const MonthHeaderComponentStyles({this.weekDayHeaderStyle});
}
