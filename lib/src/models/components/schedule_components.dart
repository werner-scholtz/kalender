import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/components/string_builders.dart';
import 'package:kalender/src/widgets/components/schedule_date.dart';
import 'package:kalender/src/widgets/components/schedule_tile_highlight.dart';

/// A class containing custom widget builders for the `ScheduleBody`.
class ScheduleComponents {
  /// A function that builds the day header widget.
  /// Null uses [ScheduleDate].
  final ScheduleDateBuilder? leadingDateBuilder;

  /// Builds the day name displayed above the day number.
  ///
  /// Defaults to the short day name in the calendar's locale.
  final DateStringBuilder? leadingDateStringBuilder;

  /// A function that builds the highlight tile widget.
  /// Null uses [ScheduleTileHighlight].
  final ScheduleTileHighlightBuilder? scheduleTileHighlightBuilder;

  /// A function that builds the row for a day without events.
  ///
  /// When null the row shows only the leading date.
  final EmptyItemBuilder? emptyItemBuilder;

  /// A function that builds the month heading row.
  ///
  /// When null a [ListTile] shows the month name in the calendar's locale.
  final MonthItemBuilder? monthItemBuilder;

  const ScheduleComponents({
    this.leadingDateBuilder,
    this.leadingDateStringBuilder,
    this.scheduleTileHighlightBuilder,
    this.emptyItemBuilder,
    this.monthItemBuilder,
  });

  /// Builds the leading date, with [leadingDateBuilder] when set.
  Widget buildLeadingDate(BuildContext context, InternalDateTime date) {
    return leadingDateBuilder?.call(context, date) ?? ScheduleDate(date: date);
  }

  /// Wraps [child] in the highlight, with [scheduleTileHighlightBuilder] when set.
  Widget buildScheduleTileHighlight(
    BuildContext context,
    InternalDateTime date,
    ValueNotifier<InternalDateTimeRange?> dateTimeRange,
    Widget child,
  ) {
    return scheduleTileHighlightBuilder?.call(context, date, dateTimeRange, child) ??
        ScheduleTileHighlight(date: date, dateTimeRange: dateTimeRange, child: child);
  }

  /// Creates a copy of this with the given fields replaced.
  ScheduleComponents copyWith({
    ScheduleDateBuilder? leadingDateBuilder,
    DateStringBuilder? leadingDateStringBuilder,
    ScheduleTileHighlightBuilder? scheduleTileHighlightBuilder,
    EmptyItemBuilder? emptyItemBuilder,
    MonthItemBuilder? monthItemBuilder,
  }) {
    return ScheduleComponents(
      leadingDateBuilder: leadingDateBuilder ?? this.leadingDateBuilder,
      leadingDateStringBuilder: leadingDateStringBuilder ?? this.leadingDateStringBuilder,
      scheduleTileHighlightBuilder: scheduleTileHighlightBuilder ?? this.scheduleTileHighlightBuilder,
      emptyItemBuilder: emptyItemBuilder ?? this.emptyItemBuilder,
      monthItemBuilder: monthItemBuilder ?? this.monthItemBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleComponents &&
        other.leadingDateBuilder == leadingDateBuilder &&
        other.leadingDateStringBuilder == leadingDateStringBuilder &&
        other.scheduleTileHighlightBuilder == scheduleTileHighlightBuilder &&
        other.emptyItemBuilder == emptyItemBuilder &&
        other.monthItemBuilder == monthItemBuilder;
  }

  @override
  int get hashCode => Object.hash(
        leadingDateBuilder,
        leadingDateStringBuilder,
        scheduleTileHighlightBuilder,
        emptyItemBuilder,
        monthItemBuilder,
      );
}

/// The builder for the empty item.
///
/// [tileRange] is the [KalenderDateTimeRange] of the ListTile where this widget will be displayed.
typedef EmptyItemBuilder = Widget Function(BuildContext context, KalenderDateTimeRange tileRange);

/// The builder for the month item.
///
/// [monthRange] is the [KalenderDateTimeRange] of the month.
typedef MonthItemBuilder = Widget Function(BuildContext context, KalenderDateTimeRange monthRange);
