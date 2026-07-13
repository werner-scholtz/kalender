import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/theme/kalender_theme.dart';

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

  /// Creates a copy of this style with the given fields replaced with the new values.
  ScheduleTileHighlightStyle copyWith({BoxDecoration? decoration}) {
    return ScheduleTileHighlightStyle(decoration: decoration ?? this.decoration);
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  ScheduleTileHighlightStyle merge(ScheduleTileHighlightStyle? other) {
    if (other == null) return this;
    return ScheduleTileHighlightStyle(decoration: other.decoration ?? decoration);
  }

  /// Linearly interpolates between [a] and [b].
  static ScheduleTileHighlightStyle? lerp(ScheduleTileHighlightStyle? a, ScheduleTileHighlightStyle? b, double t) {
    if (identical(a, b)) return a;
    return ScheduleTileHighlightStyle(decoration: BoxDecoration.lerp(a?.decoration, b?.decoration, t));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleTileHighlightStyle && other.decoration == decoration;
  }

  @override
  int get hashCode => decoration.hashCode;
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
    final style =
        (KalenderTheme.of(context).scheduleTileHighlightStyle ?? const ScheduleTileHighlightStyle()).merge(this.style);
    return ValueListenableBuilder(
      valueListenable: dateTimeRange,
      builder: (context, value, child) {
        if (value != null && date.isWithin(value)) {
          return DecoratedBox(
            decoration: style.decoration ?? const BoxDecoration(),
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
