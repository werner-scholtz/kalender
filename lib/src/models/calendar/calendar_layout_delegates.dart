import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/type_definitions.dart';

/// The [CalendarLayoutDelegates] class contains layout controllers used by the calendar view.
class CalendarLayoutDelegates<T> {
  CalendarLayoutDelegates({
    EventLayoutDelegateBuilder<T>? dayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? multiDayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? monthTileLayoutController,
  }) {
    this.tileLayoutController =
        dayTileLayoutController ?? defaultDayTileLayoutController;

    this.multiDayTileLayoutController =
        multiDayTileLayoutController ?? defaultMultiDayTileLayoutController;

    this.monthTileLayoutController =
        monthTileLayoutController ?? defaultMonthTileLayoutController;
  }

  /// The [DayLayoutController] used to layout the day tiles.
  late EventLayoutDelegateBuilder<T> tileLayoutController;

  /// The [MultiDayLayoutController] used to layout the multi day tiles.
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

  /// The default [MultiDayEventsLayoutDelegate] used to layout the multi day tiles.
  MultiDayEventsLayoutDelegate<T> defaultMultiDayTileLayoutController({
    required DateTimeRange visibleDateRange,
    required double multiDayTileHeight,
    required List<CalendarEvent<T>> events,
  }) {
    return MultiDayEventsDefaultLayoutDelegate(
      events: events,
      visibleDateRange: visibleDateRange,
      multiDayTileHeight: multiDayTileHeight,
    );
  }

  /// The default [MonthLayoutController] used to layout the month tiles.
  MultiDayEventsLayoutDelegate<T> defaultMonthTileLayoutController({
    required DateTimeRange visibleDateRange,
    required double multiDayTileHeight,
    required List<CalendarEvent<T>> events,
  }) {
    return MultiDayEventsDefaultLayoutDelegate(
      events: events,
      visibleDateRange: visibleDateRange,
      multiDayTileHeight: multiDayTileHeight,
    );
  }

  @override
  operator ==(Object other) {
    return other is CalendarLayoutDelegates<T> &&
        other.tileLayoutController == tileLayoutController &&
        other.multiDayTileLayoutController == multiDayTileLayoutController &&
        other.monthTileLayoutController == monthTileLayoutController;
  }

  @override
  int get hashCode => Object.hash(
        tileLayoutController,
        multiDayTileLayoutController,
        monthTileLayoutController,
      );

  CalendarLayoutDelegates<T> copyWith({
    EventLayoutDelegateBuilder<T>? dayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? multiDayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? monthTileLayoutController,
  }) {
    return CalendarLayoutDelegates<T>(
      dayTileLayoutController: dayTileLayoutController,
      multiDayTileLayoutController: multiDayTileLayoutController,
      monthTileLayoutController: monthTileLayoutController,
    );
  }
}
