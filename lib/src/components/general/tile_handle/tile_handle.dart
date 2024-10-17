import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class DefaultTileHandle extends StatelessWidget {
  const DefaultTileHandle({
    super.key,
    required this.enabled,
  });

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style.tileHandleStyle;
    final color = style.color ?? Theme.of(context).colorScheme.onSurface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: enabled ? color : color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(style.borderRadius ?? 8),
      ),
    );
  }
}
