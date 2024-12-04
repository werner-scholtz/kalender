import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';

mixin CalendarNavigationFunctions<T> {
  /// Jump to the given [DateTime].
  void jumpToPage(int page);

  /// Jump to the given [DateTime].
  void jumpToDate(DateTime date);

  /// Animate to the next page.
  ///
  /// [duration] the [Duration] of the animation.
  ///
  /// [curve] the [Curve] of the animation.
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the previous page.
  ///
  /// [duration] the [Duration] of the animation.
  ///
  /// [curve] the [Curve] of the animation.
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the date part of the given [DateTime].
  ///
  /// [date] the [DateTime] to animate to.
  ///
  /// [duration] the [Duration] of the animation.
  ///
  /// [curve] the [Curve] of the animation.
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the date and time parts of the given [DateTime].
  ///
  /// [date] the [DateTime] to animate to.
  ///
  /// [pageDuration] the [Duration] of the page animation.
  ///
  /// [pageCurve] the [Curve] of the page animation.
  ///
  /// [scrollDuration] the [Duration] of the scroll animation.
  ///
  /// [scrollCurve] the [Curve] of the scroll animation.
  ///
  /// [scrollCurve] the [Curve] of the scroll animation.
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  });

  /// Animate to the given [CalendarEvent].
  ///
  /// [event] the [CalendarEvent] to animate to.
  ///
  /// [pageDuration] the [Duration] of the page animation.
  ///
  /// [pageCurve] the [Curve] of the page animation.
  ///
  /// [scrollDuration] the [Duration] of the scroll animation.
  ///
  /// [scrollCurve] the [Curve] of the scroll animation.
  ///
  /// [centerEvent] center the event on the viewport.
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  });
}
