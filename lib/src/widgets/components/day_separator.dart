import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The day separator builder.
///
/// The [style] is used to style the day separator.
typedef DaySeparatorBuilder = Widget Function(
  DaySeparatorStyle? style,
);

/// The style for the [DaySeparator] widget.
class DaySeparatorStyle {
  /// The [Color] of the day separator.
  final Color? color;

  /// The width of the day separator.
  final double? width;

  /// The top indent of the day separator.
  final double? topIndent;

  /// The bottom indent of the day separator.
  final double? bottomIndent;

  const DaySeparatorStyle({
    this.color,
    this.width,
    this.topIndent,
    this.bottomIndent,
  });

  /// Creates a copy of this style with the given fields replaced with the new values.
  DaySeparatorStyle copyWith({
    Color? color,
    double? width,
    double? topIndent,
    double? bottomIndent,
  }) {
    return DaySeparatorStyle(
      color: color ?? this.color,
      width: width ?? this.width,
      topIndent: topIndent ?? this.topIndent,
      bottomIndent: bottomIndent ?? this.bottomIndent,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  DaySeparatorStyle merge(DaySeparatorStyle? other) {
    if (other == null) return this;
    return DaySeparatorStyle(
      color: other.color ?? color,
      width: other.width ?? width,
      topIndent: other.topIndent ?? topIndent,
      bottomIndent: other.bottomIndent ?? bottomIndent,
    );
  }

  /// Linearly interpolates between [a] and [b].
  static DaySeparatorStyle? lerp(DaySeparatorStyle? a, DaySeparatorStyle? b, double t) {
    if (identical(a, b)) return a;
    return DaySeparatorStyle(
      color: Color.lerp(a?.color, b?.color, t),
      width: lerpDouble(a?.width, b?.width, t),
      topIndent: lerpDouble(a?.topIndent, b?.topIndent, t),
      bottomIndent: lerpDouble(a?.bottomIndent, b?.bottomIndent, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DaySeparatorStyle &&
        other.color == color &&
        other.width == width &&
        other.topIndent == topIndent &&
        other.bottomIndent == bottomIndent;
  }

  @override
  int get hashCode => Object.hash(color, width, topIndent, bottomIndent);
}

/// A widget that displays a separator between days.
class DaySeparator extends StatelessWidget {
  final DaySeparatorStyle? style;
  const DaySeparator({super.key, this.style});
  static DaySeparator builder(DaySeparatorStyle? style) {
    return DaySeparator(style: style);
  }

  static Widget fromContext(BuildContext context) {
    final daySeparatorStyle = context.components.multiDayComponentStyles.bodyStyles.daySeparatorStyle;
    final components = context.components.multiDayComponents.bodyComponents;
    return components.daySeparator.call(daySeparatorStyle);
  }

  @override
  Widget build(BuildContext context) {
    final color = style?.color ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final width = style?.width ?? 1;
    final topIndent = style?.topIndent ?? 0;
    final bottomIndent = style?.bottomIndent ?? 0;

    return Container(
      margin: EdgeInsetsDirectional.only(start: topIndent, end: bottomIndent),
      width: width,
      color: color,
    );
  }
}
