import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

abstract class ScheduleViewController<T extends Object?> extends ViewController<T> {

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

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    // TODO: implement animateToDate
  }

  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  }) async {
    // TODO: implement animateToDateTime
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
    // TODO: implement animateToEvent
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
}
