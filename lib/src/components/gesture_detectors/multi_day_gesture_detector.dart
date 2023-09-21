import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kalender/kalendar_scope.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/constants.dart';

class DayGestureDetector<T> extends StatefulWidget {
  const DayGestureDetector({
    super.key,
    required this.viewConfiguration,
    required this.visibleDates,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final List<DateTime> visibleDates;

  @override
  State<DayGestureDetector<T>> createState() => _DayGestureDetectorState<T>();
}

class _DayGestureDetectorState<T> extends State<DayGestureDetector<T>> {
  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  int get newEventDurationInMinutes =>
      widget.viewConfiguration.newEventDuration.inMinutes;

  double cursorOffset = 0;
  int numberOfSlotsSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...List.generate(
          widget.viewConfiguration.numberOfDays,
          (dayIndex) => Expanded(
            child: Column(
              children: List.generate(
                (hoursADay * 60) ~/
                    widget.viewConfiguration.newEventDuration.inMinutes,
                (slotIndex) => Expanded(
                  child: SizedBox.expand(
                    child: GestureDetector(
                      onTap: () {
                        final date = widget.visibleDates[dayIndex].add(
                          Duration(
                            minutes: slotIndex * newEventDurationInMinutes,
                          ),
                        );
                        log(date.toString());
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
