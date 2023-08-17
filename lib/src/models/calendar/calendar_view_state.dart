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
    required this.visibleDateTimeRange,
    this.heightPerMinute,
  });

  /// The current viewConfiguration of the view.
  final ViewConfiguration viewConfiguration;

  /// The pageController of the [CalendarView].
  final PageController pageController;

  /// The scrollController of the [CalendarView].
  final ScrollController scrollController;

  ScrollPhysics scrollPhysics = const ScrollPhysics();

  /// The height per minute of the [CalendarView].
  /// This is only used in the [SingleDayView] & [MultiDayView].
  final ValueNotifier<double>? heightPerMinute;

  /// The visible dateTimeRange of the [CalendarView].
  final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  /// The adjusted dateTimeRange of the [CalendarView].
  final DateTimeRange adjustedDateTimeRange;

  /// The number of pages the [PageView] of the [CalendarView] has.
  final int numberOfPages;

  /// The current month that is displayed.
  DateTime get month {
    if (viewConfiguration is MonthViewConfiguration) {
      return visibleDateTimeRange.value.visibleMonth;
    } else {
      return visibleDateTimeRange.value.start;
    }
  }

  /// The current year that is displayed.
  DateTime get year {
    if (viewConfiguration is MonthViewConfiguration) {
      DateTime month = visibleDateTimeRange.value.visibleMonth;
      return DateTime(month.year);
    } else {
      return DateTime(visibleDateTimeRange.value.start.year);
    }
  }

  @override
  operator ==(Object other) {
    return other is ViewState &&
        viewConfiguration == other.viewConfiguration &&
        pageController == other.pageController &&
        scrollController == other.scrollController &&
        heightPerMinute == other.heightPerMinute &&
        visibleDateTimeRange == other.visibleDateTimeRange &&
        adjustedDateTimeRange == other.adjustedDateTimeRange &&
        numberOfPages == other.numberOfPages;
  }

  @override
  int get hashCode => Object.hash(
        viewConfiguration,
        pageController,
        scrollController,
        heightPerMinute?.value,
        visibleDateTimeRange.value,
        adjustedDateTimeRange,
        numberOfPages,
      );
}
