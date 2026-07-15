import 'package:flutter/material.dart';

/// The day number shown by the date components, highlighted when it is today.
///
/// Shared by every widget that shows a day number, so the today highlight looks
/// the same everywhere: the day header, the month day header, the schedule
/// date, and the multi-day overlay.
///
/// It is never interactive. It is a label that happens to be drawn like a
/// button, so [onPressed] is always null and the highlight has to set the
/// disabled colors to stay tonal.
class DayNumber extends StatelessWidget {
  const DayNumber({
    super.key,
    required this.number,
    required this.isToday,
    required this.todayKey,
    this.size,
  });

  /// The day number itself, already styled by the calling component.
  final Widget number;

  /// Whether [number] is today, and so should be highlighted.
  final bool isToday;

  /// The key applied when [isToday]. Each component passes its own, so tests
  /// and consumers can find that component's highlight.
  final Key todayKey;

  /// The size of the button. When null it keeps its natural size.
  final Size? size;

  @override
  Widget build(BuildContext context) {
    final constraints = size == null ? null : BoxConstraints.tight(size!);
    final padding = size == null ? null : EdgeInsets.zero;

    if (!isToday) {
      return IconButton(
        onPressed: null,
        icon: number,
        visualDensity: VisualDensity.compact,
        padding: padding,
        constraints: constraints,
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    return IconButton.filledTonal(
      key: todayKey,
      onPressed: null,
      icon: number,
      visualDensity: VisualDensity.compact,
      padding: padding,
      constraints: constraints,
      // Without this the button paints with the disabled colors, which greys
      // the highlight out and reads as "unavailable" rather than "today".
      style: IconButton.styleFrom(
        disabledBackgroundColor: colorScheme.secondaryContainer,
        disabledForegroundColor: colorScheme.onSecondaryContainer,
      ),
    );
  }
}
