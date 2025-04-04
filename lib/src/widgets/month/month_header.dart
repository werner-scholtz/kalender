import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The month header is a simple widget that just displays the day names.
class MonthHeader<T extends Object?> extends StatelessWidget {
  /// The [CalendarController] that will be used by the [MonthBody].
  final CalendarController<T>? calendarController;

  /// Creates a new [MonthHeader].
  const MonthHeader({super.key, this.calendarController});

  @override
  Widget build(BuildContext context) {
    final provider = CalendarProvider.maybeOf<T>(context);
    final calendarController = this.calendarController ?? CalendarProvider.calendarControllerOf(context);

    assert(
      calendarController.viewController is MonthViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    final viewController = calendarController.viewController as MonthViewController<T>;

    final calendarComponents = provider?.components;
    final styles = calendarComponents?.monthComponentStyles?.headerStyles;
    final components = calendarComponents?.monthComponents?.headerComponents;

    return ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, visibleDateTimeRange, child) {
        final style = styles?.weekDayHeaderStyle;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List<Widget>.generate(
            7,
            (index) {
              final date = visibleDateTimeRange.start.addDays(index);
              return components?.weekDayHeaderBuilder?.call(date, style) ?? WeekDayHeader(date: date, style: style);
            },
          ),
        );
      },
    );
  }
}
