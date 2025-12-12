import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

abstract class ScheduleViewController<T extends Object?> extends ViewController<T> with ScheduleMap {
  @override
  final ScheduleViewConfiguration viewConfiguration;

  @override
  late final ValueNotifier<Set<CalendarEvent<T>>> visibleEvents;

  /// The initial date to display in the schedule view.
  final InternalDateTime initialDate;

  ScheduleViewController({
    super.location,
    required this.viewConfiguration,
    required super.visibleDateTimeRange,
    required this.visibleEvents,
    required this.initialDate,
  }) {
    currentPage = viewConfiguration.pageIndexCalculator.indexFromDate(initialDate, location);
    final numberOfPages = viewConfiguration.pageIndexCalculator.numberOfPages(location);
    populateMaps(numberOfPages);
  }

  /// The [ItemScrollController] used to control the scrollable list of the current page.
  ItemScrollController? itemScrollController;

  /// The [ItemPositionsListener] used to listen to the scroll position of the list.
  ItemPositionsListener? itemPositionsListener;

  /// The highlighted date time range.
  final highlightedDateTimeRange = ValueNotifier<DateTimeRange?>(null);

  /// The index of the current page.
  late int currentPage;

  /// Get the number of items for the current page.
  int get itemCount => itemCountForPage(currentPage);

  /// Get the item at the given index of the current page.
  ListItem? item(int index) => indexItem(currentPage)[index];

  /// Get the [DateTime] for the given index of the current page.
  DateTime? dateTimeFromIndex(int index) => dateTimeFromIndexForPage(currentPage, index);

  /// Get the index of the item for the given [DateTime] for the current page.
  int? indexFromDateTime(DateTime date) => indexFromDateTimeForPage(currentPage, date);

  /// Get the index closest to the given [DateTime] of the current page.
  int closestIndex(DateTime date) => closestIndexForPage(currentPage, date);

  /// Add an item to the schedule map of the current page.
  void addItem({required ListItem item, required DateTime date, bool isFirst = false}) {
    return addItemForPage(item: item, date: date, pageIndex: currentPage, isFirst: isFirst);
  }

  /// Clear the schedule map for the current page.
  void clear() => clearPage(currentPage);

  /// Find the initial scroll index for the given date.
  int initialScrollIndex(DateTime date) {
    final asUtc = date.asUtc.startOfDay;
    return dateTimeItemIndex(currentPage)[asUtc] ??= closestIndex(asUtc);
  }

  /// Animate to the given index.
  FutureOr<void> _animateToIndex(int index, {Duration? duration, Curve? curve}) {
    if (!hasInitialized) return null;
    return itemScrollController?.scrollTo(
      index: index,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void dispose() => highlightedDateTimeRange.dispose();

  /// Check if the controller has been initialized with the necessary components.
  bool get hasInitialized {
    if (itemScrollController == null || itemPositionsListener == null) {
      debugPrint(
        'ScheduleViewController has not been initialized with ItemScrollController and ItemPositionsListener.',
      );
      return false;
    }
    return true;
  }
}

class ContinuousScheduleViewController<T extends Object?> extends ScheduleViewController<T> {
  ContinuousScheduleViewController({
    super.location,
    required super.viewConfiguration,
    required super.visibleDateTimeRange,
    required super.visibleEvents,
    required super.initialDate,
  }) {
    visibleDateTimeRange.value = viewConfiguration.pageIndexCalculator.dateTimeRangeFromIndex(currentPage, location);
    visibleEvents.value = {};
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    final dateAsUtc = date.forLocation(location: location).asUtc.startOfDay;
    final index = indexFromDateTime(dateAsUtc) ?? closestIndex(dateAsUtc);
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
    CalendarEvent<T> event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) async {
    return animateToDate(event.internalStart(location: location).asUtc.startOfDay,
        duration: scrollDuration, curve: scrollCurve);
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) async {
    if (!hasInitialized) return;
    final currentIndex = itemPositionsListener!.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    final date = dateTimeFromIndex(currentIndex);
    if (date == null) return;
    final nextMonth = date.copyWith(month: date.month + 1).startOfMonth;

    final index = monthIndexFromDateTime(currentPage, nextMonth) ?? closestIndex(nextMonth);
    return _animateToIndex(index);
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    if (!hasInitialized) return;
    final currentIndex = itemPositionsListener!.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    final currentDate = dateTimeFromIndex(currentIndex);

    if (currentDate == null) return;
    final previousDate = currentDate.copyWith(month: currentDate.month - 1).startOfMonth;

    final index = monthIndexFromDateTime(currentPage, previousDate) ?? closestIndex(previousDate);
    return _animateToIndex(index);
  }

  @override
  void jumpToDate(DateTime date) {
    if (!hasInitialized) return;
    date = date.forLocation(location: location).asUtc.startOfDay;
    final index = indexFromDateTime(date) ?? closestIndex(date);
    itemScrollController!.jumpTo(index: index);
  }

  @override
  void jumpToPage(int page) {
    debugPrint('jumpToPage is not applicable for ContinuousScheduleViewController.');
  }
}

class PaginatedScheduleViewController<T extends Object?> extends ScheduleViewController<T> {
  PaginatedScheduleViewController({
    super.location,
    required super.viewConfiguration,
    required super.visibleDateTimeRange,
    required super.visibleEvents,
    required super.initialDate,
  }) {
    visibleDateTimeRange.value = viewConfiguration.pageIndexCalculator.dateTimeRangeFromIndex(currentPage, location);
    visibleEvents.value = {};
    pageController = PageController(initialPage: currentPage);
  }

  /// The [PageController] used to control the page view.
  late final PageController pageController;

  /// Animate to the page index.
  Future<void> _animateToPage(int pageIndex, {Duration? duration, Curve? curve}) async {
    if (!_hasClients) return;
    return pageController.animateToPage(
      pageIndex,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    final dateAsUtc = date.forLocation(location: location).asUtc.startOfDay;
    final pageIndex = viewConfiguration.pageIndexCalculator.indexFromDate(dateAsUtc, location);
    await _animateToPage(pageIndex, duration: duration, curve: curve);

    final index = indexFromDateTime(dateAsUtc) ?? closestIndex(dateAsUtc);
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
    final dateAsUtc = date.forLocation(location: location).asUtc.startOfDay;
    final pageIndex = viewConfiguration.pageIndexCalculator.indexFromDate(dateAsUtc, location);
    await _animateToPage(pageIndex, duration: pageDuration, curve: pageCurve);

    final index = indexFromDateTime(dateAsUtc) ?? closestIndex(dateAsUtc);
    return _animateToIndex(index, duration: scrollDuration, curve: scrollCurve);
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
    final date = event.internalStart(location: location).asUtc.startOfDay;
    final pageIndex = viewConfiguration.pageIndexCalculator.indexFromDate(date, location);
    await _animateToPage(pageIndex, duration: pageDuration, curve: pageCurve);

    final index = indexFromDateTime(date) ?? closestIndex(date);
    return _animateToIndex(index, duration: scrollDuration, curve: scrollCurve);
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) async {
    if (!_hasClients) return;
    return await pageController.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    if (!_hasClients) return;
    return await pageController.previousPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> jumpToDate(DateTime date) async {
    final dateAsUtc = date.forLocation(location: location).asUtc.startOfDay;
    final pageIndex = viewConfiguration.pageIndexCalculator.indexFromDate(dateAsUtc, location);

    // Since jump to page does not build the page immediately,
    // and I'm currently unaware of a way to reliably wait for the page to be built,
    // I will just be using _animateToPage with hardcoded values for now.
    await _animateToPage(pageIndex, duration: const Duration(milliseconds: 100), curve: Curves.linear);
    final index = indexFromDateTime(dateAsUtc) ?? closestIndex(dateAsUtc);
    await _animateToIndex(index, duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  @override
  void jumpToPage(int page) {
    if (!_hasClients) return;
    pageController.jumpToPage(page);
  }

  /// Check if the page controller has clients.
  bool get _hasClients {
    if (!pageController.hasClients) {
      debugPrint("$PaginatedScheduleViewController's PageController has no clients.");
      return false;
    }
    return true;
  }
}
