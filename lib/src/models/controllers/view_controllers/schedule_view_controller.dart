import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

abstract class ScheduleViewController<T extends Object?> extends ViewController<T> with ScheduleMap {
  @override
  final ScheduleViewConfiguration viewConfiguration;

  @override
  late final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  @override
  late final ValueNotifier<Set<CalendarEvent<T>>> visibleEvents;

  ScheduleViewController({
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
    required this.visibleEvents,
    DateTime? initialDate,
  }) {
    currentPage = viewConfiguration.pageNavigationFunctions.indexFromDate(initialDate ?? DateTime.now());
    final numberOfPages = viewConfiguration.pageNavigationFunctions.numberOfPages;
    populateMaps(numberOfPages);
  }

  /// The [ItemScrollController] used to control the scrollable list of the current page.
  late ItemScrollController itemScrollController;

  /// The [ItemPositionsListener] used to listen to the scroll position of the list.
  late ItemPositionsListener itemPositionsListener;

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
  Future<void> _animateToIndex(int index, {Duration? duration, Curve? curve}) async {
    return itemScrollController.scrollTo(
      index: index,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void dispose() => highlightedDateTimeRange.dispose();
}

class ContinuousScheduleViewController<T extends Object?> extends ScheduleViewController<T> {
  ContinuousScheduleViewController({
    required super.viewConfiguration,
    required super.visibleDateTimeRange,
    required super.visibleEvents,
    super.initialDate,
  }) {
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
    CalendarEvent<T> event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) async {
    final date = event.startAsUtc.startOfDay;
    final index = indexFromDateTime(date) ?? closestIndex(date);
    return _animateToIndex(index);
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) async {
    final currentIndex = itemPositionsListener.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    final date = dateTimeFromIndex(currentIndex);
    if (date == null) return;
    final nextMonth = date.copyWith(month: date.month + 1).startOfMonth;

    final index = monthIndexFromDateTime(currentPage, nextMonth) ?? closestIndex(nextMonth);
    return _animateToIndex(index);
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    final currentIndex = itemPositionsListener.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    final currentDate = dateTimeFromIndex(currentIndex);

    if (currentDate == null) return;
    final previousDate = currentDate.copyWith(month: currentDate.month - 1).startOfMonth;

    final index = monthIndexFromDateTime(currentPage, previousDate) ?? closestIndex(previousDate);
    return _animateToIndex(index);
  }

  @override
  void jumpToDate(DateTime date) {
    final index = indexFromDateTime(date) ?? closestIndex(date);
    itemScrollController.jumpTo(index: index);
  }

  @override
  void jumpToPage(int page) {
    /// TODO: what to do here?
    throw UnimplementedError('jumpToPage is not implemented');
  }
}

class PaginatedScheduleViewController<T extends Object?> extends ScheduleViewController<T> {
  PaginatedScheduleViewController({
    required super.viewConfiguration,
    required super.visibleDateTimeRange,
    required super.visibleEvents,
    super.initialDate,
  }) {
    final pageNavigationFunctions = viewConfiguration.pageNavigationFunctions;
    visibleDateTimeRange.value = pageNavigationFunctions.dateTimeRangeFromIndex(currentPage);
    visibleEvents.value = {};
    pageController = PageController(initialPage: currentPage);
  }

  /// The [PageController] used to control the page view.
  late final PageController pageController;

  /// Animate to the page index.
  Future<void> _animateToPage(int pageIndex, {Duration? duration, Curve? curve}) async {
    return pageController.animateToPage(
      pageIndex,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    final pageIndex = viewConfiguration.pageNavigationFunctions.indexFromDate(date);
    await _animateToPage(pageIndex, duration: duration, curve: curve);

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
    final pageIndex = viewConfiguration.pageNavigationFunctions.indexFromDate(date);
    await _animateToPage(pageIndex, duration: pageDuration, curve: pageCurve);

    final index = indexFromDateTime(date) ?? closestIndex(date);
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
    final pageIndex = viewConfiguration.pageNavigationFunctions.indexFromDate(event.startAsUtc);
    await _animateToPage(pageIndex, duration: pageDuration, curve: pageCurve);

    final date = event.startAsUtc.startOfDay;
    final index = indexFromDateTime(date) ?? closestIndex(date);
    return _animateToIndex(index, duration: scrollDuration, curve: scrollCurve);
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) async {
    return await pageController.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    return await pageController.previousPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void jumpToDate(DateTime date) {
    final pageIndex = viewConfiguration.pageNavigationFunctions.indexFromDate(date);
    pageController.jumpToPage(pageIndex);

    final index = indexFromDateTime(date) ?? closestIndex(date);
    itemScrollController.jumpTo(index: index);
  }

  @override
  void jumpToPage(int page) => pageController.jumpToPage(page);
}
