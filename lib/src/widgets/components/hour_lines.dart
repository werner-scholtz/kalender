import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The hour lines builder.
///
/// The [heightPerMinute] is the height of each minute.
/// The [timeOfDayRange] is the range of time that the hour lines will be displayed for.
///
/// Resolve the line style with [KalenderTheme]. The number of lines follows the
/// timeline's label size, which [KalenderTheme] resolves.
typedef HourLinesBuilder = Widget Function(
  BuildContext context,
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
);

/// The style of the [HourLines] widget.
class HourLinesStyle with Diagnosticable {
  /// The [Color] of the hour lines.
  final Color? color;

  /// The thickness of the hour lines.
  final double? thickness;

  /// The indent of the hour lines.
  final double? indent;

  /// The end indent of the hour lines.
  final double? endIndent;

  const HourLinesStyle({
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  /// Creates a copy of this style with the given fields replaced with the new values.
  HourLinesStyle copyWith({
    Color? color,
    double? thickness,
    double? indent,
    double? endIndent,
  }) {
    return HourLinesStyle(
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      indent: indent ?? this.indent,
      endIndent: endIndent ?? this.endIndent,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  HourLinesStyle merge(HourLinesStyle? other) {
    if (other == null) return this;
    return HourLinesStyle(
      color: other.color ?? color,
      thickness: other.thickness ?? thickness,
      indent: other.indent ?? indent,
      endIndent: other.endIndent ?? endIndent,
    );
  }

  /// Linearly interpolates between [a] and [b].
  static HourLinesStyle? lerp(HourLinesStyle? a, HourLinesStyle? b, double t) {
    if (identical(a, b)) return a;
    return HourLinesStyle(
      color: Color.lerp(a?.color, b?.color, t),
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      indent: lerpDouble(a?.indent, b?.indent, t),
      endIndent: lerpDouble(a?.endIndent, b?.endIndent, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HourLinesStyle &&
        other.color == color &&
        other.thickness == thickness &&
        other.indent == indent &&
        other.endIndent == endIndent;
  }

  @override
  int get hashCode => Object.hash(color, thickness, indent, endIndent);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(DoubleProperty('thickness', thickness, defaultValue: null));
    properties.add(DoubleProperty('indent', indent, defaultValue: null));
    properties.add(DoubleProperty('endIndent', endIndent, defaultValue: null));
  }
}

/// A widget that displays lines for each hour based on the [timeOfDayRange] and [heightPerMinute].
class HourLines extends StatelessWidget with TimeLineUtils {
  /// The [TimeOfDayRange] that will be used to display the hour lines.
  final TimeOfDayRange timeOfDayRange;

  /// The height per minute.
  final double heightPerMinute;

  /// The style of the hour lines.
  final HourLinesStyle? style;

  @override
  final TimelineStyle? timelineStyle;

  /// Creates a new [HourLines] widget.
  const HourLines({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    this.style,
    this.timelineStyle,
  });

  @override
  Widget build(BuildContext context) {
    final timelineItemSize = largestTextSize(context, textStyle(context), textPadding(context));
    final segments = timeOfDayRange.splitIntoSegments(
      segmentDuration(timeOfDayRange, heightPerMinute, timelineItemSize.height),
    );

    final style = (KalenderTheme.of(context).hourLinesStyle ?? const HourLinesStyle()).merge(this.style);
    final thickness = style.thickness ?? 1;
    final color = style.color;
    final indent = style.indent ?? 0;
    final endIndent = style.endIndent ?? 0;

    var previousXPosition = 0.0;
    final positionedLines = segments.map((e) {
      final rangeHeight = heightPerMinute * e.duration.inMinutes;
      final position = rangeHeight + previousXPosition;
      previousXPosition = position;

      return Positioned(
        top: position,
        left: 0,
        right: 0,
        child: Container(
          margin: EdgeInsetsDirectional.only(start: indent, end: endIndent),
          height: thickness,
          color: color,
        ),
      );
    });

    return Stack(children: positionedLines.toList());
  }
}
