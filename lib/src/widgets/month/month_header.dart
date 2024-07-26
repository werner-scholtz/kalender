import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

// TODO: document this.
// Maybe give a broad overview of what this widget and how it works.

class MonthHeader<T extends Object?> extends StatelessWidget {
  /// The [CalendarController] that will be used by the [MonthBody].
  final CalendarController<T>? calendarController;

  /// The components used by the [MonthHeader].
  final MonthHeaderComponents? components;

  /// The styles of the components used by the [MonthHeader].
  final MonthHeaderComponentStyles? styles;

  const MonthHeader({
    super.key,
    this.calendarController,
    this.components,
    this.styles,
  });

  @override
  Widget build(BuildContext context) {
    late final provider = CalendarProvider.maybeOf<T>(context);
    var calendarController = this.calendarController;

    if (provider == null) {
      assert(
        calendarController != null,
        'The calendarController needs to be provided when the $MonthHeader<$T> is not wrapped in a $CalendarProvider<$T>.',
      );
    } else {
      calendarController ??= provider.calendarController;
    }

    assert(
      calendarController!.isAttached,
      'The CalendarController needs to be attached to a $ViewController<$T>.',
    );

    assert(
      calendarController!.viewController is MonthViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    final viewController = calendarController!.viewController as MonthViewController<T>;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder(
          valueListenable: viewController.visibleDateTimeRange,
          builder: (context, visibleDateTimeRange, child) {
            final style = styles?.weekDayHeaderStyle;

            final days = List<Widget>.generate(
              7,
              (index) {
                final date = visibleDateTimeRange.start.addDays(index);
                return components?.weekDayHeaderBuilder?.call(date, style) ??
                    WeekDayHeader(date: date, style: style);
              },
            );

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...days,
              ],
            );
          },
        );
      },
    );
  }
}
