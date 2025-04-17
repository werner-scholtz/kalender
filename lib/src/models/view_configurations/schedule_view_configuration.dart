import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';

enum ScheduleViewType {
  /// A continuous schedule view.
  continuous,

  /// A paginated schedule view.
  paginated,
}

class ScheduleViewConfiguration<T extends Object?> extends ViewConfiguration {
  @override
  final PageNavigationFunctions pageNavigationFunctions;

  /// The type of the schedule view.
  final ScheduleViewType viewType;

  ScheduleViewConfiguration({
    required super.name,
    required this.viewType,
    required this.pageNavigationFunctions,
  });

  /// Creates a continuous [ScheduleViewConfiguration].
  ScheduleViewConfiguration.continuous({
    super.name = 'Schedule (continuous)',
    DateTimeRange? displayRange,
    this.viewType = ScheduleViewType.continuous,
  }) : pageNavigationFunctions = PageNavigationFunctions.singleDay(displayRange ?? DateTime.now().yearRange);

  /// Creates a paginated [ScheduleViewConfiguration].
  ScheduleViewConfiguration.paginated({
    super.name = 'Schedule (paginated)',
    DateTimeRange? displayRange,
    this.viewType = ScheduleViewType.paginated,
  }) : pageNavigationFunctions = PageNavigationFunctions.singleDay(displayRange ?? DateTime.now().yearRange);
}
