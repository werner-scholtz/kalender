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
}
