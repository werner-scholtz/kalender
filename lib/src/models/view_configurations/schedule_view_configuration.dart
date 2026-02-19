import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/view_configurations/page_index_calculator.dart';

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

class ScheduleViewConfiguration extends ViewConfiguration {
  @override
  final PageIndexCalculator pageIndexCalculator;

  /// The type of the schedule view.
  final ScheduleViewType viewType;

  ScheduleViewConfiguration({
    required super.name,
    super.initialDateTime,
    super.initialDateSelectionStrategy,
    required this.viewType,
    required this.pageIndexCalculator,
  });

  /// Creates a continuous [ScheduleViewConfiguration].
  ScheduleViewConfiguration.continuous({
    super.name = 'Schedule (continuous)',
    super.initialDateTime,
    super.initialDateSelectionStrategy = kDefaultToSchedule,
    DateTimeRange? displayRange,
  })  : pageIndexCalculator = PageIndexCalculator.scheduleContinuous(displayRange ?? kDefaultRange()),
        viewType = ScheduleViewType.continuous;

  /// Creates a paginated [ScheduleViewConfiguration].
  ScheduleViewConfiguration.paginated({
    super.name = 'Schedule (paginated)',
    super.initialDateTime,
    super.initialDateSelectionStrategy = kDefaultToSchedule,
    DateTimeRange? displayRange,
  })  : pageIndexCalculator = PageIndexCalculator.schedulePaginated(displayRange ?? kDefaultRange()),
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

  /// Creates a copy of this [MultiDayHeaderConfiguration] with the given fields replaced by the new values.
  ScheduleBodyConfiguration copyWith({
    EmptyDayBehavior? emptyDay,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    ScrollPhysics? scrollPhysics,
    ScrollPhysics? pageScrollPhysics,
  }) {
    return ScheduleBodyConfiguration(
      emptyDay: emptyDay ?? this.emptyDay,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
      scrollTriggerConfiguration: scrollTriggerConfiguration ?? this.scrollTriggerConfiguration,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      pageScrollPhysics: pageScrollPhysics ?? this.pageScrollPhysics,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleBodyConfiguration &&
        other.emptyDay == emptyDay &&
        other.pageTriggerConfiguration == pageTriggerConfiguration &&
        other.scrollTriggerConfiguration == scrollTriggerConfiguration &&
        other.scrollPhysics == scrollPhysics &&
        other.pageScrollPhysics == pageScrollPhysics;
  }

  @override
  int get hashCode {
    return Object.hash(
      emptyDay,
      pageTriggerConfiguration,
      scrollTriggerConfiguration,
      scrollPhysics,
      pageScrollPhysics,
    );
  }
}
