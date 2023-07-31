import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [ViewType.month]
abstract class MonthViewConfiguration implements ViewConfiguration {
  const MonthViewConfiguration();

  // @override
  // final ViewType viewType = ViewType.month;

  Duration get verticalDurationStep;

  Duration get horizontalDurationStep;
}
