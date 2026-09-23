// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/src/kalender_view.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_time.dart';
import 'package:kalender/src/models/mixins/kalender_navigation_functions.dart';
import 'package:kalender/src/models/mixins/new_event.dart';
import 'package:kalender/src/models/view_configurations/schedule_view_configuration.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/models/view_transition.dart';

/// Holds the [ViewConfiguration] and [Location] of a calendar and the [ViewController] a [KalenderView] shows.
///
/// Setting [viewConfiguration] switches the view. Setting [location] recreates it in the new location.
///
/// {@category Controllers and callbacks}
class KalenderController extends ChangeNotifier with KalenderNavigationFunctions, NewEvent {
  KalenderController({required ViewConfiguration viewConfiguration, Location? location})
    : id = _nextId++,
      _viewConfiguration = viewConfiguration,
      _location = location {
    _floatingVisibleRange.addListener(_updateVisibleDateTimeRange);
    _adopt(viewConfiguration.createViewController(this, null));
  }

  static int _nextId = 0;

  /// Unique to this instance. The drag targets compare it to decide whether a
  /// create gesture belongs to their calendar.
  final int id;

  /// The configuration of the view.
  ///
  /// Setting a configuration that is not `==` to the current one switches the view. The date, scroll and zoom the new
  /// view opens on follow the new configuration's transition settings.
  ViewConfiguration get viewConfiguration => _viewConfiguration;
  ViewConfiguration _viewConfiguration;
  set viewConfiguration(ViewConfiguration value) {
    if (value == _viewConfiguration) return;
    _switchTo(value);
  }

  /// The location of the calendar. Null uses the device's local time.
  ///
  /// Setting a different location recreates the view controller in it.
  Location? get location => _location;
  Location? _location;
  set location(Location? value) {
    if (value == _location) return;
    final previous = _location;
    _location = value;
    try {
      _switchTo(_viewConfiguration, locationChanged: true);
    } catch (_) {
      _location = previous;
      rethrow;
    }
  }

  /// The view controller of the active [KalenderView].
  ViewController get viewController => _viewController;
  late ViewController _viewController;

  /// The last snapshot of each view, keyed by its configuration `name`.
  final _viewHistory = <String, ViewSnapshot>{};

  /// The last snapshot of a multi-day view.
  ViewSnapshot? _lastMultiDaySnapshot;

  /// The attached views, the active one last.
  final _views = <Object>[];

  /// The views holding each view controller that a view holds.
  final _holders = <ViewController, Set<Object>>{};

  /// Whether a view has held [viewController].
  bool _currentHeld = false;

  /// Whether [viewController] was created since the last frame while a view was attached, so no widget uses it yet.
  bool _awaitingBuild = false;

  /// Replaces the view controller with one [configuration] creates.
  ///
  /// A [reopen] recreates the current view where it is, seeds its visible events and does not notify.
  void _switchTo(ViewConfiguration configuration, {bool locationChanged = false, bool reopen = false}) {
    final old = _viewController;
    final snapshot = old.snapshot();
    _viewHistory[old.viewConfiguration.name] = snapshot;
    if (snapshot.heightPerMinute != null) _lastMultiDaySnapshot = snapshot;

    final transition = ViewTransitionContext(
      oldViewController: old,
      newViewConfiguration: configuration,
      byView: _viewHistory,
      lastMultiDay: _lastMultiDaySnapshot,
      locationChanged: locationChanged,
      location: _location,
      target: reopen ? snapshot : null,
    );
    final next = configuration.createViewController(this, transition);
    _viewConfiguration = configuration;
    if (reopen) next.visibleEvents.value = old.visibleEvents.value;

    _removeForwarders();
    _adopt(next);
    _retire(old);
    if (reopen) return;
    if (_hasView) {
      _awaitingBuild = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _awaitingBuild = false);
    }
    notifyListeners();
  }

  void _adopt(ViewController viewController) {
    _viewController = viewController;
    _currentHeld = false;
    _forward(viewController.floatingVisibleRange, _floatingVisibleRange);
    _forward(viewController.visibleEvents, _visibleEvents);
    // Views without vertical scroll (month and schedule) have no visible time of day.
    if (viewController is MultiDayViewController) {
      _forward(viewController.visibleTimeOfDay, visibleTimeOfDay);
    } else {
      visibleTimeOfDay.value = null;
    }
    _updateVisibleDateTimeRange();
  }

  /// Disposes [viewController] once no view holds it.
  void _retire(ViewController viewController) {
    if (_holders[viewController]?.isNotEmpty ?? false) return;
    _holders.remove(viewController);
    viewController.dispose();
  }

  /// Makes [view] the active view and returns the view controller it shows.
  ///
  /// A view that does not hold the current view controller gets a new one when a view has held it before, because
  /// its page and scroll controllers keep the position they were created with. The new one opens where the current
  /// one is.
  @internal
  ViewController attachView(Object view) {
    _views
      ..remove(view)
      ..add(view);
    final holdsCurrent = _holders[_viewController]?.contains(view) ?? false;
    if (!holdsCurrent && _currentHeld) _switchTo(_viewConfiguration, reopen: true);
    final viewController = _viewController;
    (_holders[viewController] ??= {}).add(view);
    _currentHeld = true;
    _resolvePendingSelection();
    return viewController;
  }

  /// Removes [view] from the attached views. The next newest view becomes active after this frame.
  @internal
  void detachView(Object view) {
    final wasActive = isActiveView(view);
    _views.remove(view);
    if (!wasActive || _views.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final next = _views.lastOrNull;
      if (!_isDisposed && next is KalenderViewState) next.becameActive();
    });
  }

  @internal
  bool isActiveView(Object view) => _views.isNotEmpty && identical(_views.last, view);

  /// Tells the controller that [view] no longer shows [viewController].
  @internal
  void releaseView(Object view, ViewController viewController) {
    final holders = _holders[viewController];
    if (holders == null) return;
    holders.remove(view);
    if (holders.isNotEmpty) return;
    _holders.remove(viewController);
    if (_isDisposed || !identical(viewController, _viewController)) viewController.dispose();
  }

  bool get _hasView => _views.isNotEmpty;

  /// Runs [navigate] once the view has built [viewController].
  Future<void> _whenBuilt(FutureOr<void> Function(ViewController viewController) navigate) async {
    if (!_hasView) return;
    if (_awaitingBuild) await WidgetsBinding.instance.endOfFrame;
    if (_isDisposed || !_hasView) return;
    await navigate(_viewController);
  }

  /// The [ViewController.floatingVisibleRange] of [viewController].
  late final _floatingVisibleRange = ValueNotifier<FloatingDateTimeRange?>(null);
  ValueListenable<FloatingDateTimeRange?> get floatingVisibleRange => _floatingVisibleRange;
  void _updateVisibleDateTimeRange() {
    visibleDateTimeRange.value = _floatingVisibleRange.value?.forLocation(location: _location);
  }

  /// The [floatingVisibleRange] in [location].
  final visibleDateTimeRange = ValueNotifier<KalenderDateTimeRange?>(null);

  /// The [ViewController.visibleEvents] of [viewController].
  ValueListenable<Set<KalenderEvent>> get visibleEvents => _visibleEvents;
  final _visibleEvents = ValueNotifier<Set<KalenderEvent>>({});

  /// The [KalenderTime] currently aligned with the top of the visible viewport.
  ///
  /// This reflects the vertical scroll position of a multi-day view (day/week/etc)
  /// and updates as the user scrolls or zooms. It is `null` when the view
  /// has no vertical scroll (e.g. month or schedule views).
  final visibleTimeOfDay = ValueNotifier<KalenderTime?>(null);

  /// The listeners that copy the notifiers of [viewController] into this controller's.
  final _forwarders = <(Listenable, VoidCallback)>[];

  void _forward<T>(ValueNotifier<T> source, ValueNotifier<T> target) {
    void forwarder() => target.value = source.value;
    source.addListener(forwarder);
    _forwarders.add((source, forwarder));
    target.value = source.value;
  }

  void _removeForwarders() {
    for (final (source, forwarder) in _forwarders) {
      source.removeListener(forwarder);
    }
    _forwarders.clear();
  }

  /// The event currently being focused on.
  final selectedEvent = ValueNotifier<KalenderEvent?>(null);
  String? _selectedEventId;
  String? get selectedEventId => _selectedEventId;

  /// This is used to determine if focus on the event is coming from within the package or from outside.
  bool _internalFocus = false;
  bool get internalFocus => _internalFocus;

  /// Place focus on an event.
  ///
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

  /// A selection made while no view is attached. [attachView] resolves it.
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
    final days = _daysOf(range, _location);
    selectedRange.value = days;
    if (!_hasView) {
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
    return range != null && FloatingDateTime.fromExternal(date, location: _location).isWithin(range);
  }

  FloatingDateTimeRange _daysOf(KalenderDateTimeRange range, Location? location) {
    final start = FloatingDateTime.fromExternal(range.start, location: location);
    final end = FloatingDateTime.fromExternal(range.end, location: location);
    final endsAtMidnight = end.isAtSameMomentAs(end.startOfDay) && end.isAfter(start);
    return FloatingDateTimeRange(start: start.startOfDay, end: endsAtMidnight ? end : end.endOfDay);
  }

  void _navigateTo(FloatingDateTime day) {
    if (_isVisible(day)) return;
    animateToDate(day.forLocation(location: _location));
  }

  void _resolvePendingSelection() {
    final pending = _pendingSelection;
    if (pending == null) return;
    _pendingSelection = null;
    final days = _daysOf(pending.$1, _location);
    selectedRange.value = days;
    if (!pending.navigate) return;
    // The view builds after attaching, so its pages exist only once the frame is done.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && _hasView) _navigateTo(days.start);
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
    final location = _location;
    final day = FloatingDateTime.fromExternal(date, location: location).startOfDay;

    if (_viewConfiguration is ScheduleViewConfiguration) {
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
    return _hasView && visible != null && day.isWithin(visible);
  }

  /// Closes the open day overlay.
  void hideDayOverlay() {
    if (_isDisposed) return;
    openDayOverlay.value = null;
  }

  bool _isDisposed = false;

  @override
  void jumpToPage(int page) => unawaited(_whenBuilt((viewController) => viewController.jumpToPage(page)));

  @override
  void jumpToDate(DateTime date) => unawaited(_whenBuilt((viewController) => viewController.jumpToDate(date)));

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) {
    return _whenBuilt((viewController) => viewController.animateToNextPage(duration: duration, curve: curve));
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) {
    return _whenBuilt((viewController) => viewController.animateToPreviousPage(duration: duration, curve: curve));
  }

  @override
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) {
    return _whenBuilt((viewController) => viewController.animateToDate(date, duration: duration, curve: curve));
  }

  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  }) {
    return _whenBuilt(
      (viewController) => viewController.animateToDateTime(
        date,
        pageDuration: pageDuration,
        pageCurve: pageCurve,
        scrollDuration: scrollDuration,
        scrollCurve: scrollCurve,
      ),
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
  }) {
    return _whenBuilt(
      (viewController) => viewController.animateToEvent(
        event,
        pageDuration: pageDuration,
        pageCurve: pageCurve,
        scrollDuration: scrollDuration,
        scrollCurve: scrollCurve,
        centerEvent: centerEvent,
      ),
    );
  }

  @override
  void dispose() {
    _floatingVisibleRange.removeListener(_updateVisibleDateTimeRange);
    _removeForwarders();
    // A view controller a view still shows is disposed when the view releases it.
    for (final viewController in {_viewController, ..._holders.keys}) {
      if (_holders[viewController]?.isEmpty ?? true) viewController.dispose();
    }
    _floatingVisibleRange.dispose();
    _visibleEvents.dispose();
    visibleDateTimeRange.dispose();
    visibleTimeOfDay.dispose();
    selectedEvent.dispose();
    selectedRange.dispose();
    openDayOverlay.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
