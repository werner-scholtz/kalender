// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/models/floating_date_time.dart';
import 'package:kalender/src/models/floating_date_time_range.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/theme/kalender_theme.dart';

/// The [DayNumberStyle] class is used by the [DayNumber] widget.
///
/// A day that is both today and selected takes its colors from the selected values and its border from the today
/// values, each falling back to the other when null.
///
/// {@category Appearance}
class DayNumberStyle with Diagnosticable {
  const DayNumberStyle({
    this.todayBackgroundColor,
    this.todayForegroundColor,
    this.todayBorder,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.selectedBorder,
  });

  /// The color behind the day number when it is today.
  final Color? todayBackgroundColor;

  /// The color of the day number when it is today.
  final Color? todayForegroundColor;

  /// The border around the day number when it is today.
  final BorderSide? todayBorder;

  /// The color behind the day number when it is selected.
  final Color? selectedBackgroundColor;

  /// The color of the day number when it is selected.
  final Color? selectedForegroundColor;

  /// The border around the day number when it is selected.
  final BorderSide? selectedBorder;

  /// Creates a copy of this style with the given fields replaced with the new values.
  DayNumberStyle copyWith({
    Color? todayBackgroundColor,
    Color? todayForegroundColor,
    BorderSide? todayBorder,
    Color? selectedBackgroundColor,
    Color? selectedForegroundColor,
    BorderSide? selectedBorder,
  }) {
    return DayNumberStyle(
      todayBackgroundColor: todayBackgroundColor ?? this.todayBackgroundColor,
      todayForegroundColor: todayForegroundColor ?? this.todayForegroundColor,
      todayBorder: todayBorder ?? this.todayBorder,
      selectedBackgroundColor: selectedBackgroundColor ?? this.selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor ?? this.selectedForegroundColor,
      selectedBorder: selectedBorder ?? this.selectedBorder,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  DayNumberStyle merge(DayNumberStyle? other) {
    if (other == null) return this;
    return DayNumberStyle(
      todayBackgroundColor: other.todayBackgroundColor ?? todayBackgroundColor,
      todayForegroundColor: other.todayForegroundColor ?? todayForegroundColor,
      todayBorder: other.todayBorder ?? todayBorder,
      selectedBackgroundColor: other.selectedBackgroundColor ?? selectedBackgroundColor,
      selectedForegroundColor: other.selectedForegroundColor ?? selectedForegroundColor,
      selectedBorder: other.selectedBorder ?? selectedBorder,
    );
  }

  /// Linearly interpolates between [a] and [b].
  static DayNumberStyle? lerp(DayNumberStyle? a, DayNumberStyle? b, double t) {
    if (identical(a, b)) return a;
    return DayNumberStyle(
      todayBackgroundColor: Color.lerp(a?.todayBackgroundColor, b?.todayBackgroundColor, t),
      todayForegroundColor: Color.lerp(a?.todayForegroundColor, b?.todayForegroundColor, t),
      todayBorder: _lerpSide(a?.todayBorder, b?.todayBorder, t),
      selectedBackgroundColor: Color.lerp(a?.selectedBackgroundColor, b?.selectedBackgroundColor, t),
      selectedForegroundColor: Color.lerp(a?.selectedForegroundColor, b?.selectedForegroundColor, t),
      selectedBorder: _lerpSide(a?.selectedBorder, b?.selectedBorder, t),
    );
  }

  static BorderSide? _lerpSide(BorderSide? a, BorderSide? b, double t) {
    if (a == null && b == null) return null;
    return BorderSide.lerp(
      a ?? BorderSide(width: 0, color: b!.color.withAlpha(0)),
      b ?? BorderSide(width: 0, color: a!.color.withAlpha(0)),
      t,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DayNumberStyle &&
        other.todayBackgroundColor == todayBackgroundColor &&
        other.todayForegroundColor == todayForegroundColor &&
        other.todayBorder == todayBorder &&
        other.selectedBackgroundColor == selectedBackgroundColor &&
        other.selectedForegroundColor == selectedForegroundColor &&
        other.selectedBorder == selectedBorder;
  }

  @override
  int get hashCode => Object.hash(
    todayBackgroundColor,
    todayForegroundColor,
    todayBorder,
    selectedBackgroundColor,
    selectedForegroundColor,
    selectedBorder,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('todayBackgroundColor', todayBackgroundColor, defaultValue: null));
    properties.add(ColorProperty('todayForegroundColor', todayForegroundColor, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderSide>('todayBorder', todayBorder, defaultValue: null));
    properties.add(ColorProperty('selectedBackgroundColor', selectedBackgroundColor, defaultValue: null));
    properties.add(ColorProperty('selectedForegroundColor', selectedForegroundColor, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderSide>('selectedBorder', selectedBorder, defaultValue: null));
  }
}

/// The day number shown by the date components, highlighted when it is today or selected.
///
/// Shared by every widget that shows a day number, so the highlights look the same everywhere: the day header, the
/// month day header, the schedule date, and the multi-day overlay.
///
/// It is never interactive. It is a label that happens to be drawn like a button, so `onPressed` is always null and
/// the highlight has to set the disabled colors.
class DayNumber extends StatefulWidget {
  const DayNumber({
    super.key,
    required this.date,
    required this.text,
    this.textStyle,
    required this.isToday,
    required this.todayKey,
    this.size,
  });

  /// The day this number shows, checked against the controller's selected range.
  final FloatingDateTime date;

  /// The day number itself.
  final String text;

  /// The style of [text]. Its color is replaced by the foreground color while highlighted.
  final TextStyle? textStyle;

  /// Whether [date] is today, and so should be highlighted.
  final bool isToday;

  /// The key applied when [isToday]. Each component passes its own, so tests
  /// and consumers can find that component's highlight.
  final Key todayKey;

  /// The size of the button. When null it keeps its natural size.
  final Size? size;

  @override
  State<DayNumber> createState() => _DayNumberState();
}

class _DayNumberState extends State<DayNumber> {
  ValueNotifier<FloatingDateTimeRange?>? _selection;
  var _isSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selection = context.kalenderController.selectedRange;
    if (selection == _selection) return;
    _selection?.removeListener(_onSelectionChanged);
    _selection = selection..addListener(_onSelectionChanged);
    _isSelected = _computeIsSelected();
  }

  @override
  void didUpdateWidget(DayNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) _isSelected = _computeIsSelected();
  }

  @override
  void dispose() {
    _selection?.removeListener(_onSelectionChanged);
    super.dispose();
  }

  bool _computeIsSelected() {
    final range = _selection?.value;
    return range != null && widget.date.isWithin(range);
  }

  // Rebuilds only when this day's state flips, not on every selection change.
  void _onSelectionChanged() {
    final isSelected = _computeIsSelected();
    if (isSelected != _isSelected) setState(() => _isSelected = isSelected);
  }

  @override
  Widget build(BuildContext context) {
    final constraints = widget.size == null ? null : BoxConstraints.tight(widget.size!);
    final padding = widget.size == null ? null : EdgeInsets.zero;
    final isToday = widget.isToday;

    if (!isToday && !_isSelected) {
      return IconButton(
        onPressed: null,
        icon: Text(widget.text, style: widget.textStyle),
        visualDensity: VisualDensity.compact,
        padding: padding,
        constraints: constraints,
      );
    }

    final style = KalenderTheme.of(context).dayNumberStyle ?? const DayNumberStyle();
    T? pick<T>(T? selected, T? today) => (_isSelected ? selected : null) ?? (isToday ? today : null);
    final border = (isToday ? style.todayBorder : null) ?? (_isSelected ? style.selectedBorder : null);
    final foreground = pick(style.selectedForegroundColor, style.todayForegroundColor);
    final number = Text(widget.text, style: (widget.textStyle ?? const TextStyle()).copyWith(color: foreground));

    // Without the disabled colors the button paints greyed out, which reads as "unavailable".
    final buttonStyle = IconButton.styleFrom(
      disabledBackgroundColor: pick(style.selectedBackgroundColor, style.todayBackgroundColor),
      disabledForegroundColor: foreground,
      side: border,
    );

    if (!isToday) {
      return IconButton(
        onPressed: null,
        icon: number,
        visualDensity: VisualDensity.compact,
        padding: padding,
        constraints: constraints,
        style: buttonStyle,
      );
    }

    return IconButton.filledTonal(
      key: widget.todayKey,
      onPressed: null,
      icon: number,
      visualDensity: VisualDensity.compact,
      padding: padding,
      constraints: constraints,
      style: buttonStyle,
    );
  }
}
