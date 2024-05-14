import 'package:kalender/src/type_definitions.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';

import 'package:kalender/src/widgets/multi_day_view/multi_day_body.dart';

/// The component builders used by the [MultiDayBody].
///
/// - Using these will override the respective default components.
class MultiDayBodyComponents {
  final HourLinesBuilder? hourLines;
  final TimeLineBuilder? timeline;
  final DaySeparatorBuilder? daySeparator;
  final TimeIndicatorBuilder? timeIndicator;

  const MultiDayBodyComponents({
    this.hourLines,
    this.timeline,
    this.daySeparator,
    this.timeIndicator,
  });
}

/// The styles of the default components used by the [MultiDayBody].
class MultiDayBodyComponentStyles {
  final DaySeparatorStyle? daySeparatorStyle;
  final TimeIndicatorStyle? timeIndicatorStyle;
  final HourLinesStyle? hourLinesStyle;
  final TimelineStyle? timelineStyle;

  const MultiDayBodyComponentStyles({
    this.daySeparatorStyle,
    this.timeIndicatorStyle,
    this.hourLinesStyle,
    this.timelineStyle,
  });
}
