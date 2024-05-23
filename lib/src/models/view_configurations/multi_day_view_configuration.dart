import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/layout_delegates/event_group_layout_delegate.dart';
import 'package:kalender/src/models/navigation_triggers.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';

enum MultiDayViewType {
  singleDay,
  week,
  workWeek,
  custom,
}

/// The configuration used by the [MultiDayBody] and [MultiDayHeader].
class MultiDayViewConfiguration extends ViewConfiguration {
  MultiDayViewConfiguration({
    required super.name,
    required this.timeOfDayRange,
    required this.displayRange,
    required this.numberOfDays,
    required this.timelineWidth,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
    required this.type,
  }) : assert(
          firstDayOfWeek == 1 || firstDayOfWeek == 6 || firstDayOfWeek == 7,
          'First day of week must be Monday, Saturday or Sunday\n'
          'Use DateTime.monday, DateTime.saturday or DateTime.sunday if unsure.',
        );

  /// Creates a [MultiDayViewConfiguration] for a single day.
  MultiDayViewConfiguration.singleDay({
    super.name = 'Day',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
    this.timelineWidth = defaultTimeLineWith,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
  }) {
    numberOfDays = 1;
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    pageNavigationFunctions = PageNavigationFunctions.singleDay(
      this.displayRange,
    );
    type = MultiDayViewType.singleDay;
  }

  /// Creates a [MultiDayViewConfiguration] for a week.
  MultiDayViewConfiguration.week({
    super.name = 'Week',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
    this.numberOfDays = 7,
    this.timelineWidth = defaultTimeLineWith,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
  }) {
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    pageNavigationFunctions = PageNavigationFunctions.week(
      this.displayRange,
      firstDayOfWeek,
    );
    type = MultiDayViewType.week;
  }

  /// Creates a [MultiDayViewConfiguration] for a work week.
  MultiDayViewConfiguration.workWeek({
    super.name = 'Work Week',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.numberOfDays = 5,
    this.timelineWidth = defaultTimeLineWith,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
  }) {
    firstDayOfWeek = DateTime.monday;
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    pageNavigationFunctions = PageNavigationFunctions.workWeek(
      this.displayRange,
    );
    type = MultiDayViewType.workWeek;
  }

  /// Creates a [MultiDayViewConfiguration] for a custom number of days.
  MultiDayViewConfiguration.custom({
    super.name = 'Custom',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.firstDayOfWeek = DateTime.monday,
    this.timelineWidth = defaultTimeLineWith,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
  }) {
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    pageNavigationFunctions = PageNavigationFunctions.custom(
      this.displayRange,
      numberOfDays,
    );
    type = MultiDayViewType.custom;
  }

  late final MultiDayViewType type;

  /// The functions for navigating the [PageView].
  late final PageNavigationFunctions pageNavigationFunctions;

  /// The [DateTimeRange] that can be displayed by [MultiDayBody] widgets using this configuration.
  late final DateTimeRange displayRange;

  /// The start of the [displayRange].
  DateTime get start => displayRange.start;

  /// The end of the [displayRange].
  DateTime get end => displayRange.end;

  /// The [TimeOfDayRange] that can be displayed by [MultiDayBody] widgets using this configuration.
  late final TimeOfDayRange timeOfDayRange;

  /// The first day of the week.
  ///
  /// This can be [DateTime.monday], [DateTime.saturday] or [DateTime.sunday].
  late final int firstDayOfWeek;

  /// The number of days that can be displayed by [MultiDayBody] widgets using this configuration.
  late final int numberOfDays;

  /// The width of the timeline.
  ///
  /// This is used by the [MultiDayBody] and [MultiDayHeader].
  final double timelineWidth;

  MultiDayViewConfiguration copyWith({
    String? name,
    TimeOfDayRange? timeOfDayRange,
    DateTimeRange? displayRange,
    int? numberOfDays,
    double? timelineWidth,
    int? firstDayOfWeek,
  }) {
    final displayRange0 = displayRange ?? this.displayRange;
    final firstDayOfWeek0 = firstDayOfWeek ?? this.firstDayOfWeek;

    return switch (type) {
      MultiDayViewType.singleDay => MultiDayViewConfiguration.singleDay(
          name: name ?? this.name,
          timeOfDayRange: timeOfDayRange ?? this.timeOfDayRange,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
        ),
      MultiDayViewType.week => MultiDayViewConfiguration.week(
          name: name ?? this.name,
          timeOfDayRange: timeOfDayRange ?? this.timeOfDayRange,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
        ),
      MultiDayViewType.workWeek => MultiDayViewConfiguration.workWeek(
          name: name ?? this.name,
          timeOfDayRange: timeOfDayRange ?? this.timeOfDayRange,
          displayRange: displayRange0,
        ),
      MultiDayViewType.custom => MultiDayViewConfiguration.custom(
          name: name ?? this.name,
          timeOfDayRange: timeOfDayRange ?? this.timeOfDayRange,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          numberOfDays: numberOfDays ?? this.numberOfDays,
        ),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayViewConfiguration &&
        other.name == name &&
        other.timeOfDayRange == timeOfDayRange &&
        other.displayRange == displayRange &&
        other.numberOfDays == numberOfDays &&
        other.timelineWidth == timelineWidth &&
        other.firstDayOfWeek == firstDayOfWeek &&
        other.pageNavigationFunctions == pageNavigationFunctions;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      timeOfDayRange,
      displayRange,
      numberOfDays,
      timelineWidth,
      firstDayOfWeek,
      pageNavigationFunctions,
    );
  }

  @override
  String toString() {
    return '''
    name: $name
    timeOfDayRange: $timeOfDayRange
    displayRange: $displayRange
    numberOfDays: $numberOfDays
    timelineWidth: $timelineWidth
    firstDayOfWeek: $firstDayOfWeek
    pageNavigationFunctions: $pageNavigationFunctions''';
  }
}

/// The configuration used by the [MultiDayBody].
///
/// This configuration is used to determine the behavior of the [MultiDayBody].
class MultiDayBodyConfiguration {
  /// Creates a new [MultiDayHeaderConfiguration].
  MultiDayBodyConfiguration({
    this.showMultiDayEvents = defaultShowMultiDayEvents,
    this.allowEventCreation = defaultAllowEventCreation,
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.createEventTrigger = defaultCreateEventTrigger,
    this.newEventDuration = defaultNewEventDuration,
    this.snapToTimeIndicator = defaultSnapToTimeIndicator,
    this.snapToOtherEvents = defaultSnapToOtherEvents,
    this.snapRange = defaultSnapRange,
    this.snapIntervalMinutes = defaultSnapIntervalMinutes,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.dayEventLayoutStrategy = defaultLayoutStrategy,
    this.scrollPhysics,
    this.pageScrollPhysics,
  }) {
    this.pageTriggerConfiguration =
        pageTriggerConfiguration ?? PageTriggerConfiguration();
    this.scrollTriggerConfiguration =
        scrollTriggerConfiguration ?? ScrollTriggerConfiguration();
  }

  /// Whether to show events that are longer than 1 day in the [MultiDayBody].
  final bool showMultiDayEvents;

  /// Allow the resizing of events.
  final bool allowResizing;

  /// Allow the rescheduling of events.
  final bool allowRescheduling;

  /// Allow the creation of events.
  final bool allowEventCreation;

  /// Gesture type for creating events.
  final CreateEventTrigger createEventTrigger;

  /// The snap interval in minutes for events in the [MultiDayBody].
  /// * This is used when not snapping to the time indicator or other events.
  final int snapIntervalMinutes;

  /// Whether to snap to the time indicator when altering an event.
  final bool snapToTimeIndicator;

  /// Whether to snap to other events when altering an event.
  final bool snapToOtherEvents;

  /// The [Duration] in which events will snap to other events.
  final Duration snapRange;

  /// The duration of the new event when created by tapping on the [MultiDayBody].
  final Duration newEventDuration;

  /// The configuration for the page navigation triggers.
  late final PageTriggerConfiguration pageTriggerConfiguration;

  /// The configuration for the scroll navigation triggers.
  late final ScrollTriggerConfiguration scrollTriggerConfiguration;

  /// The layout strategy used by the [MultiDayBody] to layout events.
  final DayEventLayoutStrategy dayEventLayoutStrategy;

  /// The [ScrollPhysics] used by the scrollable body.
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;
}

/// The configuration used by the [MultiDayHeader].
///
/// This configuration is used to determine the behavior of the [MultiDayHeader].
class MultiDayHeaderConfiguration {
  /// Creates a new [MultiDayHeaderConfiguration].
  MultiDayHeaderConfiguration({
    this.tileHeight = defaultTileHeight,
    this.allowEventCreation = defaultAllowEventCreation,
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.createEventTrigger = defaultCreateEventTrigger,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
  }) {
    this.pageTriggerConfiguration =
        pageTriggerConfiguration ?? PageTriggerConfiguration();
  }

  /// The height of the tiles in the [MultiDayHeader].
  final double tileHeight;

  /// Allow the resizing of events.
  final bool allowResizing;

  /// Allow the rescheduling of events.
  final bool allowRescheduling;

  /// Allow the creation of events.
  final bool allowEventCreation;

  /// Gesture type for creating events.
  final CreateEventTrigger createEventTrigger;

  /// The configuration for the page navigation triggers.
  late final PageTriggerConfiguration pageTriggerConfiguration;
}
