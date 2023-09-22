import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/layout_delegates/event_group_layout.dart';
import 'package:kalender/src/components/layout_delegates/multi_day_event_group_layout.dart';
import 'package:kalender/src/type_definitions.dart';

/// The [CalendarLayoutControllers] class contains layout controllers used by the calendar view.
class CalendarLayoutControllers<T> {
  CalendarLayoutControllers({
    EventLayoutDelegateBuilder<T>? dayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? multiDayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? monthTileLayoutController,
  }) {
    this.dayTileLayoutController =
        dayTileLayoutController ?? defaultDayTileLayoutController;

    this.multiDayTileLayoutController =
        multiDayTileLayoutController ?? defaultMultiDayTileLayoutController;

    this.monthTileLayoutController =
        monthTileLayoutController ?? defaultMonthTileLayoutController;
  }

  /// The [DayLayoutController] used to layout the day tiles.
  late EventLayoutDelegateBuilder<T> dayTileLayoutController;

  /// The [MultiDayLayoutController] used to layout the multiday tiles.
  late MultiDayEventLayoutDelegateBuilder<T> multiDayTileLayoutController;

  /// The [MonthLayoutController] used to layout the month tiles.
  late MultiDayEventLayoutDelegateBuilder<T> monthTileLayoutController;

  /// The default [EventGroupLayoutDelegate] used to layout the day tiles.
  EventGroupLayoutDelegate<T> defaultDayTileLayoutController({
    required List<CalendarEvent<T>> events,
    required DateTime startOfGroup,
    required double heightPerMinute,
  }) {
    return EventGroupOverlapLayoutDelegate(
      events: events,
      startOfGroup: startOfGroup,
      heightPerMinute: heightPerMinute,
    );
  }

  /// The default [MultiDayEventGroupLayoutDelegate] used to layout the multiday tiles.
  MultiDayEventGroupLayoutDelegate<T> defaultMultiDayTileLayoutController({
    required DateTimeRange visibleDateRange,
    required double multiDayTileHeight,
    required List<CalendarEvent<T>> events,
  }) {
    return MultiDayEventGroupDefaultLayoutDelegate(
      events: events,
      visibleDateRange: visibleDateRange,
      multiDayTileHeight: multiDayTileHeight,
    );
  }

  /// The default [MonthLayoutController] used to layout the month tiles.
  MultiDayEventGroupLayoutDelegate<T> defaultMonthTileLayoutController({
    required DateTimeRange visibleDateRange,
    required double multiDayTileHeight,
    required List<CalendarEvent<T>> events,
  }) {
    return MultiDayEventGroupDefaultLayoutDelegate(
      events: events,
      visibleDateRange: visibleDateRange,
      multiDayTileHeight: multiDayTileHeight,
    );
  }

  @override
  operator ==(Object other) {
    return other is CalendarLayoutControllers &&
        other.dayTileLayoutController == dayTileLayoutController &&
        other.multiDayTileLayoutController == multiDayTileLayoutController &&
        other.monthTileLayoutController == monthTileLayoutController;
  }

  @override
  int get hashCode => Object.hash(
        dayTileLayoutController,
        multiDayTileLayoutController,
        monthTileLayoutController,
      );

  CalendarLayoutControllers<T> copyWith({
    EventLayoutDelegateBuilder<T>? dayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? multiDayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? monthTileLayoutController,
  }) {
    return CalendarLayoutControllers<T>(
      dayTileLayoutController: dayTileLayoutController,
      multiDayTileLayoutController: multiDayTileLayoutController,
      monthTileLayoutController: monthTileLayoutController,
    );
  }
}
