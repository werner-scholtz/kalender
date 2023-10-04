import 'package:flutter/material.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the timeline.
class Timeline extends StatelessWidget {
  const Timeline({
    super.key,
    required this.hourHeight,
  });

  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    final timelineStyle = CalendarStyleProvider.of(context).style.timelineStyle;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: hourHeight / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (int i = 1; i < hoursADay; i++)
              SizedBox(
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
    final string = use24HourFormat
        ? '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}'
        : '${((timeOfDay.hour - 1) % 12) + 1} ${timeOfDay.hour ~/ 12 == 0 ? "am" : "pm"}';
    return Text(
      string,
      style: textStyle,
    );
  }
}
