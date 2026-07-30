import 'package:flutter/material.dart';
import 'package:kalender/src/models/components/string_builders.dart';
import 'package:kalender/src/widgets/components/schedule_date.dart';
import 'package:kalender/src/widgets/components/schedule_tile_highlight.dart';

/// A class containing custom widget builders for the `ScheduleBody`.
class ScheduleComponents {
  /// A function that builds the day header widget.
  final ScheduleDateBuilder leadingDateBuilder;

  /// Builds the day name displayed above the day number.
  ///
  /// Defaults to the short day name in the calendar's locale.
  final DateStringBuilder? leadingDateStringBuilder;

  /// A function that builds the highlight tile widget.
  final ScheduleTileHighlightBuilder scheduleTileHighlightBuilder;

  /// A function that builds the row for a day without events.
  ///
  /// When null the row shows only the leading date.
  final EmptyItemBuilder? emptyItemBuilder;

  /// A function that builds the month heading row.
  ///
  /// When null a [ListTile] shows the month name in the calendar's locale.
  final MonthItemBuilder? monthItemBuilder;

  const ScheduleComponents({
    this.leadingDateBuilder = ScheduleDate.builder,
    this.leadingDateStringBuilder,
    this.scheduleTileHighlightBuilder = ScheduleTileHighlight.builder,
    this.emptyItemBuilder,
    this.monthItemBuilder,
  });
}

/// The builder for the empty item.
///
/// [tileRange] is the [DateTimeRange] of the ListTile where this widget will be displayed.
typedef EmptyItemBuilder = Widget Function(DateTimeRange tileRange);

/// The builder for the month item.
///
/// [monthRange] is the [DateTimeRange] of the month.
typedef MonthItemBuilder = Widget Function(DateTimeRange monthRange);
