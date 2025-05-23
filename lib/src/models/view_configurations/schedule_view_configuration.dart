import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';

enum ScheduleViewType {
  /// A continuous schedule view.
  continuous,

  /// A paginated schedule view.
  paginated,
}

enum EmptyDaysBehavior {
  /// Show empty days in the schedule view.
  show,

  /// Show today in the schedule view, even if it does not have any events.
  showToday,

  /// Hide empty days in the schedule view.
  hide,
}

class ScheduleViewConfiguration<T extends Object?> extends ViewConfiguration {
  @override
  final PageNavigationFunctions pageNavigationFunctions;

  /// The type of the schedule view.
  final ScheduleViewType viewType;

  /// The behavior of empty days in the schedule view.
  /// - [EmptyDaysBehavior.show]: Show empty days in the schedule view.
  /// - [EmptyDaysBehavior.showToday]: Show today in the schedule view.
  /// - [EmptyDaysBehavior.hide]: Hide empty days in the schedule view.
  final EmptyDaysBehavior emptyDays;

  ScheduleViewConfiguration({
    required super.name,
    required this.viewType,
    required this.pageNavigationFunctions,
    this.emptyDays = EmptyDaysBehavior.showToday,
  });

  /// Creates a continuous [ScheduleViewConfiguration].
  ScheduleViewConfiguration.continuous({
    super.name = 'Schedule (continuous)',
    DateTimeRange? displayRange,
    this.emptyDays = kDefaultEmptyDayBehavior,
  })  : pageNavigationFunctions = PageNavigationFunctions.scheduleContinuous(displayRange ?? DateTime.now().yearRange),
        viewType = ScheduleViewType.continuous;

  /// Creates a paginated [ScheduleViewConfiguration].
  ScheduleViewConfiguration.paginated({
    super.name = 'Schedule (paginated)',
    DateTimeRange? displayRange,
    this.emptyDays = kDefaultEmptyDayBehavior,
  })  : pageNavigationFunctions = PageNavigationFunctions.schedulePaginated(displayRange ?? DateTime.now().yearRange),
        viewType = ScheduleViewType.paginated;
}
