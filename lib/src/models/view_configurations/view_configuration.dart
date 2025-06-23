import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout_delegate.dart';
import 'package:kalender/src/models/initial_date_selection_strategy.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';
import 'package:kalender/src/models/view_configurations/schedule_view_configuration.dart';

export 'package:kalender/kalender_extensions.dart';

/// The base class for all [ViewConfiguration]s.
///
/// [ViewConfiguration]s are used to configure the view of the calendar.
abstract class ViewConfiguration<T extends Object?> {
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
