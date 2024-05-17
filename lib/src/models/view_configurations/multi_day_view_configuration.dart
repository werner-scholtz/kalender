import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/layout_delegates/event_group_layout_delegate.dart';
import 'package:kalender/src/models/navigation_triggers.dart';

const defaultTileHeight = 24.0;
const defaultTimeLineWith = 48.0;
const defaultNewEventDuration = Duration(minutes: 30);
const defaultAllowEventCreation = true;
const defaultAllowResizing = true;
const defaultAllowRescheduling = true;
const defaultCreateEventTrigger = CreateEventTrigger.tap;
const defaultShowMultiDayEvents = false;
const defaultLayoutStrategy = overlapLayoutStrategy;
const defaultFirstDayOfWeek = DateTime.monday;

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
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be between 1 and 7 (inclusive)\n'
          'Use DateTime.monday ~ DateTime.sunday if unsure.',
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
  }

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
  late final int firstDayOfWeek;

  /// The number of days that can be displayed by [MultiDayBody] widgets using this configuration.
  late final int numberOfDays;

  /// The width of the timeline.
  ///
  /// This is used by the [MultiDayBody] and [MultiDayHeader].
  final double timelineWidth;
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
  final int snapIntervalMinutes = 15;

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
