import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A widget that displays a list of times based on the [timeOfDayRange] and [heightPerMinute].
class CustomTimeLine extends StatelessWidget {
  /// The [TimeOfDayRange] that will be used to display the timeline.
  final TimeOfDayRange timeOfDayRange;

  /// The height per minute.
  final double heightPerMinute;

  /// The style of the timeline.
  final TimelineStyle? style;

  /// The [ValueNotifier] that contains the event being dragged.
  final ValueNotifier<CalendarEvent<dynamic>?> eventBeingDragged;

  /// The visibleDataTimeRange.
  final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  /// Creates a new [CustomTimeLine] widget.
  const CustomTimeLine({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    required this.eventBeingDragged,
    required this.visibleDateTimeRange,
    required this.style,
  });

  static CustomTimeLine builder(
    double heightPerMinute,
    TimeOfDayRange timeOfDayRange,
    TimelineStyle? style,
    ValueNotifier<CalendarEvent<Object?>?> eventBeingDragged,
    ValueNotifier<DateTimeRange> visibleDateTimeRange,
  ) {
    return CustomTimeLine(
      heightPerMinute: heightPerMinute,
      timeOfDayRange: timeOfDayRange,
      style: style,
      eventBeingDragged: eventBeingDragged,
      visibleDateTimeRange: visibleDateTimeRange,
    );
  }

  /// The [TextStyle] that will be used for the text.
  TextStyle textStyle(BuildContext context) =>
      style?.textStyle ?? Theme.of(context).textTheme.labelMedium!;

  /// The [TextDirection] that will be used for the text.
  TextDirection textDirection(BuildContext context) =>
      style?.textDirection ?? TextDirection.ltr;

  /// The [EdgeInsets] that will be used for the text.
  EdgeInsets textPadding(BuildContext context) =>
      style?.textPadding ?? const EdgeInsets.symmetric(horizontal: 4);

  /// The [Size] of the largest text.
  Size largestTextSize(
    BuildContext context,
    TextStyle textStyle,
    EdgeInsets padding,
  ) {
    const displayTime = TimeOfDay(hour: 12, minute: 0);
    final text =
        style?.stringBuilder?.call(displayTime) ?? displayTime.format(context);
    final textSize = _textSize(text, textStyle);
    final paddingSize = Size(padding.horizontal, padding.vertical);
    return Size(
      textSize.width + paddingSize.width,
      textSize.height + paddingSize.height,
    );
  }

  /// Returns the [Size] of the text.
  Size _textSize(String text, TextStyle? style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: this.style?.textDirection ?? TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle(context);
    final textPadding = this.textPadding(context);
    final textSize = largestTextSize(context, textStyle, textPadding);
    final textHeight = textSize.height;
    final textWidth = textSize.width;
    final textXOffset = textHeight / 2;

    print(heightPerMinute * timeOfDayRange.duration.inMinutes);

    return SizedBox(
      width: textWidth,
      // child: Column(
      //   children: List.generate(96, (index) {
      //     return Text(index.toString());
      //   }),
      // ),
    );
  }
}

/// A widget that displays a prototype time line.
class PrototypeCustomTimeline extends CustomTimeLine {
  const PrototypeCustomTimeline({
    super.key,
    required super.timeOfDayRange,
    required super.heightPerMinute,
    required super.eventBeingDragged,
    required super.visibleDateTimeRange,
    required super.style,
  });

  static PrototypeCustomTimeline prototypeBuilder(
    double heightPerMinute,
    TimeOfDayRange timeOfDayRange,
    TimelineStyle? style,
  ) {
    return PrototypeCustomTimeline(
      heightPerMinute: heightPerMinute,
      timeOfDayRange: timeOfDayRange,
      style: style,
      eventBeingDragged: ValueNotifier(null),
      visibleDateTimeRange: ValueNotifier(
        DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 2)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle(context);
    final textPadding = this.textPadding(context);
    final largestTextSize = this.largestTextSize(
      context,
      textStyle,
      textPadding,
    );
    return SizedBox(width: largestTextSize.width);
  }
}
