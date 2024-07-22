import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/mixins/calendar_navigation_functions.dart';
import 'package:kalender/src/models/resize_event.dart';

class CalendarController<T extends Object?> extends ChangeNotifier
    with CalendarNavigationFunctions<T> {
  CalendarController();

  /// TODO: Document this.
  ViewController<T>? _viewController;
  ViewController<T>? get viewController => _viewController;
  bool get isAttached => _viewController != null;

  /// The [DateTimeRange] that is currently visible.
  ValueNotifier<DateTimeRange> visibleDateTimeRange = ValueNotifier<DateTimeRange>(
    DateTime.now().dayRange,
  );

  /// The [CalendarEvent]s that are currently visible.
  ValueNotifier<List<CalendarEvent<T>>> visibleEvents = ValueNotifier<List<CalendarEvent<T>>>([]);

  /// The event being modified.
  ValueNotifier<CalendarEvent<T>?> eventBeingDragged = ValueNotifier<CalendarEvent<T>?>(null);
  int? _eventBeingDraggedId;
  int? get eventBeingDraggedId => _eventBeingDraggedId;

  ValueNotifier<ResizeEvent<T>?> eventBeingResized = ValueNotifier<ResizeEvent<T>?>(null);

  void onDragEnd() {
    eventBeingResized.value = null;
    eventBeingDragged.value = null;
    _eventBeingDraggedId = null;
  }

  /// The selected event.
  ///
  /// This is used to keep track of the selected event on mobile.
  ValueNotifier<CalendarEvent<T>?> selectedEvent = ValueNotifier<CalendarEvent<T>?>(null);

  bool isAttachedTo(ViewController viewController) {
    return viewController == _viewController;
  }

  /// Attach the [ViewController] to this [CalendarController].
  void attach(ViewController<T> viewController) {
    if (isAttached) detach();

    _viewController = viewController;
    notifyListeners();
  }

  /// Detach the [ViewController] from this [CalendarController].
  void detach() {
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
