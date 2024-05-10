import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/mixins/calendar_navigation_functions.dart';

class CalendarController<T extends Object?> extends ChangeNotifier
    with CalendarNavigationFunctions<T> {
  CalendarController({
    DateTime? initialDate,
    DateTimeRange? calendarRange,
  }) {
    _focusedDate = initialDate ?? DateTime.now();
    _calendarRange = calendarRange ??
        DateTimeRange(
          start: DateTime(_focusedDate.year - 1),
          end: DateTime(_focusedDate.year + 1),
        );
  }

  /// The date that has focus.
  late DateTime _focusedDate;
  DateTime get focusedDate => _focusedDate;

  /// The [DateTimeRange] that the calendar can display.
  late final DateTimeRange _calendarRange;
  DateTimeRange get calendarRange => _calendarRange;

  /// TODO: Document this.
  ViewController? _viewController;
  ViewController? get viewController => _viewController;
  bool get isAttached => _viewController != null;

  bool isAttachedTo(ViewController viewController) {
    return viewController == _viewController;
  }

  /// Attach the [ViewController] to this [CalendarController].
  void attach(ViewController viewController) {
    if (isAttached) detach();
    log('Attaching ${viewController.toString()} to $this');
    _viewController = viewController;
    notifyListeners();
  }

  /// Detach the [ViewController] from this [CalendarController].
  void detach() {
    log('Detaching ${viewController.toString()} from $this');
    _viewController = null;
  }

  /// Jump to the given [DateTime].
  @override
  void jumpToPage(int page) {}

  /// Jump to the given [DateTime].
  @override
  void jumpToDate(DateTime date) {}

  /// Animate to the next page.
  ///
  /// [duration] the [Duration] of the animation.
  /// [curve] the [Curve] of the animation.
  @override
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  }) async {
    await viewController?.animateToNextPage(
      duration: duration,
      curve: curve,
    );
  }

  /// Animate to the previous page.
  ///
  /// [duration] the [Duration] of the animation.
  /// [curve] the [Curve] of the animation.
  @override
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  }) async {
    return viewController?.animateToPreviousPage(
      duration: duration,
      curve: curve,
    );
  }

  /// Animate to the given [DateTime].
  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    await viewController?.animateToDate(
      date,
      duration: duration,
      curve: curve,
    );
  }

  /// Animate to the given [DateTime].
  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  }) async {
    await viewController?.animateToDateTime(
      date,
      pageDuration: pageDuration,
      pageCurve: pageCurve,
      scrollDuration: scrollDuration,
      scrollCurve: scrollCurve,
    );
  }

  /// Animate to the given [CalendarEvent].
  @override
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? duration,
    Curve? curve,
    bool centerEvent = true,
  }) async {
    await viewController?.animateToEvent(
      event,
      duration: duration,
      curve: curve,
      centerEvent: centerEvent,
    );
  }

  @override
  String toString() {
    return runtimeType.toString();
  }
}
