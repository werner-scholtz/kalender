import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';

/// This is used to store state related to a view.
///
/// This state is shared with the [CalendarController]
class ViewState {
  ViewState({
    required this.viewConfiguration,
    required this.pageController,
    required this.scrollController,
    required this.numberOfPages,
    required this.adjustedDateTimeRange,
    required ValueNotifier<DateTimeRange> visibleDateTimeRange,
    this.heightPerMinute,
  }) : _visibleDateTimeRange = visibleDateTimeRange;

  /// The current viewConfiguration of the view.
  final ViewConfiguration viewConfiguration;

  /// The pageController of the current view.
  final PageController pageController;

  /// The scrollController of the current view.
  final ScrollController scrollController;

  /// The scrollPhysics of the current view.
  ValueNotifier<ScrollPhysics> scrollPhysics =
      ValueNotifier<ScrollPhysics>(const ScrollPhysics());

  /// The height per minute of the current view.
  /// This is only used in the [SingleDayView] & [MultiDayView].
  final ValueNotifier<double>? heightPerMinute;

  /// The visible dateTimeRange of the current page.
  final ValueNotifier<DateTimeRange> _visibleDateTimeRange;
  set visibleDateTimeRange(DateTimeRange value) {
    _visibleDateTimeRange.value = value;
    if (viewConfiguration is MonthViewConfiguration) {
      DateTime month = _visibleDateTimeRange.value.visibleMonth.startOfMonth;
      _visibleMonth.value = month.startOfMonth;
    } else {
      _visibleMonth.value = _visibleDateTimeRange.value.start.startOfMonth;
    }
  }

  /// The visible dateTimeRange notifier of the current page.
  ValueNotifier<DateTimeRange> get visibleDateTimeRangeNotifier =>
      _visibleDateTimeRange;

  /// The visible month notifier of the current page.
  late final ValueNotifier<DateTime> _visibleMonth = ValueNotifier<DateTime>(
    _visibleDateTimeRange.value.start.startOfMonth,
  );

  /// The visible month of the current page.
  ValueNotifier<DateTime> get visibleMonth => _visibleMonth;

  /// The adjusted dateTimeRange of the current view.
  final DateTimeRange adjustedDateTimeRange;

  /// The number of pages the [PageView] of the current view has.
  final int numberOfPages;

  @override
  operator ==(Object other) {
    return other is ViewState &&
        viewConfiguration == other.viewConfiguration &&
        pageController == other.pageController &&
        scrollController == other.scrollController &&
        heightPerMinute == other.heightPerMinute &&
        visibleDateTimeRangeNotifier == other.visibleDateTimeRangeNotifier &&
        adjustedDateTimeRange == other.adjustedDateTimeRange &&
        numberOfPages == other.numberOfPages;
  }

  @override
  int get hashCode => Object.hash(
        viewConfiguration,
        pageController,
        scrollController,
        heightPerMinute?.value,
        visibleDateTimeRangeNotifier.value,
        adjustedDateTimeRange,
        numberOfPages,
      );
}
