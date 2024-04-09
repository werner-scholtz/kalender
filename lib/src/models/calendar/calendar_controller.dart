import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/view_state/month_view_state.dart';
import 'package:kalender/src/models/calendar/view_state/multi_day_view_state.dart';
import 'package:kalender/src/models/calendar/view_state/schedule_view_state.dart';
import 'package:kalender/src/models/calendar/view_state/view_state.dart';

/// The [CalendarController] is used to control a calendar view.
///
/// * Can be used to animate to a specific date or page.
/// * Can be used to jump to a specific date or page.
/// * Can be used to navigate to a specific Event.
/// * Can be used to change the height per minute of the view. (Zoom level)
/// * Can be used to lock or unlock the vertical scroll of the view.
class CalendarController<T> with ChangeNotifier {
  CalendarController({
    DateTime? initialDate,
    DateTimeRange? calendarDateTimeRange,
  })  : _dateTimeRange = calendarDateTimeRange ?? defaultDateRange,
        _selectedDate = initialDate?.startOfDay ?? DateTime.now().startOfDay;

  /// The currently selected date.
  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  /// The list of [CalendarEvent]s that are currently visible.
  Iterable<CalendarEvent<T>> _visibleEvents = [];
  Iterable<CalendarEvent<T>> get visibleEvents => _visibleEvents;
  set visibleEvents(Iterable<CalendarEvent<T>> value) {
    _visibleEvents = value;
    notifyListeners();
  }

  /// The [DateTimeRange] that the calendar can display.
  final DateTimeRange _dateTimeRange;
  DateTimeRange get dateTimeRange => _dateTimeRange;

  /// The current [_state] of the view this controller is linked to.
  ViewState? _state;
  ViewState? get state => _state;
  bool get isAttached => _state != null;

  /// The previous [_state]s of the view this controller was linked to.
  MultiDayViewState? _previousMultiDayViewState;
  MonthViewState? _previousMonthViewState;
  ScheduleViewState? _previousScheduleViewState;

  /// This [ValueNotifier] exposes the visible dateTimeRange of the current view.
  ValueNotifier<DateTimeRange>? get visibleDateTimeRange {
    return _state?.visibleDateTimeRangeNotifier;
  }

  /// The visible month of the current view.
  DateTime? get visibleMonth {
    return _state?.visibleMonth;
  }

  /// The [ScrollController] of the current view.
  ///
  /// * This is only available for [MultiDayView]'s.
  ScrollController? get scrollController {
    if (_state is MultiDayViewState) {
      return (_state as MultiDayViewState).scrollController;
    }
    return null;
  }

  /// This [ValueNotifier] exposes the height per minute of the current view.
  ///
  /// * This is only available for [MultiDayView]'s.
  ValueNotifier<double>? get heightPerMinute {
    if (_state is MultiDayViewState) {
      return (_state as MultiDayViewState).heightPerMinute;
    }
    return null;
  }

  ViewState? attach(ViewConfiguration viewConfiguration) {
    /// Detach the current view if it is attached.
    if (isAttached) detach();

    ViewState? viewState;

    if (viewConfiguration is MultiDayViewConfiguration) {
      viewState = MultiDayViewState.fromViewConfiguration(
        dateTimeRange: dateTimeRange,
        selectedDate: selectedDate,
        viewConfiguration: viewConfiguration,
        previousState: _previousMultiDayViewState,
      );
    } else if (viewConfiguration is MonthViewConfiguration) {
      viewState = MonthViewState.fromViewConfiguration(
        dateTimeRange: dateTimeRange,
        selectedDate: selectedDate,
        viewConfiguration: viewConfiguration,
        previousState: _previousMonthViewState,
      );
    } else if (viewConfiguration is ScheduleViewConfiguration) {
      viewState = ScheduleViewState.fromViewConfiguration(
        dateTimeRange: dateTimeRange,
        selectedDate: selectedDate,
        viewConfiguration: viewConfiguration,
        previousState: _previousScheduleViewState,
      );
    }

    assert(
      viewState != null,
      'The $viewConfiguration is not supported.',
    );

    if (viewState != null) {
      attachViewState(viewState);
    }

    return viewState;
  }

  void attachViewState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  /// Detaches the [CalendarController] from a [CalendarView].
  void detach() {
    if (_state != null) {
      if (_state is MultiDayViewState) {
        _previousMultiDayViewState = _state as MultiDayViewState;
      }
      if (_state is MonthViewState) {
        _previousMonthViewState = _state as MonthViewState;
      }
      if (_state is ScheduleViewState) {
        _previousScheduleViewState = _state as ScheduleViewState;
      }
    }
    _state = null;
    _visibleEvents = [];
  }

  /// Animates to the next page.
  ///
  /// The [duration] and [curve] can be provided to customize the animation.
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  }) async {
    if (!hasState) return;
    await _state?.animateToNextPage(duration: duration, curve: curve);
    notifyListeners();
  }

  /// Animates to the previous page.
  ///
  /// The [duration] and [curve] can be provided to customize the animation.
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  }) async {
    if (!hasState) return;
    await _state?.animateToPreviousPage(duration: duration, curve: curve);
    notifyListeners();
  }

  /// Jumps to the [page].
  ///  The [page] must be within the [numberOfPages].
  void jumpToPage(int page) {
    if (!hasState) return;
    _state!.jumpToPage(page);
    notifyListeners();
  }

  /// Jumps to the [date].
  void jumpToDate(DateTime date) {
    if (!hasState) return;
    _state!.jumpToDate(date);
    notifyListeners();
  }

  /// Animates to the [DateTime] provided.
  ///
  /// The [duration] and [curve] can be provided to customize the animation.
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    if (!hasState) return;
    await _state?.animateToDate(date, duration: duration, curve: curve);
    notifyListeners();
  }

  /// Animates to the [DateTime] provided.
  ///
  /// The [duration] and [curve] can be provided to customize the animation.
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    if (!hasState) return;

    if (state is MultiDayViewState) {
      await _state?.animateToDateTime(date, duration: duration, curve: curve);
      notifyListeners();
    } else {
      debugPrint('Not available for this calendar view');
    }
  }

  /// Changes the [heightPerMinute] of the view. (Zoom level)
  /// * This is only available for [SingleDayView] and [MultiDayViewOLD].
  ///
  /// The [heightPerMinute] must be greater than 0.
  void adjustHeightPerMinute(double heightPerMinute) {
    if (!hasState) return;
    _state?.adjustHeightPerMinute(heightPerMinute);
    notifyListeners();
  }

  /// Animates to the [CalendarEvent].
  ///
  /// The [duration] and [curve] can be provided to customize the animation.
  ///
  /// * If [centerEvent] is true, the event will be centered in the viewport if the event is smaller than the viewport.
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? duration,
    Curve? curve,
    bool centerEvent = true,
  }) async {
    if (!hasState) return;

    await _state?.animateToEvent(
      event,
      duration: duration,
      curve: curve,
      centerEvent: centerEvent,
    );

    notifyListeners();
  }

  /// Locks the vertical scroll of the current view.
  void lockScrollPhysics() {
    if (!hasState) return;

    assert(
      _state is MultiDayViewState,
      'The $_state must be a $MultiDayViewState.',
    );
    if (_state is! MultiDayViewState) return;

    (_state as MultiDayViewState).scrollPhysics.value =
        const NeverScrollableScrollPhysics();
    notifyListeners();
  }

  /// Unlocks the vertical scroll of the current view.
  /// * If [scrollPhysics] is provided it will be used instead of the default.
  void unlockScrollPhysics({
    ScrollPhysics? scrollPhysics,
  }) {
    if (!hasState) return;

    assert(
      _state is MultiDayViewState,
      'The $_state must be a $MultiDayViewState.',
    );
    if (_state is! MultiDayViewState) return;
    (_state as MultiDayViewState).scrollPhysics.value =
        scrollPhysics ?? const ScrollPhysics();
    notifyListeners();
  }

  bool get hasState {
    if (_state == null) {
      if (kDebugMode) {
        print(
          'The $_state must not be null.'
          'Please attach the $CalendarController to a view.',
        );
      }
      return false;
    }
    return true;
  }
}
