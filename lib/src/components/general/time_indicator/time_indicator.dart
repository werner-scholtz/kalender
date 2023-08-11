import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class TimeIndicator extends StatefulWidget {
  const TimeIndicator({
    super.key,
    required this.width,
    required this.height,
    required this.visibleDateRange,
    required this.heightPerMinute,
  });

  /// Width of indicator
  final double width;

  /// Height of the display area.
  final double height;

  /// The visible date range.
  final DateTimeRange visibleDateRange;

  ///
  final double heightPerMinute;

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator> {
  late Timer _timer;
  late DateTime _currentDate;
  late DateTimeRange _visibleDateRange;
  double circleRadius = 9;

  @override
  void initState() {
    super.initState();

    _visibleDateRange = widget.visibleDateRange;
    _currentDate = DateTime.now();
    _timer = Timer(const Duration(seconds: 1), setTimer);
  }

  @override
  void didUpdateWidget(covariant TimeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _timer.cancel();
    _visibleDateRange = widget.visibleDateRange;
    _currentDate = DateTime.now();
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
    return Positioned(
      right: _left,
      top: _top,
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
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: widget.width + circleRadius * 2,
                height: 2,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get _top {
    double heightPerMinute = widget.heightPerMinute;
    int minutes = _currentDate.difference(_currentDate.startOfDay).inMinutes;
    return minutes * heightPerMinute - (circleRadius * heightPerMinute);
  }

  double get _left {
    return (_visibleDateRange.start.startOfDay
            .difference(_currentDate)
            .inDays
            .abs() *
        widget.width);
  }
}
