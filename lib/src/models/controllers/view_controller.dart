import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/kalender_navigation_functions.dart';

export 'view_controllers/month_view_controller.dart';
export 'view_controllers/multi_day_view_controller.dart';
export 'view_controllers/schedule_view_controller.dart';

/// A controller for calendar views.
///
/// A view controller lets you control a calendar view.
abstract class ViewController with KalenderNavigationFunctions {
  /// The location of the current view.
  Location? location;

  /// The range currently visible, in the calendar's internal layout space.
  ///
  /// This is the unzoned counterpart of [KalenderController.visibleDateTimeRange],
  /// which carries the same range as a [KalenderDateTimeRange] for an app to read.
  /// Call [InternalDateTimeRange.forLocation] to cross between them.
  final ValueNotifier<InternalDateTimeRange?> internalVisibleRange;

  ViewController({this.location, required this.internalVisibleRange});

  /// The view configuration that will be used by the controller.
  ViewConfiguration get viewConfiguration;

  /// The [KalenderEvent]s that are currently visible.
  ValueNotifier<Set<KalenderEvent>> get visibleEvents;

  // TODO: this can be passed between ViewControllers, but for now it is created here.

  /// The cache used by the event layout delegate.
  final EventLayoutDelegateCache cache = EventLayoutDelegateCache();

  /// The cache used for the multi-day event layout.
  final MultiDayLayoutFrameCache multiDayCache = MultiDayLayoutFrameCache();

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
    KalenderEvent event, {
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
