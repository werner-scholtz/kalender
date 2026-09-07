import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/kalender_time.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// Builds the text displayed for [date].
///
/// The [date] is a wall-clock [DateTime] in the calendar's configured location.
/// Read the calendar's locale from the [context] with
/// [KalenderLocale.kalenderLocale].
typedef DateStringBuilder = String Function(BuildContext context, DateTime date);

/// Builds the text displayed for [time].
///
/// Read the calendar's locale from the [context] with
/// [KalenderLocale.kalenderLocale].
typedef KalenderTimeStringBuilder = String Function(BuildContext context, KalenderTime time);

/// Builds the text displayed on the overlay button that opens the hidden events.
///
/// Read the calendar's locale from the [context] with
/// [KalenderLocale.kalenderLocale].
typedef HiddenEventCountStringBuilder = String Function(BuildContext context, int numberOfHiddenEvents);

/// Gives a string builder access to the locale of the calendar it is building for.
extension KalenderLocale on BuildContext {
  /// The locale of the enclosing calendar, as passed to `KalenderView.locale`.
  ///
  /// This is the locale the calendar formats its own dates and times with, which
  /// is not necessarily the app's locale. Pass it to `intl`'s `DateFormat` or
  /// `NumberFormat`, or to the localized extensions on [DateTime].
  Locale? get kalenderLocale => LocaleProvider.of(this);

  /// The locale of the enclosing calendar.
  @Deprecated('Renamed to kalenderLocale. Will be removed in 0.31.0.')
  Locale? get calendarLocale => kalenderLocale;
}
