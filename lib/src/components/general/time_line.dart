import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class TimelineStyle {
  const TimelineStyle({
    this.textStyle,
    this.use24HourFormat,
  });

  /// The [TextStyle] of the time text.
  final TextStyle? textStyle;

  /// Whether to use 24 hour format.
  /// If true the time is displayed as 'HH:mm'.
  /// If false the time is displayed as 'h am/pm'.
  ///
  /// If null, the value of [MediaQueryData.alwaysUse24HourFormat] is used.
  final bool? use24HourFormat;
}

class Timeline<T extends Object?> extends StatelessWidget {
  const Timeline({
    super.key,
    required this.timelineWidth,
    required this.height,
    required this.hourHeight,
  });
  final double timelineWidth;
  final double height;
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    TimelineStyle? timelineStyle = CalendarStyleProvider.of(context).style.timelineStyle;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: hourHeight / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (int i = 1; i < hoursADay; i++)
            SizedBox(
              width: timelineWidth,
              height: hourHeight,
              child: Center(
                child: TimeText(
                  timeOfDay: TimeOfDay(hour: i, minute: 0),
                  textStyle: timelineStyle?.textStyle,
                  use24HourFormat: timelineStyle?.use24HourFormat ??
                      MediaQuery.of(context).alwaysUse24HourFormat,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TimeText extends StatelessWidget {
  const TimeText({
    super.key,
    required this.timeOfDay,
    required this.textStyle,
    required this.use24HourFormat,
  });
  final TimeOfDay timeOfDay;
  final TextStyle? textStyle;
  final bool use24HourFormat;

  @override
  Widget build(BuildContext context) {
    String string = use24HourFormat
        ? '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}'
        : '${((timeOfDay.hour - 1) % 12) + 1} ${timeOfDay.hour ~/ 12 == 0 ? "am" : "pm"}';
    return Text(
      string,
      style: textStyle,
    );
  }
}
