import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/providers/kalender_scope.dart';
import 'package:kalender/src/theme/kalender_theme.dart';

/// The width of the month's week number column.
///
/// The column is drawn in the month body and reserved again in the month header,
/// so both read one number rather than each measuring what they build. It is not
/// called for a view that draws no week numbers.
///
/// It runs above `CalendarHeader` and `CalendarBody`, so the context resolves
/// [KalenderTheme] and every [KalenderScope] accessor except the four those two
/// install: `interactionOf`, `snappingOf`, `tileComponentsOf` and
/// `heightPerMinuteOf`.
typedef WeekNumberWidthBuilder = double Function(BuildContext context);

/// The width [defaultWeekNumberWidth] returns when the style sets none.
///
/// Matches `kDefaultScheduleLeadingWidth`, the schedule's equivalent.
const kDefaultWeekNumberWidth = 56.0;

/// The default [WeekNumberWidthBuilder].
///
/// Returns the width of [WeekNumberStyle.buttonSize] plus its padding when the
/// style sets one, and [kDefaultWeekNumberWidth] otherwise.
double defaultWeekNumberWidth(BuildContext context) {
  final style = KalenderTheme.of(context).weekNumberStyle ?? const WeekNumberStyle();
  final buttonSize = style.buttonSize;
  if (buttonSize == null) return kDefaultWeekNumberWidth;
  final padding = style.padding ?? const EdgeInsets.symmetric(horizontal: 4);
  return buttonSize.width + padding.horizontal;
}

/// The week number builder.
///
/// The [visibleDateTimeRange] is the range of dates that the week number will be displayed for.
///
/// Resolve the style with [KalenderTheme]. The month gutter merges its own
/// defaults into that scope, so the same call returns the month's value there.
typedef WeekNumberBuilder = Widget Function(
  BuildContext context,
  DateTimeRange visibleDateTimeRange,
);

/// The style of the [WeekNumber].
class WeekNumberStyle with Diagnosticable {
  /// Creates a new [WeekNumberStyle].
  const WeekNumberStyle({
    this.textStyle,
    this.buttonSize,
    this.tooltip,
    this.padding,
    this.alignment,
  });

  /// The [TextStyle] used by the [WeekNumber] widget to display the week number.
  final TextStyle? textStyle;

  /// The size of the week number button. When null the button keeps its
  /// natural size.
  final Size? buttonSize;

  /// The tooltip used by the [WeekNumber] widget.
  final String? tooltip;

  /// The padding around by the [WeekNumber] widget.
  final EdgeInsets? padding;

  /// The alignment of the week number within its available cell.
  final AlignmentGeometry? alignment;

  /// Creates a copy of this style with the given fields replaced with the new values.
  WeekNumberStyle copyWith({
    TextStyle? textStyle,
    Size? buttonSize,
    String? tooltip,
    EdgeInsets? padding,
    AlignmentGeometry? alignment,
  }) {
    return WeekNumberStyle(
      textStyle: textStyle ?? this.textStyle,
      buttonSize: buttonSize ?? this.buttonSize,
      tooltip: tooltip ?? this.tooltip,
      padding: padding ?? this.padding,
      alignment: alignment ?? this.alignment,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  WeekNumberStyle merge(WeekNumberStyle? other) {
    if (other == null) return this;
    return WeekNumberStyle(
      textStyle: other.textStyle ?? textStyle,
      buttonSize: other.buttonSize ?? buttonSize,
      tooltip: other.tooltip ?? tooltip,
      padding: other.padding ?? padding,
      alignment: other.alignment ?? alignment,
    );
  }

  /// Linearly interpolates between [a] and [b]. Fields that cannot be interpolated switch at the midpoint.
  static WeekNumberStyle? lerp(WeekNumberStyle? a, WeekNumberStyle? b, double t) {
    if (identical(a, b)) return a;
    return WeekNumberStyle(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      buttonSize: Size.lerp(a?.buttonSize, b?.buttonSize, t),
      tooltip: t < 0.5 ? a?.tooltip : b?.tooltip,
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t),
      alignment: AlignmentGeometry.lerp(a?.alignment, b?.alignment, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeekNumberStyle &&
        other.textStyle == textStyle &&
        other.buttonSize == buttonSize &&
        other.tooltip == tooltip &&
        other.padding == padding &&
        other.alignment == alignment;
  }

  @override
  int get hashCode => Object.hash(textStyle, buttonSize, tooltip, padding, alignment);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<Size>('buttonSize', buttonSize, defaultValue: null));
    properties.add(StringProperty('tooltip', tooltip, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, defaultValue: null));
  }
}

/// A widget that displays the week number.
class WeekNumber extends StatelessWidget {
  /// The range of dates that the week number will be displayed for.
  final DateTimeRange visibleDateTimeRange;

  /// The style used by the [WeekNumber].
  final WeekNumberStyle? weekNumberStyle;

  const WeekNumber({super.key, required this.visibleDateTimeRange, this.weekNumberStyle});

  @override
  Widget build(BuildContext context) {
    final internalDateTime = InternalDateTimeRange(
      start: InternalDateTime.fromExternal(visibleDateTimeRange.start, location: context.location),
      end: InternalDateTime.fromExternal(visibleDateTimeRange.end, location: context.location),
    );
    final (start, end) = internalDateTime.weekNumbers;
    final weekNumber = start.toString() + ((end == null) ? '' : ' - $end');

    final style = (KalenderTheme.of(context).weekNumberStyle ?? const WeekNumberStyle()).merge(weekNumberStyle);
    final padding = style.padding ?? const EdgeInsets.symmetric(horizontal: 4);
    final buttonSize = style.buttonSize;

    return Align(
      alignment: style.alignment ?? Alignment.center,
      child: Padding(
        padding: padding,
        child: IconButton.filledTonal(
          tooltip: style.tooltip,
          onPressed: null,
          visualDensity: VisualDensity.compact,
          padding: buttonSize == null ? null : EdgeInsets.zero,
          constraints: buttonSize == null ? null : BoxConstraints.tight(buttonSize),
          // The gutter is sized by the calendar, not by this label, so a range
          // spanning two weeks wraps. Without this the short second line sits
          // against the leading edge.
          icon: Text(
            weekNumber,
            textAlign: TextAlign.center,
            style: style.textStyle,
          ),
        ),
      ),
    );
  }
}
