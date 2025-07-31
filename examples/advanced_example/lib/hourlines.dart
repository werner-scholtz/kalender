import 'package:advanced_example/timeline.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A widget that displays lines for each hour based on the [timeOfDayRange] and [heightPerMinute].
class CustomHourLines extends StatelessWidget with TimeOfDayUtils {
  /// The [TimeOfDayRange] that will be used to display the hour lines.
  final TimeOfDayRange timeOfDayRange;

  /// The height per minute.
  final double heightPerMinute;

  /// The style of the hour lines.
  final HourLinesStyle? style;

  /// Creates a new [CustomHourLines] widget.
  const CustomHourLines({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    this.style,
  });

  static CustomHourLines builder(
    double heightPerMinute,
    TimeOfDayRange timeOfDayRange,
    HourLinesStyle? style,
  ) {
    return CustomHourLines(
      heightPerMinute: heightPerMinute,
      timeOfDayRange: timeOfDayRange,
      style: style,
    );
  }

  TimelineStyle get timelineStyle => const TimelineStyle();

  /// The [TextStyle] that will be used for the text.
  TextStyle textStyle(BuildContext context) =>
      timelineStyle.textStyle ?? Theme.of(context).textTheme.labelMedium!;

  /// The [TextDirection] that will be used for the text.
  TextDirection textDirection(BuildContext context) =>
      timelineStyle.textDirection ?? TextDirection.ltr;

  /// The [EdgeInsets] that will be used for the text.
  EdgeInsets textPadding(BuildContext context) =>
      timelineStyle.textPadding ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 24);

  /// The [Size] of the largest text.
  Size largestTextSize(BuildContext context, TextStyle textStyle, EdgeInsets padding) {
    const displayTime = TimeOfDay(hour: 12, minute: 0);
    final text = timelineStyle.stringBuilder?.call(displayTime) ?? displayTime.format(context);
    final textSize = _textSize(text, textStyle);
    final paddingSize = Size(padding.horizontal, padding.vertical);
    return Size(textSize.width + paddingSize.width, textSize.height + paddingSize.height);
  }

  /// Returns the [Size] of the text.
  Size _textSize(String text, TextStyle? style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: timelineStyle.textDirection ?? TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    final thickness = style?.thickness ?? 1;
    final color = style?.color ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final indent = style?.indent ?? 0;
    final endIndent = style?.endIndent ?? 0;
    final textStyle = this.textStyle(context);

    final textPadding = this.textPadding(context);
    final textSize = largestTextSize(context, textStyle, textPadding);
    final textHeight = textSize.height;

    final itemHeight = textHeight + textPadding.vertical;

    final segments = timeOfDayRange.splitIntoSegments(
      numberOfSegments(timeOfDayRange, heightPerMinute, itemHeight),
    );

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
