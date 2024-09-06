import 'package:flutter/material.dart';

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
}

/// A widget that displays a separator between days.
class DaySeparator extends StatelessWidget {
  final DaySeparatorStyle? style;
  const DaySeparator({super.key, this.style});

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
