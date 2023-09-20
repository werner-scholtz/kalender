import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalendar_scope.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/providers/calendar_style.dart';

// TODO: add custom time indicator.

class TimeIndicatorV2<T> extends StatefulWidget {
  const TimeIndicatorV2({
    super.key,
    required this.visibleDates,
    required this.dayWidth,
  });
  final List<DateTime> visibleDates;
  final double dayWidth;

  @override
  State<TimeIndicatorV2<T>> createState() => _TimeIndicatorV2State<T>();
}

class _TimeIndicatorV2State<T> extends State<TimeIndicatorV2<T>> {
  late Timer _timer;
  late DateTime _currentDate;
  late CalendarScope<T> scope = CalendarScope.of<T>(context);
  double get heightPerMinute => scope.state.heightPerMinute?.value ?? 0.7;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _timer = Timer.periodic(
      const Duration(seconds: 15),
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
    final circleRadius = style.timeIndicatorStyle?.circleRadius ?? 4.5;
    final circleSize = Size(circleRadius * 2, circleRadius * 2);

    return Stack(
      children: [
        Positioned(
          top: top - (style.timeIndicatorStyle?.lineWidth ?? 1) / 2,
          left: left,
          width: widget.dayWidth,
          child: SizedBox(
            height: style.timeIndicatorStyle?.lineWidth ?? 1,
            child: Container(
              color: style.timeIndicatorStyle?.color ?? Colors.red,
            ),
          ),
        ),
        Positioned(
          top: top,
          left: left,
          width: 0,
          height: 0,
          child: OverflowBox(
            minWidth: circleSize.width,
            maxWidth: circleSize.width,
            minHeight: circleSize.height,
            maxHeight: circleSize.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: style.timeIndicatorStyle?.color ?? Colors.red,
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
    return minutes * heightPerMinute;
  }

  double get left {
    final index = widget.visibleDates.lastIndexOf(_currentDate.startOfDay);
    return index * widget.dayWidth;
  }
}
