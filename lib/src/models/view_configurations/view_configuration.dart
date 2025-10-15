import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout_delegate.dart';
import 'package:kalender/src/models/initial_date_selection_strategy.dart';
import 'package:kalender/src/models/navigation_triggers.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';
import 'package:kalender/src/models/view_configurations/schedule_view_configuration.dart';

export 'package:kalender/kalender_extensions.dart';

/// The base class for all [ViewConfiguration]s.
///
/// [ViewConfiguration]s are used to configure the view of the calendar.
abstract class ViewConfiguration {
  const ViewConfiguration({
    required this.name,
    this.selectedDate,
    this.initialDateSelectionStrategy = kDefaultInitialDateSelectionStrategy,
  });

  /// The name of the [ViewConfiguration].
  final String name;

  /// The selected date to start the view from.
  ///
  /// If this is provided, it will take precedence over the initial date selection strategy.
  /// When null, the view will use the initialDateSelectionStrategy for transition behavior.
  final DateTime? selectedDate;

  /// The strategy used for determining initial date when transitioning between view configurations.
  ///
  /// This determines how the calendar chooses which date to display when switching
  /// between different view types (daily, weekly, monthly, schedule).
  /// Defaults to [kDefaultInitialDateSelectionStrategy] which follows specific rules for each transition type.
  final InitialDateSelectionStrategy initialDateSelectionStrategy;

  /// The functions for navigating the [PageView].
  PageNavigationFunctions get pageNavigationFunctions;

  /// The [DateTimeRange] that can be displayed by the calendar.
  /// * This is the range that is adjusted by the [pageNavigationFunctions].
  ///   Which means that it is in UTC.
  DateTimeRange get displayRange => pageNavigationFunctions.adjustedRange;

  /// The original [DateTimeRange] that was used to create the [PageNavigationFunctions].
  DateTimeRange get originalDisplayRange => pageNavigationFunctions.originalRange;
}

/// The base class for all vertical views of the calendar.
abstract class VerticalConfiguration {
  /// Whether to show events that are longer than 1 day.
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
abstract class HorizontalConfiguration<T extends Object?> {
  /// The height of the tiles.
  final double tileHeight;

  /// Whether to show event tiles.
  final bool showTiles;

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

  /// Whether to display events shorter than 24 hours.
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HorizontalConfiguration &&
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
const kDefaultEmptyDayBehavior = EmptyDayBehavior.showToday;

@Deprecated('This will be removed in the future. Use `generateMultiDayLayoutFrame` instead.')
const defaultMultiDayEventLayoutStrategy = defaultMultiDayLayoutStrategy;
