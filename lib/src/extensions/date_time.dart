import 'package:intl/intl.dart';

/// Useful extensions for working with [DateTime] objects.
extension DateTimeExtensions on DateTime {
  /// Gets the day name in a specific locale.
  ///
  /// The [locale] parameter allows you to specify the desired locale.
  /// If not provided, it uses the system locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // Monday
  /// print(date.dayNameLocalized('en')); // Output: "Monday"
  /// print(date.dayNameLocalized('fr')); // Output: "lundi"
  /// print(date.dayNameLocalized('es')); // Output: "lunes"
  /// ```
  String dayNameLocalized([dynamic locale]) => DateFormat.EEEE(locale).format(this);

  /// Gets the abbreviated day name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // Monday
  /// print(date.dayNameShortLocalized('en')); // Output: "Mon"
  /// print(date.dayNameShortLocalized('fr')); // Output: "lun"
  /// ```
  String dayNameShortLocalized([dynamic locale]) => DateFormat.E(locale).format(this);

  /// Gets the month name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // January
  /// print(date.monthNameLocalized('en')); // Output: "January"
  /// print(date.monthNameLocalized('fr')); // Output: "janvier"
  /// print(date.monthNameLocalized('es')); // Output: "enero"
  /// ```
  String monthNameLocalized([dynamic locale]) => DateFormat.MMMM(locale).format(this);

  /// Gets the abbreviated month name in a specific locale.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // January
  /// print(date.monthNameShortLocalized('en')); // Output: "Jan"
  /// print(date.monthNameShortLocalized('fr')); // Output: "janv."
  /// ```
  String monthNameShortLocalized([dynamic locale]) => DateFormat.MMM(locale).format(this);

  /// Gets the month name in English (backwards compatibility).
  ///
  /// This method is kept for backwards compatibility but it's recommended
  /// to use [monthName] or [monthNameLocalized] for better internationalization.
  @Deprecated('Use monthName or monthNameLocalized or monthNameShortLocalized instead.')
  String get monthNameEnglish => switch (month) {
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'May',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December',
        _ => throw Exception('Invalid month'),
      };

  /// Gets the day name in English (backwards compatibility).
  ///
  /// This method is kept for backwards compatibility but it's recommended
  /// to use [dayName] or [dayNameLocalized] for better internationalization.
  @Deprecated('Use dayName or dayNameLocalized or dayNameShortLocalized instead.')
  String get dayNameEnglish => switch (weekday) {
        1 => 'Monday',
        2 => 'Tuesday',
        3 => 'Wednesday',
        4 => 'Thursday',
        5 => 'Friday',
        6 => 'Saturday',
        7 => 'Sunday',
        _ => throw Exception('Invalid weekday'),
      };
}
