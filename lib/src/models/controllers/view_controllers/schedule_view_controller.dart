import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

abstract class ScheduleViewController<T extends Object?> extends ViewController<T> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final highlightedDate = ValueNotifier<DateTime?>(null);
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

  /// The indices of all items to calendar event IDs.
  final itemIndexEventId = <int, int>{};

  /// The indices of all items to DateTime.
  final eventIdDateIndex = <int, DateTime>{};

  /// The first item index of each event ID.
  final firstItemIndex = <int, int>{};

  /// The indices of all the month items.
  final monthItemIndices = <int, DateTime>{};

  /// The indices of all the date items.
  final dateItemIndices = <DateTime, int>{};

  /// The indices of all the date items to DateTime.
  final indicesDateItem = <int, DateTime>{};

  int _closestIndex(DateTime date) {
    final lastDate = indicesDateItem.values.last;
    final firstDate = indicesDateItem.values.first;
    if (date.isAfter(lastDate)) {
      return indicesDateItem.keys.last;
    } else if (date.isBefore(firstDate)) {
      return indicesDateItem.keys.first;
    } else {
      // If the date is in between, we need to find the closest index.
      return indicesDateItem.entries.reduce((a, b) => (a.value.isBefore(b.value) ? a : b)).key;
    }
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    var index = dateItemIndices[date.asUtc.startOfDay];
    index ??= _closestIndex(date);

    return itemScrollController.scrollTo(
      index: index,
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
    final index = firstItemIndex[event.id];
    if (index == null) {
      debugPrint('Event not found in items: $event');
      return;
    }
    return itemScrollController.scrollTo(
      index: index,
      duration: scrollDuration ?? const Duration(milliseconds: 300),
      curve: scrollCurve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) async {
    final currentIndex = itemPositionsListener.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    // find the index of the next month.
    final nextMonth = monthItemIndices.entries
        .firstWhereOrNull((element) => element.value.isAfter(indicesDateItem[currentIndex]!))
        ?.key;

    // If there is no next month, return.
    if (nextMonth == null) return;

    return animateToDate(
      indicesDateItem[nextMonth]!.asUtc.startOfDay,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    final currentIndex = itemPositionsListener.itemPositions.value.firstOrNull?.index;
    if (currentIndex == null) return;

    // Find the index of the previous month.
    final previousMonth = monthItemIndices.entries
        .firstWhereOrNull((element) => element.value.isBefore(indicesDateItem[currentIndex]!))
        ?.key;

    // If there is no previous month, return.
    if (previousMonth == null) return;

    return animateToDate(
      indicesDateItem[previousMonth]!.asUtc.startOfDay,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void jumpToDate(DateTime date) {
    var index = dateItemIndices[date.asUtc.startOfDay];
    index ??= _closestIndex(date);
    itemScrollController.jumpTo(index: index);
  }

  @override
  void jumpToPage(int page) {
    throw UnimplementedError('jumpToPage is not implemented');
  }

  @override
  void dispose() {}
}
