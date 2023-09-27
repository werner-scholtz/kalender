import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/schedule_group.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// The base class for the viewStates.
abstract class ViewState {
  ViewState({
    required ValueNotifier<DateTimeRange> visibleDateTimeRange,
  }) : _visibleDateTimeRange = visibleDateTimeRange;

  /// The current viewConfiguration of the view.
  ViewConfiguration get viewConfiguration;

  final ValueNotifier<DateTimeRange> _visibleDateTimeRange;
  ValueNotifier<DateTimeRange> get visibleDateTimeRangeNotifier =>
      _visibleDateTimeRange;
  DateTimeRange get visibleDateTimeRange => _visibleDateTimeRange.value;

  set visibleDateTimeRange(DateTimeRange value);

  /// The visible month notifier of the current page.
  late DateTime _visibleMonth = _visibleDateTimeRange.value.start.startOfMonth;
  DateTime get visibleMonth => _visibleMonth;

  /// The adjusted dateTimeRange of the current view.
  DateTimeRange get adjustedDateTimeRange;

  @override
  operator ==(Object other);

  @override
  int get hashCode;
}

/// The viewState for the [ScheduleView].
class ScheduleViewState<T> extends ViewState {
  ScheduleViewState({
    required super.visibleDateTimeRange,
    required this.viewConfiguration,
    required this.adjustedDateTimeRange,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  final ScheduleViewConfiguration viewConfiguration;

  @override
  set visibleDateTimeRange(DateTimeRange value) {
    _visibleDateTimeRange.value = value;
    _visibleMonth = _visibleDateTimeRange.value.start.startOfMonth;
  }

  /// The ItemScrollController of the current view.
  final ItemScrollController itemScrollController;

  /// The ItemPositionsListener of the current view.
  final ItemPositionsListener itemPositionsListener;

  final ValueNotifier<List<ScheduleGroup<T>>> _scheduleGroups =
      ValueNotifier([]);
  ValueNotifier<List<ScheduleGroup<T>>> get scheduleGroupsNotifier =>
      _scheduleGroups;
  List<ScheduleGroup<T>> get scheduleGroups => _scheduleGroups.value;
  set scheduleGroups(List<ScheduleGroup<T>> value) {
    _scheduleGroups.value = value;
  }

  @override
  operator ==(Object other);

  @override
  int get hashCode;

  @override
  final DateTimeRange adjustedDateTimeRange;
}

/// The viewState for the [MultiDayView].
class MultiDayViewState extends ViewState {
  MultiDayViewState({
    required super.visibleDateTimeRange,
    required this.viewConfiguration,
    this.heightPerMinute,
    required this.adjustedDateTimeRange,
    required this.numberOfPages,
    required this.pageController,
    required this.scrollController,
  });

  @override
  final MultiDayViewConfiguration viewConfiguration;

  final ValueNotifier<double>? heightPerMinute;

  @override
  set visibleDateTimeRange(DateTimeRange value) {
    _visibleDateTimeRange.value = value;
    _visibleMonth = _visibleDateTimeRange.value.start.startOfMonth;
  }

  /// The pageController of the current view.
  final PageController? pageController;

  /// The scrollController of the current view.
  final ScrollController scrollController;

  /// The scrollPhysics of the current view.
  ValueNotifier<ScrollPhysics> scrollPhysics =
      ValueNotifier<ScrollPhysics>(const ScrollPhysics());

  /// The adjusted dateTimeRange of the current view.
  @override
  final DateTimeRange adjustedDateTimeRange;

  /// The number of pages the [PageView] of the current view has.
  final int numberOfPages;

  @override
  operator ==(Object other);

  @override
  int get hashCode;
}

/// The viewState for the [DayView].
class MonthViewState extends ViewState {
  MonthViewState({
    required super.visibleDateTimeRange,
    required this.viewConfiguration,
    required this.adjustedDateTimeRange,
    required this.numberOfPages,
    required this.pageController,
  });

  @override
  final MonthViewConfiguration viewConfiguration;

  @override
  set visibleDateTimeRange(DateTimeRange value) {
    _visibleDateTimeRange.value = value;
    final month = _visibleDateTimeRange.value.visibleMonth.startOfMonth;
    _visibleMonth = month.startOfMonth;
  }

  /// The pageController of the current view.
  final PageController? pageController;

  /// The adjusted dateTimeRange of the current view.
  @override
  final DateTimeRange adjustedDateTimeRange;

  /// The number of pages the [PageView] of the current view has.
  final int numberOfPages;

  @override
  operator ==(Object other);

  @override
  int get hashCode;
}
