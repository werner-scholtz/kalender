import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/time_of_day_range.dart';

/// The time indicator builder.
///
/// The [timeOfDayRange] is the range of time that the time indicator will be displayed for.
/// The [heightPerMinute] is the height of each minute.
/// The [timelineWidth] is the width of the timeline.
/// The [style] is used to style the time indicator.
typedef TimeIndicatorBuilder = Widget Function(
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double timelineWidth,
  TimeIndicatorStyle? style,
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

  /// The width of the timeline.
  final double timelineWidth;

  /// The style of the time indicator.
  final TimeIndicatorStyle? style;

  /// Creates a new [TimeIndicator] widget.
  const TimeIndicator({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    required this.timelineWidth,
    this.style,
  });

  static TimeIndicator builder(
    TimeOfDayRange timeOfDayRange,
    double heightPerMinute,
    double timelineWidth,
    TimeIndicatorStyle? style,
  ) {
    return TimeIndicator(
      timeOfDayRange: timeOfDayRange,
      heightPerMinute: heightPerMinute,
      timelineWidth: timelineWidth,
      style: style,
    );
  }

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator> {
  late final Timer _timer;
  late DateTime _startTime;
  late DateTime _endTime;
  late DateTime _currentTime;

  /// The offset to center the circle on the first pixel of the pageview.
  static const _circleCenterOffset = 1.0;

  /// Whether the indicator should be shown.
  bool get showIndicator {
    return _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);
  }

  /// The top value of the current time.
  double get top {
    final duration = _currentTime.difference(_startTime);
    return duration.inMinutes * widget.heightPerMinute;
  }

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTime = widget.timeOfDayRange.start.toDateTime(_currentTime);
    _endTime = widget.timeOfDayRange.end.toDateTime(_currentTime);
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant TimeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hasChangedTimeOfDayRange = widget.timeOfDayRange != oldWidget.timeOfDayRange;

    if (hasChangedTimeOfDayRange) {
      _startTime = widget.timeOfDayRange.start.toDateTime(_currentTime);
      _endTime = widget.timeOfDayRange.end.toDateTime(_currentTime);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        // Update the current time.
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!showIndicator) return const SizedBox.shrink();

    final lineColor = widget.style?.lineColor ?? Colors.red;
    final thickness = widget.style?.thickness ?? 1;

    final line = Container(
      height: thickness,
      color: lineColor,
    );

    final circleColor = widget.style?.circleColor ?? lineColor;
    final circleWidth = (widget.style?.circleSize?.width) ?? 10;
    final circleHeight = (widget.style?.circleSize?.height) ?? 10;
    final circleTop = top - circleHeight / 2;

    // This needs to be offset slightly so the center of the circle aligns with the first pixel of the pageview.
    final circleLeft = widget.timelineWidth - (circleWidth / 2) + _circleCenterOffset;

    final timeIndicatorCircle = DecoratedBox(
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        PositionedDirectional(
          top: top,
          start: widget.timelineWidth,
          end: 0,
          child: line,
        ),
        PositionedDirectional(
          top: circleTop,
          start: circleLeft,
          width: circleWidth,
          height: circleHeight,
          child: timeIndicatorCircle,
        ),
      ],
    );
  }
}
