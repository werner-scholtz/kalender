import 'package:kalender/kalender.dart';

/// Strategy typedef for determining the initial date when transitioning between view configurations.
///
/// - [oldViewController]: the controller of the view being switched away from.
/// - [newViewConfiguration]: the configuration of the view being switched to.
/// - [lastVisibleDates]: the last visible date each view showed, keyed by the
///   view configuration's `name`. Used by history-aware strategies such as
///   [kRestoreLastVisitedDate]; ignore it for stateless "carry-focus" strategies.
typedef InitialDateSelectionStrategy = InternalDateTime Function({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
  required Map<String, InternalDateTime> lastVisibleDates,
});

/// Default implementation for transitioning to Monthly view
InternalDateTime kDefaultToMonthly({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
  required Map<String, InternalDateTime> lastVisibleDates,
}) {
  final oldConfig = oldViewController.viewConfiguration;
  final oldRange = oldViewController.visibleDateTimeRange.value!;
  switch (oldConfig) {
    case MonthViewConfiguration _:
      return InternalDateTime.fromDateTime(oldRange.dominantMonthDate);
    case MultiDayViewConfiguration _:
      return oldRange.start;
    case ScheduleViewConfiguration _:
      return oldRange.start;
    default:
      return InternalDateTime.fromDateTime(oldRange.dominantMonthDate);
  }
}

/// Default implementation for transitioning to Weekly view
InternalDateTime kDefaultToWeekly({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
  required Map<String, InternalDateTime> lastVisibleDates,
}) {
  final oldConfig = oldViewController.viewConfiguration;
  final oldRange = oldViewController.visibleDateTimeRange.value!;
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
InternalDateTime kDefaultToDaily({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
  required Map<String, InternalDateTime> lastVisibleDates,
}) {
  final oldConfig = oldViewController.viewConfiguration;
  final oldRange = oldViewController.visibleDateTimeRange.value!;
  switch (oldConfig) {
    case MonthViewConfiguration _:
      return InternalDateTime.fromDateTime(oldRange.dominantMonthDate);
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

/// Default implementation for transitioning to Schedule view
InternalDateTime kDefaultToSchedule({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
  required Map<String, InternalDateTime> lastVisibleDates,
}) {
  final oldRange = oldViewController.visibleDateTimeRange.value!;
  return oldRange.start;
}

/// General default strategy that routes to appropriate specific strategies
InternalDateTime kDefaultInitialDateSelectionStrategy({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
  required Map<String, InternalDateTime> lastVisibleDates,
}) {
  return switch (newViewConfiguration) {
    MonthViewConfiguration _ => kDefaultToMonthly(
        oldViewController: oldViewController,
        newViewConfiguration: newViewConfiguration,
        lastVisibleDates: lastVisibleDates,
      ),
    ScheduleViewConfiguration _ => kDefaultToSchedule(
        oldViewController: oldViewController,
        newViewConfiguration: newViewConfiguration,
        lastVisibleDates: lastVisibleDates,
      ),
    final MultiDayViewConfiguration viewConfig => switch (viewConfig.type) {
        MultiDayViewType.custom when viewConfig.numberOfDays == 1 => kDefaultToDaily(
            oldViewController: oldViewController,
            newViewConfiguration: newViewConfiguration,
            lastVisibleDates: lastVisibleDates,
          ),
        MultiDayViewType.freeScroll when viewConfig.numberOfDays == 1 => kDefaultToDaily(
            oldViewController: oldViewController,
            newViewConfiguration: newViewConfiguration,
            lastVisibleDates: lastVisibleDates,
          ),
        MultiDayViewType.singleDay => kDefaultToDaily(
            oldViewController: oldViewController,
            newViewConfiguration: newViewConfiguration,
            lastVisibleDates: lastVisibleDates,
          ),
        _ => kDefaultToWeekly(
            oldViewController: oldViewController,
            newViewConfiguration: newViewConfiguration,
            lastVisibleDates: lastVisibleDates,
          ),
      },
    _ => kDefaultToDaily(
        oldViewController: oldViewController,
        newViewConfiguration: newViewConfiguration,
        lastVisibleDates: lastVisibleDates,
      ),
  };
}

/// Strategy that restores each view's own last-visited date.
///
/// Unlike the default "carry-focus" strategies (which derive the new date from
/// the view being switched away from), this looks up the last date the target
/// view itself displayed — keyed by the view configuration's `name` — so
/// switching, for example, Day → Month → Day reopens the day you last had in the
/// Day view. Views are matched by `name`, so give each view a distinct name.
///
/// Falls back to [kDefaultInitialDateSelectionStrategy] when the target view has
/// no recorded history yet (e.g. the first time it is shown).
InternalDateTime kRestoreLastVisitedDate({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
  required Map<String, InternalDateTime> lastVisibleDates,
}) {
  return lastVisibleDates[newViewConfiguration.name] ??
      kDefaultInitialDateSelectionStrategy(
        oldViewController: oldViewController,
        newViewConfiguration: newViewConfiguration,
        lastVisibleDates: lastVisibleDates,
      );
}
