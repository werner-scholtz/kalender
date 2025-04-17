import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

abstract class ScheduleViewController<T extends Object?> extends ViewController<T> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
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

  /// The first item index of each event ID.
  final firstItemIndex = <int, int>{};

  /// The indices of all the month items.
  final monthItemIndices = <int, DateTime>{};

  /// The indices of all the date items.
  final dateItemIndices = <DateTime, int>{};

  /// The indices of all the date items to DateTime.
  final indicesDateItem = <int, DateTime>{};

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    var index = dateItemIndices[date.asUtc.startOfDay];

    if (index == null) {
      // If the index is not found, and the date is after the last date or before the first date,
      // we need to find the closest index.

      final lastDate = indicesDateItem.values.last;
      final firstDate = indicesDateItem.values.first;
      if (date.isAfter(lastDate)) {
        index = indicesDateItem.keys.last;
      } else if (date.isBefore(firstDate)) {
        index = indicesDateItem.keys.first;
      } else {
        // If the date is in between, we need to find the closest index.
        index = indicesDateItem.entries.reduce((a, b) => (a.value.isBefore(b.value) ? a : b)).key;
      }
    }

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
    // TODO: implement animateToNextPage
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    // TODO: implement animateToPreviousPage
  }

  @override
  void jumpToDate(DateTime date) {
    // TODO: implement jumpToDate
  }

  @override
  void jumpToPage(int page) {
    // TODO: implement jumpToPage
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
