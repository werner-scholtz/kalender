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
  /// Show every empty day in the schedule view.
  show,

  /// Show only today when it has no events; all other empty days are hidden.
  showOnlyToday,

  /// Hide every empty day in the schedule view.
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
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    required this.viewType,
    required this.pageIndexCalculator,
  });

  /// Creates a continuous [ScheduleViewConfiguration].
  ScheduleViewConfiguration.continuous({
    super.name = 'Schedule (continuous)',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    DateTimeRange? displayRange,
  })  : pageIndexCalculator = PageIndexCalculator.scheduleContinuous(displayRange ?? kDefaultRange()),
        viewType = ScheduleViewType.continuous;

  /// Creates a paginated [ScheduleViewConfiguration].
  ScheduleViewConfiguration.paginated({
    super.name = 'Schedule (paginated)',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    DateTimeRange? displayRange,
  })  : pageIndexCalculator = PageIndexCalculator.schedulePaginated(displayRange ?? kDefaultRange()),
        viewType = ScheduleViewType.paginated;
}

/// The default width of the leading (date) column in the schedule view.
///
/// A fixed width keeps every row's event tile aligned regardless of whether the
/// row shows a date, and independent of the day name, day-number digits, locale,
/// or text scale.
const kDefaultScheduleLeadingWidth = 56.0;

class ScheduleBodyConfiguration {
  /// Creates a new [ScheduleBodyConfiguration].
  ScheduleBodyConfiguration({
    this.emptyDay = kDefaultEmptyDayBehavior,
    this.leadingWidth = kDefaultScheduleLeadingWidth,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.scrollPhysics,
    this.pageScrollPhysics,
  })  : pageTriggerConfiguration = pageTriggerConfiguration ?? PageTriggerConfiguration(),
        scrollTriggerConfiguration = scrollTriggerConfiguration ?? ScrollTriggerConfiguration();

  /// The behavior of empty days in the schedule view.
  /// - [EmptyDayBehavior.show]: Show every empty day in the schedule view.
  /// - [EmptyDayBehavior.showOnlyToday]: Show only today when it has no events.
  /// - [EmptyDayBehavior.hide]: Hide every empty day in the schedule view.
  final EmptyDayBehavior emptyDay;

  /// The width of the leading (date) column, shared by every row so the event
  /// tiles line up. Defaults to [kDefaultScheduleLeadingWidth].
  final double leadingWidth;

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
    double? leadingWidth,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    ScrollPhysics? scrollPhysics,
    ScrollPhysics? pageScrollPhysics,
  }) {
    return ScheduleBodyConfiguration(
      emptyDay: emptyDay ?? this.emptyDay,
      leadingWidth: leadingWidth ?? this.leadingWidth,
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
        other.leadingWidth == leadingWidth &&
        other.pageTriggerConfiguration == pageTriggerConfiguration &&
        other.scrollTriggerConfiguration == scrollTriggerConfiguration &&
        other.scrollPhysics == scrollPhysics &&
        other.pageScrollPhysics == pageScrollPhysics;
  }

  @override
  int get hashCode {
    return Object.hash(
      emptyDay,
      leadingWidth,
      pageTriggerConfiguration,
      scrollTriggerConfiguration,
      scrollPhysics,
      pageScrollPhysics,
    );
  }
}
