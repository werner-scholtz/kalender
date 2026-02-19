import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The month header is a simple widget that just displays the day names.
class MonthHeader<T extends Object?> extends StatelessWidget {
  /// Creates a new [MonthHeader].
  const MonthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController<T>();

    assert(
      calendarController.viewController is MonthViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    // final viewController = calendarController.viewController as MonthViewController<T>;
    final calendarComponents = context.components<T>();
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
              final date = visibleDateTimeRange.start.add(Duration(days: index));
              return components.weekDayHeaderBuilder.call(date, style);
            },
          ),
        );
      },
    );
  }
}
