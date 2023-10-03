import 'dart:ui';

/// The [TileHandleStyle] class is used by the default [TimeIndicator] widget.
class TileHandleStyle {
  const TileHandleStyle({
    this.borderRadius,
    this.color,
  });

  /// The radius of the circle.
  final double? borderRadius;

  /// The color of time indicator.
  final Color? color;
}
