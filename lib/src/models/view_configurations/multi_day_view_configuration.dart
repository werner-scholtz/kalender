// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout.dart';
import 'package:kalender/src/models/controllers/kalender_controller.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/kalender_events/multi_day_rule.dart';
import 'package:kalender/src/models/kalender_time.dart';
import 'package:kalender/src/models/navigation_triggers.dart';
import 'package:kalender/src/models/view_configurations/page_index_calculator.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/models/view_transition.dart';
import 'package:kalender/src/widgets/month/month_body.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_body.dart';
import 'package:kalender/src/widgets/multi_day/multi_day_header.dart';

/// {@category Views}
enum MultiDayViewType { singleDay, week, workWeek, custom, freeScroll }

/// The configuration used by the [MultiDayBody] and [MultiDayHeader].
///
/// {@category Views}
class MultiDayViewConfiguration extends ViewConfiguration {
  /// The type of the [MultiDayViewConfiguration].
  final MultiDayViewType type;

  @override
  final PageIndexCalculator pageIndexCalculator;

  /// The [KalenderTimeRange] that can be displayed by [MultiDayBody] widgets using this configuration.
  final KalenderTimeRange timeOfDayRange;

  /// The first day of the week.
  final int firstDayOfWeek;

  /// The number of days that can be displayed by [MultiDayBody] widgets using this configuration.
  final int numberOfDays;

  /// The initial time of day that the calendar should display.
  final KalenderTime initialTimeOfDay;

  /// The initial heightPerMinute (zoom level).
  final double initialHeightPerMinute;

  /// How the vertical scroll position (time-of-day) is chosen when switching to
  /// this view from another. Defaults to [ScrollTransition.preserve]. Applies
  /// when [scrollResolver] is null or returns null.
  final ScrollTransition scrollTransition;

  /// Decides the time of day on a view switch before [scrollTransition].
  ///
  /// See [ScrollResolver].
  final ScrollResolver? scrollResolver;

  /// How the zoom (`heightPerMinute`) is chosen when switching to this view from
  /// another. Defaults to [ZoomTransition.preserve]. Applies when [zoomResolver]
  /// is null or returns null.
  final ZoomTransition zoomTransition;

  /// Decides the zoom on a view switch before [zoomTransition].
  ///
  /// See [ZoomResolver].
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
    KalenderTimeRange? timeOfDayRange,
    this.firstDayOfWeek = kDefaultFirstDayOfWeek,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  }) : timeOfDayRange = timeOfDayRange ?? KalenderTimeRange.allDay(),
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
    KalenderTimeRange? timeOfDayRange,
    this.firstDayOfWeek = kDefaultFirstDayOfWeek,
    this.numberOfDays = 7,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  }) : assert(
         numberOfDays >= 1 && numberOfDays <= DateTime.daysPerWeek,
         'numberOfDays must be between 1 and 7 for a week view.\n'
         'Use MultiDayViewConfiguration.custom for a page of any other length.',
       ),
       timeOfDayRange = timeOfDayRange ?? KalenderTimeRange.allDay(),
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
    KalenderTimeRange? timeOfDayRange,
    this.numberOfDays = 5,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  }) : assert(
         numberOfDays >= 1 && numberOfDays <= DateTime.daysPerWeek,
         'numberOfDays must be between 1 and 7 for a work week view.\n'
         'Use MultiDayViewConfiguration.custom for a page of any other length.',
       ),
       timeOfDayRange = timeOfDayRange ?? KalenderTimeRange.allDay(),
       firstDayOfWeek = kDefaultFirstDayOfWeek,
       type = MultiDayViewType.workWeek,
       pageIndexCalculator = PageIndexCalculator.workWeek(displayRange ?? kDefaultRange(), daysToDisplay: numberOfDays);

  /// Creates a [MultiDayViewConfiguration] for a custom number of days.
  MultiDayViewConfiguration.custom({
    super.name = 'Custom',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    KalenderDateTimeRange? displayRange,
    KalenderTimeRange? timeOfDayRange,
    required this.numberOfDays,
    this.firstDayOfWeek = kDefaultFirstDayOfWeek,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  }) : timeOfDayRange = timeOfDayRange ?? KalenderTimeRange.allDay(),
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
    KalenderTimeRange? timeOfDayRange,
    required this.numberOfDays,
    this.initialTimeOfDay = kDefaultInitialTimeOfDay,
    this.initialHeightPerMinute = kDefaultHeightPerMinute,
    this.scrollTransition = ScrollTransition.preserve,
    this.scrollResolver,
    this.zoomTransition = ZoomTransition.preserve,
    this.zoomResolver,
  }) : timeOfDayRange = timeOfDayRange ?? KalenderTimeRange.allDay(),
       firstDayOfWeek = kDefaultFirstDayOfWeek,
       type = MultiDayViewType.freeScroll,
       pageIndexCalculator = PageIndexCalculator.freeScroll(displayRange ?? kDefaultRange());

  MultiDayViewConfiguration._({
    required super.name,
    required super.initialDateTime,
    required super.dateTransition,
    required super.dateResolver,
    required super.nowCallback,
    required super.multiDayRule,
    required this.timeOfDayRange,
    required this.numberOfDays,
    required this.firstDayOfWeek,
    required this.pageIndexCalculator,
    required this.type,
    required this.initialTimeOfDay,
    required this.initialHeightPerMinute,
    required this.scrollTransition,
    required this.scrollResolver,
    required this.zoomTransition,
    required this.zoomResolver,
  });

  MultiDayViewConfiguration copyWith({
    String? name,
    DateTime? initialDateTime,
    DateTransition? dateTransition,
    DateResolver? dateResolver,
    NowCallback? nowCallback,
    KalenderTimeRange? timeOfDayRange,
    KalenderDateTimeRange? displayRange,
    int? numberOfDays,
    int? firstDayOfWeek,
    KalenderTime? initialTimeOfDay,
    ScrollTransition? scrollTransition,
    ScrollResolver? scrollResolver,
    ZoomTransition? zoomTransition,
    ZoomResolver? zoomResolver,
    MultiDayRule? multiDayRule,
  }) {
    final displayRange0 = displayRange ?? dateTimeRange;
    final numberOfDays0 = type == MultiDayViewType.singleDay ? 1 : numberOfDays ?? this.numberOfDays;
    final firstDayOfWeek0 = switch (type) {
      MultiDayViewType.workWeek || MultiDayViewType.freeScroll => kDefaultFirstDayOfWeek,
      _ => firstDayOfWeek ?? this.firstDayOfWeek,
    };

    return MultiDayViewConfiguration._(
      name: name ?? this.name,
      initialDateTime: initialDateTime ?? this.initialDateTime,
      dateTransition: dateTransition ?? this.dateTransition,
      dateResolver: dateResolver ?? this.dateResolver,
      nowCallback: nowCallback ?? this.nowCallback,
      multiDayRule: multiDayRule ?? this.multiDayRule,
      timeOfDayRange: timeOfDayRange ?? this.timeOfDayRange,
      numberOfDays: numberOfDays0,
      firstDayOfWeek: firstDayOfWeek0,
      pageIndexCalculator: switch (type) {
        MultiDayViewType.singleDay => PageIndexCalculator.singleDay(displayRange0),
        MultiDayViewType.week => PageIndexCalculator.week(displayRange0, firstDayOfWeek0, daysToDisplay: numberOfDays0),
        MultiDayViewType.workWeek => PageIndexCalculator.workWeek(displayRange0, daysToDisplay: numberOfDays0),
        MultiDayViewType.custom => PageIndexCalculator.custom(displayRange0, numberOfDays0),
        MultiDayViewType.freeScroll => PageIndexCalculator.freeScroll(displayRange0),
      },
      type: type,
      initialTimeOfDay: initialTimeOfDay ?? this.initialTimeOfDay,
      initialHeightPerMinute: initialHeightPerMinute,
      scrollTransition: scrollTransition ?? this.scrollTransition,
      scrollResolver: scrollResolver ?? this.scrollResolver,
      zoomTransition: zoomTransition ?? this.zoomTransition,
      zoomResolver: zoomResolver ?? this.zoomResolver,
    );
  }

  @override
  MultiDayViewController createViewController(KalenderController controller, ViewTransitionContext? transition) {
    final date = resolveDate(controller.location, transition);
    return MultiDayViewController(
      viewConfiguration: this,
      initial: transition == null
          ? ViewSnapshot(date: date)
          : ViewSnapshot(
              date: date,
              timeOfDay: transition.target?.timeOfDay ?? scrollResolver?.call(transition) ?? _resolveScroll(transition),
              heightPerMinute:
                  transition.target?.heightPerMinute ?? zoomResolver?.call(transition) ?? _resolveZoom(transition),
            ),
      location: controller.location,
    );
  }

  KalenderTime? _resolveScroll(ViewTransitionContext transition) => switch (scrollTransition) {
    ScrollTransition.preserve => _carry(transition, (snapshot) => snapshot.timeOfDay),
    ScrollTransition.reset => null,
    ScrollTransition.restorePerView => _carry(transition, (snapshot) => snapshot.timeOfDay, perView: true),
  };

  double? _resolveZoom(ViewTransitionContext transition) => switch (zoomTransition) {
    ZoomTransition.preserve => _carry(transition, (snapshot) => snapshot.heightPerMinute),
    ZoomTransition.reset => null,
    ZoomTransition.restorePerView => _carry(transition, (snapshot) => snapshot.heightPerMinute, perView: true),
  };

  /// The value [read] from the last multi-day view, or with [perView] first from this view's own history.
  T? _carry<T>(ViewTransitionContext transition, T? Function(ViewSnapshot snapshot) read, {bool perView = false}) {
    final own = perView ? transition.byView[name] : null;
    final last = transition.lastMultiDay;
    return (own == null ? null : read(own)) ?? (last == null ? null : read(last));
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
    initialDateTime: $initialDateTime
    dateTransition: $dateTransition
    timeOfDayRange: $timeOfDayRange
    displayRange: $dateTimeRange
    numberOfDays: $numberOfDays
    firstDayOfWeek: $firstDayOfWeek
    pageIndexCalculator: $pageIndexCalculator''';
  }
}

/// The configuration used by the [MultiDayBody].
///
/// {@category Views}
class MultiDayBodyConfiguration extends VerticalConfiguration {
  /// Keeps visited pages built so returning to one does not rebuild it.
  ///
  /// Off by default. Cached pages stay in memory for the view's lifetime.
  final bool keepPagesAlive;

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
///
/// {@category Views}
class MultiDayHeaderConfiguration extends HorizontalConfiguration {
  const MultiDayHeaderConfiguration({
    super.showTiles = kDefaultShowEventTiles,
    super.tileHeight = kDefaultTileHeight,
    super.multiDayLayoutStrategy,
    super.maximumNumberOfVerticalEvents,
    super.eventPadding = kDefaultMultiDayEventPadding,
    super.pageTriggerConfiguration,
    super.allowSingleDayEvents = false,
  });

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
