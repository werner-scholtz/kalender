import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalender/src/models/components/string_builders.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/theme/kalender_theme.dart';

/// The builder used to create the button for the [MultiDayPortalOverlayButton].
///
/// [portalController] is the controller for the overlay portal.
/// [numberOfHiddenRows] is the number of events that are not displayed because of constraints.
/// [style] is the style of the button.
typedef MultiDayPortalOverlayButtonBuilder = Widget Function(
  OverlayPortalController portalController,
  int numberOfHiddenRows,
  MultiDayPortalOverlayButtonStyle? style,
);

class MultiDayPortalOverlayButtonStyle {
  /// The text style of the button.
  final TextStyle? textStyle;

  /// The padding of the text.
  final EdgeInsetsGeometry? textPadding;

  /// The text overflow behavior.
  final TextOverflow? textOverflow;

  /// A function that builds a string based on the number of hidden rows.
  @Deprecated(
    'Moved to OverlayBuilders.multiDayPortalOverlayButtonStringBuilder, which also receives a BuildContext. '
    'Will be removed in 0.24.0.',
  )
  final String Function(int numberOfHiddenRows)? stringBuilder;

  const MultiDayPortalOverlayButtonStyle({this.textStyle, this.textPadding, this.stringBuilder, this.textOverflow});

  /// Creates a copy of this style with the given fields replaced with the new values.
  MultiDayPortalOverlayButtonStyle copyWith({
    TextStyle? textStyle,
    EdgeInsetsGeometry? textPadding,
    TextOverflow? textOverflow,
    String Function(int numberOfHiddenRows)? stringBuilder,
  }) {
    return MultiDayPortalOverlayButtonStyle(
      textStyle: textStyle ?? this.textStyle,
      textPadding: textPadding ?? this.textPadding,
      textOverflow: textOverflow ?? this.textOverflow,
      stringBuilder: stringBuilder ?? this.stringBuilder,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  MultiDayPortalOverlayButtonStyle merge(MultiDayPortalOverlayButtonStyle? other) {
    if (other == null) return this;
    return MultiDayPortalOverlayButtonStyle(
      textStyle: other.textStyle ?? textStyle,
      textPadding: other.textPadding ?? textPadding,
      textOverflow: other.textOverflow ?? textOverflow,
      stringBuilder: other.stringBuilder ?? stringBuilder,
    );
  }

  /// Linearly interpolates between [a] and [b]. Fields that cannot be interpolated switch at the midpoint.
  static MultiDayPortalOverlayButtonStyle? lerp(
    MultiDayPortalOverlayButtonStyle? a,
    MultiDayPortalOverlayButtonStyle? b,
    double t,
  ) {
    if (identical(a, b)) return a;
    return MultiDayPortalOverlayButtonStyle(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      textPadding: EdgeInsetsGeometry.lerp(a?.textPadding, b?.textPadding, t),
      textOverflow: t < 0.5 ? a?.textOverflow : b?.textOverflow,
      stringBuilder: t < 0.5 ? a?.stringBuilder : b?.stringBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayPortalOverlayButtonStyle &&
        other.textStyle == textStyle &&
        other.textPadding == textPadding &&
        other.textOverflow == textOverflow &&
        other.stringBuilder == stringBuilder;
  }

  @override
  int get hashCode => Object.hash(textStyle, textPadding, textOverflow, stringBuilder);
}

class MultiDayPortalOverlayButton extends StatelessWidget {
  /// The [ValueKey] used to identify text displayed in the button.
  static const textKey = ValueKey('multi_day_portal_overlay_button_text');

  final MultiDayPortalOverlayButtonStyle? style;
  final OverlayPortalController portalController;
  final int numberOfHiddenRows;

  /// Builds the button's label. Resolved from the [OverlayBuilders] that apply
  /// to this view, so it follows the same precedence as [style].
  final HiddenEventCountStringBuilder? stringBuilder;

  const MultiDayPortalOverlayButton({
    super.key,
    required this.portalController,
    required this.numberOfHiddenRows,
    required this.style,
    this.stringBuilder,
  });

  /// The default label: a plus sign and the count, with the number formatted for
  /// the calendar's locale so locales with their own numerals read correctly.
  static String defaultLabel(BuildContext context, int numberOfHiddenRows) {
    return '+${NumberFormat.decimalPattern(context.locale).format(numberOfHiddenRows)}';
  }

  /// Returns a [Key] for the button based on the date.
  static Key getKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_portal_overlay_button_${date.millisecondsSinceEpoch}');
  }

  @override
  Widget build(BuildContext context) {
    final style =
        (KalenderTheme.of(context).multiDayPortalOverlayButtonStyle ?? const MultiDayPortalOverlayButtonStyle())
            .merge(this.style);
    return InkWell(
      onTap: portalController.show,
      child: Padding(
        padding: style.textPadding ?? const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          stringBuilder?.call(context, numberOfHiddenRows) ??
              style.stringBuilder?.call(numberOfHiddenRows) ??
              defaultLabel(context, numberOfHiddenRows),
          style: style.textStyle,
          overflow: style.textOverflow,
          key: textKey,
        ),
      ),
    );
  }
}
