import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the header background.
class CalendarHeaderBackground extends StatelessWidget {
  const CalendarHeaderBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final style =
        CalendarStyleProvider.of(context).style.calendarHeaderBackgroundStyle;

    final color =
        style.headerBackgroundColor ?? Theme.of(context).colorScheme.surface;
    final surfaceTintColor = style.headerSurfaceTintColor ??
        Theme.of(context).colorScheme.surfaceTint;
    final elevation = style.headerElevation ?? 2;
    return Material(
      color: color,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      child: child,
    );
  }
}
