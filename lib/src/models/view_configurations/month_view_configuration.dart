import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';

class MonthViewConfiguration extends ViewConfiguration {
  @override
  final PageNavigationFunctions pageNavigationFunctions;

  /// The start of the [displayRange].
  DateTime get start => displayRange.start;

  /// The end of the [displayRange].
  DateTime get end => displayRange.end;

  /// The first day of the week.
  final int firstDayOfWeek;

  /// The layout strategy used by the [MultiDayHeader] to layout events.
  final MultiDayEventLayoutStrategy eventLayoutStrategy;

  MonthViewConfiguration({
    required super.name,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
    required this.eventLayoutStrategy,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be between 1 and 7 (inclusive)\n'
          'Use DateTime.monday ~ DateTime.sunday if unsure.',
        );

  MonthViewConfiguration.singleMonth({
    super.name = 'Month',
    DateTimeRange? displayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
    this.eventLayoutStrategy = defaultMultiDayEventLayoutStrategy,
  }) : pageNavigationFunctions = PageNavigationFunctions.month(
          displayRange ?? DateTime.now().yearRange,
          firstDayOfWeek,
        );
}
