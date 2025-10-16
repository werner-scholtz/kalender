import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class MonthViewController<T extends Object?> extends ViewController<T> {
  MonthViewController({
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
    required this.visibleEvents,
    DateTime? initialDate,
  }) {
    final pageNavigationFunctions = viewConfiguration.pageNavigationFunctions;
    initialPage = pageNavigationFunctions.indexFromDate(initialDate ?? DateTime.now());
    pageController = PageController(initialPage: initialPage);
    numberOfPages = pageNavigationFunctions.numberOfPages;
    visibleDateTimeRange.value = pageNavigationFunctions.dateTimeRangeFromIndex(initialPage);
    visibleEvents.value = {};
  }

  @override
  final MonthViewConfiguration viewConfiguration;

  /// The initial page of the view.
  late final int initialPage;

  /// The number of pages in the view.
  late final int numberOfPages;

  /// The page controller used by the view.
  late final PageController pageController;

  @override
  late final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  @override
  late final ValueNotifier<Set<CalendarEvent<T>>> visibleEvents;

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    // Calculate the pageNumber of the date.
    final pageNumber = viewConfiguration.pageNavigationFunctions.indexFromDate(date);

    // Animate to that page.
    await pageController.animateToPage(
      pageNumber,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  }) async {
    // Animate to the date.
    await animateToDate(date, duration: pageDuration, curve: pageCurve);
  }

  @override
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) {
    return animateToDateTime(
      event.start,
      pageDuration: pageDuration,
      pageCurve: pageCurve,
      scrollDuration: scrollDuration,
      scrollCurve: scrollCurve,
    );
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) async {
    await pageController.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    await pageController.previousPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void jumpToDate(DateTime date) {
    final pageNumber = viewConfiguration.pageNavigationFunctions.indexFromDate(
      date,
    );
    jumpToPage(pageNumber);
  }

  @override
  void jumpToPage(int page) => pageController.jumpToPage(page);

  @override
  String toString() {
    return '${runtimeType.toString()} (${viewConfiguration.runtimeType})';
  }

  @override
  void dispose() {
    pageController.dispose();
  }
}
