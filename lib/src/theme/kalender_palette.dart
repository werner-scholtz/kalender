import 'package:flutter/material.dart';

/// The values the calendar's default look is built from.
///
/// Six, which is everything `KalenderThemeData.defaults` reads from a theme.
/// Holding them behind one type means the defaults themselves name no Material,
/// so pointing them at another design system is a change to `fromTheme` rather
/// than to each of the fourteen style classes.
@immutable
class KalenderPalette {
  /// Hour lines, day separators, the month grid and the tooltip background.
  final Color surface;

  /// The schedule's highlight.
  final Color accent;

  /// The time indicator.
  final Color error;

  /// Day names, weekday headers and the schedule's dates.
  final TextStyle? small;

  /// Day numbers, week numbers and the overlay's text.
  final TextStyle? medium;

  /// The timeline's hour labels.
  final TextStyle? label;

  /// Creates a [KalenderPalette].
  const KalenderPalette({
    required this.surface,
    required this.accent,
    required this.error,
    this.small,
    this.medium,
    this.label,
  });

  /// Maps a Material [ThemeData] onto the six.
  ///
  /// The only place the defaults touch Material. A core that does not depend on
  /// it moves this one factory and leaves every style where it is.
  factory KalenderPalette.fromTheme(ThemeData theme) {
    return KalenderPalette(
      surface: theme.colorScheme.surfaceContainerHighest,
      accent: theme.colorScheme.primary,
      error: theme.colorScheme.error,
      small: theme.textTheme.bodySmall,
      medium: theme.textTheme.bodyMedium,
      label: theme.textTheme.labelMedium,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KalenderPalette &&
        other.surface == surface &&
        other.accent == accent &&
        other.error == error &&
        other.small == small &&
        other.medium == medium &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(surface, accent, error, small, medium, label);
}
