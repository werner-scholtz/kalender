import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/week_number.dart';

import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';

/// The component builders used by the [MultiDayHeader].
///
/// - Using these will override the respective default components.
class MultiDayHeaderComponentBuilders {
  final DayHeaderBuilder? dayHeaderBuilder;
  final WeekNumberBuilder? weekNumberBuilder;

  const MultiDayHeaderComponentBuilders({
    this.dayHeaderBuilder,
    this.weekNumberBuilder,
  });
}

/// The styles of the default components used by the [MultiDayHeader].
class MultiDayHeaderComponentStyles {
  final DayHeaderStyle? dayHeaderStyle;
  final WeekNumberStyle? weekNumberStyle;

  const MultiDayHeaderComponentStyles({
    this.dayHeaderStyle,
    this.weekNumberStyle,
  });
}
