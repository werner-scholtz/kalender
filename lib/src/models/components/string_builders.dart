import 'package:flutter/material.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// Builds the text displayed for [date].
///
/// The [date] is a wall-clock [DateTime] in the calendar's configured location.
/// Read the calendar's locale from the [context] with
/// [CalendarLocale.calendarLocale].
typedef DateStringBuilder = String Function(BuildContext context, DateTime date);

/// Builds the text displayed for [time].
///
/// Read the calendar's locale from the [context] with
/// [CalendarLocale.calendarLocale].
typedef TimeOfDayStringBuilder = String Function(BuildContext context, TimeOfDay time);

/// Builds the text displayed on the overlay button that opens the hidden events.
///
/// Read the calendar's locale from the [context] with
/// [CalendarLocale.calendarLocale].
typedef HiddenEventCountStringBuilder = String Function(BuildContext context, int numberOfHiddenEvents);

/// Gives a string builder access to the locale of the calendar it is building for.
extension CalendarLocale on BuildContext {
  /// The locale of the enclosing calendar, as passed to `CalendarView.locale`.
  ///
  /// This is the locale the calendar formats its own dates and times with, which
  /// is not necessarily the app's locale. Pass it to `intl`'s [DateFormat] or
  /// [NumberFormat], or to the localized extensions on [DateTime].
  dynamic get calendarLocale => LocaleProvider.of(this);
}
