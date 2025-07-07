import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class MultiDayViewController<T extends Object?> extends ViewController<T> {
  MultiDayViewController({
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
    required this.visibleEvents,
    DateTime? initialDate,
  }) {
    final pageNavigationFunctions = viewConfiguration.pageNavigationFunctions;
    initialPage = pageNavigationFunctions.indexFromDate(initialDate ?? DateTime.now());

    final type = viewConfiguration.type;
    final viewPortFraction = type == MultiDayViewType.freeScroll ? 1 / viewConfiguration.numberOfDays : 1.0;

    pageController = PageController(initialPage: initialPage, viewportFraction: viewPortFraction);
    headerController = PageController(initialPage: initialPage, viewportFraction: viewPortFraction);
    numberOfPages = pageNavigationFunctions.numberOfPages;
    heightPerMinute = ValueNotifier<double>(viewConfiguration.initialHeightPerMinute);

    final range = pageNavigationFunctions.dateTimeRangeFromIndex(initialPage);

    if (type == MultiDayViewType.freeScroll) {
      visibleDateTimeRange.value = DateTimeRange(
        start: range.start,
        end: range.start.addDays(viewConfiguration.numberOfDays),
      );
    } else {
      visibleDateTimeRange.value = pageNavigationFunctions.dateTimeRangeFromIndex(initialPage);
    }

    // Calculate the scroll offset so that the initialTimeOfDay is aligned with the top.
    final initialTimeOfDay = viewConfiguration.initialTimeOfDay.toDateTime(DateTime.now());
    final dayStart = viewConfiguration.timeOfDayRange.start.toDateTime(DateTime.now());
    final timeDifference = initialTimeOfDay.difference(dayStart);
    final initialScrollOffset = timeDifference.inMinutes * (heightPerMinute.value);
    scrollController = ScrollController(initialScrollOffset: initialScrollOffset);

    visibleEvents.value = {};

    // This listener will sync the headerController with the pageController.
    // Note this only really works if both PageView's have the same horizontal 'size'.
    pageController.addListener(pageListener);
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

  /// The page offset of the view.
  /// This is a value notifier that updates when the page is scrolled.
  ValueNotifier<double> pageOffset = ValueNotifier<double>(0.0);

  @override
  final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  @override
  final ValueNotifier<Set<CalendarEvent<T>>> visibleEvents;

  void pageListener() {
    if (!headerController.hasClients) return;
    headerController.position.correctPixels(pageController.offset);
    headerController.position.notifyListeners();
    
    // Update the pageOffset based on the current pageController position.
    pageOffset.value = pageController.position.pixels / pageController.position.viewportDimension;
  }

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) {
    // Calculate the pageNumber of the date.
    final pageNumber = viewConfiguration.pageNavigationFunctions.indexFromDate(date);
    // Animate to that page.
    return pageController.animateToPage(
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

    final startOfDay = viewConfiguration.timeOfDayRange.start.toDateTime(date);
    final timeDifference = date.difference(startOfDay);
    final timeOffset = timeDifference.inMinutes * (heightPerMinute.value);

    // Animate to the offset of the time.
    return scrollController.animateTo(
      timeOffset,
      duration: scrollDuration ?? const Duration(milliseconds: 300),
      curve: scrollCurve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) async {
    final DateTime date;

    if (centerEvent) {
      final eventCenter = event.startAsUtc.add(Duration(minutes: event.duration.inMinutes ~/ 2));
      final halfViewPortHeight = scrollController.position.viewportDimension ~/ 2;
      final duration = Duration(minutes: halfViewPortHeight ~/ heightPerMinute.value);
      date = eventCenter.subtract(duration).asLocal;
    } else {
      date = event.start;
    }

    return animateToDateTime(
      date,
      pageDuration: pageDuration,
      pageCurve: pageCurve,
      scrollDuration: scrollDuration,
      scrollCurve: scrollCurve,
    );
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) {
    return pageController.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) {
    return pageController.previousPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void jumpToDate(DateTime date) {
    final pageNumber = viewConfiguration.pageNavigationFunctions.indexFromDate(date);
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
    pageController.removeListener(pageListener);
    pageController.dispose();
    headerController.dispose();
    scrollController.dispose();
  }
}
