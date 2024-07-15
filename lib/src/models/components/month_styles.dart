import 'package:kalender/src/widgets/components/month_grid.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';

/// The styles of the default components used by the [MonthBody].
class MonthBodyComponentStyles {
  final MonthGridStyle? monthGridStyle;

  const MonthBodyComponentStyles({
    this.monthGridStyle,
  });
}

/// The styles of the default components used by the [MonthHeader].
class MonthHeaderComponentStyles {
  final WeekDayHeaderStyle? weekDayHeaderStyle;

  const MonthHeaderComponentStyles({
    this.weekDayHeaderStyle,
  });
}
