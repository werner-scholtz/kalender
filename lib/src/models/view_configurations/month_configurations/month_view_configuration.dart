import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [MonthViewConfiguration]s.
abstract class MonthViewConfiguration implements ViewConfiguration {
  const MonthViewConfiguration();

  /// The duration of one vertical step.
  Duration get verticalStepDuration;

  /// The duration of one horizontal step.
  Duration get horizontalStepDuration;

  /// The first day of the week.
  int get firstDayOfWeek;

  /// Whether the events can be resized.
  bool get enableResizing;

  /// The height of the multiDay tiles.
  double get multiDayTileHeight;

  bool get createMultiDayEvents;
}
