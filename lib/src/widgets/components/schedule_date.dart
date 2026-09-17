// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/theme/kalender_theme.dart';
import 'package:kalender/src/widgets/internal_components/day_number.dart';

/// The schedule date builder.
///
/// Resolve the style with [KalenderTheme].
///
/// {@category Appearance}
typedef ScheduleDateBuilder = Widget Function(BuildContext context, FloatingDateTime date);

/// The style of the [ScheduleDate].
///
/// {@category Appearance}
class ScheduleDateStyle with Diagnosticable {
  const ScheduleDateStyle({this.textStyle, this.numberTextStyle});

  /// The [TextStyle] used by the [ScheduleDate] widget to display the name of the day.
  final TextStyle? textStyle;

  /// The [TextStyle] used by the [ScheduleDate] widget to display the day number of the week.
  final TextStyle? numberTextStyle;

  /// Creates a copy of this style with the given fields replaced with the new values.
  ScheduleDateStyle copyWith({TextStyle? textStyle, TextStyle? numberTextStyle}) {
    return ScheduleDateStyle(
      textStyle: textStyle ?? this.textStyle,
      numberTextStyle: numberTextStyle ?? this.numberTextStyle,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  ScheduleDateStyle merge(ScheduleDateStyle? other) {
    if (other == null) return this;
    return ScheduleDateStyle(
      textStyle: other.textStyle ?? textStyle,
      numberTextStyle: other.numberTextStyle ?? numberTextStyle,
    );
  }

  /// Linearly interpolates between [a] and [b]. Fields that cannot be interpolated switch at the midpoint.
  static ScheduleDateStyle? lerp(ScheduleDateStyle? a, ScheduleDateStyle? b, double t) {
    if (identical(a, b)) return a;
    return ScheduleDateStyle(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      numberTextStyle: TextStyle.lerp(a?.numberTextStyle, b?.numberTextStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleDateStyle && other.textStyle == textStyle && other.numberTextStyle == numberTextStyle;
  }

  @override
  int get hashCode => Object.hash(textStyle, numberTextStyle);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('numberTextStyle', numberTextStyle, defaultValue: null));
  }
}

/// A widget that displays the name of the day and the day number of the week.
///
/// {@category Appearance}
class ScheduleDate extends StatelessWidget {
  /// Key applied to the `IconButton` when the date is today.
  static const todayKey = ValueKey('ScheduleDate.today');

  final FloatingDateTime date;
  final ScheduleDateStyle? style;

  const ScheduleDate({super.key, required this.date, this.style});

  @override
  Widget build(BuildContext context) {
    final style = (KalenderTheme.of(context).scheduleDateStyle ?? const ScheduleDateStyle()).merge(this.style);
    final stringBuilder = context.components.scheduleComponents.leadingDateStringBuilder;
    final displayDate = date.forLocation(location: context.location);
    final text = Text(
      stringBuilder?.call(context, displayDate) ?? date.dayNameShortLocalized(context.locale),
      style: style.textStyle,
    );

    final button = DayNumber(
      date: date,
      text: date.day.toString(),
      textStyle: style.numberTextStyle,
      isToday: context.isToday(date),
      todayKey: todayKey,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(mainAxisSize: MainAxisSize.min, children: [text, button]),
    );
  }
}
