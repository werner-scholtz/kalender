import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout.dart';
import 'package:kalender/src/models/calendar_events/multi_day_rule.dart';
import 'package:kalender/src/models/navigation_triggers.dart';
import 'package:kalender/src/models/view_configurations/page_index_calculator.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/models/view_transition.dart';
import 'package:kalender/src/widgets/month/month_body.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_body.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';

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
  final PageIndexCalculator pageIndexCalculator;

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

  /// How the vertical scroll position (time-of-day) is chosen when switching to
  /// this view from another. Defaults to [ScrollTransition.preserve]. Overridden
  /// by [scrollResolver] when that is provided.
  final ScrollTransition scrollTransition;

  /// Optional resolver for the initial time-of-day on a view switch. Overrides
  /// [scrollTransition] when non-null; return `null` to use [initialTimeOfDay].
  final ScrollResolver? scrollResolver;

  /// How the zoom (`heightPerMinute`) is chosen when switching to this view from
  /// another. Defaults to [ZoomTransition.preserve]. Overridden by [zoomResolver].
  final ZoomTransition zoomTransition;

  /// Optional resolver for the initial zoom on a view switch. Overrides
  /// [zoomTransition] when non-null; return `null` to use [initialHeightPerMinute].
  final ZoomResolver? zoomResolver;

  MultiDayViewConfiguration({
    required super.name,
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    required this.timeOfDayRange,
    required this.numberOfDays,
    required this.firstDayOfWeek,
    required this.pageIndexCalculator,
    required this.type,
    required this.initialTimeOfDay,
    required this.initialHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be a valid week day number\n'
          'Use DateTime.monday, DateTime.tuesday, etc. to set the first day of the week',
        );

  /// Creates a [MultiDayViewConfiguration] for a single day.
  MultiDayViewConfiguration.singleDay({
    super.name = 'Day',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    KalenderDateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.firstDayOfWeek = kDefaultFirstDayOfWeek,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        numberOfDays = 1,
        type = MultiDayViewType.singleDay,
        pageIndexCalculator = PageIndexCalculator.singleDay(displayRange ?? kDefaultRange());

  /// Creates a [MultiDayViewConfiguration] for a week.
  ///
  /// [numberOfDays] shortens the page without changing the pagination, so 6 with
  /// a [firstDayOfWeek] of [DateTime.monday] shows Monday to Saturday and still
  /// turns the page a week at a time. It must be between 1 and 7. Use
  /// [MultiDayViewConfiguration.custom] for a page of any other length, which
  /// pages by [numberOfDays] rather than by the week.
  MultiDayViewConfiguration.week({
    super.name = 'Week',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    KalenderDateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.firstDayOfWeek = kDefaultFirstDayOfWeek,
    this.numberOfDays = 7,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  })  : assert(
          numberOfDays >= 1 && numberOfDays <= DateTime.daysPerWeek,
          'numberOfDays must be between 1 and 7 for a week view.\n'
          'Use MultiDayViewConfiguration.custom for a page of any other length.',
        ),
        timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        type = MultiDayViewType.week,
        pageIndexCalculator = PageIndexCalculator.week(
          displayRange ?? kDefaultRange(),
          firstDayOfWeek,
          daysToDisplay: numberOfDays,
        );

  /// Creates a [MultiDayViewConfiguration] for a work week.
  ///
  /// [numberOfDays] shortens the page without changing the pagination, which
  /// starts every page on a Monday. It must be between 1 and 7.
  MultiDayViewConfiguration.workWeek({
    super.name = 'Work Week',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    KalenderDateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    this.numberOfDays = 5,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  })  : assert(
          numberOfDays >= 1 && numberOfDays <= DateTime.daysPerWeek,
          'numberOfDays must be between 1 and 7 for a work week view.\n'
          'Use MultiDayViewConfiguration.custom for a page of any other length.',
        ),
        timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        firstDayOfWeek = kDefaultFirstDayOfWeek,
        type = MultiDayViewType.workWeek,
        pageIndexCalculator = PageIndexCalculator.workWeek(
          displayRange ?? kDefaultRange(),
          daysToDisplay: numberOfDays,
        );

  /// Creates a [MultiDayViewConfiguration] for a custom number of days.
  MultiDayViewConfiguration.custom({
    super.name = 'Custom',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    KalenderDateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.firstDayOfWeek = kDefaultFirstDayOfWeek,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        type = MultiDayViewType.custom,
        pageIndexCalculator = PageIndexCalculator.custom(displayRange ?? kDefaultRange(), numberOfDays);

  /// Creates a [MultiDayViewConfiguration] for a free scrolling view.
  MultiDayViewConfiguration.freeScroll({
    super.name = 'Free Scroll',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    KalenderDateTimeRange? displayRange,
    TimeOfDayRange? timeOfDayRange,
    required this.numberOfDays,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  })  : timeOfDayRange = timeOfDayRange ?? TimeOfDayRange.allDay(),
        firstDayOfWeek = kDefaultFirstDayOfWeek,
        type = MultiDayViewType.freeScroll,
        pageIndexCalculator = PageIndexCalculator.freeScroll(displayRange ?? kDefaultRange());

  MultiDayViewConfiguration copyWith({
    String? name,
    DateTime? initialDateTime,
    DateTransition? dateTransition,
    DateResolver? dateResolver,
    NowCallback? nowCallback,
    TimeOfDayRange? timeOfDayRange,
    KalenderDateTimeRange? displayRange,
    int? numberOfDays,
    int? firstDayOfWeek,
    TimeOfDay? initialTimeOfDay,
    ScrollTransition? scrollTransition,
    ScrollResolver? scrollResolver,
    ZoomTransition? zoomTransition,
    ZoomResolver? zoomResolver,
    MultiDayRule? multiDayRule,
  }) {
    final name0 = name ?? this.name;
    final selectedDate0 = initialDateTime ?? this.initialDateTime;
    final dateTransition0 = dateTransition ?? this.dateTransition;
    final dateResolver0 = dateResolver ?? this.dateResolver;
    final nowCallback0 = nowCallback ?? this.nowCallback;
    final timeOfDayRange0 = timeOfDayRange ?? this.timeOfDayRange;
    final displayRange0 = displayRange ?? dateTimeRange;
    final firstDayOfWeek0 = firstDayOfWeek ?? this.firstDayOfWeek;
    final initialTimeOfDay0 = initialTimeOfDay ?? this.initialTimeOfDay;
    final scrollTransition0 = scrollTransition ?? this.scrollTransition;
    final scrollResolver0 = scrollResolver ?? this.scrollResolver;
    final zoomTransition0 = zoomTransition ?? this.zoomTransition;
    final zoomResolver0 = zoomResolver ?? this.zoomResolver;
    final multiDayRule0 = multiDayRule ?? this.multiDayRule;

    return switch (type) {
      MultiDayViewType.singleDay => MultiDayViewConfiguration.singleDay(
          name: name0,
          initialDateTime: selectedDate0,
          dateTransition: dateTransition0,
          dateResolver: dateResolver0,
          nowCallback: nowCallback0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          initialTimeOfDay: initialTimeOfDay0,
          scrollTransition: scrollTransition0,
          scrollResolver: scrollResolver0,
          zoomTransition: zoomTransition0,
          zoomResolver: zoomResolver0,
          multiDayRule: multiDayRule0,
        ),
      MultiDayViewType.week => MultiDayViewConfiguration.week(
          name: name0,
          initialDateTime: selectedDate0,
          dateTransition: dateTransition0,
          dateResolver: dateResolver0,
          nowCallback: nowCallback0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          numberOfDays: numberOfDays ?? this.numberOfDays,
          initialTimeOfDay: initialTimeOfDay0,
          scrollTransition: scrollTransition0,
          scrollResolver: scrollResolver0,
          zoomTransition: zoomTransition0,
          zoomResolver: zoomResolver0,
          multiDayRule: multiDayRule0,
        ),
      MultiDayViewType.workWeek => MultiDayViewConfiguration.workWeek(
          name: name0,
          initialDateTime: selectedDate0,
          dateTransition: dateTransition0,
          dateResolver: dateResolver0,
          nowCallback: nowCallback0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          numberOfDays: numberOfDays ?? this.numberOfDays,
          initialTimeOfDay: initialTimeOfDay0,
          scrollTransition: scrollTransition0,
          scrollResolver: scrollResolver0,
          zoomTransition: zoomTransition0,
          zoomResolver: zoomResolver0,
          multiDayRule: multiDayRule0,
        ),
      MultiDayViewType.custom => MultiDayViewConfiguration.custom(
          name: name0,
          initialDateTime: selectedDate0,
          dateTransition: dateTransition0,
          dateResolver: dateResolver0,
          nowCallback: nowCallback0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          firstDayOfWeek: firstDayOfWeek0,
          numberOfDays: numberOfDays ?? this.numberOfDays,
          initialTimeOfDay: initialTimeOfDay0,
          scrollTransition: scrollTransition0,
          scrollResolver: scrollResolver0,
          zoomTransition: zoomTransition0,
          zoomResolver: zoomResolver0,
          multiDayRule: multiDayRule0,
        ),
      MultiDayViewType.freeScroll => MultiDayViewConfiguration.freeScroll(
          name: name0,
          initialDateTime: selectedDate0,
          dateTransition: dateTransition0,
          dateResolver: dateResolver0,
          nowCallback: nowCallback0,
          timeOfDayRange: timeOfDayRange0,
          displayRange: displayRange0,
          numberOfDays: numberOfDays ?? this.numberOfDays,
          initialTimeOfDay: initialTimeOfDay0,
          scrollTransition: scrollTransition0,
          scrollResolver: scrollResolver0,
          zoomTransition: zoomTransition0,
          zoomResolver: zoomResolver0,
          multiDayRule: multiDayRule0,
        ),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayViewConfiguration &&
        other.type == type &&
        other.name == name &&
        other.initialDateTime == initialDateTime &&
        other.dateTransition == dateTransition &&
        other.nowCallback == nowCallback &&
        other.scrollTransition == scrollTransition &&
        other.zoomTransition == zoomTransition &&
        other.timeOfDayRange == timeOfDayRange &&
        other.initialTimeOfDay == initialTimeOfDay &&
        other.initialHeightPerMinute == initialHeightPerMinute &&
        other.dateTimeRange == dateTimeRange &&
        other.numberOfDays == numberOfDays &&
        other.firstDayOfWeek == firstDayOfWeek &&
        other.multiDayRule == multiDayRule &&
        other.pageIndexCalculator == pageIndexCalculator;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      name,
      initialDateTime,
      dateTransition,
      nowCallback,
      scrollTransition,
      zoomTransition,
      timeOfDayRange,
      initialTimeOfDay,
      initialHeightPerMinute,
      dateTimeRange,
      numberOfDays,
      firstDayOfWeek,
      multiDayRule,
      pageIndexCalculator,
    );
  }

  @override
  String toString() {
    return '''
    name: $name
    selectedDate: $initialDateTime
    dateTransition: $dateTransition
    timeOfDayRange: $timeOfDayRange
    displayRange: $dateTimeRange
    numberOfDays: $numberOfDays
    firstDayOfWeek: $firstDayOfWeek
    pageNavigationFunctions: $pageIndexCalculator''';
  }
}

/// The configuration used by the [MultiDayBody].
class MultiDayBodyConfiguration extends VerticalConfiguration {
  /// Whether to keep visited pages alive so navigating back to them does not
  /// rebuild their content.
  ///
  /// Off by default. When enabled, each page you navigate to is cached and
  /// reused, so navigating back to it is close to free instead of rebuilding
  /// every event tile. The trade-off is memory: cached pages stay in memory for
  /// the lifetime of the view, so this grows with the number of distinct pages
  /// visited. Prefer it for views where the user moves back and forth between a
  /// small set of pages.
  final bool keepPagesAlive;

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
    this.keepPagesAlive = false,
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
    bool? keepPagesAlive,
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
      keepPagesAlive: keepPagesAlive ?? this.keepPagesAlive,
    );
  }

  @override
  bool operator ==(Object other) {
    return super == other && other is MultiDayBodyConfiguration && other.keepPagesAlive == keepPagesAlive;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, keepPagesAlive);
}

/// The configuration used by the [MultiDayHeader] and [MonthBody].
class MultiDayHeaderConfiguration extends HorizontalConfiguration {
  /// Creates a new [MultiDayHeaderConfiguration].
  const MultiDayHeaderConfiguration({
    super.showTiles = kDefaultShowEventTiles,
    super.tileHeight = kDefaultTileHeight,
    super.multiDayLayoutStrategy,
    super.maximumNumberOfVerticalEvents,
    super.eventPadding = kDefaultMultiDayEventPadding,
    super.pageTriggerConfiguration,
    super.allowSingleDayEvents = false,
  });

  /// Creates a copy of this [MultiDayHeaderConfiguration] with the given fields replaced by the new values.
  @override
  MultiDayHeaderConfiguration copyWith({
    double? tileHeight,
    bool? showTiles,
    PageTriggerConfiguration? pageTriggerConfiguration,
    MultiDayLayoutStrategy? multiDayLayoutStrategy,
    int? maximumNumberOfVerticalEvents,
    EdgeInsets? eventPadding,
    bool? allowSingleDayEvents,
  }) {
    return MultiDayHeaderConfiguration(
      showTiles: showTiles ?? this.showTiles,
      tileHeight: tileHeight ?? this.tileHeight,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
      multiDayLayoutStrategy: multiDayLayoutStrategy ?? this.multiDayLayoutStrategy,
      maximumNumberOfVerticalEvents: maximumNumberOfVerticalEvents ?? this.maximumNumberOfVerticalEvents,
      eventPadding: eventPadding ?? this.eventPadding,
      allowSingleDayEvents: allowSingleDayEvents ?? this.allowSingleDayEvents,
    );
  }
}
