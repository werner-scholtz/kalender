import 'package:kalender/kalender.dart';
import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/components/week_day_header.dart';

/// The component builders used by the [MonthBody].
///
/// - Using these will override the respective default components.
class MonthBodyComponents {
  const MonthBodyComponents();
}

/// The styles of the default components used by the [MonthBody].
class MonthBodyComponentStyles {
  const MonthBodyComponentStyles();
}

/// The component builders used by the [MonthHeader].
///
/// - Using these will override the respective default components.
class MonthHeaderComponents {
  final WeekDayHeaderBuilder? weekDayHeaderBuilder;

  const MonthHeaderComponents({
    this.weekDayHeaderBuilder,
  });
}

/// The styles of the default components used by the [MonthHeader].
class MonthHeaderComponentStyles {
  final WeekDayHeaderStyle? weekDayHeaderStyle;

  const MonthHeaderComponentStyles({
    this.weekDayHeaderStyle,
  });
}
