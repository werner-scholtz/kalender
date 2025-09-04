import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/calendar_navigation_functions.dart';

export 'view_controllers/month_view_controller.dart';
export 'view_controllers/multi_day_view_controller.dart';
export 'view_controllers/schedule_view_controller.dart';

/// A controller for calendar views.
///
/// A view controller lets you control a calendar view.
abstract class ViewController<T extends Object?> with CalendarNavigationFunctions<T> {
  /// The view configuration that will be used by the controller.
  ViewConfiguration get viewConfiguration;

  /// The [DateTimeRange] that is currently visible.
  ValueNotifier<DateTimeRange> get visibleDateTimeRange;

  /// The [CalendarEvent]s that are currently visible.
  ValueNotifier<Set<CalendarEvent<T>>> get visibleEvents;

  /// The cache used by the event layout delegate.
  final EventLayoutDelegateCache cache = EventLayoutDelegateCache();

  /// The cache used for the multi-day event layout.
  final MultiDayLayoutFrameCache<T> multiDayCache = MultiDayLayoutFrameCache<T>();

  /// Jump to the given [DateTime].
  @override
  void jumpToPage(int page);

  /// Jump to the given [DateTime].
  @override
  FutureOr<void> jumpToDate(DateTime date);

  @override
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  });

  @override
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  });

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  });

  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  });

  @override
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  });

  void dispose();

  @override
  String toString() {
    return runtimeType.toString();
  }
}
