import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/mixins/calendar_navigation_functions.dart';
import 'package:kalender/src/calendar_view.dart';

/// The [CalendarController] is used to controller a single [CalendarView].
/// It provides some useful functions for navigating the [CalendarView].
///
/// The [CalendarView] attaches itself to the [CalendarController] by calling [attach].
/// And detaches itself by calling [detach].
///
class CalendarController<T extends Object?> extends ChangeNotifier
    with CalendarNavigationFunctions<T> {
  CalendarController({DateTime? initialDate}) : initialDate = initialDate ?? DateTime.now();

  late final DateTime initialDate;

  /// This is a reference to the [ViewController] that is currently attached to this [CalendarController].
  ViewController<T>? _viewController;
  ViewController<T>? get viewController => _viewController;
  bool get isAttached => _viewController != null;

  /// The [DateTimeRange] that is currently visible.
  final visibleDateTimeRange = ValueNotifier<DateTimeRange>(
    DateTime.now().dayRange,
  );

  /// The [CalendarEvent]s that are currently visible.
  /// TODO: Implement this so it works.
  final visibleEvents = ValueNotifier<List<CalendarEvent<T>>>([]);

  /// The event currently being focused on.
  final selectedEvent = ValueNotifier<CalendarEvent<T>?>(null);
  int? _selectedEventId;
  int? get selectedEventId => _selectedEventId;

  /// This is used to determine if focus on the event is coming from within the package or from outside.
  bool internalFocus = false;

  /// Place focus on an event.
  ///
  /// [event] the event to focus on.
  /// [internal] leave false if not called from within the package.
  void selectEvent(CalendarEvent<T> event, {bool internal = false}) {
    selectedEvent.value = event;
    _selectedEventId = event.id;
    internalFocus = internal;
  }

  void updateEvent(CalendarEvent<T> event, {bool internal = false}) {
    selectedEvent.value = event;
    internalFocus = internal;
  }

  /// Deselect the event.
  void deselectEvent() {
    selectedEvent.value = null;
    internalFocus = false;
    _selectedEventId = null;
  }

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
  void jumpToPage(int page) {
    viewController?.jumpToPage(page);
  }

  /// Jump to the given [DateTime].
  @override
  void jumpToDate(DateTime date) {
    viewController?.jumpToDate(date);
  }

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

  /// Animate to the date part of the given [DateTime].
  ///
  /// [date] the [DateTime] to animate to.
  /// [duration] the [Duration] of the animation.
  /// [curve] the [Curve] of the animation.
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

  /// Animate to the date and time parts of the given [DateTime].
  ///
  /// [date] the [DateTime] to animate to.
  /// [pageDuration] the [Duration] of the page animation.
  /// [pageCurve] the [Curve] of the page animation.
  /// [scrollDuration] the [Duration] of the scroll animation.
  /// [scrollCurve] the [Curve] of the scroll animation.
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
  ///
  /// [event] the [CalendarEvent] to animate to.
  /// [duration] the [Duration] of the animation.
  /// [curve] the [Curve] of the animation.
  /// [centerEvent] whether to center the event in the view.
  @override
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) async {
    
    await viewController?.animateToEvent(
      event,
      centerEvent: centerEvent,
    );
  }

  @override
  String toString() {
    return runtimeType.toString();
  }
}
