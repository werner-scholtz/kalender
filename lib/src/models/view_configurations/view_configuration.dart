import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout.dart';
import 'package:kalender/src/models/calendar_events/multi_day_rule.dart';
import 'package:kalender/src/models/navigation_triggers.dart';
import 'package:kalender/src/models/view_configurations/page_index_calculator.dart';
import 'package:kalender/src/models/view_configurations/schedule_view_configuration.dart';
import 'package:kalender/src/models/view_transition.dart';

export 'package:kalender/kalender_extensions.dart';

/// A callback that returns the current [DateTime] representing "now" for the calendar.
///
/// The returned [DateTime]'s wall-clock components (year, month, day, hour, minute)
/// are used as-is to:
/// - Position the time indicator on the calendar grid.
/// - Determine which day is "today" for header highlighting
///   ([DayHeader], [MonthDayHeader], [ScheduleDate]).
/// - Evaluate [EmptyDayBehavior.showOnlyToday] in schedule views.
///
/// Any [DateTime] subtype works:
/// - [DateTime.now] — uses the system's local wall-clock time.
/// - `() => DateTime.now().toUtc()` — uses the current UTC time.
/// - `() => TZDateTime.now(location)` — uses the wall-clock time for a specific timezone.
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
    this.multiDayRule = defaultMultiDayRule,
  });

  /// The name of the [ViewConfiguration].
  final String name;

  /// Decides which events belong in the multi-day header rather than the day
  /// timeline.
  ///
  /// Applies to every event this view shows. An individual event can opt out
  /// with [CalendarEvent.multiDayRule].
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
  /// When provided, the wall-clock components of the returned [DateTime] are
  /// used instead of the calendar's [Location]-based time resolution for:
  ///
  /// - **Time indicator positioning** — determines both the horizontal (day)
  ///   and vertical (time-of-day) placement of the current-time line.
  /// - **"Today" highlighting** — the default [DayHeader], [MonthDayHeader],
  ///   and [ScheduleDate] widgets use this to decide which day receives the
  ///   filled-button highlight.
  /// - **Schedule empty-day logic** — [EmptyDayBehavior.showOnlyToday] uses this
  ///   to decide whether an empty day should still be shown.
  ///
  /// This is useful when the calendar displays events in UTC but should
  /// reflect the user's local wall-clock time. For example, a time-tracking
  /// app that stores wall-clock times as UTC values can pass [DateTime.now]
  /// to align the indicator and highlighting with local time:
  ///
  /// ```dart
  /// MultiDayViewConfiguration.week(
  ///   nowCallback: DateTime.now,
  /// )
  /// ```
  ///
  /// When `null` (the default), the calendar uses its configured [Location]
  /// to determine the current time.
  final NowCallback? nowCallback;

  /// The functions for navigating the [PageView].
  PageIndexCalculator get pageIndexCalculator;

  /// The [DateTimeRange] that the calendar can display.
  ///
  /// The exact range shown can differ by the calendar's location.
  DateTimeRange get dateTimeRange => pageIndexCalculator.dateTimeRange;
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
    this.showMultiDayEvents = defaultShowMultiDayEvents,
    this.horizontalPadding = defaultHorizontalPadding,
    this.eventLayoutStrategy = defaultEventLayoutStrategy,
    this.scrollPhysics,
    this.pageScrollPhysics,
    this.minimumTileHeight,
    this.pageTriggerConfiguration = const PageTriggerConfiguration.defaultConfiguration(),
    this.scrollTriggerConfiguration = const ScrollTriggerConfiguration.defaultConfiguration(),
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

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

  /// The function that generates the layout frame for the multi-day event.
  ///
  /// * see [defaultMultiDayFrameGenerator] for default implementation.
  final GenerateMultiDayLayoutFrame? generateMultiDayLayoutFrame;

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
    this.showTiles = defaultShowEventTiles,
    this.tileHeight = defaultTileHeight,
    this.generateMultiDayLayoutFrame,
    this.maximumNumberOfVerticalEvents,
    this.eventPadding = kDefaultMultiDayEventPadding,
    required this.allowSingleDayEvents,
    this.pageTriggerConfiguration = const PageTriggerConfiguration.defaultConfiguration(),
  });

  HorizontalConfiguration copyWith({
    double? tileHeight,
    bool? showTiles,
    GenerateMultiDayLayoutFrame? generateMultiDayLayoutFrame,
    int? maximumNumberOfVerticalEvents,
    EdgeInsets? eventPadding,
    bool? allowSingleDayEvents,
    PageTriggerConfiguration? pageTriggerConfiguration,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HorizontalConfiguration &&
        other.tileHeight == tileHeight &&
        other.showTiles == showTiles &&
        other.pageTriggerConfiguration == pageTriggerConfiguration &&
        other.generateMultiDayLayoutFrame == generateMultiDayLayoutFrame &&
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
      generateMultiDayLayoutFrame,
      maximumNumberOfVerticalEvents,
      eventPadding,
      allowSingleDayEvents,
    );
  }
}

// TODO: rename these to use `k` prefix
const defaultTileHeight = 24.0;
const defaultNewEventDuration = Duration(minutes: 30);
const defaultShowMultiDayEvents = false;
const defaultEventLayoutStrategy = overlapLayoutStrategy;
const defaultFirstDayOfWeek = DateTime.monday;
const defaultShowEventTiles = true;
const defaultInitialTimeOfDay = TimeOfDay(hour: 0, minute: 0);
const defaultHeightPerMinute = 0.7;
const defaultHorizontalPadding = EdgeInsets.only(left: 0, right: 4);

const kDefaultMultiDayEventPadding = EdgeInsets.only(left: 0, right: 4, bottom: 2);
const kDefaultEmptyDayBehavior = EmptyDayBehavior.showOnlyToday;
DateTimeRange kDefaultRange() {
  final now = DateTime.now();
  return DateTimeRange(start: DateTime(now.year - 2), end: DateTime(now.year + 2));
}
