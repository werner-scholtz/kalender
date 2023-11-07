import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/type_definitions.dart';

/// The [CalendarLayoutDelegates] class contains layout controllers used by the calendar view.
class CalendarLayoutDelegates<T> {
  CalendarLayoutDelegates({
    EventLayoutDelegateBuilder<T>? tileLayoutDelegate,
    MultiDayEventLayoutDelegateBuilder<T>? multiDayTileLayoutDelegate,
    MultiDayEventLayoutDelegateBuilder<T>? monthTileLayoutDelegate,
  }) {
    this.tileLayoutDelegate =
        tileLayoutDelegate ?? defaultDayTileLayoutController;

    this.multiDayTileLayoutDelegate =
        multiDayTileLayoutDelegate ?? defaultMultiDayTileLayoutController;

    this.monthTileLayoutDelegate =
        monthTileLayoutDelegate ?? defaultMonthTileLayoutController;
  }

  ///
  late EventLayoutDelegateBuilder<T> tileLayoutDelegate;

  ///
  late MultiDayEventLayoutDelegateBuilder<T> multiDayTileLayoutDelegate;

  ///
  late MultiDayEventLayoutDelegateBuilder<T> monthTileLayoutDelegate;

  /// The default [EventGroupLayoutDelegate] used to layout the day tiles.
  EventGroupLayoutDelegate<T> defaultDayTileLayoutController({
    required List<CalendarEvent<T>> events,
    required DateTime date,
    required double heightPerMinute,
    required int startHour,
    required int endHour,
  }) {
    return EventGroupOverlapLayoutDelegate(
      events: events,
      date: date,
      heightPerMinute: heightPerMinute,
      startHour: startHour,
      endHour: endHour,
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
        other.tileLayoutDelegate == tileLayoutDelegate &&
        other.multiDayTileLayoutDelegate == multiDayTileLayoutDelegate &&
        other.monthTileLayoutDelegate == monthTileLayoutDelegate;
  }

  @override
  int get hashCode => Object.hash(
        tileLayoutDelegate,
        multiDayTileLayoutDelegate,
        monthTileLayoutDelegate,
      );

  CalendarLayoutDelegates<T> copyWith({
    EventLayoutDelegateBuilder<T>? dayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? multiDayTileLayoutController,
    MultiDayEventLayoutDelegateBuilder<T>? monthTileLayoutController,
  }) {
    return CalendarLayoutDelegates<T>(
      tileLayoutDelegate: dayTileLayoutController,
      multiDayTileLayoutDelegate: multiDayTileLayoutController,
      monthTileLayoutDelegate: monthTileLayoutController,
    );
  }
}
