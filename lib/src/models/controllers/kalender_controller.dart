import 'package:flutter/material.dart';
import 'package:kalender/src/extensions/internal_date_time_range.dart';
import 'package:kalender/src/kalender_view.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_time.dart';
import 'package:kalender/src/models/mixins/kalender_navigation_functions.dart';
import 'package:kalender/src/models/mixins/new_event.dart';

/// The [KalenderController] is used to controller a single [KalenderView].
/// It provides some useful functions for navigating the [KalenderView].
///
/// The [KalenderView] attaches itself to the [KalenderController] by calling [attach].
/// And detaches itself by calling [detach].
///
class KalenderController extends ChangeNotifier with KalenderNavigationFunctions, NewEvent {
  KalenderController() : id = DateTime.now().millisecondsSinceEpoch {
    _internalDateTimeRange.addListener(_updateVisibleDateTimeRange);
  }

  /// This controllers id.
  final int id;

  /// This is a reference to the [ViewController] that is currently attached to this [KalenderController].
  ViewController? _viewController;
  ViewController? get viewController => _viewController;
  bool get isAttached => _viewController != null;

  /// The internal [InternalDateTimeRange] that is currently visible.
  ///
  /// See [InternalDateTimeRange] for more information.
  late final _internalDateTimeRange = ValueNotifier<InternalDateTimeRange?>(null);
  ValueNotifier<InternalDateTimeRange?> get internalDateTimeRange => _internalDateTimeRange;
  void _updateVisibleDateTimeRange() {
    final newRange = _internalDateTimeRange.value?.forLocation(location: _viewController?.location);
    visibleDateTimeRange.value = newRange;
  }

  /// The [KalenderDateTimeRange] that is currently visible for the current location of the calendar this controller is attached to.
  final visibleDateTimeRange = ValueNotifier<KalenderDateTimeRange?>(null);

  /// The [KalenderEvent]s that are currently visible.
  final visibleEvents = ValueNotifier<Set<KalenderEvent>>({});

  /// The [KalenderTime] currently aligned with the top of the visible viewport.
  ///
  /// This reflects the vertical scroll position of a multi-day view (day/week/etc)
  /// and updates as the user scrolls or zooms. It is `null` when the attached view
  /// has no vertical scroll (e.g. month or schedule views).
  final visibleTimeOfDay = ValueNotifier<KalenderTime?>(null);

  /// The multi-day view's [MultiDayViewController.visibleTimeOfDay] source that is
  /// currently being forwarded into [visibleTimeOfDay], and its listener.
  ValueNotifier<KalenderTime?>? _visibleTimeOfDaySource;
  VoidCallback? _visibleTimeOfDayForwarder;

  /// The event currently being focused on.
  final selectedEvent = ValueNotifier<KalenderEvent?>(null);
  String? _selectedEventId;
  String? get selectedEventId => _selectedEventId;

  /// This is used to determine if focus on the event is coming from within the package or from outside.
  bool _internalFocus = false;
  bool get internalFocus => _internalFocus;

  /// Place focus on an event.
  ///
  /// [event] the event to focus on.
  /// [internal] leave false if not called from within the package.
  void selectEvent(KalenderEvent event, {bool internal = false}) {
    _selectedEventId = event.id;
    _internalFocus = internal;
    selectedEvent.value = event;
  }

  void updateEvent(KalenderEvent event, {bool internal = false}) {
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

  /// Attach the [ViewController] to this [KalenderController].
  void attach(ViewController viewController) {
    if (isAttached) detach();

    _viewController = viewController;
    final visibleRange = viewController.visibleDateTimeRange.value!;
    _internalDateTimeRange.value = visibleRange;
    final newRange = visibleRange.forLocation(location: viewController.location);
    visibleDateTimeRange.value = null;
    visibleDateTimeRange.value = newRange;

    // Forward the visible time-of-day from multi-day views; null for views without
    // vertical scroll (month/schedule).
    if (viewController is MultiDayViewController) {
      final source = viewController.visibleTimeOfDay;
      void forwarder() => visibleTimeOfDay.value = source.value;
      source.addListener(forwarder);
      _visibleTimeOfDaySource = source;
      _visibleTimeOfDayForwarder = forwarder;
      visibleTimeOfDay.value = source.value;
    } else {
      visibleTimeOfDay.value = null;
    }

    notifyListeners();
  }

  /// Detach the [ViewController] from this [KalenderController].
  void detach() {
    _detachVisibleTimeOfDay();
    visibleTimeOfDay.value = null;
    _viewController = null;
  }

  void _detachVisibleTimeOfDay() {
    final forwarder = _visibleTimeOfDayForwarder;
    if (forwarder != null) _visibleTimeOfDaySource?.removeListener(forwarder);
    _visibleTimeOfDaySource = null;
    _visibleTimeOfDayForwarder = null;
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
    KalenderEvent event, {
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
    _detachVisibleTimeOfDay();
    visibleTimeOfDay.dispose();
    super.dispose();
  }
}
