import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [MonthViewConfiguration]s.
abstract class MonthViewConfiguration implements ViewConfiguration {
  const MonthViewConfiguration();

  /// The duration of one vertical step.
  Duration get verticalDurationStep;

  /// The duration of one horizontal step.
  Duration get horizontalDurationStep;

  /// The first day of the week.
  int get firstDayOfWeek;
}
