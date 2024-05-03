import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// The base class for the viewStates.
abstract class ViewState {
  ViewState({
    required ValueNotifier<DateTimeRange> visibleDateTimeRange,
  }) : visibleDateTimeRangeNotifier = visibleDateTimeRange;

  ViewConfiguration get viewConfiguration;

  final ValueNotifier<DateTimeRange> visibleDateTimeRangeNotifier;
  DateTimeRange get visibleDateTimeRange => visibleDateTimeRangeNotifier.value;
  set visibleDateTimeRange(DateTimeRange value);

  final ValueNotifier<TimeOfDay?> visibleStartTimeOfDayNotifier =
      ValueNotifier(null);
  TimeOfDay? get visibleStartTimeOfDay => visibleStartTimeOfDayNotifier.value;
  set visibleStartTimeOfDay(TimeOfDay? value) {}

  /// The visible month notifier of the current page.
  late DateTime visibleMonth =
      visibleDateTimeRangeNotifier.value.centerDateTime;

  /// The adjusted dateTimeRange of the current view.
  DateTimeRange get adjustedDateTimeRange;

  /// Jump to the given [DateTime].
  void jumpToPage(int page);

  /// Jump to the given [DateTime].
  void jumpToDate(DateTime date);

  /// Adjust the height per minute of the current view.
  void adjustHeightPerMinute(double heightPerMinute);

  /// Animate to the next page.
  Future<void> animateToNextPage({
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the previous page.
  Future<void> animateToPreviousPage({
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the given [DateTime].
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the given [DateTime].
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  });

  /// Animate to the given [CalendarEvent].
  Future<void> animateToEvent(
    CalendarEvent event, {
    Duration? duration,
    Curve? curve,
    bool centerEvent = true,
  });

  @override
  operator ==(Object other);

  @override
  int get hashCode;
}
