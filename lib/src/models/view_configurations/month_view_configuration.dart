import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/navigation_triggers.dart';

class MonthViewConfiguration extends ViewConfiguration {
  MonthViewConfiguration({
    required super.name,
    required this.displayRange,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be between 1 and 7 (inclusive)\n'
          'Use DateTime.monday ~ DateTime.sunday if unsure.',
        );

  MonthViewConfiguration.month({
    super.name = 'Month',
    DateTimeRange? displayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
  }) {
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    pageNavigationFunctions = PageNavigationFunctions.month(
      this.displayRange,
      firstDayOfWeek,
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

  /// The first day of the week.
  late final int firstDayOfWeek;
}

/// The configuration used by the [MultiDayBody].
///
/// This configuration is used to determine the behavior of the [MultiDayBody].
class MonthBodyConfiguration {
  /// Creates a new [MultiDayHeaderConfiguration].
  MonthBodyConfiguration({
    this.allowEventCreation = defaultAllowEventCreation,
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.createEventTrigger = defaultCreateEventTrigger,
    this.newEventDuration = defaultNewEventDuration,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.scrollPhysics,
    this.pageScrollPhysics,
  }) {
    this.pageTriggerConfiguration =
        pageTriggerConfiguration ?? PageTriggerConfiguration();
    this.scrollTriggerConfiguration =
        scrollTriggerConfiguration ?? ScrollTriggerConfiguration();
  }

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

  /// The [ScrollPhysics] used by the scrollable body(s).
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;
}
