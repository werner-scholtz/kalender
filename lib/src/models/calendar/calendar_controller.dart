import 'package:flutter/material.dart';

import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/calendar_view_state.dart';

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
  })  : _selectedDate = initialDate ?? DateTime.now(),
        _dateTimeRange = calendarDateTimeRange ?? defaultDateRange;

  /// The currently selected date.
  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  /// The [DateTimeRange] that the calendar can display.
  final DateTimeRange _dateTimeRange;
  DateTimeRange get dateTimeRange => _dateTimeRange;

  /// The current [_state] of the view this controller is linked to.
  ViewStateV2? _state;
  bool get isAttached => _state != null;

  ViewStateV2? _previousState;

  /// This [ValueNotifier] exposes the height per minute of the current view.
  ///
  /// This is only available for [SingleDayView] and [MultiDayViewOLD].
  ValueNotifier<double>? get heightPerMinute => (_state is MultiDayViewState)
      ? (_state as MultiDayViewState).heightPerMinute
      : null;

  /// This [ValueNotifier] exposes the visible dateTimeRange of the current view.
  ValueNotifier<DateTimeRange>? get visibleDateTimeRange =>
      _state?.visibleDateTimeRangeNotifier ??
      _previousState?.visibleDateTimeRangeNotifier;

  /// The visible month of the current view.
  DateTime? get visibleMonth =>
      _state?.visibleMonth ?? _previousState?.visibleMonth;

  /// Attaches the [CalendarController] to a [CalendarView].
  void attach(ViewStateV2 viewState) {
    _state = viewState;
  }

  /// Detaches the [CalendarController] from a [CalendarView].
  void detach() {
    _previousState = _state;
    _state = null;
  }

  /// Animates to the next page.
  ///
  /// The [duration] and [curve] can be provided to customize the animation.
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  }) async {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a view.',
    );
    if (_state == null) return;
    assert(
      _state is MonthViewState || _state is MultiDayViewState,
      'The $_state must be either a $MonthViewState or a $MultiDayViewState.',
    );
    if (_state is! MonthViewState && _state is! MultiDayViewState) return;

    if (_state is MonthViewState) {
      await (_state as MonthViewState).pageController?.nextPage(
            duration: duration ?? const Duration(milliseconds: 300),
            curve: curve ?? Curves.easeInOut,
          );

      notifyListeners();
    } else if (_state is MultiDayViewState) {
      await (_state as MultiDayViewState).pageController?.nextPage(
            duration: duration ?? const Duration(milliseconds: 300),
            curve: curve ?? Curves.easeInOut,
          );
      notifyListeners();
    }
  }

  /// Animates to the previous page.
  ///
  /// The [duration] and [curve] can be provided to customize the animation.
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  }) async {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a view.',
    );
    if (_state == null) return;
    assert(
      _state is MonthViewState || _state is MultiDayViewState,
      'The $_state must be either a $MonthViewState or a $MultiDayViewState.',
    );
    if (_state is! MonthViewState && _state is! MultiDayViewState) return;

    if (_state is MonthViewState) {
      await (_state as MonthViewState).pageController?.previousPage(
            duration: duration ?? const Duration(milliseconds: 300),
            curve: curve ?? Curves.easeInOut,
          );

      notifyListeners();
    } else if (_state is MultiDayViewState) {
      await (_state as MultiDayViewState).pageController?.previousPage(
            duration: duration ?? const Duration(milliseconds: 300),
            curve: curve ?? Curves.easeInOut,
          );
      notifyListeners();
    }
  }

  /// Jumps to the [page].
  ///  The [page] must be within the [numberOfPages].
  void jumpToPage(int page) {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a view.',
    );
    if (_state == null) return;

    assert(
      _state is MonthViewState || _state is MultiDayViewState,
      'The $_state must be either a $MonthViewState or a $MultiDayViewState.',
    );
    if (_state is! MonthViewState && _state is! MultiDayViewState) return;

    if (_state is MonthViewState) {
      (_state as MonthViewState).pageController?.jumpToPage(page);
      notifyListeners();
    } else if (_state is MultiDayViewState) {
      (_state as MultiDayViewState).pageController?.jumpToPage(page);
      notifyListeners();
    }
  }

  /// Jumps to the [date].
  void jumpToDate(DateTime date) {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a view.',
    );
    if (_state == null) return;

    assert(
      !date.isWithin(_state!.adjustedDateTimeRange),
      'The date must be within the dateTimeRange of the Calendar.',
    );
    if (!date.isWithin(_state!.adjustedDateTimeRange)) return;

    if (_state is MonthViewState) {
      (_state as MonthViewState).pageController?.jumpToPage(
            _state!.viewConfiguration.calculateDateIndex(
              date,
              _state!.adjustedDateTimeRange.start,
            ),
          );
      notifyListeners();
    } else if (_state is MultiDayViewState) {
      (_state as MultiDayViewState).pageController?.jumpToPage(
            _state!.viewConfiguration.calculateDateIndex(
              date,
              _state!.adjustedDateTimeRange.start,
            ),
          );
      notifyListeners();
    } else if (_state is ScheduleViewState) {
      final state = _state as ScheduleViewState;

      var index = state.scheduleGroups.indexWhere(
        (group) => group.date.isSameDay(date),
      );

      if (index == -1) {
        index = state.scheduleGroups.indexWhere(
          (group) => group.date.startOfWeek == date.startOfWeek,
        );
      }

      if (index == -1) {
        index = state.scheduleGroups.indexWhere(
          (group) => group.date.startOfMonth == date.startOfMonth,
        );
      }

      (_state as ScheduleViewState).itemScrollController.jumpTo(index: index);
      notifyListeners();
    }
  }

  /// Animates to the [DateTime] provided.
  ///
  /// The [duration] and [curve] can be provided to customize the animation.
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a view.',
    );
    if (_state == null) return;

    assert(
      date.isWithin(_state!.adjustedDateTimeRange),
      'The date must be within the dateTimeRange of the Calendar.',
    );
    if (!date.isWithin(_state!.adjustedDateTimeRange)) return;

    if (_state is MonthViewState) {
      (_state as MonthViewState).pageController?.animateToPage(
            _state!.viewConfiguration.calculateDateIndex(
              date,
              _state!.adjustedDateTimeRange.start,
            ),
            duration: duration ?? const Duration(milliseconds: 300),
            curve: curve ?? Curves.easeInOut,
          );
      notifyListeners();
    } else if (_state is MultiDayViewState) {
      (_state as MultiDayViewState).pageController?.animateToPage(
            _state!.viewConfiguration.calculateDateIndex(
              date,
              _state!.adjustedDateTimeRange.start,
            ),
            duration: duration ?? const Duration(milliseconds: 300),
            curve: curve ?? Curves.easeInOut,
          );
      notifyListeners();
    } else if (_state is ScheduleViewState) {
      final state = _state as ScheduleViewState;

      var index = state.scheduleGroups.indexWhere(
        (group) => group.date.isSameDay(date),
      );

      if (index == -1) {
        index = state.scheduleGroups.indexWhere(
          (group) => group.date.startOfWeek == date.startOfWeek,
        );
      }

      if (index == -1) {
        index = state.scheduleGroups.indexWhere(
          (group) => group.date.startOfMonth == date.startOfMonth,
        );
      }

      (_state as ScheduleViewState).itemScrollController.scrollTo(
            index: index,
            duration: duration ?? const Duration(milliseconds: 500),
            curve: curve ?? Curves.easeInOut,
          );
      notifyListeners();
    }
  }

  /// Changes the [heightPerMinute] of the view. (Zoom level)
  /// * This is only available for [SingleDayView] and [MultiDayViewOLD].
  ///
  /// The [heightPerMinute] must be greater than 0.
  void adjustHeightPerMinute(double heightPerMinute) {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a view.',
    );
    if (_state == null) return;
    assert(
      _state is MultiDayViewState,
      'The $_state must be a $MultiDayViewState.',
    );
    if (_state is! MultiDayViewState) return;
    assert(
      heightPerMinute > 0,
      'The heightPerMinute must be greater than 0',
    );
    if (heightPerMinute <= 0) return;

    (_state as MultiDayViewState).heightPerMinute?.value = heightPerMinute;
    notifyListeners();
  }

  /// Animates to the [CalendarEvent].
  Future<void> animateToEvent(
    CalendarEvent<T> event, {
    Duration? duration,
    Curve? curve,
  }) async {
    // First animate to the date of the event.
    await animateToDate(
      event.dateTimeRange.start,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.ease,
    );

    if (_state is MultiDayViewState) {
      (_state as MultiDayViewState).scrollController.animateTo(
            event.start.difference(event.start.startOfDay).inMinutes *
                heightPerMinute!.value,
            duration: duration ?? const Duration(milliseconds: 300),
            curve: curve ?? Curves.ease,
          );
      notifyListeners();
    }
  }

  /// Locks the vertical scroll of the current view.
  void lockScrollPhysics() {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a view.',
    );
    if (_state == null) return;
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
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a view.',
    );
    if (_state == null) return;
    assert(
      _state is MultiDayViewState,
      'The $_state must be a $MultiDayViewState.',
    );
    if (_state is! MultiDayViewState) return;
    (_state as MultiDayViewState).scrollPhysics.value =
        scrollPhysics ?? const ScrollPhysics();
    notifyListeners();
  }
}
