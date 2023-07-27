import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class CalendarHeaderBackgroundStyle {
  const CalendarHeaderBackgroundStyle({
    this.headerBackgroundColor,
    this.headerSurfaceTintColor,
    this.headerElevation,
  });

  final Color? headerBackgroundColor;
  final Color? headerSurfaceTintColor;
  final double? headerElevation;
}

class CalendarHeaderBackground extends StatelessWidget {
  const CalendarHeaderBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CalendarStyleProvider.of(context)
              .style
              .calendarHeaderBackgroundStyle
              ?.headerBackgroundColor ??
          Theme.of(context).colorScheme.surface,
      surfaceTintColor: CalendarStyleProvider.of(context)
              .style
              .calendarHeaderBackgroundStyle
              ?.headerSurfaceTintColor ??
          Theme.of(context).colorScheme.surfaceTint,
      elevation:
          CalendarStyleProvider.of(context).style.calendarHeaderBackgroundStyle?.headerElevation ??
              4,
      child: child,
    );
  }
}
