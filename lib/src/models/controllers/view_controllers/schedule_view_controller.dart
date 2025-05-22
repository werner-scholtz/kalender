import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// A map of all the items in the list.
/// [ListItem] is the type of the item.
///   * [EventItem] is the type of the event item.
///   * [MonthItem] is the type of the month item.
///   * [EmptyItem] is the type of the empty item.
typedef IndexItem = Map<int, ListItem>;

/// A map of all the item indices to the date time.
/// [int] is the index of the item.
/// [DateTime] is the date time of the item.
typedef IndexItemDateTime = Map<int, DateTime>;

/// A map of all the date times to the item index.
/// [DateTime] is the date time of the item.
/// [int] is the index of the item.
typedef DateTimeItemIndex = Map<DateTime, int>;

class ScheduleMap {
  /// A map of all the pageIndexes to the IndexItems.
  final indexedIndexItems = <int, IndexItem>{};

  /// Get the [IndexItem] for the given pageIndex.
  IndexItem indexItem(int pageIndex) => indexedIndexItems[pageIndex]!;

  /// Get the number of items for the given pageIndex.
  int itemCount(int pageIndex) => indexItem(pageIndex).length;

  /// Add an item to the map.
  ///
  /// [pageIndex] is the page index to add the item to.
  /// [item] is the item to add.
  /// [date] is the date to add.
  /// [isFirst] is whether the item is the first item of the date.
  void addItem({required ListItem item, required DateTime date, required int pageIndex, bool isFirst = false}) {
    final itemsForPage = indexItem(pageIndex);
    final index = itemsForPage.length;
    itemsForPage[index] = item;

    final itemDateTimeForPage = itemIndexDateTime(pageIndex);
    itemDateTimeForPage[index] = date;

    if (isFirst) dateTimeItemIndex(pageIndex)[date] = index;
    if (item is MonthItem) monthIndices(pageIndex)[date.startOfMonth] = index;
  }

  /// A map of all the pageIndexes to IndexItemDateTimes.
  final indexedItemIndexDateTime = <int, IndexItemDateTime>{};

  /// Get the [IndexItemDateTime] for the given pageIndex.
  IndexItemDateTime itemIndexDateTime(int pageIndex) => indexedItemIndexDateTime[pageIndex]!;

  /// Get the [DateTime] for the given pageIndex and itemIndex.
  ///
  /// [pageIndex] is the page index to get the date for.
  /// [itemIndex] is the item index to get the date for.
  DateTime? dateTimeFromIndex(int pageIndex, int itemIndex) => itemIndexDateTime(pageIndex)[itemIndex];

  /// A map of all the pageIndexes to DateTimeItemIndices.
  final indexedDateTimeItemIndex = <int, DateTimeItemIndex>{};

  /// Get the [DateTimeItemIndex] for the given pageIndex.
  DateTimeItemIndex dateTimeItemIndex(int pageIndex) => indexedDateTimeItemIndex[pageIndex]!;

  int? indexFromDateTime(int pageIndex, DateTime date) {
    final dateTimeFirstItemIndex = dateTimeItemIndex(pageIndex);
    return dateTimeFirstItemIndex[date];
  }

  /// Find the index closest to the given date.
  ///
  /// [pageIndex] is the page index to search in.
  /// [date] is the date to search for.
  int closestIndex(int pageIndex, DateTime date) {
    final dateTimeFirstItemIndex = dateTimeItemIndex(pageIndex);
    if (dateTimeFirstItemIndex.isEmpty) return 0;

    final itemIndexDateTimeForPage = itemIndexDateTime(pageIndex);
    final lastDate = dateTimeFirstItemIndex.keys.last;
    final firstDate = dateTimeFirstItemIndex.keys.first;
    if (date.isAfter(lastDate)) {
      return itemIndexDateTimeForPage.keys.last;
    } else if (date.isBefore(firstDate)) {
      return itemIndexDateTimeForPage.keys.first;
    } else {
      // If the date is in between, we need to find the closest index.
      return itemIndexDateTimeForPage.entries.reduce((a, b) => (a.value.isBefore(b.value) ? a : b)).key;
    }
  }

  /// A map of all the pageIndexes to MonthIndices.
  final indexedMonthIndices = <int, DateTimeItemIndex>{};

  /// Get the [DateTimeItemIndex] for the given pageIndex.
  DateTimeItemIndex monthIndices(int pageIndex) => indexedMonthIndices[pageIndex]!;

  int? monthIndexFromDateTime(int pageIndex, DateTime date) {
    final monthIndicesForPage = monthIndices(pageIndex);
    return monthIndicesForPage[date.startOfMonth];
  }

  /// Populate the maps with the given number of pages.
  void populateMaps(int numberOfPages) {
    indexedIndexItems.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    indexedItemIndexDateTime.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    indexedDateTimeItemIndex.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    indexedMonthIndices.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
  }

  void clearPage(int pageIndex) {
    indexedIndexItems[pageIndex]?.clear();
    indexedItemIndexDateTime[pageIndex]?.clear();
    indexedDateTimeItemIndex[pageIndex]?.clear();
    indexedMonthIndices[pageIndex]?.clear();
  }
}

abstract class ListItem {
  const ListItem();
}

class EventItem extends ListItem {
  final int eventId;
  final bool isFirst;
  EventItem(this.eventId, this.isFirst);
}

class MonthItem extends ListItem {}

class EmptyItem extends ListItem {}

abstract class ScheduleViewController<T extends Object?> extends ViewController<T> {
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
    scheduleMap.populateMaps(numberOfPages);
  }

  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;
  final highlightedDateTimeRange = ValueNotifier<DateTimeRange?>(null);
  late int currentPage;
  final scheduleMap = ScheduleMap();

  /// Get the number of items for the current page.
  int get itemCount => scheduleMap.itemCount(currentPage);

  /// Get the item at the given index of the current page.
  ListItem? item(int index) => scheduleMap.indexItem(currentPage)[index];

  /// Get the [DateTime] for the given index of the current page.
  DateTime dateTimeForIndex(int index) => scheduleMap.dateTimeFromIndex(currentPage, index)!;

  /// Get the index of the item for the given [DateTime] for the current page.
  int? indexFromDateTime(DateTime date) => scheduleMap.indexFromDateTime(currentPage, date);

  /// Get the index closest to the given [DateTime] of the current page.
  int closestIndex(DateTime date) => scheduleMap.closestIndex(currentPage, date);

  /// Add an item to the schedule map of the current page.
  void addItem({required ListItem item, required DateTime date, bool isFirst = false}) {
    return scheduleMap.addItem(item: item, date: date, pageIndex: currentPage, isFirst: isFirst);
  }

  /// Clear the schedule map for the current page.
  void clear() => scheduleMap.clearPage(currentPage);

  /// Find the initial scroll index for the given date.
  int initialScrollIndex(DateTime date) {
    final asUtc = date.asUtc.startOfDay;
    return scheduleMap.dateTimeItemIndex(currentPage)[asUtc] ??= scheduleMap.closestIndex(currentPage, asUtc);
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

    final date = scheduleMap.dateTimeFromIndex(currentPage, currentIndex);
    if (date == null) return;
    final nextMonth = date.copyWith(month: date.month + 1).startOfMonth;

    // TODO: need some better way to deal with months that are not in the list.
    final index =
        scheduleMap.monthIndexFromDateTime(currentPage, nextMonth) ?? scheduleMap.closestIndex(currentPage, date);
    return _animateToIndex(index);
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    final currentIndex = itemPositionsListener.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    final currentDate = scheduleMap.dateTimeFromIndex(currentPage, currentIndex);

    if (currentDate == null) return;
    final previousDate = currentDate.copyWith(month: currentDate.month - 1).startOfMonth;

    // TODO: need some better way to deal with months that are not in the list.
    final index = scheduleMap.monthIndexFromDateTime(currentPage, previousDate) ??
        scheduleMap.closestIndex(currentPage, currentDate);
    return _animateToIndex(index);
  }

  @override
  void jumpToDate(DateTime date) {
    // final index = dateTimeFirstItemIndex[date.asUtc.startOfDay] ?? _closestIndex(date);
    // itemScrollController.jumpTo(index: index);
  }

  @override
  void jumpToPage(int page) {
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
  void jumpToPage(int page) {
    // Jump to the page.
    pageController.jumpToPage(page);
  }
}
