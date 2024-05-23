import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_event.dart';
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

  const TimelineStyle({
    this.textStyle,
    this.textDirection,
    this.stringBuilder,
    this.textPadding,
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
  /// TODO: display the resulting start/end times of the dragged event.
  final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;

  /// Creates a new [TimeLine] widget.
  const TimeLine({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    required this.eventBeingDragged,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle =
        style?.textStyle ?? Theme.of(context).textTheme.labelMedium;
    final textDirection = style?.textDirection ?? TextDirection.ltr;

    final textHeight = _textSize('0', textStyle).height;
    final textXOffset = textHeight / 2;

    // This includes the last hour for which we do not want to display the time.
    final hourRanges = timeOfDayRange.hourRanges;
    var previousXPosition = 0.0;

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
        final text = style?.stringBuilder?.call(displayTime) ??
            displayTime.format(context);

        final textPadding =
            style?.textPadding ?? const EdgeInsets.symmetric(horizontal: 4);

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
      valueListenable: eventBeingDragged,
      builder: (context, eventBeingDragged, child) {
        // TODO: calculate eventBeingDragged start/end times and display them.
        return SizedBox();
      },
    );

    return Stack(
      children: positionedTimes.nonNulls.toList(),
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
