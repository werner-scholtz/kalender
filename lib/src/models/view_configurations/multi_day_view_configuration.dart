import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout_delegate.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/navigation_triggers.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_event_layout_widget.dart';

enum MultiDayViewType {
  singleDay,
  week,
  workWeek,
  custom,
  freeScroll,
}

/// The configuration used by the [MultiDayBody] and [MultiDayHeader].
class MultiDayViewConfiguration extends ViewConfiguration {
  /// The type of the [MultiDayViewConfiguration].
  final MultiDayViewType type;

  @override
  final PageNavigationFunctions pageNavigationFunctions;

  /// The [TimeOfDayRange] that can be displayed by [MultiDayBody] widgets using this configuration.
  final TimeOfDayRange timeOfDayRange;

  /// The first day of the week.
  ///
  /// This can be [DateTime.monday], [DateTime.saturday] or [DateTime.sunday].
  final int firstDayOfWeek;

  /// The number of days that can be displayed by [MultiDayBody] widgets using this configuration.
  final int numberOfDays;

  /// The initial time of day that the calendar should display.
  final TimeOfDay initialTimeOfDay;

  /// The initial heightPerMinute (zoom level).
  final double initialHeightPerMinute;

  MultiDayViewConfiguration({
    required super.name,
    required this.timeOfDayRange,
    required this.numberOfDays,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
    required this.type,
    required this.initialTimeOfDay,
    required this.initialHeightPerMinute,
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
    this.initialTimeOfDay = defaultInitialTimeOfDay,
    this.initialHeightPerMinute = defaultHeightPerMinute,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        numberOfDays = 1,
        type = MultiDayViewType.singleDay,
        pageNavigationFunctions = PageNavigationFunctions.singleDay(displayRange ?? DateTime.now().yearRange);

  /// Creates a [MultiDayViewConfiguration] for a week.
  MultiDayViewConfiguration.week({
    super.name = 'Week',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
    this.numberOfDays = 7,
    this.initialTimeOfDay = defaultInitialTimeOfDay,
    this.initialHeightPerMinute = defaultHeightPerMinute,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        type = MultiDayViewType.week,
        pageNavigationFunctions = PageNavigationFunctions.week(
          displayRange ?? DateTime.now().yearRange,
          firstDayOfWeek,
        );

  /// Creates a [MultiDayViewConfiguration] for a work week.
  MultiDayViewConfiguration.workWeek({
    super.name = 'Work Week',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.numberOfDays = 5,
    this.initialTimeOfDay = defaultInitialTimeOfDay,
    this.initialHeightPerMinute = defaultHeightPerMinute,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        firstDayOfWeek = DateTime.monday,
        type = MultiDayViewType.workWeek,
        pageNavigationFunctions = PageNavigationFunctions.workWeek(displayRange ?? DateTime.now().yearRange);

  /// Creates a [MultiDayViewConfiguration] for a custom number of days.
  MultiDayViewConfiguration.custom({
    super.name = 'Custom',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.firstDayOfWeek = DateTime.monday,
    this.initialTimeOfDay = defaultInitialTimeOfDay,
    this.initialHeightPerMinute = defaultHeightPerMinute,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        type = MultiDayViewType.custom,
        pageNavigationFunctions =
            PageNavigationFunctions.custom(displayRange ?? DateTime.now().yearRange, numberOfDays);

  /// Creates a [MultiDayViewConfiguration] for a free scrolling view.
  MultiDayViewConfiguration.freeScroll({
    super.name = 'Free Scroll',
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.initialTimeOfDay = defaultInitialTimeOfDay,
    this.initialHeightPerMinute = defaultHeightPerMinute,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        firstDayOfWeek = DateTime.monday,
        type = MultiDayViewType.freeScroll,
        pageNavigationFunctions = PageNavigationFunctions.freeScroll(displayRange ?? DateTime.now().yearRange);

  MultiDayViewConfiguration copyWith({
    String? name,
    TimeOfDayRange? timeOfDayRange,
    DateTimeRange? displayRange,
    int? numberOfDays,
    int? firstDayOfWeek,
    TimeOfDay? initialTimeOfDay,
  }) {
    final name0 = name ?? this.name;
    final timeOfDayRange0 = timeOfDayRange ?? this.timeOfDayRange;
    final displayRange0 = displayRange ?? this.displayRange;
    final firstDayOfWeek0 = firstDayOfWeek ?? this.firstDayOfWeek;
    final initialTimeOfDay0 = initialTimeOfDay ?? this.initialTimeOfDay;

    return switch (type) {
      MultiDayViewType.singleDay => MultiDayViewConfiguration.singleDay(
          name: name0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          initialTimeOfDay: initialTimeOfDay0,
        ),
      MultiDayViewType.week => MultiDayViewConfiguration.week(
          name: name0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          initialTimeOfDay: initialTimeOfDay0,
        ),
      MultiDayViewType.workWeek => MultiDayViewConfiguration.workWeek(
          name: name0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          initialTimeOfDay: initialTimeOfDay0,
        ),
      MultiDayViewType.custom => MultiDayViewConfiguration.custom(
          name: name0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          numberOfDays: numberOfDays ?? this.numberOfDays,
          initialTimeOfDay: initialTimeOfDay0,
        ),
      MultiDayViewType.freeScroll => MultiDayViewConfiguration.freeScroll(
          name: name0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          numberOfDays: numberOfDays ?? this.numberOfDays,
          initialTimeOfDay: initialTimeOfDay0,
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
    firstDayOfWeek: $firstDayOfWeek
    pageNavigationFunctions: $pageNavigationFunctions''';
  }
}

/// The configuration used by the [MultiDayBody].
class MultiDayBodyConfiguration {
  /// Whether to show events that are longer than 1 day.
  final bool showMultiDayEvents;

  /// The horizontal padding between events and the edge of the day.
  ///
  /// * Vertical values are ignored.
  final EdgeInsets horizontalPadding;

  /// The configuration for the page navigation triggers.
  late final PageTriggerConfiguration pageTriggerConfiguration;

  /// The configuration for the scroll navigation triggers.
  late final ScrollTriggerConfiguration scrollTriggerConfiguration;

  /// The layout strategy used by the body to layout events.
  final EventLayoutStrategy eventLayoutStrategy;

  /// The [ScrollPhysics] used by the scrollable body.
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;

  /// Creates a new [MultiDayHeaderConfiguration].
  MultiDayBodyConfiguration({
    this.showMultiDayEvents = defaultShowMultiDayEvents,
    CalendarInteraction? calendarInteraction,
    CalendarSnapping? calendarSnapping,
    this.horizontalPadding = defaultHorizontalPadding,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    this.eventLayoutStrategy = defaultEventLayoutStrategy,
    this.scrollPhysics,
    this.pageScrollPhysics,
  })  : pageTriggerConfiguration = pageTriggerConfiguration ?? PageTriggerConfiguration(),
        scrollTriggerConfiguration = scrollTriggerConfiguration ?? ScrollTriggerConfiguration();

  /// Creates a copy of this [MultiDayBodyConfiguration] with the given fields replaced by the new values.
  MultiDayBodyConfiguration copyWith({
    bool? showMultiDayEvents,
    EdgeInsets? horizontalPadding,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    EventLayoutStrategy? eventLayoutStrategy,
    ScrollPhysics? scrollPhysics,
    ScrollPhysics? pageScrollPhysics,
  }) {
    return MultiDayBodyConfiguration(
      showMultiDayEvents: showMultiDayEvents ?? this.showMultiDayEvents,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
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
        other.horizontalPadding == horizontalPadding &&
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
      horizontalPadding,
      pageTriggerConfiguration,
      scrollTriggerConfiguration,
      eventLayoutStrategy,
      scrollPhysics,
      pageScrollPhysics,
    );
  }
}

/// The configuration used by the [MultiDayHeader] and [MonthBody].
class MultiDayHeaderConfiguration<T extends Object?> {
  /// The height of the tiles.
  final double tileHeight;

  /// Whether to show event tiles.
  final bool showTiles;

  /// The configuration for the page navigation triggers.
  final PageTriggerConfiguration pageTriggerConfiguration;

  /// The function that generates the layout frame for the multi-day event.
  ///
  /// * see [defaultMultiDayFrameGenerator] for default implementation.
  final GenerateMultiDayLayoutFrame<T>? generateMultiDayLayoutFrame;

  /// The maximum number of events that can be displayed vertically.
  ///
  /// If this is null, then there is no limit.
  final int? maximumNumberOfVerticalEvents;

  /// The padding used around events.
  final EdgeInsets eventPadding;

  /// The layout strategy used to layout events.
  @Deprecated('''
This method is deprecated and will be removed in a future release. 
Please use the `generateFrame` method instead.
''')
  final MultiDayEventLayoutStrategy? eventLayoutStrategy;

  /// Creates a new [MultiDayHeaderConfiguration].
  MultiDayHeaderConfiguration({
    this.showTiles = defaultShowEventTiles,
    this.tileHeight = defaultTileHeight,
    this.generateMultiDayLayoutFrame,
    this.maximumNumberOfVerticalEvents,
    this.eventLayoutStrategy,
    this.eventPadding = kDefaultMultiDayEventPadding,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
  }) : pageTriggerConfiguration = pageTriggerConfiguration ?? PageTriggerConfiguration();

  /// Creates a copy of this [MultiDayHeaderConfiguration] with the given fields replaced by the new values.
  MultiDayHeaderConfiguration<T> copyWith({
    double? tileHeight,
    bool? showTiles,
    PageTriggerConfiguration? pageTriggerConfiguration,
    GenerateMultiDayLayoutFrame<T>? generateMultiDayLayoutFrame,
    int? maximumNumberOfVerticalEvents,
    EdgeInsets? eventPadding,
  }) {
    return MultiDayHeaderConfiguration(
      showTiles: showTiles ?? this.showTiles,
      tileHeight: tileHeight ?? this.tileHeight,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
      generateMultiDayLayoutFrame: generateMultiDayLayoutFrame ?? this.generateMultiDayLayoutFrame,
      maximumNumberOfVerticalEvents: maximumNumberOfVerticalEvents ?? this.maximumNumberOfVerticalEvents,
      eventPadding: eventPadding ?? this.eventPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayHeaderConfiguration &&
        other.tileHeight == tileHeight &&
        other.showTiles == showTiles &&
        other.pageTriggerConfiguration == pageTriggerConfiguration &&
        other.generateMultiDayLayoutFrame == generateMultiDayLayoutFrame &&
        other.maximumNumberOfVerticalEvents == maximumNumberOfVerticalEvents &&
        other.eventPadding == eventPadding;
  }

  @override
  int get hashCode {
    return Object.hash(
      tileHeight,
      showTiles,
      pageTriggerConfiguration,
      generateMultiDayLayoutFrame,
      maximumNumberOfVerticalEvents,
      eventPadding,
    );
  }
}
