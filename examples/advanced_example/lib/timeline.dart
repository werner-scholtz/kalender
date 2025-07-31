import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// TODO: add this to package.
class CustomTimeLine extends StatelessWidget with TimeOfDayUtils {
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
  TextDirection textDirection(BuildContext context) => style?.textDirection ?? TextDirection.ltr;

  /// The [EdgeInsets] that will be used for the text.
  EdgeInsets textPadding(BuildContext context) =>
      style?.textPadding ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 24);

  /// The [Size] of the largest text.
  Size largestTextSize(BuildContext context, TextStyle textStyle, EdgeInsets padding) {
    const displayTime = TimeOfDay(hour: 12, minute: 0);
    final text = style?.stringBuilder?.call(displayTime) ?? displayTime.format(context);
    final textSize = _textSize(text, textStyle);
    final paddingSize = Size(padding.horizontal, padding.vertical);
    return Size(textSize.width + paddingSize.width, textSize.height + paddingSize.height);
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
    final textDirection = this.textDirection(context);
    final textPadding = this.textPadding(context);
    final textSize = largestTextSize(context, textStyle, textPadding);
    final textHeight = textSize.height;
    final textWidth = textSize.width;
    final textXOffset = textHeight / 2;

    final itemHeight = textHeight + textPadding.vertical;

    final segments = timeOfDayRange.splitIntoSegments(
      numberOfSegments(timeOfDayRange, heightPerMinute, itemHeight),
    );

    final positionedTimes = segments.indexed.map((e) {
      final (index, range) = e;

      final height = range.duration.inMinutes * heightPerMinute;

      final pos = index * height;

      // Always skip the first item.
      if (index == 0 || index == segments.length) return null;

      // The time to display is the next hour.
      final displayTime = range.start;
      final text = style?.stringBuilder?.call(displayTime) ?? displayTime.format(context);

      return Positioned(
        top: pos - textXOffset,
        child: Padding(
          padding: textPadding,
          child: Text(text, style: textStyle, textDirection: textDirection),
        ),
      );
    });

    final eventBeingDraggedTimes = ValueListenableBuilder(
      valueListenable: visibleDateTimeRange,
      builder: (context, visibleRange, child) {
        return ValueListenableBuilder(
          valueListenable: eventBeingDragged,
          builder: (context, eventBeingDragged, child) {
            // Ensure that there is a event being dragged.
            if (eventBeingDragged == null) return const SizedBox();

            // Ensure that the event is visible.
            final eventRange = eventBeingDragged.dateTimeRangeAsUtc;
            if (!eventRange.overlaps(visibleRange)) return const SizedBox();

            final start = eventBeingDragged.startAsUtc;
            final end = eventBeingDragged.endAsUtc;

            // Calculate the top and bottom values.
            final startTop =
                start.difference(timeOfDayRange.start.toDateTime(start)).inMinutes *
                heightPerMinute;
            final endTop =
                end.difference(timeOfDayRange.start.toDateTime(end)).inMinutes * heightPerMinute;

            final startTime = TimeOfDay.fromDateTime(start);
            final endTime = TimeOfDay.fromDateTime(end);
            final startText = style?.stringBuilder?.call(startTime) ?? startTime.format(context);
            final endText = style?.stringBuilder?.call(endTime) ?? endTime.format(context);

            late final decoration = BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            );

            return Stack(
              children: [
                Positioned(
                  top: startTop,
                  child: Container(
                    decoration: style?.startDecoration ?? decoration,
                    child: Center(child: Text(startText)),
                  ),
                ),
                Positioned(
                  top: endTop,
                  child: Container(
                    decoration: style?.endDecoration ?? decoration,
                    child: Center(child: Text(endText)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    return SizedBox(
      width: textWidth,
      child: Stack(children: [...positionedTimes.nonNulls, eventBeingDraggedTimes]),
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
    final largestTextSize = this.largestTextSize(context, textStyle, textPadding);
    return SizedBox(width: largestTextSize.width);
  }
}

/// TODO: add this to package.
extension TimeOfDayRangeExtensions on TimeOfDayRange {
  /// Generates a list of [TimeOfDayRange] segments based on the provided [segmentLength] in minutes.
  List<TimeOfDayRange> splitIntoSegments(int segmentLength) {
    final segments = <TimeOfDayRange>[];
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final totalMinutes = endMinutes - startMinutes;
    final numOfSegments = (totalMinutes / segmentLength).floor();
    for (var i = 0; i <= numOfSegments; i++) {
      final startMinutes = i * segmentLength;
      final start = TimeOfDay(hour: startMinutes ~/ 60, minute: startMinutes % 60);
      final endMinutes = startMinutes + segmentLength - 1;
      final end = TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60);

      segments.add(TimeOfDayRange(start: start, end: end));
    }

    return segments;
  }
}

// TODO: figure out how this can be applied in the hourline builder as well.
mixin TimeOfDayUtils {
  int numberOfSegments(TimeOfDayRange timeOfDayRange, double heightPerMinute, double itemHeight) {
    final totalHeight = timeOfDayRange.duration.inMinutes * heightPerMinute;
    final totalItems = (totalHeight / itemHeight).ceil();
    return switch (totalItems) {
      < 12 => 60,
      < 24 => 30,
      < 48 => 15,
      _ => 5,
    };
  }
}
