// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controllers/animation_defaults.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:meta/meta.dart' show internal;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef _PageList = ({
  ItemScrollController scrollController,
  ItemPositionsListener positionsListener,
  VoidCallback onCurrent,
});

/// {@category Controllers and callbacks}
abstract class ScheduleViewController extends ViewController with ScheduleMap {
  @override
  final ScheduleViewConfiguration viewConfiguration;

  @override
  late final ValueNotifier<Set<KalenderEvent>> visibleEvents;

  /// The initial date to display in the schedule view.
  final FloatingDateTime initialDate;

  ScheduleViewController({
    super.location,
    required this.viewConfiguration,
    required super.floatingVisibleRange,
    required this.visibleEvents,
    required ViewSnapshot initial,
  }) : initialDate = initial.date {
    currentPage = viewConfiguration.pageIndexCalculator.indexFromDate(initialDate, location);
    final numberOfPages = viewConfiguration.pageIndexCalculator.numberOfPages(location);
    populateMaps(numberOfPages);
  }

  /// The [ItemScrollController] of the list showing [currentPage].
  ItemScrollController? itemScrollController;

  /// The [ItemPositionsListener] of the list showing [currentPage].
  ItemPositionsListener? itemPositionsListener;

  /// The highlighted date time range.
  final highlightedRange = ValueNotifier<FloatingDateTimeRange?>(null);

  /// The index of the page on screen.
  ///
  /// Setting it points [itemScrollController] and [itemPositionsListener] at the list of that page.
  int get currentPage => _currentPage;
  late int _currentPage;
  set currentPage(int page) {
    _currentPage = page;
    final list = _lists[page];
    _useList(list);
    list?.onCurrent();
  }

  final _lists = <int, _PageList>{};

  /// Registers the list showing [page]. [onCurrent] runs when [page] becomes [currentPage].
  @internal
  void attachList(
    int page, {
    required ItemScrollController scrollController,
    required ItemPositionsListener positionsListener,
    required VoidCallback onCurrent,
  }) {
    final list = (scrollController: scrollController, positionsListener: positionsListener, onCurrent: onCurrent);
    _lists[page] = list;
    if (page == currentPage) _useList(list);
  }

  /// Unregisters the list showing [page] unless another list registered for it since.
  @internal
  void detachList(int page, ItemScrollController scrollController) {
    if (_lists[page]?.scrollController != scrollController) return;
    _lists.remove(page);
    if (page == currentPage) _useList(null);
  }

  void _useList(_PageList? list) {
    itemScrollController = list?.scrollController;
    itemPositionsListener = list?.positionsListener;
  }

  /// Get the [DateTime] for the given index of the current page.
  FloatingDateTime? dateTimeFromIndex(int index) => dateTimeFromIndexForPage(currentPage, index);

  /// Get the index of the item for the given [DateTime] for the current page.
  int? indexFromDateTime(DateTime date) => indexFromDateTimeForPage(currentPage, date);

  /// Get the index closest to the given [DateTime] of the current page.
  int closestIndex(DateTime date) => closestIndexForPage(currentPage, date);

  FutureOr<void> _animateToIndex(int index, {Duration? duration, Curve? curve}) {
    if (!hasInitialized) return null;
    return itemScrollController?.scrollTo(
      index: index,
      duration: duration ?? defaultAnimationDuration,
      curve: curve ?? defaultAnimationCurve,
    );
  }

  @override
  void dispose() => highlightedRange.dispose();

  /// Check if the controller has been initialized with the necessary components.
  bool get hasInitialized => itemScrollController != null && itemPositionsListener != null;
}

/// {@category Controllers and callbacks}
class ContinuousScheduleViewController extends ScheduleViewController {
  ContinuousScheduleViewController({
    super.location,
    required super.viewConfiguration,
    required super.floatingVisibleRange,
    required super.visibleEvents,
    required super.initial,
  }) {
    floatingVisibleRange.value = viewConfiguration.pageIndexCalculator.rangeFromIndex(currentPage, location);
    visibleEvents.value = {};
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    final index = indexFromDateTime(date) ?? closestIndex(date);
    return _animateToIndex(index, duration: duration, curve: curve);
  }

  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  }) async {
    return animateToDate(date, duration: scrollDuration, curve: scrollCurve);
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
    return animateToDate(event.start, duration: scrollDuration, curve: scrollCurve);
  }

  Future<void> _animateByMonths(int delta) async {
    if (!hasInitialized) return;
    final currentIndex = itemPositionsListener!.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    final date = dateTimeFromIndex(currentIndex);
    if (date == null) return;
    final month = FloatingDateTime.fromDateTime(date.copyWith(month: date.month + delta)).startOfMonth;

    final index = monthIndexFromDateTime(currentPage, month) ?? closestIndex(month);
    return _animateToIndex(index);
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) => _animateByMonths(1);

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) => _animateByMonths(-1);

  @override
  void jumpToDate(DateTime date) {
    if (!hasInitialized) return;
    final index = indexFromDateTime(date) ?? closestIndex(date);
    itemScrollController!.jumpTo(index: index);
  }

  @override
  void jumpToPage(int page) {
    debugPrint('jumpToPage is not applicable for ContinuousScheduleViewController.');
  }
}

/// {@category Controllers and callbacks}
class PaginatedScheduleViewController extends ScheduleViewController {
  PaginatedScheduleViewController({
    super.location,
    required super.viewConfiguration,
    required super.floatingVisibleRange,
    required super.visibleEvents,
    required super.initial,
  }) {
    floatingVisibleRange.value = viewConfiguration.pageIndexCalculator.rangeFromIndex(currentPage, location);
    visibleEvents.value = {};
    pageController = PageController(initialPage: currentPage);
  }

  /// The [PageController] used to control the page view.
  late final PageController pageController;

  Future<void> _animateToPage(int pageIndex, {Duration? duration, Curve? curve}) async {
    if (!pageController.hasClients) return;
    return pageController.animateToPage(
      pageIndex,
      duration: duration ?? defaultAnimationDuration,
      curve: curve ?? defaultAnimationCurve,
    );
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    return animateToDateTime(
      date,
      pageDuration: duration,
      pageCurve: curve,
      scrollDuration: duration,
      scrollCurve: curve,
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
    final pageIndex = viewConfiguration.pageIndexCalculator.indexFromDate(date, location);
    await _animateToPage(pageIndex, duration: pageDuration, curve: pageCurve);
    final index = indexFromDateTime(date) ?? closestIndex(date);
    return _animateToIndex(index, duration: scrollDuration, curve: scrollCurve);
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
    if (!pageController.hasClients) return;
    return await pageController.nextPage(
      duration: duration ?? defaultAnimationDuration,
      curve: curve ?? defaultAnimationCurve,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    if (!pageController.hasClients) return;
    return await pageController.previousPage(
      duration: duration ?? defaultAnimationDuration,
      curve: curve ?? defaultAnimationCurve,
    );
  }

  @override
  Future<void> jumpToDate(DateTime date) async {
    final pageIndex = viewConfiguration.pageIndexCalculator.indexFromDate(date, location);

    // animateToPage builds the page before the index scroll. jumpToPage does not.
    await _animateToPage(pageIndex, duration: const Duration(milliseconds: 100), curve: Curves.linear);
    final index = indexFromDateTime(date) ?? closestIndex(date);
    await _animateToIndex(index, duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  @override
  void jumpToPage(int page) {
    if (!pageController.hasClients) return;
    pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
