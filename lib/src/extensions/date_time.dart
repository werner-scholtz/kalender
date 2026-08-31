import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Formats [date] and replaces intl's uninitialized locale data error with one that names the setup step and the
/// library it comes from.
///
/// The format is built inside the guard because intl resolves its locale data lazily, so either the construction or
/// the format call can fail.
String _formatLocalized(DateFormat Function() format, DateTime date, Locale? locale) {
  try {
    return format().format(date);
  } catch (error) {
    if (!error.toString().contains('Locale data has not been initialized')) rethrow;
    throw FlutterError.fromParts([
      ErrorSummary('Locale data for ${locale == null ? 'the default locale' : '"$locale"'} has not been loaded.'),
      ErrorDescription(
        'kalender formats day and month names with the intl package, which needs its locale data loaded first.',
      ),
      ErrorHint(
        'Call initializeDateFormatting() before runApp:\n'
        "  import 'package:intl/date_symbol_data_local.dart';\n"
        '\n'
        '  void main() async {\n'
        '    await initializeDateFormatting();\n'
        '    runApp(const MyApp());\n'
        '  }',
      ),
      ErrorHint(
        'intl compiles in en_US only, so every other locale needs this call, including "en".',
      ),
    ]);
  }
}

/// Useful extensions for working with [DateTime] objects.
///
/// The localized names require intl's locale data. See [DateTimeExtensions.dayNameLocalized].
extension DateTimeExtensions on DateTime {
  /// Gets the day name in a specific locale.
  ///
  /// The [locale] parameter allows you to specify the desired locale.
  /// If not provided, it uses the system locale.
  ///
  /// Requires `initializeDateFormatting()` from `package:intl/date_symbol_data_local.dart` to have been awaited,
  /// unless [locale] is null or `en_US`. Throws a [FlutterError] naming the missing call otherwise.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // Monday
  /// print(date.dayNameLocalized(const Locale('en'))); // Output: "Monday"
  /// print(date.dayNameLocalized(const Locale('fr'))); // Output: "lundi"
  /// print(date.dayNameLocalized(const Locale('es'))); // Output: "lunes"
  /// ```
  String dayNameLocalized([Locale? locale]) =>
      _formatLocalized(() => DateFormat.EEEE(locale?.toLanguageTag()), this, locale);

  /// Gets the abbreviated day name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // Monday
  /// print(date.dayNameShortLocalized(const Locale('en'))); // Output: "Mon"
  /// print(date.dayNameShortLocalized(const Locale('fr'))); // Output: "lun"
  /// ```
  String dayNameShortLocalized([Locale? locale]) =>
      _formatLocalized(() => DateFormat.E(locale?.toLanguageTag()), this, locale);

  /// Gets the month name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // January
  /// print(date.monthNameLocalized(const Locale('en'))); // Output: "January"
  /// print(date.monthNameLocalized(const Locale('fr'))); // Output: "janvier"
  /// print(date.monthNameLocalized(const Locale('es'))); // Output: "enero"
  /// ```
  String monthNameLocalized([Locale? locale]) =>
      _formatLocalized(() => DateFormat.MMMM(locale?.toLanguageTag()), this, locale);

  /// Gets the abbreviated month name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // January
  /// print(date.monthNameShortLocalized(const Locale('en'))); // Output: "Jan"
  /// print(date.monthNameShortLocalized(const Locale('fr'))); // Output: "janv."
  /// ```
  String monthNameShortLocalized([Locale? locale]) =>
      _formatLocalized(() => DateFormat.MMM(locale?.toLanguageTag()), this, locale);
}
