// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/kalender_view.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/floating_date_time.dart';
import 'package:kalender/src/models/floating_date_time_range.dart';
import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_time.dart';
import 'package:kalender/src/models/mixins/kalender_navigation_functions.dart';
import 'package:kalender/src/models/mixins/new_event.dart';
import 'package:kalender/src/models/view_configurations/schedule_view_configuration.dart';
import 'package:timezone/timezone.dart';

/// The [KalenderController] is used to controller a single [KalenderView].
/// It provides some useful functions for navigating the [KalenderView].
///
/// The [KalenderView] attaches itself to the [KalenderController] by calling [attach].
/// And detaches itself by calling [detach].
///
///
/// {@category Controllers and callbacks}
class KalenderController extends ChangeNotifier with KalenderNavigationFunctions, NewEvent {
  KalenderController() : id = _nextId++ {
    _floatingVisibleRange.addListener(_updateVisibleDateTimeRange);
  }

  static int _nextId = 0;

  /// This controllers id.
  ///
  /// Unique to this instance. The drag targets compare it to decide whether a
  /// create gesture belongs to their calendar.
  final int id;

  /// This is a reference to the [ViewController] that is currently attached to this [KalenderController].
  ViewController? _viewController;
  ViewController? get viewController => _viewController;
  bool get isAttached => _viewController != null;

  /// The [FloatingDateTimeRange] that is currently visible.
  ///
  /// See [FloatingDateTimeRange] for more information.
  late final _floatingVisibleRange = ValueNotifier<FloatingDateTimeRange?>(null);
  ValueNotifier<FloatingDateTimeRange?> get floatingVisibleRange => _floatingVisibleRange;
  void _updateVisibleDateTimeRange() {
    final newRange = _floatingVisibleRange.value?.forLocation(location: _viewController?.location);
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

  /// The selected days, or null when nothing is selected.
  ///
  /// Always whole days: [FloatingDateTimeRange.start] is midnight of the first selected day and
  /// [FloatingDateTimeRange.end] is midnight after the last.
  final selectedRange = ValueNotifier<FloatingDateTimeRange?>(null);

  /// A selection made while no view is attached. [attach] resolves it in the view's location.
  (KalenderDateTimeRange, {bool navigate})? _pendingSelection;

  /// Selects the day of [date].
  ///
  /// When [navigate] is true and the day is not visible, the view moves to it.
  void selectDate(DateTime date, {bool navigate = false}) {
    selectRange(
      KalenderDateTimeRange(start: date, end: date),
      navigate: navigate,
    );
  }

  /// Selects every day [range] covers.
  ///
  /// An end at midnight does not include that day, the same as an event ending at midnight. A range that starts and
  /// ends at the same moment selects that day.
  ///
  /// When [navigate] is true and the first day is not visible, the view moves to it.
  void selectRange(KalenderDateTimeRange range, {bool navigate = false}) {
    final viewController = _viewController;
    final days = _daysOf(range, viewController?.location);
    selectedRange.value = days;
    if (viewController == null) {
      _pendingSelection = (range, navigate: navigate);
    } else if (navigate) {
      _navigateTo(days.start);
    }
  }

  /// Clears the selection.
  void deselectRange() {
    _pendingSelection = null;
    selectedRange.value = null;
  }

  /// Whether [date] falls on a selected day.
  bool isDateSelected(DateTime date) {
    final range = selectedRange.value;
    return range != null && FloatingDateTime.fromExternal(date, location: _viewController?.location).isWithin(range);
  }

  FloatingDateTimeRange _daysOf(KalenderDateTimeRange range, Location? location) {
    final start = FloatingDateTime.fromExternal(range.start, location: location);
    final end = FloatingDateTime.fromExternal(range.end, location: location);
    final endsAtMidnight = end.isAtSameMomentAs(end.startOfDay) && end.isAfter(start);
    return FloatingDateTimeRange(start: start.startOfDay, end: endsAtMidnight ? end : end.endOfDay);
  }

  void _navigateTo(FloatingDateTime day) {
    if (_isVisible(day)) return;
    animateToDate(day.forLocation(location: _viewController?.location));
  }

  void _resolvePendingSelection(ViewController viewController) {
    final pending = _pendingSelection;
    if (pending == null) return;
    _pendingSelection = null;
    final days = _daysOf(pending.$1, viewController.location);
    selectedRange.value = days;
    if (!pending.navigate) return;
    // The view builds after attaching, so its pages exist only once the frame is done.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_viewController == viewController) _navigateTo(days.start);
    });
  }

  /// The day whose overlay is open, or null when none is.
  ///
  /// [showDayOverlay], [hideDayOverlay] and the "+N more" button change it.
  final openDayOverlay = ValueNotifier<FloatingDateTime?>(null);

  /// Opens the overlay listing the events of the day of [date].
  ///
  /// Every visible day in the month view and the multi-day header has one. One overlay is open at a time.
  ///
  /// A day that is not visible opens nothing, unless [navigate] is true, which moves the view to it first.
  Future<void> showDayOverlay(DateTime date, {bool navigate = false}) async {
    if (_isDisposed) return;
    final location = _viewController?.location;
    final day = FloatingDateTime.fromExternal(date, location: location).startOfDay;

    if (_viewController?.viewConfiguration is ScheduleViewConfiguration) {
      debugPrint('KalenderController.showDayOverlay: the schedule view has no day overlay.');
      return;
    }

    if (!_isVisible(day)) {
      if (!navigate) {
        debugPrint('KalenderController.showDayOverlay: $day is not visible. Pass navigate: true to move to it first.');
        return;
      }
      await animateToDate(day.forLocation(location: location));
      await WidgetsBinding.instance.endOfFrame;
      if (_isDisposed) return;
      if (!_isVisible(day)) {
        debugPrint('KalenderController.showDayOverlay: the view cannot move to $day.');
        return;
      }
    }

    openDayOverlay.value = day;
  }

  /// Whether [day] is on screen in the attached view.
  bool _isVisible(FloatingDateTime day) {
    final visible = _floatingVisibleRange.value;
    return isAttached && visible != null && day.isWithin(visible);
  }

  /// Closes the open day overlay.
  void hideDayOverlay() {
    if (_isDisposed) return;
    openDayOverlay.value = null;
  }

  bool _isDisposed = false;

  bool isAttachedTo(ViewController viewController) {
    return viewController == _viewController;
  }

  /// Attach the [ViewController] to this [KalenderController].
  void attach(ViewController viewController) {
    if (isAttached) detach();

    _viewController = viewController;
    final visibleRange = viewController.floatingVisibleRange.value!;
    _floatingVisibleRange.value = visibleRange;
    final newRange = visibleRange.forLocation(location: viewController.location);
    visibleDateTimeRange.value = null;
    visibleDateTimeRange.value = newRange;
    _resolvePendingSelection(viewController);

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
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) async {
    await viewController?.animateToNextPage(duration: duration, curve: curve);
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) async {
    return viewController?.animateToPreviousPage(duration: duration, curve: curve);
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    return viewController?.animateToDate(date, duration: duration, curve: curve);
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
      pageDuration: pageDuration,
      pageCurve: pageCurve,
      scrollDuration: scrollDuration,
      scrollCurve: scrollCurve,
      centerEvent: centerEvent,
    );
  }

  @override
  String toString() {
    return runtimeType.toString();
  }

  @override
  void dispose() {
    _floatingVisibleRange.removeListener(_updateVisibleDateTimeRange);
    _detachVisibleTimeOfDay();
    visibleTimeOfDay.dispose();
    selectedRange.dispose();
    openDayOverlay.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
