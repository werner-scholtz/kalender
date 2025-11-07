import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout.dart';
import 'package:kalender/src/models/initial_date_selection_strategy.dart';
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
    super.selectedDate,
    super.initialDateSelectionStrategy,
    required this.timeOfDayRange,
    required this.numberOfDays,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
    required this.type,
    required this.initialTimeOfDay,
    required this.initialHeightPerMinute,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be a valid week day number\n'
          'Use DateTime.monday, DateTime.tuesday, etc. to set the first day of the week',
        );

  /// Creates a [MultiDayViewConfiguration] for a single day.
  MultiDayViewConfiguration.singleDay({
    super.name = 'Day',
    super.selectedDate,
    super.initialDateSelectionStrategy = kDefaultToDaily,
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
    super.selectedDate,
    super.initialDateSelectionStrategy = kDefaultToWeekly,
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
    super.selectedDate,
    super.initialDateSelectionStrategy = kDefaultToWeekly,
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.numberOfDays = 5,
    this.initialTimeOfDay = defaultInitialTimeOfDay,
    this.initialHeightPerMinute = defaultHeightPerMinute,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        firstDayOfWeek = defaultFirstDayOfWeek,
        type = MultiDayViewType.workWeek,
        pageNavigationFunctions = PageNavigationFunctions.workWeek(displayRange ?? DateTime.now().yearRange);

  /// Creates a [MultiDayViewConfiguration] for a custom number of days.
  MultiDayViewConfiguration.custom({
    super.name = 'Custom',
    super.selectedDate,
    super.initialDateSelectionStrategy = kDefaultToWeekly,
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
    this.initialTimeOfDay = defaultInitialTimeOfDay,
    this.initialHeightPerMinute = defaultHeightPerMinute,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        type = MultiDayViewType.custom,
        pageNavigationFunctions =
            PageNavigationFunctions.custom(displayRange ?? DateTime.now().yearRange, numberOfDays);

  /// Creates a [MultiDayViewConfiguration] for a free scrolling view.
  MultiDayViewConfiguration.freeScroll({
    super.name = 'Free Scroll',
    super.selectedDate,
    super.initialDateSelectionStrategy = kDefaultToWeekly,
    DateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.initialTimeOfDay = defaultInitialTimeOfDay,
    this.initialHeightPerMinute = defaultHeightPerMinute,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        firstDayOfWeek = defaultFirstDayOfWeek,
        type = MultiDayViewType.freeScroll,
        pageNavigationFunctions = PageNavigationFunctions.freeScroll(displayRange ?? DateTime.now().yearRange);

  MultiDayViewConfiguration copyWith({
    String? name,
    DateTime? selectedDate,
    InitialDateSelectionStrategy? initialDateSelectionStrategy,
    TimeOfDayRange? timeOfDayRange,
    DateTimeRange? displayRange,
    int? numberOfDays,
    int? firstDayOfWeek,
    TimeOfDay? initialTimeOfDay,
  }) {
    final name0 = name ?? this.name;
    final selectedDate0 = selectedDate ?? this.selectedDate;
    final initialDateSelectionStrategy0 = initialDateSelectionStrategy ?? this.initialDateSelectionStrategy;
    final timeOfDayRange0 = timeOfDayRange ?? this.timeOfDayRange;
    final displayRange0 = displayRange ?? dateTimeRange;
    final firstDayOfWeek0 = firstDayOfWeek ?? this.firstDayOfWeek;
    final initialTimeOfDay0 = initialTimeOfDay ?? this.initialTimeOfDay;

    return switch (type) {
      MultiDayViewType.singleDay => MultiDayViewConfiguration.singleDay(
          name: name0,
          selectedDate: selectedDate0,
          initialDateSelectionStrategy: initialDateSelectionStrategy0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          initialTimeOfDay: initialTimeOfDay0,
        ),
      MultiDayViewType.week => MultiDayViewConfiguration.week(
          name: name0,
          selectedDate: selectedDate0,
          initialDateSelectionStrategy: initialDateSelectionStrategy0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          initialTimeOfDay: initialTimeOfDay0,
        ),
      MultiDayViewType.workWeek => MultiDayViewConfiguration.workWeek(
          name: name0,
          selectedDate: selectedDate0,
          initialDateSelectionStrategy: initialDateSelectionStrategy0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          initialTimeOfDay: initialTimeOfDay0,
        ),
      MultiDayViewType.custom => MultiDayViewConfiguration.custom(
          name: name0,
          selectedDate: selectedDate0,
          initialDateSelectionStrategy: initialDateSelectionStrategy0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          numberOfDays: numberOfDays ?? this.numberOfDays,
          initialTimeOfDay: initialTimeOfDay0,
        ),
      MultiDayViewType.freeScroll => MultiDayViewConfiguration.freeScroll(
          name: name0,
          selectedDate: selectedDate0,
          initialDateSelectionStrategy: initialDateSelectionStrategy0,
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
        other.selectedDate == selectedDate &&
        other.initialDateSelectionStrategy == initialDateSelectionStrategy &&
        other.timeOfDayRange == timeOfDayRange &&
        other.dateTimeRange == dateTimeRange &&
        other.numberOfDays == numberOfDays &&
        other.firstDayOfWeek == firstDayOfWeek &&
        other.pageNavigationFunctions == pageNavigationFunctions;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      selectedDate,
      initialDateSelectionStrategy,
      timeOfDayRange,
      dateTimeRange,
      numberOfDays,
      firstDayOfWeek,
      pageNavigationFunctions,
    );
  }

  @override
  String toString() {
    return '''
    name: $name
    selectedDate: $selectedDate
    initialDateSelectionStrategy: $initialDateSelectionStrategy
    timeOfDayRange: $timeOfDayRange
    displayRange: $dateTimeRange
    numberOfDays: $numberOfDays
    firstDayOfWeek: $firstDayOfWeek
    pageNavigationFunctions: $pageNavigationFunctions''';
  }
}

/// The configuration used by the [MultiDayBody].
///
/// TODO: Depricate this in 1.0.0 and use [VerticalConfiguration] instead.
class MultiDayBodyConfiguration extends VerticalConfiguration {
  /// Creates a new [MultiDayHeaderConfiguration].
  const MultiDayBodyConfiguration({
    super.showMultiDayEvents,
    super.horizontalPadding,
    super.eventLayoutStrategy,
    super.scrollPhysics,
    super.pageScrollPhysics,
    super.minimumTileHeight,
    super.pageTriggerConfiguration,
    super.scrollTriggerConfiguration,
  });

  /// Creates a copy of this [MultiDayBodyConfiguration] with the given fields replaced by the new values.
  MultiDayBodyConfiguration copyWith({
    bool? showMultiDayEvents,
    EdgeInsets? horizontalPadding,
    PageTriggerConfiguration? pageTriggerConfiguration,
    ScrollTriggerConfiguration? scrollTriggerConfiguration,
    EventLayoutStrategy? eventLayoutStrategy,
    ScrollPhysics? scrollPhysics,
    ScrollPhysics? pageScrollPhysics,
    double? minimumTileHeight,
  }) {
    return MultiDayBodyConfiguration(
      showMultiDayEvents: showMultiDayEvents ?? this.showMultiDayEvents,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
      scrollTriggerConfiguration: scrollTriggerConfiguration ?? this.scrollTriggerConfiguration,
      eventLayoutStrategy: eventLayoutStrategy ?? this.eventLayoutStrategy,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      pageScrollPhysics: pageScrollPhysics ?? this.pageScrollPhysics,
      minimumTileHeight: minimumTileHeight ?? this.minimumTileHeight,
    );
  }
}

/// The configuration used by the [MultiDayHeader] and [MonthBody].
class MultiDayHeaderConfiguration<T extends Object?> extends HorizontalConfiguration<T> {
  /// Creates a new [MultiDayHeaderConfiguration].
  const MultiDayHeaderConfiguration({
    super.showTiles = defaultShowEventTiles,
    super.tileHeight = defaultTileHeight,
    super.generateMultiDayLayoutFrame,
    super.maximumNumberOfVerticalEvents,
    super.eventPadding = kDefaultMultiDayEventPadding,
    super.pageTriggerConfiguration,
    super.allowSingleDayEvents = false,
  });

  /// Creates a copy of this [MultiDayHeaderConfiguration] with the given fields replaced by the new values.
  MultiDayHeaderConfiguration<T> copyWith({
    double? tileHeight,
    bool? showTiles,
    PageTriggerConfiguration? pageTriggerConfiguration,
    GenerateMultiDayLayoutFrame<T>? generateMultiDayLayoutFrame,
    int? maximumNumberOfVerticalEvents,
    EdgeInsets? eventPadding,
    bool? allowSingleDayEvents,
  }) {
    return MultiDayHeaderConfiguration(
      showTiles: showTiles ?? this.showTiles,
      tileHeight: tileHeight ?? this.tileHeight,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
      generateMultiDayLayoutFrame: generateMultiDayLayoutFrame ?? this.generateMultiDayLayoutFrame,
      maximumNumberOfVerticalEvents: maximumNumberOfVerticalEvents ?? this.maximumNumberOfVerticalEvents,
      eventPadding: eventPadding ?? this.eventPadding,
      allowSingleDayEvents: allowSingleDayEvents ?? this.allowSingleDayEvents,
    );
  }
}
