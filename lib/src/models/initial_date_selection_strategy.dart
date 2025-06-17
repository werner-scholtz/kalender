import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// Strategy interface for determining the initial date when transitioning between view configurations
abstract class InitialDateSelectionStrategy {
  /// Calculates the initial date when transitioning between view configurations
  ///
  /// [oldViewController] - the previous view controller
  /// [newViewConfiguration] - the new view configuration
  /// [currentVisibleRange] - the currently visible date range
  DateTime calculateInitialDate({
    required ViewController oldViewController,
    required ViewConfiguration newViewConfiguration,
    required DateTimeRange currentVisibleRange,
  });
}

/// Default implementation of initial date selection strategy following specific rules for each transition type
class DefaultInitialDateSelectionStrategy implements InitialDateSelectionStrategy {
  const DefaultInitialDateSelectionStrategy();

  @override
  DateTime calculateInitialDate({
    required ViewController oldViewController,
    required ViewConfiguration newViewConfiguration,
    required DateTimeRange currentVisibleRange,
  }) {
    final oldConfig = oldViewController.viewConfiguration;

    // Determine view types
    final oldViewType = _getViewType(oldConfig);
    final newViewType = _getViewType(newViewConfiguration);

    return switch ((oldViewType, newViewType)) {
      // Monthly to Daily: take first day of current month
      (_ViewType.monthly, _ViewType.daily) => _monthToDaily(currentVisibleRange),

      // Monthly to Weekly: take first week from visualized months (start of visible range)
      (_ViewType.monthly, _ViewType.weekly) => _monthToWeekly(currentVisibleRange),

      // Weekly to Daily: take first day of the week
      (_ViewType.weekly, _ViewType.daily) => _weeklyToDaily(currentVisibleRange),

      // Weekly to Monthly: check current week days, take majority month
      (_ViewType.weekly, _ViewType.monthly) => _weeklyToMonthly(currentVisibleRange),

      // Daily to Weekly: show current day's week
      (_ViewType.daily, _ViewType.weekly) => _dailyToWeekly(currentVisibleRange),

      // Daily to Monthly: show this day's month
      (_ViewType.daily, _ViewType.monthly) => _dailyToMonthly(currentVisibleRange),

      // Schedule transitions - use start of visible range
      (_ViewType.schedule, _) => currentVisibleRange.start,
      (_, _ViewType.schedule) => currentVisibleRange.start,

      // Same type transitions - maintain current position
      _ => currentVisibleRange.start,
    };
  }

  DateTime _monthToDaily(DateTimeRange currentVisibleRange) => currentVisibleRange.dominantMonthDate;

  DateTime _monthToWeekly(DateTimeRange currentVisibleRange) => currentVisibleRange.start;

  DateTime _weeklyToDaily(DateTimeRange currentVisibleRange) => currentVisibleRange.start;

  DateTime _weeklyToMonthly(DateTimeRange currentVisibleRange) => currentVisibleRange.dominantMonthDate;

  DateTime _dailyToWeekly(DateTimeRange currentVisibleRange) => currentVisibleRange.start;

  DateTime _dailyToMonthly(DateTimeRange currentVisibleRange) =>
      DateTime(currentVisibleRange.start.year, currentVisibleRange.start.month, 1);

  _ViewType _getViewType(ViewConfiguration config) {
    return switch (config.runtimeType) {
      const (MonthViewConfiguration) => _ViewType.monthly,
      const (MultiDayViewConfiguration) => _getMultiDayViewType(config as MultiDayViewConfiguration),
      const (ScheduleViewConfiguration) => _ViewType.schedule,
      _ => _ViewType.unknown,
    };
  }

  _ViewType _getMultiDayViewType(MultiDayViewConfiguration config) {
    return switch (config.type) {
      MultiDayViewType.singleDay => _ViewType.daily,
      MultiDayViewType.week => _ViewType.weekly,
      MultiDayViewType.workWeek => _ViewType.weekly,
      MultiDayViewType.custom => config.numberOfDays == 1 ? _ViewType.daily : _ViewType.weekly,
      MultiDayViewType.freeScroll => _ViewType.weekly,
    };
  }
}

/// Enumeration of view types for easier pattern matching
enum _ViewType {
  daily,
  weekly,
  monthly,
  schedule,
  unknown,
}
