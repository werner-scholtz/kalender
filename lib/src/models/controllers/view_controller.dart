import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/mixins/calendar_navigation_functions.dart';
import 'package:kalender/src/models/view_configurations/export.dart';

/// A controller for calendar views.
///
/// A view controller lets you control a calendar view.
abstract class ViewController<T extends Object?> extends ChangeNotifier
    with CalendarNavigationFunctions<T> {
  ViewController();

  factory ViewController.create({
    required DateTime focusedDate,
    required ViewConfiguration viewConfiguration,
  }) {
    if (viewConfiguration is MultiDayViewConfiguration) {
      return MultiDayViewController(
        viewConfiguration: viewConfiguration,
      );
    }

    return MultiDayViewController(
      viewConfiguration: viewConfiguration as MultiDayViewConfiguration,
    );
  }

  /// The view configuration that will be used by the controller.
  ViewConfiguration get viewConfiguration;

  /// Jump to the given [DateTime].
  @override
  void jumpToPage(int page);

  /// Jump to the given [DateTime].
  @override
  void jumpToDate(DateTime date);

  /// Animate to the next page.
  ///
  /// [duration] the [Duration] of the animation.
  /// [curve] the [Curve] of the animation.
  @override
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the previous page.
  ///
  /// [duration] the [Duration] of the animation.
  /// [curve] the [Curve] of the animation.
  @override
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the given [DateTime].
  ///
  /// [date] the [DateTime] to animate to.
  /// [duration] the [Duration] of the animation.
  /// [curve] the [Curve] of the animation.
  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the given [DateTime].
  ///
  /// [date] the [DateTime] to animate to.
  /// [pageDuration] the [Duration] of the page animation.
  /// [pageCurve] the [Curve] of the page animation.
  /// [scrollDuration] the [Duration] of the scroll animation.
  /// [scrollCurve] the [Curve] of the scroll animation.
  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  });

  /// Animate to the given [CalendarEvent].
  ///
  /// [event] the [CalendarEvent] to animate to.
  /// [duration] the [Duration] of the animation.
  /// [curve] the [Curve] of the animation.
  /// [centerEvent] whether to center the event in the view.
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
  }) {
    initialPage = viewConfiguration.pageNavigationFunctions.indexFromDate(
      DateTime.now(),
    );
  }

  @override
  final MultiDayViewConfiguration viewConfiguration;

  late final int initialPage;

  /// The pageController of the current view.
  PageController? pageController;

  /// The scrollController of the current view.
  ScrollController? scrollController;

  /// The Height of each minute.jum
  ValueNotifier<double>? heightPerMinute;

  /// The visible date time range.
  ValueNotifier<DateTimeRange>? visibleDateTimeRange;

  /// Attach the body to the controller.
  void attachBody({
    required PageController pageController,
    required ValueNotifier<double> heightPerMinute,
    required ScrollController scrollController,
    required ValueNotifier<DateTimeRange> visibleDateTimeRange,
  }) {
    this.pageController = pageController;
    this.scrollController = scrollController;
    this.heightPerMinute = heightPerMinute;

    this.visibleDateTimeRange = visibleDateTimeRange;
  }

  /// Detach the body from the controller.
  void detachBody() {
    pageController = null;
    scrollController = null;
    heightPerMinute = null;
  }

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
    await pageController?.animateToPage(
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

    final timeOffset =
        timeDifference.inMinutes * (heightPerMinute?.value ?? 0.0);

    // Animate to the offset of the time.
    await scrollController?.animateTo(
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
    await pageController?.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    await pageController?.previousPage(
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
  void jumpToPage(int page) => pageController?.jumpToPage(page);

  @override
  String toString() {
    return '${runtimeType.toString()} (${viewConfiguration.runtimeType})';
  }
}
