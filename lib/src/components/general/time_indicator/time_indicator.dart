import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class TimeIndicator<T> extends StatefulWidget {
  const TimeIndicator({
    super.key,
    required this.dayWidth,
    required this.heightPerMinute,
  });

  final double dayWidth;
  final double heightPerMinute;

  @override
  State<TimeIndicator<T>> createState() => _TimeIndicatorState<T>();
}

class _TimeIndicatorState<T> extends State<TimeIndicator<T>> {
  late Timer _timer;
  late DateTime _currentDate;
  late CalendarScope<T> scope = CalendarScope.of<T>(context);

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _currentDate = DateTime.now();
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style;
    final circleRadius = style.timeIndicatorStyle.circleRadius ?? 4.5;
    final circleSize = Size(circleRadius * 2, circleRadius * 2);

    return Stack(
      children: [
        Positioned(
          top: top - (style.timeIndicatorStyle.lineWidth ?? 1) / 2,
          left: 0,
          width: widget.dayWidth,
          child: SizedBox(
            height: style.timeIndicatorStyle.lineWidth ?? 1,
            child: Container(
              color: style.timeIndicatorStyle.color ?? Colors.red,
            ),
          ),
        ),
        Positioned(
          top: top,
          left: 0,
          width: 0,
          height: 0,
          child: OverflowBox(
            minWidth: circleSize.width,
            maxWidth: circleSize.width,
            minHeight: circleSize.height,
            maxHeight: circleSize.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: style.timeIndicatorStyle.color ?? Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the top position of the time indicator.
  double get top {
    final minutes = _currentDate.difference(_currentDate.startOfDay).inMinutes;
    return minutes * widget.heightPerMinute;
  }
}
