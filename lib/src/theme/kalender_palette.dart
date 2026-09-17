// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

/// The colors and text styles the default theme is built from.
@immutable
class KalenderPalette {
  /// Hour lines, day separators, the month grid and the tooltip background.
  final Color surface;

  /// The schedule's highlight.
  final Color accent;

  /// The time indicator.
  final Color error;

  /// The today highlight behind a day number.
  final Color highlight;

  /// The day number inside the today highlight.
  final Color onHighlight;

  /// Day names, weekday headers and the schedule's dates.
  final TextStyle? small;

  /// Day numbers, week numbers and the overlay's text.
  final TextStyle? medium;

  /// The timeline's hour labels.
  final TextStyle? label;

  const KalenderPalette({
    required this.surface,
    required this.accent,
    required this.error,
    required this.highlight,
    required this.onHighlight,
    this.small,
    this.medium,
    this.label,
  });

  /// The palette for [theme].
  factory KalenderPalette.fromTheme(ThemeData theme) {
    return KalenderPalette(
      surface: theme.colorScheme.surfaceContainerHighest,
      accent: theme.colorScheme.primary,
      error: theme.colorScheme.error,
      highlight: theme.colorScheme.secondaryContainer,
      onHighlight: theme.colorScheme.onSecondaryContainer,
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
        other.highlight == highlight &&
        other.onHighlight == onHighlight &&
        other.small == small &&
        other.medium == medium &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(surface, accent, error, highlight, onHighlight, small, medium, label);
}
