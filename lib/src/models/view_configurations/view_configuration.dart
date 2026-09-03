import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout.dart';
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
/// See [ViewConfiguration.nowCallback] for what it affects. Any [DateTime]
/// subtype works, so it can return local time, UTC, or a `TZDateTime` in a
/// specific zone.
///
/// Pass the same function on every build, since it is included in the view
/// configuration's equality. These qualify:
///
/// - a tear-off, such as [DateTime.now] or a top-level or static function,
/// - a closure stored in a field, which matters when the callback needs a
///   captured value such as a location.
///
/// A closure written inline does not. It is a new function every build.
typedef NowCallback = DateTime Function();

/// The base class for all [ViewConfiguration]s.
///
/// [ViewConfiguration]s are used to configure the view of the calendar.
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

  /// The selected date to start the view from.
  ///
  /// If this is provided, it takes precedence over [dateResolver] / [dateTransition]
  /// when switching between view configurations.
  final DateTime? initialDateTime;

  /// How the visible date is chosen when switching to this view from another.
  ///
  /// Defaults to [DateTransition.carryFocus]. Overridden by [dateResolver] when
  /// that is provided, and by [initialDateTime] when that is set.
  final DateTransition dateTransition;

  /// An optional resolver for the visible date on a view switch.
  ///
  /// When non-null it overrides [dateTransition], allowing arbitrary logic (e.g.
  /// "snap to the next business day"). See [kCarryFocusDate] to reuse the default.
  final DateResolver? dateResolver;

  /// An optional callback that overrides how the calendar resolves "now".
  ///
  /// The wall-clock components of the returned [DateTime] decide:
  ///
  /// - where the time indicator sits, both its day and its time of day,
  /// - which day [DayHeader], [MonthDayHeader] and [ScheduleDate] highlight as
  ///   today,
  /// - whether [EmptyDayBehavior.showOnlyToday] keeps an empty day.
  ///
  /// Useful when the calendar displays UTC but should follow the user's local
  /// wall clock:
  ///
  /// ```dart
  /// MultiDayViewConfiguration.week(nowCallback: DateTime.now)
  /// ```
  ///
  /// Pass the same function on every build, since this is included in `==`. See
  /// [NowCallback] for the shapes that qualify. [dateResolver] and the
  /// multi-day resolvers are not compared, because they are read from the
  /// incoming configuration at a view switch and so are already current.
  ///
  /// Null, the default, uses the calendar's [Location].
  final NowCallback? nowCallback;

  /// The functions for navigating the [PageView].
  PageIndexCalculator get pageIndexCalculator;

  /// The [KalenderDateTimeRange] that the calendar can display.
  ///
  /// The exact range shown can differ by the calendar's location.
  KalenderDateTimeRange get dateTimeRange =>
      KalenderDateTimeRange(start: pageIndexCalculator.start, end: pageIndexCalculator.end);
}

/// The base class for all vertical views of the calendar.
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

  /// The minimum height of the tile.
  ///
  /// Setting this value will force all tiles to have a minimum height of this value.
  /// This is useful for displaying short events in a consistent way.
  ///
  /// * Note tiles will be expanded downwards except when the tile is at the bottom of the screen
  ///   then they will be expanded upwards.
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

    // Subclasses add fields but not all of them override this, so without a
    // runtime type check two different configuration types compare equal.
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

    // MonthBodyConfiguration and MultiDayHeaderConfiguration both extend this
    // and add no equality of their own, so without a runtime type check they
    // compare equal to each other.
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

const kDefaultTileHeight = 24.0;
const kDefaultNewEventDuration = Duration(minutes: 30);
const kDefaultShowMultiDayEvents = false;
const kDefaultEventLayoutStrategy = EventLayoutStrategy.overlap();
const kDefaultMultiDayLayoutStrategy = MultiDayLayoutStrategy.byDuration();
const kDefaultFirstDayOfWeek = DateTime.monday;
const kDefaultShowEventTiles = true;
const kDefaultInitialTimeOfDay = KalenderTime(hour: 0, minute: 0);
const kDefaultHeightPerMinute = 0.7;
const kDefaultHorizontalPadding = EdgeInsets.only(left: 0, right: 4);
const kDefaultMultiDayEventPadding = EdgeInsets.only(left: 0, right: 4, bottom: 2);
const kDefaultEmptyDayBehavior = EmptyDayBehavior.showOnlyToday;
KalenderDateTimeRange kDefaultRange() {
  final now = DateTime.now();
  return KalenderDateTimeRange(start: DateTime(now.year - 2), end: DateTime(now.year + 2));
}
