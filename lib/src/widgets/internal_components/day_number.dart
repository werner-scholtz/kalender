// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/theme/kalender_theme.dart';

/// The [DayNumberStyle] class is used by the [DayNumber] widget.
///
/// {@category Appearance}
class DayNumberStyle with Diagnosticable {
  const DayNumberStyle({this.todayBackgroundColor, this.todayForegroundColor});

  /// The color behind the day number when it is today.
  final Color? todayBackgroundColor;

  /// The color of the day number when it is today.
  final Color? todayForegroundColor;

  /// Creates a copy of this style with the given fields replaced with the new values.
  DayNumberStyle copyWith({Color? todayBackgroundColor, Color? todayForegroundColor}) {
    return DayNumberStyle(
      todayBackgroundColor: todayBackgroundColor ?? this.todayBackgroundColor,
      todayForegroundColor: todayForegroundColor ?? this.todayForegroundColor,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  DayNumberStyle merge(DayNumberStyle? other) {
    if (other == null) return this;
    return DayNumberStyle(
      todayBackgroundColor: other.todayBackgroundColor ?? todayBackgroundColor,
      todayForegroundColor: other.todayForegroundColor ?? todayForegroundColor,
    );
  }

  /// Linearly interpolates between [a] and [b].
  static DayNumberStyle? lerp(DayNumberStyle? a, DayNumberStyle? b, double t) {
    if (identical(a, b)) return a;
    return DayNumberStyle(
      todayBackgroundColor: Color.lerp(a?.todayBackgroundColor, b?.todayBackgroundColor, t),
      todayForegroundColor: Color.lerp(a?.todayForegroundColor, b?.todayForegroundColor, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DayNumberStyle &&
        other.todayBackgroundColor == todayBackgroundColor &&
        other.todayForegroundColor == todayForegroundColor;
  }

  @override
  int get hashCode => Object.hash(todayBackgroundColor, todayForegroundColor);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('todayBackgroundColor', todayBackgroundColor, defaultValue: null));
    properties.add(ColorProperty('todayForegroundColor', todayForegroundColor, defaultValue: null));
  }
}

/// The day number shown by the date components, highlighted when it is today.
///
/// Shared by every widget that shows a day number, so the today highlight looks
/// the same everywhere: the day header, the month day header, the schedule
/// date, and the multi-day overlay.
///
/// It is never interactive. It is a label that happens to be drawn like a
/// button, so `onPressed` is always null and the highlight has to set the
/// disabled colors to stay tonal.
class DayNumber extends StatelessWidget {
  const DayNumber({
    super.key,
    required this.text,
    this.textStyle,
    required this.isToday,
    required this.todayKey,
    this.size,
  });

  /// The day number itself.
  final String text;

  /// The style of [text]. Its color is replaced by [DayNumberStyle.todayForegroundColor] when [isToday].
  final TextStyle? textStyle;

  /// Whether [text] is today, and so should be highlighted.
  final bool isToday;

  /// The key applied when [isToday]. Each component passes its own, so tests
  /// and consumers can find that component's highlight.
  final Key todayKey;

  /// The size of the button. When null it keeps its natural size.
  final Size? size;

  @override
  Widget build(BuildContext context) {
    final constraints = size == null ? null : BoxConstraints.tight(size!);
    final padding = size == null ? null : EdgeInsets.zero;

    if (!isToday) {
      return IconButton(
        onPressed: null,
        icon: Text(text, style: textStyle),
        visualDensity: VisualDensity.compact,
        padding: padding,
        constraints: constraints,
      );
    }

    final style = KalenderTheme.of(context).dayNumberStyle ?? const DayNumberStyle();
    return IconButton.filledTonal(
      key: todayKey,
      onPressed: null,
      icon: Text(text, style: (textStyle ?? const TextStyle()).copyWith(color: style.todayForegroundColor)),
      visualDensity: VisualDensity.compact,
      padding: padding,
      constraints: constraints,
      // Without this the button paints with the disabled colors, which greys
      // the highlight out and reads as "unavailable" rather than "today".
      style: IconButton.styleFrom(
        disabledBackgroundColor: style.todayBackgroundColor,
        disabledForegroundColor: style.todayForegroundColor,
      ),
    );
  }
}
