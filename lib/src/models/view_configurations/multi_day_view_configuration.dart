import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout_delegate.dart';
import 'package:kalender/src/models/navigation_triggers.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

enum MultiDayViewType {
  singleDay,
  week,
  workWeek,
  custom,
  freeScroll,
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
    required this.leftPageClip,
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
    this.leftPageClip = defaultLeftPageClip,
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
    this.leftPageClip = defaultLeftPageClip,
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
    this.leftPageClip = defaultLeftPageClip,
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
    this.leftPageClip = defaultLeftPageClip,
  }) {
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    pageNavigationFunctions = PageNavigationFunctions.custom(
      this.displayRange,
      numberOfDays,
    );
    type = MultiDayViewType.custom;
  }

  /// Creates a [MultiDayViewConfiguration] for a free scrolling view.
  MultiDayViewConfiguration.freeScroll({
    super.name = 'Free Scroll',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.timelineWidth = defaultTimeLineWith,
    this.leftPageClip = defaultLeftPageClip,
  }) {
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    pageNavigationFunctions = PageNavigationFunctions.freeScroll(this.displayRange);
    type = MultiDayViewType.freeScroll;
    firstDayOfWeek = DateTime.monday;
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
  /// This is used by the [MultiDayBody] and [MultiDayHeader] to layout the timeline.
  final double timelineWidth;

  /// The width of the left page clip.
  ///
  /// This is used by the [MultiDayBody] to clip the left of the page.
  final double leftPageClip;

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
      MultiDayViewType.freeScroll => MultiDayViewConfiguration.freeScroll(
          name: name ?? this.name,
          timeOfDayRange: timeOfDayRange ?? this.timeOfDayRange,
          displayRange: displayRange0,
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
    this.eventLayoutStrategy = defaultEventLayoutStrategy,
    this.scrollPhysics,
    this.pageScrollPhysics,
  }) {
    this.pageTriggerConfiguration = pageTriggerConfiguration ?? PageTriggerConfiguration();
    this.scrollTriggerConfiguration = scrollTriggerConfiguration ?? ScrollTriggerConfiguration();
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
  final EventLayoutStrategy eventLayoutStrategy;

  /// The [ScrollPhysics] used by the scrollable body.
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;

  /// Creates a copy of this [MultiDayBodyConfiguration] with the given fields replaced by the new values.
  MultiDayBodyConfiguration copyWith({
    bool? showMultiDayEvents,
    bool? allowEventCreation,
    bool? allowResizing,
    bool? allowRescheduling,
    CreateEventTrigger? createEventTrigger,
    Duration? newEventDuration,
    bool? snapToTimeIndicator,
    bool? snapToOtherEvents,
    Duration? snapRange,
    int? snapIntervalMinutes,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    EventLayoutStrategy? eventLayoutStrategy,
    ScrollPhysics? scrollPhysics,
    ScrollPhysics? pageScrollPhysics,
  }) {
    return MultiDayBodyConfiguration(
      showMultiDayEvents: showMultiDayEvents ?? this.showMultiDayEvents,
      allowEventCreation: allowEventCreation ?? this.allowEventCreation,
      allowResizing: allowResizing ?? this.allowResizing,
      allowRescheduling: allowRescheduling ?? this.allowRescheduling,
      createEventTrigger: createEventTrigger ?? this.createEventTrigger,
      newEventDuration: newEventDuration ?? this.newEventDuration,
      snapToTimeIndicator: snapToTimeIndicator ?? this.snapToTimeIndicator,
      snapToOtherEvents: snapToOtherEvents ?? this.snapToOtherEvents,
      snapRange: snapRange ?? this.snapRange,
      snapIntervalMinutes: snapIntervalMinutes ?? this.snapIntervalMinutes,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
      scrollTriggerConfiguration: scrollTriggerConfiguration ?? this.scrollTriggerConfiguration,
      eventLayoutStrategy: eventLayoutStrategy ?? this.eventLayoutStrategy,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      pageScrollPhysics: pageScrollPhysics ?? this.pageScrollPhysics,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayBodyConfiguration &&
        other.showMultiDayEvents == showMultiDayEvents &&
        other.allowEventCreation == allowEventCreation &&
        other.allowResizing == allowResizing &&
        other.allowRescheduling == allowRescheduling &&
        other.createEventTrigger == createEventTrigger &&
        other.newEventDuration == newEventDuration &&
        other.snapToTimeIndicator == snapToTimeIndicator &&
        other.snapToOtherEvents == snapToOtherEvents &&
        other.snapRange == snapRange &&
        other.snapIntervalMinutes == snapIntervalMinutes &&
        other.pageTriggerConfiguration == pageTriggerConfiguration &&
        other.scrollTriggerConfiguration == scrollTriggerConfiguration &&
        other.eventLayoutStrategy == eventLayoutStrategy &&
        other.scrollPhysics == scrollPhysics &&
        other.pageScrollPhysics == pageScrollPhysics;
  }

  @override
  int get hashCode {
    return Object.hash(
      showMultiDayEvents,
      allowEventCreation,
      allowResizing,
      allowRescheduling,
      createEventTrigger,
      newEventDuration,
      snapToTimeIndicator,
      snapToOtherEvents,
      snapRange,
      snapIntervalMinutes,
      pageTriggerConfiguration,
      scrollTriggerConfiguration,
      eventLayoutStrategy,
      scrollPhysics,
      pageScrollPhysics,
    );
  }
}

/// The configuration used by the [MultiDayHeader] and [MonthBody].
class MultiDayHeaderConfiguration {
  /// Creates a new [MultiDayHeaderConfiguration].
  MultiDayHeaderConfiguration({
    this.showTiles = defaultShowEventTiles,
    this.tileHeight = defaultTileHeight,
    this.allowEventCreation = defaultAllowEventCreation,
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.createEventTrigger = defaultCreateEventTrigger,
    this.eventLayoutStrategy = defaultMultiDayEventLayoutStrategy,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
  }) {
    this.pageTriggerConfiguration = pageTriggerConfiguration ?? PageTriggerConfiguration();
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

  /// Whether to show event tiles.
  final bool showTiles;

  /// The layout strategy used by the [MultiDayHeader] to layout events.
  final MultiDayEventLayoutStrategy eventLayoutStrategy;

  /// The configuration for the page navigation triggers.
  late final PageTriggerConfiguration pageTriggerConfiguration;

  /// Creates a copy of this [MultiDayHeaderConfiguration] with the given fields replaced by the new values.
  MultiDayHeaderConfiguration copyWith({
    double? tileHeight,
    bool? allowEventCreation,
    bool? allowResizing,
    bool? allowRescheduling,
    CreateEventTrigger? createEventTrigger,
    PageTriggerConfiguration? pageTriggerConfiguration,
  }) {
    return MultiDayHeaderConfiguration(
      tileHeight: tileHeight ?? this.tileHeight,
      allowEventCreation: allowEventCreation ?? this.allowEventCreation,
      allowResizing: allowResizing ?? this.allowResizing,
      allowRescheduling: allowRescheduling ?? this.allowRescheduling,
      createEventTrigger: createEventTrigger ?? this.createEventTrigger,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayHeaderConfiguration &&
        other.tileHeight == tileHeight &&
        other.allowEventCreation == allowEventCreation &&
        other.allowResizing == allowResizing &&
        other.allowRescheduling == allowRescheduling &&
        other.createEventTrigger == createEventTrigger &&
        other.pageTriggerConfiguration == pageTriggerConfiguration;
  }

  @override
  int get hashCode {
    return Object.hash(
      tileHeight,
      allowEventCreation,
      allowResizing,
      allowRescheduling,
      createEventTrigger,
      pageTriggerConfiguration,
    );
  }
}
