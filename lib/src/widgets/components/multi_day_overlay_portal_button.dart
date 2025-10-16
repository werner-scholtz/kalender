import 'package:flutter/material.dart';

/// The builder used to create the button for the [MultiDayPortalOverlayButton].
///
/// [portalController] is the controller for the overlay portal.
/// [numberOfHiddenRows] is the number of events that are not displayed because of constraints.
/// [style] is the style of the button.
typedef MultiDayPortalOverlayButtonBuilder = Widget Function({
  required OverlayPortalController portalController,
  required int numberOfHiddenRows,
  required MultiDayPortalOverlayButtonStyle? style,
});

class MultiDayPortalOverlayButtonStyle {
  /// The text style of the button.
  final TextStyle? textStyle;

  /// The padding of the text.
  final EdgeInsetsGeometry? textPadding;

  /// The text overflow behavior.
  final TextOverflow? textOverflow;

  /// A function that builds a string based on the number of hidden rows.
  final String Function(int numberOfHiddenRows)? stringBuilder;

  const MultiDayPortalOverlayButtonStyle({this.textStyle, this.textPadding, this.stringBuilder, this.textOverflow});
}

class MultiDayPortalOverlayButton extends StatelessWidget {
  /// The [ValueKey] used to identify text displayed in the button.
  static const textKey = ValueKey('multi_day_portal_overlay_button_text');

  final MultiDayPortalOverlayButtonStyle? style;
  final OverlayPortalController portalController;
  final int numberOfHiddenRows;

  const MultiDayPortalOverlayButton({
    super.key,
    required this.portalController,
    required this.numberOfHiddenRows,
    required this.style,
  });

  /// Returns a [Key] for the button based on the date.
  static Key getKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_portal_overlay_button_${date.millisecondsSinceEpoch}');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: portalController.show,
      child: Padding(
        padding: style?.textPadding ?? const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          style?.stringBuilder?.call(numberOfHiddenRows) ?? '$numberOfHiddenRows more',
          style: style?.textStyle ?? Theme.of(context).textTheme.bodyMedium,
          overflow: style?.textOverflow ?? TextOverflow.ellipsis,
          key: textKey,
        ),
      ),
    );
  }
}
