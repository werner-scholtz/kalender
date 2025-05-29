import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';

/// The type of the schedule view.
enum ScheduleViewType {
  /// A continuous schedule view.
  continuous,

  /// A paginated schedule view.
  paginated,
}

/// The default behavior for empty days in the schedule view.
enum EmptyDayBehavior {
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

  ScheduleViewConfiguration({
    required super.name,
    required this.viewType,
    required this.pageNavigationFunctions,
  });

  /// Creates a continuous [ScheduleViewConfiguration].
  ScheduleViewConfiguration.continuous({
    super.name = 'Schedule (continuous)',
    DateTimeRange? displayRange,
  })  : pageNavigationFunctions = PageNavigationFunctions.scheduleContinuous(displayRange ?? DateTime.now().yearRange),
        viewType = ScheduleViewType.continuous;

  /// Creates a paginated [ScheduleViewConfiguration].
  ScheduleViewConfiguration.paginated({
    super.name = 'Schedule (paginated)',
    DateTimeRange? displayRange,
  })  : pageNavigationFunctions = PageNavigationFunctions.schedulePaginated(displayRange ?? DateTime.now().yearRange),
        viewType = ScheduleViewType.paginated;
}

class ScheduleBodyConfiguration {
  /// Creates a new [ScheduleBodyConfiguration].
  ScheduleBodyConfiguration({
    this.emptyDay = kDefaultEmptyDayBehavior,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.scrollPhysics,
    this.pageScrollPhysics,
  })  : pageTriggerConfiguration = pageTriggerConfiguration ?? PageTriggerConfiguration(),
        scrollTriggerConfiguration = scrollTriggerConfiguration ?? ScrollTriggerConfiguration();

  /// The behavior of empty days in the schedule view.
  /// - [EmptyDayBehavior.show]: Show empty days in the schedule view.
  /// - [EmptyDayBehavior.showToday]: Show today in the schedule view.
  /// - [EmptyDayBehavior.hide]: Hide empty days in the schedule view.
  final EmptyDayBehavior emptyDay;

  /// The configuration for the page navigation triggers.
  final PageTriggerConfiguration pageTriggerConfiguration;

  /// The configuration for the scroll navigation triggers.
  final ScrollTriggerConfiguration scrollTriggerConfiguration;

  
  /// The [ScrollPhysics] used by the scrollable body.
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;
}
