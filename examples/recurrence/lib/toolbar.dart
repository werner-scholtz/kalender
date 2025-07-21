import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarToolBar extends StatelessWidget {
  final CalendarController calendarController;
  const CalendarToolBar({required this.calendarController, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: calendarController.visibleDateTimeRangeUtc,
                  builder: (context, value, child) {
                    final String month;
                    final int year;

                    if (calendarController.viewController?.viewConfiguration is MonthViewConfiguration) {
                      // Since the visible DateTimeRange returned by the month view does not always start at the beginning of the month,
                      // we need to check the second week of the visibleDateTimeRange to determine the month and year.
                      final secondWeek = value.start.addDays(7);
                      year = secondWeek.year;
                      month = secondWeek.monthNameLocalized();
                    } else {
                      year = value.start.year;
                      month = value.start.monthNameLocalized();
                    }
                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(minimumSize: const Size(160, kMinInteractiveDimension)),
                      child: Text('$month $year'),
                    );
                  },
                ),
              ],
            ),
          ),
          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToPreviousPage(),
              icon: const Icon(Icons.chevron_left),
            ),
          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToNextPage(),
              icon: const Icon(Icons.chevron_right),
            ),
          IconButton.filledTonal(
            onPressed: () => calendarController.animateToDate(DateTime.now()),
            icon: const Icon(Icons.today),
          ),
        ],
      ),
    );
  }
}
