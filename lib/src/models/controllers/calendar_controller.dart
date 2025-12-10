import 'package:flutter/material.dart';
import 'package:kalender/src/calendar_view.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/mixins/calendar_navigation_functions.dart';
import 'package:kalender/src/models/mixins/new_event.dart';

/// The [CalendarController] is used to controller a single [CalendarView].
/// It provides some useful functions for navigating the [CalendarView].
///
/// The [CalendarView] attaches itself to the [CalendarController] by calling [attach].
/// And detaches itself by calling [detach].
///
class CalendarController<T extends Object?> extends ChangeNotifier with CalendarNavigationFunctions<T>, NewEvent<T> {
  CalendarController() : id = DateTime.now().millisecondsSinceEpoch {
    _internalDateTimeRange.addListener(_updateVisibleDateTimeRange);
  }

  /// This controllers id.
  final int id;

  /// This is a reference to the [ViewController] that is currently attached to this [CalendarController].
  ViewController<T>? _viewController;
  ViewController<T>? get viewController => _viewController;
  bool get isAttached => _viewController != null;

  /// The internal [InternalDateTimeRange] that is currently visible.
  ///
  /// See [InternalDateTimeRange] for more information.
  late final _internalDateTimeRange = ValueNotifier<InternalDateTimeRange?>(null);
  ValueNotifier<InternalDateTimeRange?> get internalDateTimeRange => _internalDateTimeRange;
  void _updateVisibleDateTimeRange() {
    final newRange = _internalDateTimeRange.value?.forLocation(_viewController?.location);
    visibleDateTimeRange.value = newRange;
  }

  /// The [DateTimeRange] that is currently visible for the current location of the calendar this controller is attached to.
  final visibleDateTimeRange = ValueNotifier<DateTimeRange<DateTime>?>(null);

  /// The [CalendarEvent]s that are currently visible.
  final visibleEvents = ValueNotifier<Set<CalendarEvent<T>>>({});

  /// The event currently being focused on.
  final selectedEvent = ValueNotifier<CalendarEvent<T>?>(null);
  int? _selectedEventId;
  int? get selectedEventId => _selectedEventId;

  /// This is used to determine if focus on the event is coming from within the package or from outside.
  bool _internalFocus = false;
  bool get internalFocus => _internalFocus;

  /// Place focus on an event.
  ///
  /// [event] the event to focus on.
  /// [internal] leave false if not called from within the package.
  void selectEvent(CalendarEvent<T> event, {bool internal = false}) {
    _selectedEventId = event.id;
    _internalFocus = internal;
    selectedEvent.value = event;
  }

  void updateEvent(CalendarEvent<T> event, {bool internal = false}) {
    _internalFocus = internal;
    selectedEvent.value = event;
  }

  /// Deselect the event.
  void deselectEvent() {
    _internalFocus = false;
    _selectedEventId = null;
    selectedEvent.value = null;
  }

  bool isAttachedTo(ViewController viewController) {
    return viewController == _viewController;
  }

  /// Attach the [ViewController] to this [CalendarController].
  void attach(ViewController<T> viewController) {
    if (isAttached) detach();

    _viewController = viewController;
    final visibleRange = viewController.visibleDateTimeRange.value!;
    _internalDateTimeRange.value = visibleRange;
    final newRange = visibleRange.forLocation(viewController.location);
    visibleDateTimeRange.value = null;
    visibleDateTimeRange.value = newRange;

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
    return viewController?.animateToDate(
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
    return viewController?.animateToDateTime(
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
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) async {
    return viewController?.animateToEvent(
      event,
      centerEvent: centerEvent,
    );
  }

  @override
  String toString() {
    return runtimeType.toString();
  }

  @override
  void dispose() {
    _internalDateTimeRange.removeListener(_updateVisibleDateTimeRange);
    super.dispose();
  }
}
