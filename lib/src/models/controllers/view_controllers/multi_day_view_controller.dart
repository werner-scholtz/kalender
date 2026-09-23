// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controllers/animation_defaults.dart';
import 'package:linked_pageview/linked_pageview.dart';

/// {@category Controllers and callbacks}
class MultiDayViewController extends ViewController {
  MultiDayViewController({required this.viewConfiguration, required ViewSnapshot initial, super.location}) {
    final pageIndexCalculator = viewConfiguration.pageIndexCalculator;
    final now = FloatingDateTime.fromDateTime(location == null ? DateTime.now() : TZDateTime.now(location!));
    initialPage = pageIndexCalculator.indexFromDate(initial.date, location);
    final type = viewConfiguration.type;
    final viewPortFraction = type == MultiDayViewType.freeScroll ? 1 / viewConfiguration.numberOfDays : 1.0;

    pageController = _controllerGroup.create(viewportFraction: viewPortFraction, initialPage: initialPage);
    headerController = _controllerGroup.create(viewportFraction: viewPortFraction, initialPage: initialPage);

    numberOfPages = pageIndexCalculator.numberOfPages(location);
    heightPerMinute = ValueNotifier<double>(initial.heightPerMinute ?? viewConfiguration.initialHeightPerMinute);

    final range = pageIndexCalculator.rangeFromIndex(initialPage, location);

    if (type == MultiDayViewType.freeScroll) {
      floatingVisibleRange.value = FloatingDateTimeRange(
        start: range.start,
        end: range.start.add(Duration(days: viewConfiguration.numberOfDays)),
      );
    } else {
      floatingVisibleRange.value = range;
    }

    final topOfDay = (initial.timeOfDay ?? viewConfiguration.initialTimeOfDay).toFloatingDateTime(now);
    final dayStart = viewConfiguration.timeOfDayRange.start.toFloatingDateTime(now);
    final scrollOffset = topOfDay.difference(dayStart).inMinutes * heightPerMinute.value;
    scrollController = ScrollController(initialScrollOffset: scrollOffset);
    // Seed the visible time-of-day from the initial offset, since a ScrollController
    // does not necessarily notify its listeners when it first attaches.
    visibleTimeOfDay.value = _timeOfDayFromOffset(scrollOffset);

    pageController.addListener(_offsetListener);
    scrollController.addListener(_updateVisibleTimeOfDay);
    heightPerMinute.addListener(_updateVisibleTimeOfDay);
  }

  @override
  final MultiDayViewConfiguration viewConfiguration;

  /// The initial page of the view.
  late final int initialPage;

  /// The number of pages in the view.
  late final int numberOfPages;

  /// The linked page controller group used to link the header and body controllers.
  final _controllerGroup = LinkedPageControllerGroup();

  /// The page controller used by the view.
  late final LinkedPageController pageController;

  /// The page controller for the paged single-day and multi-day headers, linked
  /// to [pageController] so the header and body scroll together.
  ///
  /// The free-scroll header does not use it. It renders one continuous band and
  /// derives its position from [pageOffset] instead.
  late final LinkedPageController headerController;

  /// The scroll controller used by the view.
  late ScrollController scrollController;

  /// The height per minute of the view.
  late ValueNotifier<double> heightPerMinute;

  /// The page offset of the view.
  ValueNotifier<double> pageOffset = ValueNotifier<double>(0.0);

  /// The [KalenderTime] currently aligned with the top of the visible viewport.
  ///
  /// Updates as the view is scrolled vertically or zoomed. It is `null` until the
  /// [scrollController] has been attached to a scroll view.
  final ValueNotifier<KalenderTime?> visibleTimeOfDay = ValueNotifier<KalenderTime?>(null);

  void _offsetListener() =>
      pageOffset.value = pageController.position.pixels / pageController.position.viewportDimension;

  /// Converts a vertical scroll [offset] (in pixels) to the [KalenderTime] aligned
  /// with the top of the viewport, using the current zoom level and time range.
  KalenderTime _timeOfDayFromOffset(double offset) {
    final perMinute = heightPerMinute.value;
    final minutesFromStart = perMinute <= 0 ? 0 : (offset / perMinute).round();
    final start = viewConfiguration.timeOfDayRange.start;
    final totalMinutes = (start.hour * 60 + start.minute + minutesFromStart).clamp(0, Duration.minutesPerDay - 1);
    return KalenderTime(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  /// Recomputes [visibleTimeOfDay] from the current scroll offset and zoom level.
  void _updateVisibleTimeOfDay() {
    if (!scrollController.hasClients) return;
    visibleTimeOfDay.value = _timeOfDayFromOffset(scrollController.offset);
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    final pageNumber = viewConfiguration.pageIndexCalculator.indexFromDate(date, location);

    return pageController.animateToPage(
      pageNumber,
      duration: duration ?? defaultAnimationDuration,
      curve: curve ?? defaultAnimationCurve,
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
    await animateToDate(date, duration: pageDuration, curve: pageCurve);

    final floatingDate = FloatingDateTime.fromExternal(date);
    final startOfDay = viewConfiguration.timeOfDayRange.start.toFloatingDateTime(floatingDate);
    final timeDifference = floatingDate.difference(startOfDay);
    final timeOffset = timeDifference.inMinutes * (heightPerMinute.value);

    return scrollController.animateTo(
      timeOffset,
      duration: scrollDuration ?? defaultAnimationDuration,
      curve: scrollCurve ?? defaultAnimationCurve,
    );
  }

  @override
  Future<void> animateToEvent(
    KalenderEvent event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) async {
    final DateTime date;
    final eventCenter = event.floatingStart(location: location).add(Duration(minutes: event.duration.inMinutes ~/ 2));
    final halfViewPortHeight = scrollController.position.viewportDimension ~/ 2;
    final duration = Duration(minutes: halfViewPortHeight ~/ heightPerMinute.value);
    final target = FloatingDateTime.fromDateTime(eventCenter.subtract(duration));

    // Keep the event start when the target falls on an earlier day, so a midnight start does not show the previous day.
    if (target.isSameDay(event.floatingStart(location: location))) {
      date = target;
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
      duration: duration ?? defaultAnimationDuration,
      curve: curve ?? defaultAnimationCurve,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) {
    return pageController.previousPage(
      duration: duration ?? defaultAnimationDuration,
      curve: curve ?? defaultAnimationCurve,
    );
  }

  @override
  void jumpToDate(DateTime date) {
    final pageNumber = viewConfiguration.pageIndexCalculator.indexFromDate(date, location);
    jumpToPage(pageNumber);
  }

  @override
  void jumpToPage(int page) => pageController.jumpToPage(page);

  /// Adds the time of day at the top of the viewport and the zoom.
  @override
  ViewSnapshot snapshot() => ViewSnapshot(
    date: floatingVisibleRange.value!.start,
    timeOfDay: visibleTimeOfDay.value,
    heightPerMinute: heightPerMinute.value,
  );

  @override
  String toString() {
    return '${runtimeType.toString()} (${viewConfiguration.runtimeType})';
  }

  @override
  void dispose() {
    pageController.removeListener(_offsetListener);
    scrollController.removeListener(_updateVisibleTimeOfDay);
    heightPerMinute.removeListener(_updateVisibleTimeOfDay);
    pageController.dispose();
    headerController.dispose();
    _controllerGroup.dispose();
    scrollController.dispose();
    heightPerMinute.dispose();
    pageOffset.dispose();
    visibleTimeOfDay.dispose();
    super.dispose();
  }
}
