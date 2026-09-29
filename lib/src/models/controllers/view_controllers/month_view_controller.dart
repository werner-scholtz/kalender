// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controllers/animation_defaults.dart';

/// {@category Controllers and callbacks}
class MonthViewController extends ViewController {
  MonthViewController({required this.viewConfiguration, required ViewSnapshot initial, super.location}) {
    final pageNavigationFunctions = viewConfiguration.pageIndexCalculator;
    initialPage = pageNavigationFunctions.indexFromDate(initial.date, location);
    pageController = PageController(initialPage: initialPage);
    numberOfPages = pageNavigationFunctions.numberOfPages(location);
    floatingVisibleRange.value = pageNavigationFunctions.rangeFromIndex(initialPage, location);
  }

  @override
  final MonthViewConfiguration viewConfiguration;

  /// The initial page of the view.
  late final int initialPage;

  /// The number of pages in the view.
  late final int numberOfPages;

  /// The page controller used by the view.
  late final PageController pageController;

  /// Returns the first day of the month with the most visible days.
  @override
  ViewSnapshot snapshot() =>
      ViewSnapshot(date: FloatingDateTime.fromDateTime(floatingVisibleRange.value!.dominantMonthDate));

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    final pageNumber = viewConfiguration.pageIndexCalculator.indexFromDate(date, location);

    await pageController.animateToPage(
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
  }

  @override
  Future<void> animateToEvent(
    KalenderEvent event, {
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
      duration: duration ?? defaultAnimationDuration,
      curve: curve ?? defaultAnimationCurve,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    await pageController.previousPage(
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

  @override
  String toString() {
    return '${runtimeType.toString()} (${viewConfiguration.runtimeType})';
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
