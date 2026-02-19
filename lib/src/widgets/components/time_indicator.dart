import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The time indicator builder.
///
/// The [timeOfDayRange] is the range of time that the time indicator will be displayed for.
/// The [heightPerMinute] is the height of each minute.
/// The [style] is used to style the time indicator.
typedef TimeIndicatorBuilder = Widget Function(
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  TimeIndicatorStyle? style,
  Location? location,
);

/// The style of the [TimeIndicator] widget.
class TimeIndicatorStyle {
  /// The [Color] of the time indicator.
  final Color? lineColor;

  /// The thickness of the time indicator.
  final double? thickness;

  /// The [Color] of the circle.
  /// * If not provided, the [lineColor] will be used.
  final Color? circleColor;

  /// The size of the circle.
  final Size? circleSize;

  const TimeIndicatorStyle({
    this.lineColor,
    this.thickness,
    this.circleColor,
    this.circleSize,
  });
}

/// A widget that displays the current time as a line and a circle.
class TimeIndicator extends StatefulWidget {
  /// The [TimeOfDayRange] that will be used to display the hour lines.
  final TimeOfDayRange timeOfDayRange;

  /// The height per minute.
  final double heightPerMinute;

  /// The style of the time indicator.
  final TimeIndicatorStyle? style;

  /// The location to use for the time indicator.
  final Location? location;

  /// Creates a new [TimeIndicator] widget.
  const TimeIndicator({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    required this.location,
    this.style,
  });

  static TimeIndicator builder(
    TimeOfDayRange timeOfDayRange,
    double heightPerMinute,
    TimeIndicatorStyle? style,
    Location? location,
  ) {
    return TimeIndicator(
      timeOfDayRange: timeOfDayRange,
      heightPerMinute: heightPerMinute,
      location: location,
      style: style,
    );
  }

  /// Creates a [TimeIndicator] from the [BuildContext].
  static Widget fromContext(
    BuildContext context,
    TimeOfDayRange timeOfDayRange,
  ) {
    final timeIndicatorStyle = context.components().multiDayComponentStyles.bodyStyles.timeIndicatorStyle;
    final components = context.components().multiDayComponents.bodyComponents;
    return components.timeIndicator.call(
      timeOfDayRange,
      context.heightPerMinute,
      timeIndicatorStyle,
      context.location,
    );
  }

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator> {
  /// The timer that updates the time indicator every 10 seconds.
  late final Timer _timer;

  /// The offset to center the circle on the first pixel of the pageview.
  static const _circleCenterOffset = 1.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant TimeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timeOfDayRange != oldWidget.timeOfDayRange || oldWidget.location != widget.location) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() => _timer = Timer.periodic(const Duration(seconds: 10), (_) => setState(() {}));

  @override
  Widget build(BuildContext context) {
    final now = InternalDateTime.fromExternal(DateTime.timestamp(), location: widget.location);
    final startTime = widget.timeOfDayRange.start.toDateTime(now);
    final endTime = widget.timeOfDayRange.end.toDateTime(now);
    final showIndicator = now.isAfter(startTime) && now.isBefore(endTime);
    if (!showIndicator) return const SizedBox.shrink();
    final top = now.difference(startTime).inMinutes * widget.heightPerMinute;

    final lineColor = widget.style?.lineColor ?? Colors.red;
    final thickness = widget.style?.thickness ?? 1;

    final circleWidth = (widget.style?.circleSize?.width) ?? 10;
    final circleHeight = (widget.style?.circleSize?.height) ?? 10;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        PositionedDirectional(
          top: top,
          start: 0,
          end: 0,
          child: Container(
            height: thickness,
            color: lineColor,
          ),
        ),
        PositionedDirectional(
          top: top - circleHeight / 2,
          // This needs to be offset slightly so the center of the circle aligns with the first pixel of the pageview.
          start: -(circleWidth / 2) + _circleCenterOffset,
          width: circleWidth,
          height: circleHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.style?.circleColor ?? lineColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
