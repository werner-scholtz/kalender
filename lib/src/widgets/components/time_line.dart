import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

// TODO: Update docs to reflect visibleDateTimeRange change.
/// The time line builder.
///
/// The [heightPerMinute] is the height of each minute.
/// The [timeOfDayRange] is the range of time that the time line will be displayed for.
/// The [style] is used to style the time line.
typedef TimeLineBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
  TimelineStyle? style,
  ValueNotifier<CalendarEvent?> eventBeingDragged,
  ValueNotifier<DateTimeRange<DateTime>?> visibleDateTimeRange,
);

/// The prototype time line builder.
///
/// The [heightPerMinute] is the height of each minute.
/// The [timeOfDayRange] is the range of time that the time line will be displayed for.
/// The [style] is used to style the time line.
typedef PrototypeTimeLineBuilder = Widget Function(
  double heightPerMinute,
  TimeOfDayRange timeOfDayRange,
  TimelineStyle? style,
);

/// The style of the [TimeLine] widget.
class TimelineStyle {
  /// The style of the text.
  final TextStyle? textStyle;

  /// The text direction of the text.
  final TextDirection? textDirection;

  /// The text align of the text.
  final TextAlign? textAlign;

  /// The text overflow of the text.
  final TextOverflow? textOverflow;

  /// The padding of the text.
  final EdgeInsets? textPadding;

  /// The function that will be used to build the string.
  final String Function(TimeOfDay timeOfDay)? stringBuilder;

  /// The decoration for the event start time.
  final Decoration? startDecoration;

  /// The decoration for the event end time.
  final Decoration? endDecoration;

  const TimelineStyle({
    this.textStyle,
    this.textDirection,
    this.textAlign,
    this.textOverflow,
    this.stringBuilder,
    this.textPadding,
    this.startDecoration,
    this.endDecoration,
  });
}

/// A mixin that provides utility methods for the [TimeLine] and [HourLines] widget.
mixin TimeLineUtils {
  /// The style of the timeline.
  TimelineStyle? get timelineStyle;

  /// The [TextStyle] that will be used for the text.
  TextStyle textStyle(BuildContext context) => timelineStyle?.textStyle ?? Theme.of(context).textTheme.labelMedium!;

  /// The [TextDirection] that will be used for the text.
  TextDirection textDirection(BuildContext context) => timelineStyle?.textDirection ?? TextDirection.ltr;

  /// The [EdgeInsets] that will be used for the text.
  EdgeInsets textPadding(BuildContext context) =>
      timelineStyle?.textPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 36);

  /// The [Size] of the largest text.
  Size largestTextSize(BuildContext context, TextStyle textStyle, EdgeInsets padding) {
    const displayTime = TimeOfDay(hour: 23, minute: 59);
    final text = timelineStyle?.stringBuilder?.call(displayTime) ?? displayTime.format(context);
    final textSize = _textSize(text, textStyle);
    return Size(textSize.width + padding.horizontal, textSize.height + padding.vertical);
  }

  /// Returns the [Size] of the text.
  Size _textSize(String text, TextStyle? style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: timelineStyle?.textDirection ?? TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size;
  }

  /// Calculates the [Size] of the item based on the [textStyle] and [textPadding].
  Size itemSize(BuildContext context) => largestTextSize(context, textStyle(context), textPadding(context));

  /// Calculates the segments duration based on the [timeOfDayRange], [heightPerMinute], and [itemHeight].
  int segmentDuration(TimeOfDayRange timeOfDayRange, double heightPerMinute, double itemHeight) {
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

/// A widget that displays a list of times based on the [timeOfDayRange] and [heightPerMinute].
class TimeLine extends StatelessWidget with TimeLineUtils {
  /// The [TimeOfDayRange] that will be used to display the timeline.
  final TimeOfDayRange timeOfDayRange;

  /// The height per minute.
  final double heightPerMinute;

  /// The style of the timeline.
  final TimelineStyle? style;

  /// The [ValueNotifier] that contains the event being dragged.
  final ValueNotifier<CalendarEvent?> eventBeingDragged;

  /// The visibleDataTimeRange.
  final ValueNotifier<DateTimeRange<DateTime>?> visibleDateTimeRange;

  /// Creates a new [TimeLine] widget.
  const TimeLine({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    required this.eventBeingDragged,
    required this.visibleDateTimeRange,
    required this.style,
  });

  @override
  TimelineStyle? get timelineStyle => style;

  static TimeLine builder(
    double heightPerMinute,
    TimeOfDayRange timeOfDayRange,
    TimelineStyle? style,
    ValueNotifier<CalendarEvent?> eventBeingDragged,
    ValueNotifier<DateTimeRange<DateTime>?> visibleDateTimeRange,
  ) {
    return TimeLine(
      heightPerMinute: heightPerMinute,
      timeOfDayRange: timeOfDayRange,
      style: style,
      eventBeingDragged: eventBeingDragged,
      visibleDateTimeRange: visibleDateTimeRange,
    );
  }

  /// Returns a [Key] for the given time.
  static Key getTimeKey(int hour, int minute) => Key('time-$hour-$minute');

  /// Builds the time line widget based on the provided context.
  static Widget fromContext(BuildContext context, TimeOfDayRange timeOfDayRange) {
    final calendarController = context.calendarController();
    final selectedEvent = calendarController.selectedEvent;
    final timelineStyle = context.components().multiDayComponentStyles.bodyStyles.timelineStyle;
    final bodyComponents = context.components().multiDayComponents.bodyComponents;
    return bodyComponents.timeline.call(
      context.heightPerMinute,
      timeOfDayRange,
      timelineStyle,
      selectedEvent,
      calendarController.visibleDateTimeRange,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle(context);
    final textDirection = this.textDirection(context);
    final textPadding = this.textPadding(context);
    final itemSize = this.itemSize(context);
    final textXOffset = itemSize.height / 2;
    final segmentDuration = this.segmentDuration(timeOfDayRange, heightPerMinute, itemSize.height);
    final segments = timeOfDayRange.splitIntoSegments(segmentDuration);
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
          child: Text(
            key: getTimeKey(displayTime.hour, displayTime.minute),
            text,
            style: textStyle,
            textDirection: textDirection,
            textAlign: style?.textAlign,
            overflow: style?.textOverflow,
          ),
        ),
      );
    });

    // TODO: Improve this.
    final eventBeingDraggedTimes = ValueListenableBuilder(
      valueListenable: visibleDateTimeRange,
      builder: (context, visibleRange, child) {
        if (visibleRange == null) return const SizedBox();
        return ValueListenableBuilder(
          valueListenable: eventBeingDragged,
          builder: (context, eventBeingDragged, child) {
            // Ensure that there is a event being dragged.
            if (eventBeingDragged == null) return const SizedBox();

            // Multi-day events belong in the header, not the body.
            // Don't show timeline tooltips for them.
            if (eventBeingDragged.isMultiDayEvent) return const SizedBox();

            // Ensure that the event is visible.
            final eventRange = eventBeingDragged.internalRange(location: context.location);
            if (!eventRange.overlaps(visibleRange)) return const SizedBox();

            final start = eventBeingDragged.internalStart(location: context.location);
            final end = eventBeingDragged.internalEnd(location: context.location);

            // Calculate the top and bottom values.
            final startTop = start.difference(timeOfDayRange.start.toDateTime(start)).inMinutes * heightPerMinute;
            final endTop = end.difference(timeOfDayRange.start.toDateTime(end)).inMinutes * heightPerMinute;

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
      width: itemSize.width,
      child: Stack(
        children: [
          ...positionedTimes.nonNulls,
          eventBeingDraggedTimes,
        ],
      ),
    );
  }
}

/// A widget that displays a prototype time line.
class PrototypeTimeline extends TimeLine {
  const PrototypeTimeline({
    super.key,
    required super.timeOfDayRange,
    required super.heightPerMinute,
    required super.eventBeingDragged,
    required super.visibleDateTimeRange,
    required super.style,
  });

  static PrototypeTimeline prototypeBuilder(
    double heightPerMinute,
    TimeOfDayRange timeOfDayRange,
    TimelineStyle? style,
  ) {
    return PrototypeTimeline(
      heightPerMinute: heightPerMinute,
      timeOfDayRange: timeOfDayRange,
      style: style,
      eventBeingDragged: ValueNotifier(null),
      visibleDateTimeRange: ValueNotifier(DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 2))),
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
