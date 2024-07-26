import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/calendar_navigation_functions.dart';

/// A controller for calendar views.
///
/// A view controller lets you control a calendar view.
abstract class ViewController<T extends Object?> with CalendarNavigationFunctions<T> {
  /// The view configuration that will be used by the controller.
  ViewConfiguration get viewConfiguration;

  /// The [DateTimeRange] that is currently visible.
  ValueNotifier<DateTimeRange> get visibleDateTimeRange;

  /// The [CalendarEvent]s that are currently visible.
  ValueNotifier<List<CalendarEvent<T>>> get visibleEvents;

  /// Jump to the given [DateTime].
  @override
  void jumpToPage(int page);

  /// Jump to the given [DateTime].
  @override
  void jumpToDate(DateTime date);

  @override
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  });

  @override
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  });

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  });

  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  });

  @override
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? duration,
    Curve? curve,
    bool centerEvent = true,
  });

  @override
  String toString() {
    return runtimeType.toString();
  }
}

class MultiDayViewController<T extends Object?> extends ViewController<T> {
  MultiDayViewController({
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
    required this.visibleEvents,
    ViewController? previousViewConfiguration,
    // TODO: pass this in
    DateTime? initialDate,
  }) {
    final pageNavigationFunctions = viewConfiguration.pageNavigationFunctions;
    initialPage = pageNavigationFunctions.indexFromDate(initialDate ?? DateTime.now());
    pageController = PageController(initialPage: initialPage, viewportFraction: 1);
    headerController = PageController(initialPage: initialPage, viewportFraction: 1);
    numberOfPages = pageNavigationFunctions.numberOfPages;
    heightPerMinute = ValueNotifier<double>(0.7);
    visibleDateTimeRange.value = pageNavigationFunctions.dateTimeRangeFromIndex(initialPage);
    scrollController = ScrollController();
    visibleEvents.value = [];

    // This listener will sync the headerController with the pageController.
    // Note this only really works if both PageView's have the same horizontal 'size'.
    pageController.addListener(() {
      if (!headerController.hasClients) return;
      headerController.position.correctPixels(pageController.offset);
      headerController.position.notifyListeners();
    });
  }

  @override
  final MultiDayViewConfiguration viewConfiguration;

  /// The initial page of the view.
  late final int initialPage;

  /// The number of pages in the view.
  late final int numberOfPages;

  /// The page controller used by the view.
  late final PageController pageController;

  /// The page controller used by the header. (Linked to [pageController])
  late final PageController headerController;

  /// The scroll controller used by the view.
  late ScrollController scrollController;

  /// The height per minute of the view.
  late ValueNotifier<double> heightPerMinute;

  @override
  final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  @override
  final ValueNotifier<List<CalendarEvent<T>>> visibleEvents;

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    // Calculate the pageNumber of the date.
    final pageNumber = viewConfiguration.pageNavigationFunctions.indexFromDate(
      date,
    );


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

    // TODO: Figure out how custom hours will work.
    final timeDifference = date.difference(date.startOfDay);
    final timeOffset = timeDifference.inMinutes * (heightPerMinute.value);

    // Animate to the offset of the time.
    await scrollController.animateTo(
      timeOffset,
      duration: scrollDuration ?? const Duration(milliseconds: 300),
      curve: scrollCurve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? duration,
    Curve? curve,
    bool centerEvent = true,
  }) {
    // TODO: implement animateToEvent
    throw UnimplementedError();
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
}

class MonthViewController<T extends Object?> extends ViewController<T> {
  MonthViewController({
    required this.viewConfiguration,
    ViewController? previousViewConfiguration,
    // TODO: pass this in
    DateTime? initialDate,
  }) {
    final pageNavigationFunctions = viewConfiguration.pageNavigationFunctions;
    initialPage = pageNavigationFunctions.indexFromDate(initialDate ?? DateTime.now());
    pageController = PageController(initialPage: initialPage);
    numberOfPages = pageNavigationFunctions.numberOfPages;
    visibleDateTimeRange = ValueNotifier<DateTimeRange>(
      pageNavigationFunctions.dateTimeRangeFromIndex(initialPage),
    );
    visibleEvents = ValueNotifier<List<CalendarEvent<T>>>([]);
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
  late final ValueNotifier<List<CalendarEvent<T>>> visibleEvents;

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    // Calculate the pageNumber of the date.
    final pageNumber = viewConfiguration.pageNavigationFunctions.indexFromDate(
      date,
    );

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
    Duration? duration,
    Curve? curve,
    bool centerEvent = true,
  }) {
    // TODO: implement animateToEvent
    throw UnimplementedError();
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
}
