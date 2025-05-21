import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

abstract class ScheduleViewController<T extends Object?> extends ViewController<T> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final highlightedDateTimeRange = ValueNotifier<DateTimeRange?>(null);
}

abstract class ListItem {
  const ListItem();
}

class EventItem extends ListItem {
  final int eventId;
  final bool isFirst;
  EventItem(this.eventId, this.isFirst);
}

class MonthItem extends ListItem {
  MonthItem();
}

class EmptyItem extends ListItem {
  EmptyItem();
}

class ContinuousScheduleViewController<T extends Object?> extends ScheduleViewController<T> {
  ContinuousScheduleViewController({
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
    required this.visibleEvents,
    DateTime? initialDate,
  }) {
    final pageNavigationFunctions = viewConfiguration.pageNavigationFunctions;
    final initialIndex = pageNavigationFunctions.indexFromDate(initialDate ?? DateTime.now());
    visibleDateTimeRange.value = pageNavigationFunctions.dateTimeRangeFromIndex(initialIndex);
    visibleEvents.value = {};
  }

  @override
  final ScheduleViewConfiguration viewConfiguration;

  @override
  late final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  @override
  late final ValueNotifier<Set<CalendarEvent<T>>> visibleEvents;



  /// A map of all the items in the list.
  /// [ListItem] is the type of the item.
  ///   * [EventItem] is the type of the event item.
  ///   * [MonthItem] is the type of the month item.
  ///   * [EmptyItem] is the type of the empty item.
  final indexItem = <int, ListItem>{};
  int addItem(ListItem item, DateTime date, {bool isFirst = false}) {
    final index = indexItem.length;
    indexItem[index] = item;
    itemIndexDateTime[index] = date;
    if (isFirst) dateTimeFirstItemIndex[date] = index;
    if (item is MonthItem) monthIndices[date.startOfMonth] = index;
    return index;
  }

  /// The item index to DateTime.
  final itemIndexDateTime = <int, DateTime>{};

  /// The DateTime of the first event on a day to item index.
  final dateTimeFirstItemIndex = <DateTime, int>{};

  /// The dateTime for each month to the item index.
  final monthIndices = <DateTime, int>{};

  /// Clear all the items in the list.
  void clear() {
    indexItem.clear();
    itemIndexDateTime.clear();
    dateTimeFirstItemIndex.clear();
    monthIndices.clear();
  }

  /// Find the closest index to the given date.
  int _closestIndex(DateTime date) {
    final lastDate = dateTimeFirstItemIndex.keys.last;
    final firstDate = dateTimeFirstItemIndex.keys.first;
    if (date.isAfter(lastDate)) {
      return itemIndexDateTime.keys.last;
    } else if (date.isBefore(firstDate)) {
      return itemIndexDateTime.keys.first;
    } else {
      // If the date is in between, we need to find the closest index.
      return itemIndexDateTime.entries.reduce((a, b) => (a.value.isBefore(b.value) ? a : b)).key;
    }
  }

  /// Find the initial scroll index for the given date.
  int initialScrollIndex(DateTime date) {
    final asUtc = date.asUtc.startOfDay;
    return dateTimeFirstItemIndex[asUtc] ?? _closestIndex(asUtc);
  }

  /// Animate to the given index.
  ///
  /// [duration] is the duration of the animation.
  /// [curve] is the curve of the animation.
  Future<void> _animateToIndex(int index, {Duration? duration, Curve? curve}) async {
    return itemScrollController.scrollTo(
      index: index,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    final index = dateTimeFirstItemIndex[date.asUtc.startOfDay] ?? _closestIndex(date);
    return _animateToIndex(index);
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
    final index = dateTimeFirstItemIndex[event.startAsUtc.startOfDay];
    if (index == null) {
      debugPrint('Event not found in items: $event');
      return;
    }
    return _animateToIndex(index);
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) async {
    final currentIndex = itemPositionsListener.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;
    final date = itemIndexDateTime[currentIndex]?.endOfMonth;
    if (date == null) return;
    // TODO: need some better way to deal with months that are not in the list.
    final index = monthIndices[date] ?? _closestIndex(date);
    return _animateToIndex(index);
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    final currentIndex = itemPositionsListener.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    final currentDate = itemIndexDateTime[currentIndex];
    if (currentDate == null) return;
    final previousDate = currentDate.copyWith(month: currentDate.month - 1).startOfMonth;

    // TODO: need some better way to deal with months that are not in the list.
    final index = monthIndices[previousDate] ?? _closestIndex(previousDate);
    return _animateToIndex(index);
  }

  @override
  void jumpToDate(DateTime date) {
    final index = dateTimeFirstItemIndex[date.asUtc.startOfDay] ?? _closestIndex(date);
    itemScrollController.jumpTo(index: index);
  }

  @override
  void jumpToPage(int page) {
    throw UnimplementedError('jumpToPage is not implemented');
  }

  @override
  void dispose() {
    highlightedDateTimeRange.dispose();
  }
}
