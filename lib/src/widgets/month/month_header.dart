import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The month header is a simple widget that just displays the day names.
class MonthHeader extends StatelessWidget {
  /// Creates a new [MonthHeader].
  const MonthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController();

    assert(
      calendarController.viewController is MonthViewController,
      'The CalendarController\'s $ViewController needs to be a $MonthViewController',
    );

    // final viewController = calendarController.viewController as MonthViewController;
    final calendarComponents = context.components();
    final styles = calendarComponents.monthComponentStyles.headerStyles;
    final components = calendarComponents.monthComponents.headerComponents;

    return ValueListenableBuilder(
      valueListenable: calendarController.visibleDateTimeRange,
      builder: (context, visibleDateTimeRange, child) {
        if (visibleDateTimeRange == null) {
          debugPrint('Warning: The visibleDateTimeRange is null in MonthHeader.');
          return const SizedBox.shrink();
        }
        final style = styles.weekDayHeaderStyle;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List<Widget>.generate(
            7,
            (index) {
              final date = visibleDateTimeRange.start.addDays(index);
              return components.weekDayHeaderBuilder.call(date, style);
            },
          ),
        );
      },
    );
  }
}
