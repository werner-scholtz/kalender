import 'package:flutter/material.dart';

/// The builder used to create the button for the [MultiDayPortalOverlayButton].
///
/// TODO: docs
typedef MultiDayPortalOverlayButtonBuilder = Widget Function(
  OverlayPortalController portalController,
  int numberOfHiddenEvents,
  MultiDayPortalOverlayButtonStyle? style,
);

class MultiDayPortalOverlayButtonStyle {
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? textPadding;
  const MultiDayPortalOverlayButtonStyle({this.textStyle, this.textPadding});
}

class MultiDayPortalOverlayButton extends StatelessWidget {
  final MultiDayPortalOverlayButtonStyle? style;
  final OverlayPortalController portalController;
  final int numberOfHiddenEvents;

  const MultiDayPortalOverlayButton({
    super.key,
    required this.portalController,
    required this.numberOfHiddenEvents,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: portalController.show,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text('$numberOfHiddenEvents more'),
      ),
    );
  }
}
