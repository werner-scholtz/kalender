import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/mixins/calendar_navigation_functions.dart';

/// A controller for calendar views.
///
/// A view controller lets you control a calendar view.
abstract class ViewController<T extends Object?> extends ChangeNotifier
    with CalendarNavigationFunctions<T> {
  /// The view configuration that will be used by the controller.
  ViewConfiguration get viewConfiguration;

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
    ViewController? previousViewConfiguration,
  }) {
    final pageNavigationFunctions = viewConfiguration.pageNavigationFunctions;
    initialPage = pageNavigationFunctions.indexFromDate(DateTime.now());
    pageController = PageController(initialPage: initialPage);
    numberOfPages = pageNavigationFunctions.numberOfPages;
    heightPerMinute = ValueNotifier<double>(0.7);
    visibleDateTimeRange = ValueNotifier<DateTimeRange>(
      pageNavigationFunctions.dateTimeRangeFromIndex(initialPage),
    );
    eventBeingDragged = ValueNotifier<CalendarEvent<T>?>(null);
    scrollController = ScrollController();
  }

  @override
  final MultiDayViewConfiguration viewConfiguration;

  /// The initial page of the view.
  late final int initialPage;

  /// The number of pages in the view.
  late final int numberOfPages;

  /// The page controller used by the view.
  late final PageController pageController;

  /// The scroll controller used by the view.
  late ScrollController scrollController;

  /// The height per minute of the view.
  late final ValueNotifier<double> heightPerMinute;

  /// The visible date time range of the view.
  late final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  /// The event being dragged.
  late final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;
  int? draggingEventId;

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
