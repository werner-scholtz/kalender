import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/time_of_day_range.dart';

/// The style of the [TimeLine] widget.
class TimelineStyle {
  /// The style of the text.
  final TextStyle? textStyle;

  /// The text direction of the text.
  final TextDirection? textDirection;

  /// The padding of the text.
  ///
  /// * Recommendation only pad horizontal.
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
    this.stringBuilder,
    this.textPadding,
    this.startDecoration,
    this.endDecoration,
  });
}

/// A widget that displays a list of times based on the [timeOfDayRange] and [heightPerMinute].
class TimeLine<T extends Object?> extends StatelessWidget {
  /// The [TimeOfDayRange] that will be used to display the timeline.
  final TimeOfDayRange timeOfDayRange;

  /// The height per minute.
  final double heightPerMinute;

  /// The style of the timeline.
  final TimelineStyle? style;

  /// The [ValueNotifier] that contains the event being dragged.
  final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;

  /// The visibleDataTimeRange.
  final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  /// Creates a new [TimeLine] widget.
  const TimeLine({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    required this.eventBeingDragged,
    required this.visibleDateTimeRange,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style?.textStyle ?? Theme.of(context).textTheme.labelMedium;
    final textDirection = style?.textDirection ?? TextDirection.ltr;

    const displayTime = TimeOfDay(hour: 12, minute: 0);
    final text = style?.stringBuilder?.call(displayTime) ?? displayTime.format(context);
    final textSize = _textSize(text, textStyle);
    final textHeight = textSize.height;
    final textWidth = textSize.width;

    final textXOffset = textHeight / 2;

    // This includes the last hour for which we do not want to display the time.
    final hourRanges = timeOfDayRange.hourRanges;
    var previousXPosition = 0.0;

    final textPadding = style?.textPadding ?? const EdgeInsets.symmetric(horizontal: 4);

    final positionedTimes = hourRanges.indexed.map(
      (e) {
        final index = e.$1;
        final range = e.$2;

        // Calculate the height of the range.
        final rangeHeight = heightPerMinute * range.duration.inMinutes;
        // Calculate the position of the range.
        final position = rangeHeight + previousXPosition;
        // Update the previous position.
        previousXPosition = position;

        // Check if the first time can be displayed.
        if (index == 0) {
          // Check if there is space to display the time.
          final canDisplay = position - textXOffset >= 0;
          if (!canDisplay) return null;
        }

        // Check if the second last time can be displayed.
        if (index == hourRanges.length - 2) {
          // Calculate the height of the next item.
          final nextDuration = hourRanges[index + 1].duration.inMinutes;
          final nextItemHeight = nextDuration * heightPerMinute;

          // Check if there is space to display the time.
          final canDisplay = nextItemHeight - textXOffset > 0;
          if (!canDisplay) return null;
        }

        // Do not display the last time.
        if (index == hourRanges.length - 1) return null;

        // The time to display is the next hour.
        final displayTime = TimeOfDay(hour: range.start.hour + 1, minute: 0);
        final text = style?.stringBuilder?.call(displayTime) ?? displayTime.format(context);

        return Positioned(
          top: position - textXOffset,
          child: Padding(
            padding: textPadding,
            child: Text(
              text,
              style: textStyle,
              textDirection: textDirection,
            ),
          ),
        );
      },
    );

    final eventBeingDraggedTimes = ValueListenableBuilder(
      valueListenable: visibleDateTimeRange,
      builder: (context, visibleRange, child) {
        return ValueListenableBuilder(
          valueListenable: eventBeingDragged,
          builder: (context, eventBeingDragged, child) {
            // Ensure that there is a event being dragged.
            if (eventBeingDragged == null) return const SizedBox();

            // Ensure that the event is visible.
            final eventRange = eventBeingDragged.dateTimeRange;
            if (!eventRange.overlaps(visibleRange)) return const SizedBox();

            final start = eventBeingDragged.start;
            final end = eventBeingDragged.end;

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
      width: textWidth + textPadding.horizontal,
      child: Stack(
        children: [
          ...positionedTimes.nonNulls.toList(),
          eventBeingDraggedTimes,
        ],
      ),
    );
  }

  /// Returns the size of the text.
  Size _textSize(String text, TextStyle? style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: this.style?.textDirection ?? TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size;
  }
}
