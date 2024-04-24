import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/view_state/view_state.dart';
import 'package:kalender/src/models/schedule_group.dart';
import 'package:kalender/src/models/view_configurations/schedule_configurations/schedule_view_configuration.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// The viewState for the [ScheduleView].
class ScheduleViewState extends ViewState {
  ScheduleViewState({
    required super.visibleDateTimeRange,
    required this.adjustedDateTimeRange,
    required this.viewConfiguration,
  });

  /// Creates a [ScheduleViewState] from a [ScheduleViewConfiguration].
  factory ScheduleViewState.fromViewConfiguration({
    required DateTimeRange dateTimeRange,
    required DateTime selectedDate,
    required ScheduleViewConfiguration viewConfiguration,
    required ScheduleViewState? previousState,
  }) {
    final adjustedDateTimeRange =
        viewConfiguration.calculateAdjustedDateTimeRange(
      dateTimeRange: dateTimeRange,
    );

    final visibleDateRange = viewConfiguration.calculateVisibleDateTimeRange(
      selectedDate,
    );

    return ScheduleViewState(
      viewConfiguration: viewConfiguration,
      adjustedDateTimeRange: adjustedDateTimeRange,
      visibleDateTimeRange: previousState?.visibleDateTimeRangeNotifier ??
          ValueNotifier<DateTimeRange>(visibleDateRange),
    );
  }

  @override
  final ScheduleViewConfiguration viewConfiguration;

  @override
  set visibleDateTimeRange(DateTimeRange value) {
    visibleDateTimeRangeNotifier.value = value;
    visibleMonth = visibleDateTimeRange.start.startOfMonth;
  }

  /// The ItemScrollController of the current view.
  final ItemScrollController itemScrollController = ItemScrollController();

  /// The ItemPositionsListener of the current view.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final ValueNotifier<List<ScheduleGroup>> _scheduleGroups = ValueNotifier([]);
  ValueNotifier<List<ScheduleGroup>> get scheduleGroupsNotifier =>
      _scheduleGroups;
  List<ScheduleGroup> get scheduleGroups => _scheduleGroups.value;
  set scheduleGroups(List<ScheduleGroup> value) {
    _scheduleGroups.value = value;
  }

  @override
  final DateTimeRange adjustedDateTimeRange;

  @override
  void adjustHeightPerMinute(double heightPerMinute) {
    if (kDebugMode) {
      print(
        'The current view does not support adjusting the height per minute.',
      );
    }
  }

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    var index = scheduleGroups.indexWhere(
      (group) => group.date.isSameDay(date),
    );

    if (index == -1) {
      index = scheduleGroups.indexWhere(
        (group) => group.date.startOfWeek == date.startOfWeek,
      );
    }

    if (index == -1) {
      index = scheduleGroups.indexWhere(
        (group) => group.date.startOfMonth == date.startOfMonth,
      );
    }

    itemScrollController.scrollTo(
      index: index,
      duration: duration ?? const Duration(milliseconds: 500),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToEvent(
    CalendarEvent event, {
    Duration? duration,
    Curve? curve,
    bool centerEvent = true,
  }) async {
    final index = scheduleGroups.indexWhere(
      (group) => group.events.contains(event),
    );

    itemScrollController.scrollTo(
      index: index,
      duration: duration ?? const Duration(milliseconds: 500),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  }) async {
    if (kDebugMode) {
      print(
        'The current view does not support animating to the next page.',
      );
    }
  }

  @override
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  }) async {
    if (kDebugMode) {
      print(
        'The current view does not support animating to the previous page.',
      );
    }
  }

  @override
  void jumpToDate(DateTime date) {
    var index = scheduleGroups.indexWhere(
      (group) => group.date.isSameDay(date),
    );

    if (index == -1) {
      index = scheduleGroups.indexWhere(
        (group) => group.date.startOfWeek == date.startOfWeek,
      );
    }

    if (index == -1) {
      index = scheduleGroups.indexWhere(
        (group) => group.date.startOfMonth == date.startOfMonth,
      );
    }

    itemScrollController.jumpTo(index: index);
  }

  @override
  void jumpToPage(int page) {
    if (kDebugMode) {
      print(
        'The current view does not support jumping to a page.',
      );
    }
  }

  @override
  operator ==(Object other) {
    return other is ScheduleViewState &&
        other.visibleDateTimeRange == visibleDateTimeRange &&
        other.adjustedDateTimeRange == adjustedDateTimeRange &&
        other.itemScrollController == itemScrollController &&
        other.itemPositionsListener == itemPositionsListener;
  }

  @override
  int get hashCode {
    return Object.hash(
      visibleDateTimeRange,
      adjustedDateTimeRange,
      itemScrollController,
      itemPositionsListener,
    );
  }

  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) {
    throw UnimplementedError();
  }
}
