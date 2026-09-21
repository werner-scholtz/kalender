// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

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
      ErrorHint('intl compiles in en_US only, so every other locale needs this call, including "en".'),
    ]);
  }
}

/// Useful extensions for working with [DateTime] objects.
///
/// The localized names require intl's locale data. See [DateTimeExtensions.dayNameLocalized].
///
/// ```dart
/// final date = DateTime(2024, 1, 15); // Monday
/// date.dayNameLocalized(const Locale('fr')); // "lundi"
/// ```
///
/// {@category Dates and times}
extension DateTimeExtensions on DateTime {
  /// Gets the day name in a specific locale.
  ///
  /// Requires `initializeDateFormatting()` from `package:intl/date_symbol_data_local.dart` to have been awaited,
  /// unless [locale] is null or `en_US`. Throws a [FlutterError] naming the missing call otherwise.
  String dayNameLocalized([Locale? locale]) =>
      _formatLocalized(() => DateFormat.EEEE(locale?.toLanguageTag()), this, locale);

  /// Gets the abbreviated day name in a specific locale.
  String dayNameShortLocalized([Locale? locale]) =>
      _formatLocalized(() => DateFormat.E(locale?.toLanguageTag()), this, locale);

  /// Gets the month name in a specific locale.
  String monthNameLocalized([Locale? locale]) =>
      _formatLocalized(() => DateFormat.MMMM(locale?.toLanguageTag()), this, locale);

  /// Gets the abbreviated month name in a specific locale.
  String monthNameShortLocalized([Locale? locale]) =>
      _formatLocalized(() => DateFormat.MMM(locale?.toLanguageTag()), this, locale);

  /// Gets the time of day in a specific locale.
  ///
  /// [use24HourFormat] forces `HH:mm`. Otherwise the locale decides, which is
  /// what intl resolves for `jm`.
  String timeLocalized({Locale? locale, bool use24HourFormat = false}) {
    final tag = locale?.toLanguageTag();
    return _formatLocalized(() => use24HourFormat ? DateFormat.Hm(tag) : DateFormat.jm(tag), this, locale);
  }
}
