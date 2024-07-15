import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/components/month_styles.dart';
import 'package:kalender/src/models/components/multi_day_styles.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarHeader<T extends Object?> extends StatelessWidget {
  final EventsController<T>? eventsController;
  final CalendarController<T>? calendarController;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> multiDayTileComponents;
  final MultiDayHeaderComponents? multiDayHeaderComponents;
  final MultiDayHeaderComponentStyles? multiDayHeaderComponentStyles;
  final MonthHeaderComponents? monthHeaderComponents;
  final MonthHeaderComponentStyles? monthHeaderComponentStyles;
  final MultiDayHeaderConfiguration? multiDayHeaderConfiguration;

  const CalendarHeader({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.multiDayTileComponents,
    this.monthHeaderComponents,
    this.monthHeaderComponentStyles,
    this.multiDayHeaderConfiguration,
    this.multiDayHeaderComponents,
    this.multiDayHeaderComponentStyles,
  });

  @override
  Widget build(BuildContext context) {
    late final provider = CalendarProvider.maybeOf<T>(context);
    final viewController = calendarController?.viewController ?? provider?.viewController;

    assert(
      viewController != null,
      'The $CalendarController<$T> must have a $ViewController<$T> attached to it. \n'
      'If you are using the $CalendarController<$T> directly, make sure to attach a $ViewController<$T> to it.',
    );

    if (viewController is MultiDayViewController<T>) {
      return MultiDayHeader<T>(
        eventsController: eventsController,
        calendarController: calendarController,
        callbacks: callbacks,
        tileComponents: multiDayTileComponents,
        configuration: multiDayHeaderConfiguration,
        components: multiDayHeaderComponents,
      );
    } else if (viewController is MonthViewController<T>) {
      return MonthHeader<T>(
        calendarController: calendarController,
        components: monthHeaderComponents,
        styles: monthHeaderComponentStyles,
      );
    } else {
      throw UnimplementedError();
    }
  }
}
