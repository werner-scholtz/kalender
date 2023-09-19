import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the current time.
class TimeIndicator extends StatefulWidget {
  const TimeIndicator({
    super.key,
    required this.width,
    required this.visibleDateRange,
    required this.heightPerMinute,
    required this.timelineWidth,
  });

  /// Width of indicator
  final double width;

  /// The width of the timeline.
  final double timelineWidth;

  /// The visible date range.
  final DateTimeRange visibleDateRange;

  /// The height per minute.
  final double heightPerMinute;

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator> {
  late Timer _timer;
  late DateTime _currentDate;
  late DateTimeRange _visibleDateRange;
  late double _heightPerMinute;
  double circleRadius = 9;

  @override
  void initState() {
    super.initState();
    _visibleDateRange = widget.visibleDateRange;
    _currentDate = DateTime.now();
    _heightPerMinute = widget.heightPerMinute;
    _timer = Timer(const Duration(seconds: 1), setTimer);
  }

  @override
  void didUpdateWidget(covariant TimeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _timer.cancel();
    _visibleDateRange = widget.visibleDateRange;
    _currentDate = DateTime.now();
    _heightPerMinute = widget.heightPerMinute;
    _timer.cancel();
    _timer = Timer(const Duration(seconds: 1), setTimer);
  }

  @override
  void didChangeDependencies() {
    circleRadius = CalendarStyleProvider.of(context)
            .style
            .timeIndicatorStyle
            ?.circleRadius ??
        9;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Creates an recursive timer that that runs every 1 seconds.
  void setTimer() {
    if (mounted) {
      setState(() {
        _currentDate = DateTime.now();
        _timer = Timer(const Duration(seconds: 1), setTimer);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style;
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: widget.width + circleRadius / 2,
        height: circleRadius,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: circleRadius,
                height: circleRadius,
                decoration: BoxDecoration(
                  color: style.timeIndicatorStyle?.color ?? Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: widget.width + circleRadius * 2,
                height: 2,
                color: style.timeIndicatorStyle?.color ?? Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get top {
    final minutes = _currentDate.difference(_currentDate.startOfDay).inMinutes;
    return minutes * _heightPerMinute - (circleRadius / 2);
  }

  double get left {
    return (_visibleDateRange.start.startOfDay
                .difference(_currentDate)
                .inDays
                .abs() *
            widget.width) +
        widget.timelineWidth -
        circleRadius / 2;
  }
}
