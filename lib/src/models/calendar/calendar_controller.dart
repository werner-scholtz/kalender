import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/views/calendar_view.dart';

class CalendarController {
  CalendarController({
    DateTime? initialDate,
    DateTimeRange? calendarDateTimeRange,
  })  : selectedDate = initialDate ?? DateTime.now(),
        _dateTimeRange = calendarDateTimeRange ?? defaultDateRange;

  /// The currently selected date.
  DateTime selectedDate;

  /// The dateTimeRange that the calendar can display.
  DateTimeRange _dateTimeRange;
  DateTimeRange get dateTimeRange => _dateTimeRange;

  CalendarViewState? _state;

  /// Attaches the [CalendarController] to a [CalendarView].
  void attach(CalendarViewState controllerState) {
    assert(
      _state == null,
      "The controller cannot be attached to multiple $CalendarView's",
    );
    _state = controllerState;
  }

  void detach() {
    _state = null;
  }

  /// Animates to the next page.
  void animateToNextPage({
    Duration? duration,
    Curve? curve,
  }) {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a $CalendarView.',
    );
    _state?.pageController.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  /// Animates to the previous page.
  void animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  }) {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a $CalendarView.',
    );
    _state?.pageController.previousPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  /// Jumps to the [page].
  void jumpToPage(int page) {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a $CalendarView.',
    );
    _state?.pageController.jumpToPage(page);
  }

  /// Jumps to the [date] of the [CalendarView].
  void jumpToDate(DateTime date) {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a $CalendarView.',
    );
    if (_state == null) return;

    assert(
      !date.isWithin(_state!.adjustedDateTimeRange),
      'The date must be within the dateTimeRange of the Calendar.',
    );
    if (!date.isWithin(_state!.adjustedDateTimeRange)) return;

    _state!.pageController.jumpToPage(
      _state!.viewConfiguration.calculateDateIndex(
        date,
        _state!.adjustedDateTimeRange.start,
      ),
    );
  }

  /// Animates to the [DateTime] provided.
  Future<void> animateToDate(
    DateTime date, {
    required Duration duration,
    required Curve curve,
  }) async {
    assert(
      _state != null,
      'The $_state must not be null.'
      'Please attach the $CalendarController to a $CalendarView.',
    );
    if (_state == null) return;

    assert(
      !date.isWithin(_state!.adjustedDateTimeRange),
      'The date must be within the dateTimeRange of the Calendar.',
    );
    if (!date.isWithin(_state!.adjustedDateTimeRange)) return;

    await _state!.pageController.animateToPage(
      _state!.viewConfiguration.calculateDateIndex(
        date,
        _state!.adjustedDateTimeRange.start,
      ),
      duration: duration,
      curve: curve,
    );
  }
}

/// The state of the [CalendarController].
///
/// This is used to store state related to the [CalendarView].
class CalendarViewState {
  CalendarViewState({
    required this.viewConfiguration,
    required this.pageController,
    required this.scrollController,
    required this.numberOfPages,
    required this.adjustedDateTimeRange,
    required this.visibleDateTimeRange,
    this.heightPerMinute,
  });

  /// The current viewConfiguration of the [CalendarView].
  final ViewConfiguration viewConfiguration;

  /// The pageController of the [CalendarView].
  final PageController pageController;

  /// The scrollController of the [CalendarView].
  final ScrollController scrollController;

  /// The height per minute of the [CalendarView].
  final ValueNotifier<double>? heightPerMinute;

  /// The visible dateTimeRange of the [CalendarView].
  final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  /// The adjusted dateTimeRange of the [CalendarView].
  final DateTimeRange adjustedDateTimeRange;

  /// The number of pages the [PageView] of the [CalendarView] has.
  final int numberOfPages;
}
