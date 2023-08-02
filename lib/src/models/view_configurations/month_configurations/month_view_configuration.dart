import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [ViewType.month]
abstract class MonthViewConfiguration implements ViewConfiguration {
  const MonthViewConfiguration();

  Duration get verticalDurationStep;

  Duration get horizontalDurationStep;

  /// The first day of the week.
  int get firstDayOfWeek;
}
