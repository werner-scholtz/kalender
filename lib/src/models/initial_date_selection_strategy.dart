import 'package:kalender/kalender.dart';

/// Strategy typedef for determining the initial date when transitioning between view configurations
typedef InitialDateSelectionStrategy = DateTime Function({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
});

/// Default implementation for transitioning to Monthly view
DateTime kDefaultToMonthly({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
}) {
  final oldConfig = oldViewController.viewConfiguration;
  final oldRange = oldViewController.visibleDateTimeRange.value;
  switch (oldConfig) {
    case MonthViewConfiguration _:
      return oldRange.dominantMonthDate;
    case MultiDayViewConfiguration _:
      return oldRange.start;
    case ScheduleViewConfiguration _:
      return oldRange.start;
    default:
      return oldRange.dominantMonthDate;
  }
}

/// Default implementation for transitioning to Weekly view
DateTime kDefaultToWeekly({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
}) {
  final oldConfig = oldViewController.viewConfiguration;
  final oldRange = oldViewController.visibleDateTimeRange.value;
  switch (oldConfig) {
    case MonthViewConfiguration _:
      return oldRange.start;
    case final MultiDayViewConfiguration multiDayConfig:
      final viewType = _getMultiDayViewType(multiDayConfig);
      return switch (viewType) {
        _MultiDayViewType.weekly => oldRange.start,
        _MultiDayViewType.daily => oldRange.start,
      };
    case ScheduleViewConfiguration _:
      return oldRange.start;
    default:
      return oldRange.start;
  }
}

/// Default implementation for transitioning to Daily view
DateTime kDefaultToDaily({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
}) {
  final oldConfig = oldViewController.viewConfiguration;
  final oldRange = oldViewController.visibleDateTimeRange.value;
  switch (oldConfig) {
    case MonthViewConfiguration _:
      return oldRange.dominantMonthDate;
    case final MultiDayViewConfiguration multiDayConfig:
      final viewType = _getMultiDayViewType(multiDayConfig);
      return switch (viewType) {
        _MultiDayViewType.weekly => oldRange.start,
        _MultiDayViewType.daily => oldRange.start,
      };
    case ScheduleViewConfiguration _:
      return oldRange.start;
    default:
      return oldRange.start;
  }
}

/// Default implementation for transitioning to Schedule view
DateTime kDefaultToSchedule({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
}) {
  final oldRange = oldViewController.visibleDateTimeRange.value;
  return oldRange.start;
}

/// General default strategy that routes to appropriate specific strategies
DateTime kDefaultInitialDateSelectionStrategy({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
}) {
  return switch (newViewConfiguration) {
    MonthViewConfiguration _ => kDefaultToMonthly(
        oldViewController: oldViewController,
        newViewConfiguration: newViewConfiguration,
      ),
    final MultiDayViewConfiguration multiDayConfig => switch (_getMultiDayViewType(multiDayConfig)) {
        _MultiDayViewType.weekly => kDefaultToWeekly(
            oldViewController: oldViewController,
            newViewConfiguration: newViewConfiguration,
          ),
        _MultiDayViewType.daily => kDefaultToDaily(
            oldViewController: oldViewController,
            newViewConfiguration: newViewConfiguration,
          ),
      },
    ScheduleViewConfiguration _ => kDefaultToSchedule(
        oldViewController: oldViewController,
        newViewConfiguration: newViewConfiguration,
      ),
    _ => kDefaultToDaily(
        oldViewController: oldViewController,
        newViewConfiguration: newViewConfiguration,
      ),
  };
}

_MultiDayViewType _getMultiDayViewType(MultiDayViewConfiguration config) {
  return switch (config.type) {
    MultiDayViewType.singleDay => _MultiDayViewType.daily,
    MultiDayViewType.week => _MultiDayViewType.weekly,
    MultiDayViewType.workWeek => _MultiDayViewType.weekly,
    MultiDayViewType.custom => config.numberOfDays == 1 ? _MultiDayViewType.daily : _MultiDayViewType.weekly,
    MultiDayViewType.freeScroll => _MultiDayViewType.weekly,
  };
}

/// Enumeration of multi-day view types for easier pattern matching
enum _MultiDayViewType {
  daily,
  weekly,
}
