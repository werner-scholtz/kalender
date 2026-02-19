import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';

/// The schedule tile highlight builder.
///
/// The [date] is the date that the highlight will be applied to.
/// The [dateTimeRange] is the range of dates that the highlight will be applied to.
/// The [style] is the style of the highlight.
/// The [child] is the widget that will be displayed inside the highlight.
typedef ScheduleTileHighlightBuilder = Widget Function(
  InternalDateTime date,
  ValueNotifier<InternalDateTimeRange?> dateTimeRange,
  ScheduleTileHighlightStyle? style,
  Widget child,
);

class ScheduleTileHighlightStyle {
  /// Creates a new [ScheduleTileHighlightStyle].
  const ScheduleTileHighlightStyle({this.decoration});

  /// The [BoxDecoration] used to style the highlight.
  final BoxDecoration? decoration;
}

/// A widget that highlights the list item if the date is within the given dateTimeRange.
class ScheduleTileHighlight extends StatelessWidget {
  /// The date to check against the dateTimeRange.
  final InternalDateTime date;

  /// The dateTimeRange to check against the date.
  final ValueNotifier<InternalDateTimeRange?> dateTimeRange;

  /// The style of the highlight.
  final ScheduleTileHighlightStyle style;

  /// The child widget to display.
  final Widget child;

  const ScheduleTileHighlight({
    super.key,
    required this.date,
    required this.dateTimeRange,
    required this.style,
    required this.child,
  });
  static ScheduleTileHighlight builder(
    InternalDateTime date,
    ValueNotifier<InternalDateTimeRange?> dateTimeRange,
    ScheduleTileHighlightStyle? style,
    Widget child,
  ) {
    return ScheduleTileHighlight(
      date: date,
      dateTimeRange: dateTimeRange,
      style: style ?? const ScheduleTileHighlightStyle(),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dateTimeRange,
      builder: (context, value, child) {
        if (value != null && date.isWithin(value)) {
          return DecoratedBox(
            decoration: style.decoration ?? BoxDecoration(color: Theme.of(context).colorScheme.primary.withAlpha(50)),
            child: child!,
          );
        } else {
          return child!;
        }
      },
      child: child,
    );
  }
}
