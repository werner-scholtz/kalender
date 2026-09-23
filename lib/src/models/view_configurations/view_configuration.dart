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
import 'package:kalender/src/models/view_configurations/schedule_view_configuration.dart';
import 'package:kalender/src/models/view_transition.dart';
import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/month_day_header.dart';
import 'package:kalender/src/widgets/components/schedule_date.dart';

export 'package:kalender/kalender_extensions.dart';

/// A callback that returns the current [DateTime] representing "now" for the calendar.
///
/// See [ViewConfiguration.nowCallback] for what it affects. Any [DateTime] subtype works.
///
/// Pass the same function on every build: it is included in `==`.
///
/// {@category Views}
typedef NowCallback = DateTime Function();

/// The base class for all [ViewConfiguration]s.
///
/// {@category Views}
abstract class ViewConfiguration {
  const ViewConfiguration({
    required this.name,
    this.initialDateTime,
    this.dateTransition = DateTransition.carryFocus,
    this.dateResolver,
    this.nowCallback,
    this.multiDayRule = kDefaultMultiDayRule,
  });

  /// The name of the [ViewConfiguration].
  final String name;

  /// Decides which events belong in the multi-day header rather than the day
  /// timeline.
  ///
  /// Applies to every event this view shows. An individual event can opt out
  /// with [KalenderEvent.multiDayRule].
  final MultiDayRule multiDayRule;

  /// The date the view opens on when the calendar is first built.
  ///
  /// Not read on a view switch or a change of location, where [dateResolver] or [dateTransition] decides the date.
  final DateTime? initialDateTime;

  /// How the visible date is chosen when switching to this view from another, or when the calendar's location
  /// changes.
  ///
  /// Defaults to [DateTransition.carryFocus]. Overridden by [dateResolver] when that is provided.
  final DateTransition dateTransition;

  /// An optional resolver for the visible date on a view switch or a change of location.
  ///
  /// When non-null it overrides [dateTransition], allowing arbitrary logic (e.g.
  /// "snap to the next business day"). See [kCarryFocusDate] to reuse the default.
  final DateResolver? dateResolver;

  /// An optional callback that overrides how the calendar resolves "now".
  ///
  /// The wall-clock components of the returned [DateTime] decide where the time indicator sits, which day
  /// [DayHeader], [MonthDayHeader] and [ScheduleDate] highlight as today, and whether
  /// [EmptyDayBehavior.showOnlyToday] keeps an empty day.
  ///
  /// Included in `==`, unlike [dateResolver]. Null, the default, uses the calendar's [Location].
  final NowCallback? nowCallback;

  /// The functions for navigating the [PageView].
  PageIndexCalculator get pageIndexCalculator;

  /// [transition] is null when the calendar is first built, and describes the view being replaced on a view switch or
  /// a change of location.
  ViewController createViewController(KalenderController controller, ViewTransitionContext? transition);

  /// The date the view opens on.
  ///
  /// On the first build [transition] is null and the date is [initialDateTime], or today in [location] without one. On
  /// a transition the date of [ViewTransitionContext.target] wins, then [dateResolver], then [dateTransition].
  @protected
  FloatingDateTime resolveDate(Location? location, ViewTransitionContext? transition) {
    if (transition == null) {
      final now = location == null ? DateTime.now() : TZDateTime.now(location);
      return FloatingDateTime.fromExternal(initialDateTime ?? now, location: location);
    }
    if (transition.target case final target?) return target.date;
    if (dateResolver case final resolver?) return resolver(transition);
    return switch (dateTransition) {
      DateTransition.carryFocus => kCarryFocusDate(transition),
      DateTransition.restorePerView => transition.byView[name]?.date ?? kCarryFocusDate(transition),
    };
  }

  /// The [KalenderDateTimeRange] that the calendar can display.
  ///
  /// The exact range shown can differ by the calendar's location.
  KalenderDateTimeRange get dateTimeRange =>
      KalenderDateTimeRange(start: pageIndexCalculator.start, end: pageIndexCalculator.end);
}

/// The base class for all vertical views of the calendar.
///
/// {@category Views}
abstract class VerticalConfiguration {
  /// Whether to show multi-day events in the body.
  ///
  /// Which events count is decided by [ViewConfiguration.multiDayRule],
  /// 24 hours or longer by default.
  final bool showMultiDayEvents;

  /// The horizontal padding between events and the edge of the day column.
  ///
  /// * Vertical values are ignored.
  final EdgeInsets horizontalPadding;

  /// The layout strategy used by the body to layout events.
  final EventLayoutStrategy eventLayoutStrategy;

  /// The [ScrollPhysics] used by the scrollable body.
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;

  /// The minimum height of a tile.
  ///
  /// A shorter tile grows downwards, or upwards when it sits at the bottom of the screen.
  final double? minimumTileHeight;

  /// The configuration for the page navigation triggers.
  final PageTriggerConfiguration pageTriggerConfiguration;

  /// The configuration for the scroll navigation triggers.
  final ScrollTriggerConfiguration scrollTriggerConfiguration;

  const VerticalConfiguration({
    this.showMultiDayEvents = kDefaultShowMultiDayEvents,
    this.horizontalPadding = kDefaultHorizontalPadding,
    this.eventLayoutStrategy = kDefaultEventLayoutStrategy,
    this.scrollPhysics,
    this.pageScrollPhysics,
    this.minimumTileHeight,
    this.pageTriggerConfiguration = const PageTriggerConfiguration.defaultConfiguration(),
    this.scrollTriggerConfiguration = const ScrollTriggerConfiguration.defaultConfiguration(),
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // Subclasses do not all override ==.
    if (other.runtimeType != runtimeType) return false;

    return other is VerticalConfiguration &&
        other.showMultiDayEvents == showMultiDayEvents &&
        other.horizontalPadding == horizontalPadding &&
        other.pageTriggerConfiguration == pageTriggerConfiguration &&
        other.scrollTriggerConfiguration == scrollTriggerConfiguration &&
        other.eventLayoutStrategy == eventLayoutStrategy &&
        other.scrollPhysics == scrollPhysics &&
        other.pageScrollPhysics == pageScrollPhysics &&
        other.minimumTileHeight == minimumTileHeight;
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
      minimumTileHeight,
    );
  }
}

/// The base class for all horizontal views of the calendar.
///
/// {@category Views}
abstract class HorizontalConfiguration {
  /// The height of the tiles.
  final double tileHeight;

  /// Whether to show event tiles.
  final bool showTiles;

  /// The strategy that assigns each multi-day event a row and a span of columns.
  final MultiDayLayoutStrategy multiDayLayoutStrategy;

  /// The maximum number of events that can be displayed vertically.
  ///
  /// If this is null, then there is no limit.
  final int? maximumNumberOfVerticalEvents;

  /// The padding used around events.
  final EdgeInsets eventPadding;

  /// Whether to display single-day events in this horizontal lane.
  ///
  /// Which events count is decided by [ViewConfiguration.multiDayRule],
  /// shorter than 24 hours by default.
  final bool allowSingleDayEvents;

  /// The configuration for the page navigation triggers.
  final PageTriggerConfiguration pageTriggerConfiguration;

  const HorizontalConfiguration({
    this.showTiles = kDefaultShowEventTiles,
    this.tileHeight = kDefaultTileHeight,
    this.multiDayLayoutStrategy = kDefaultMultiDayLayoutStrategy,
    this.maximumNumberOfVerticalEvents,
    this.eventPadding = kDefaultMultiDayEventPadding,
    required this.allowSingleDayEvents,
    this.pageTriggerConfiguration = const PageTriggerConfiguration.defaultConfiguration(),
  });

  HorizontalConfiguration copyWith({
    double? tileHeight,
    bool? showTiles,
    MultiDayLayoutStrategy? multiDayLayoutStrategy,
    int? maximumNumberOfVerticalEvents,
    EdgeInsets? eventPadding,
    bool? allowSingleDayEvents,
    PageTriggerConfiguration? pageTriggerConfiguration,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // Subclasses do not all override ==.
    if (other.runtimeType != runtimeType) return false;

    return other is HorizontalConfiguration &&
        other.tileHeight == tileHeight &&
        other.showTiles == showTiles &&
        other.pageTriggerConfiguration == pageTriggerConfiguration &&
        other.multiDayLayoutStrategy == multiDayLayoutStrategy &&
        other.maximumNumberOfVerticalEvents == maximumNumberOfVerticalEvents &&
        other.eventPadding == eventPadding &&
        other.allowSingleDayEvents == allowSingleDayEvents;
  }

  @override
  int get hashCode {
    return Object.hash(
      tileHeight,
      showTiles,
      pageTriggerConfiguration,
      multiDayLayoutStrategy,
      maximumNumberOfVerticalEvents,
      eventPadding,
      allowSingleDayEvents,
    );
  }
}

/// {@category Views}
const kDefaultTileHeight = 24.0;

/// {@category Views}
const kDefaultShowMultiDayEvents = false;

/// {@category Layout}
const kDefaultEventLayoutStrategy = EventLayoutStrategy.overlap();

/// {@category Layout}
const kDefaultMultiDayLayoutStrategy = MultiDayLayoutStrategy.byDuration();

/// {@category Views}
const kDefaultFirstDayOfWeek = DateTime.monday;

/// {@category Views}
const kDefaultShowEventTiles = true;

/// {@category Views}
const kDefaultInitialTimeOfDay = KalenderTime(hour: 0, minute: 0);

/// {@category Views}
const kDefaultHeightPerMinute = 0.7;

/// {@category Views}
const kDefaultHorizontalPadding = EdgeInsets.only(left: 0, right: 4);

/// {@category Views}
const kDefaultMultiDayEventPadding = EdgeInsets.only(left: 0, right: 4, bottom: 2);

/// {@category Views}
const kDefaultEmptyDayBehavior = EmptyDayBehavior.showOnlyToday;

/// {@category Views}
KalenderDateTimeRange kDefaultRange() {
  final now = DateTime.now();
  return KalenderDateTimeRange(start: DateTime(now.year - 2), end: DateTime(now.year + 2));
}
