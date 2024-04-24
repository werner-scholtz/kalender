import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/view_state/view_state.dart';
import 'package:kalender/src/models/view_configurations/month_configurations/month_view_configuration.dart';

/// The viewState for the [MonthView].
class MonthViewState extends ViewState {
  MonthViewState({
    required super.visibleDateTimeRange,
    required this.adjustedDateTimeRange,
    required this.numberOfPages,
    required this.pageController,
    required this.viewConfiguration,
  });

  /// Creates a [MultiDayViewState] from a [MultiDayViewConfiguration].
  factory MonthViewState.fromViewConfiguration({
    required DateTimeRange dateTimeRange,
    required DateTime selectedDate,
    required MonthViewConfiguration viewConfiguration,
    required MonthViewState? previousState,
  }) {
    final adjustedDateTimeRange =
        viewConfiguration.calculateAdjustedDateTimeRange(
      dateTimeRange: dateTimeRange,
    );

    final numberOfPages = viewConfiguration.calculateNumberOfPages(
      adjustedDateTimeRange,
    );

    final initialPage = viewConfiguration.calculateDateIndex(
      selectedDate,
      adjustedDateTimeRange.start,
    );

    final pageController = PageController(
      initialPage: initialPage,
    );

    final visibleDateRange = viewConfiguration.calculateVisibleDateTimeRange(
      selectedDate,
    );

    return MonthViewState(
      visibleDateTimeRange: ValueNotifier(visibleDateRange),
      viewConfiguration: viewConfiguration,
      adjustedDateTimeRange: adjustedDateTimeRange,
      numberOfPages: numberOfPages,
      pageController: pageController,
    );
  }

  @override
  final MonthViewConfiguration viewConfiguration;

  @override
  set visibleDateTimeRange(DateTimeRange value) {
    visibleDateTimeRangeNotifier.value = value;
    final month = visibleDateTimeRangeNotifier.value.visibleMonth.startOfMonth;
    visibleMonth = month.startOfMonth;
  }

  /// The pageController of the current view.
  final PageController? pageController;

  /// The adjusted dateTimeRange of the current view.
  @override
  final DateTimeRange adjustedDateTimeRange;

  /// The number of pages the [PageView] of the current view has.
  final int numberOfPages;

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
    final pageNumber = viewConfiguration.calculateDateIndex(
      date,
      adjustedDateTimeRange.start,
    );

    await pageController?.animateToPage(
      pageNumber,
      duration: duration ?? const Duration(milliseconds: 300),
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
    // First animate to the date of the event.
    await animateToDate(
      event.dateTimeRange.start,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.ease,
    );
  }

  @override
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  }) async {
    await pageController?.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  }) async {
    await pageController?.previousPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void jumpToDate(DateTime date) {
    // Calculate the page number of the given date.
    final pageNumber = viewConfiguration.calculateDateIndex(
      date,
      adjustedDateTimeRange.start,
    );

    // Jump to the page.
    jumpToPage(pageNumber);
  }

  @override
  void jumpToPage(int page) {
    pageController?.jumpToPage(page);
  }

  @override
  operator ==(Object other) {
    return other is MonthViewState &&
        other.visibleDateTimeRange == visibleDateTimeRange &&
        other.adjustedDateTimeRange == adjustedDateTimeRange &&
        other.numberOfPages == numberOfPages &&
        other.pageController == pageController;
  }

  @override
  int get hashCode {
    return Object.hash(
      visibleDateTimeRange,
      adjustedDateTimeRange,
      numberOfPages,
      pageController,
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
