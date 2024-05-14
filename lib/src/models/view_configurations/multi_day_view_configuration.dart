import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/layout_delegates/event_group_layout_delegate.dart';
import 'package:kalender/src/models/navigation_triggers.dart';

class MultiDayViewConfiguration extends ViewConfiguration {
  MultiDayViewConfiguration({
    required super.name,
    required this.timeOfDayRange,
    required this.displayRange,
    required this.numberOfDays,
    required this.timelineWidth,
    required this.showMultiDayEvents,
    required this.firstDayOfWeek,
    required this.allowEventCreation,
    required this.allowResizing,
    required this.allowRescheduling,
    required this.createEventTrigger,
    required this.newEventDuration,
    required this.pageNavigationFunctions,
    required this.pageTriggerConfiguration,
    required this.scrollTriggerConfiguration,
    required this.dayEventLayoutStrategy,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be between 1 and 7 (inclusive)\n'
          'Use DateTime.monday ~ DateTime.sunday if unsure.',
        );

  static const defaultTimeLineWith = 48.0;
  static const defaultNewEventDuration = Duration(minutes: 30);
  static const defaultAllowEventCreation = true;
  static const defaultAllowResizing = true;
  static const defaultAllowRescheduling = true;
  static const defaultCreateEventTrigger = CreateEventTrigger.tap;
  static const defaultShowMultiDayEvents = false;

  MultiDayViewConfiguration.singleDay({
    super.name = 'Day',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.firstDayOfWeek = DateTime.monday,
    this.timelineWidth = defaultTimeLineWith,
    this.showMultiDayEvents = defaultShowMultiDayEvents,
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.allowEventCreation = defaultAllowEventCreation,
    this.createEventTrigger = defaultCreateEventTrigger,
    this.newEventDuration = defaultNewEventDuration,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.dayEventLayoutStrategy = overlapLayoutStrategy,
  }) {
    numberOfDays = 1;
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    this.pageTriggerConfiguration =
        pageTriggerConfiguration ?? PageTriggerConfiguration();
    this.scrollTriggerConfiguration =
        scrollTriggerConfiguration ?? ScrollTriggerConfiguration();

    pageNavigationFunctions = PageNavigationFunctions(
      dateTimeRangeFromIndex: (index) => start.addDays(index).dayRange,
      indexFromDate: (date) {
        final dateUtc = date.startOfDay.toUtc();
        final startDateUtc = this.displayRange.start.startOfDay.toUtc();
        return dateUtc.difference(startDateUtc).inDays;
      },
      numberOfPages: this.displayRange.dayDifference,
    );
  }

  MultiDayViewConfiguration.week({
    super.name = 'Week',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.firstDayOfWeek = DateTime.monday,
    this.numberOfDays = 7,
    this.timelineWidth = defaultTimeLineWith,
    this.showMultiDayEvents = defaultShowMultiDayEvents,
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.allowEventCreation = defaultAllowEventCreation,
    this.createEventTrigger = defaultCreateEventTrigger,
    this.newEventDuration = defaultNewEventDuration,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.dayEventLayoutStrategy = overlapLayoutStrategy,
  }) {
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    this.pageTriggerConfiguration =
        pageTriggerConfiguration ?? PageTriggerConfiguration();
    this.scrollTriggerConfiguration =
        scrollTriggerConfiguration ?? ScrollTriggerConfiguration();

    pageNavigationFunctions = PageNavigationFunctions(
      dateTimeRangeFromIndex: (index) {
        return DateTime(
          start.year,
          start.month,
          start.day + (index * DateTime.daysPerWeek),
        ).weekRangeWithOffset(firstDayOfWeek);
      },
      indexFromDate: (date) {
        final dateUtc = date.startOfDay.toUtc();
        final startDateUtc = start.startOfDay.toUtc();
        final index =
            dateUtc.difference(startDateUtc).inDays / DateTime.daysPerWeek;
        return index.floor();
      },
      numberOfPages:
          (this.displayRange.dayDifference / DateTime.daysPerWeek).ceil(),
    );
  }

  MultiDayViewConfiguration.workWeek({
    super.name = 'Work Week',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.numberOfDays = 5,
    this.timelineWidth = defaultTimeLineWith,
    this.showMultiDayEvents = defaultShowMultiDayEvents,
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.allowEventCreation = defaultAllowEventCreation,
    this.createEventTrigger = defaultCreateEventTrigger,
    this.newEventDuration = defaultNewEventDuration,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.dayEventLayoutStrategy = overlapLayoutStrategy,
  }) {
    firstDayOfWeek = DateTime.monday;
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    this.pageTriggerConfiguration =
        pageTriggerConfiguration ?? PageTriggerConfiguration();
    this.scrollTriggerConfiguration =
        scrollTriggerConfiguration ?? ScrollTriggerConfiguration();

    pageNavigationFunctions = PageNavigationFunctions(
      dateTimeRangeFromIndex: (index) {
        final weekRange = DateTime(
          start.year,
          start.month,
          start.day + (index * DateTime.daysPerWeek),
        ).weekRangeWithOffset(firstDayOfWeek);

        return DateTimeRange(
          start: weekRange.start,
          end: weekRange.end.subtractDays(2),
        );
      },
      indexFromDate: (date) {
        final dateUtc = date.startOfDay.toUtc();
        final startDateUtc = start.startOfDay.toUtc();
        final index =
            dateUtc.difference(startDateUtc).inDays / DateTime.daysPerWeek;
        return index.floor();
      },
      numberOfPages:
          (this.displayRange.dayDifference / DateTime.daysPerWeek).ceil(),
    );
  }

  MultiDayViewConfiguration.custom({
    super.name = 'Custom',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.firstDayOfWeek = DateTime.monday,
    this.timelineWidth = defaultTimeLineWith,
    this.showMultiDayEvents = defaultShowMultiDayEvents,
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.allowEventCreation = defaultAllowEventCreation,
    this.createEventTrigger = defaultCreateEventTrigger,
    this.newEventDuration = defaultNewEventDuration,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.dayEventLayoutStrategy = overlapLayoutStrategy,
  }) {
    this.timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay();
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    this.pageTriggerConfiguration =
        pageTriggerConfiguration ?? PageTriggerConfiguration();
    this.scrollTriggerConfiguration =
        scrollTriggerConfiguration ?? ScrollTriggerConfiguration();

    pageNavigationFunctions = PageNavigationFunctions(
      dateTimeRangeFromIndex: (index) {
        final startDateUtc = this.displayRange.start.startOfDay;
        return DateTime(
          startDateUtc.year,
          startDateUtc.month,
          startDateUtc.day + (index * numberOfDays),
        ).multiDayDateTimeRange(numberOfDays);
      },
      indexFromDate: (date) {
        final dateUtc = date.startOfDay.toUtc();
        final startDateUtc = this.displayRange.start.startOfDay.toUtc();
        return dateUtc.difference(startDateUtc).inDays ~/ numberOfDays;
      },
      numberOfPages: this.displayRange.dayDifference ~/ numberOfDays,
    );
  }

  /// The functions for navigating the page.
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
}
