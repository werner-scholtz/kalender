import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarBody<T extends Object?> extends StatelessWidget {
  /// The [EventsController] that will be used by the [CalendarBody].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [CalendarBody].
  final CalendarController<T>? calendarController;

  /// The callbacks used by the [CalendarBody].
  final CalendarCallbacks<T>? callbacks;

  /// The tile components used by the [MultiDayBody].
  final TileComponents<T> tileComponents;

  /// The tile components used by the [MonthBody] and [MultiDayHeader].
  final TileComponents<T> multiDayTileComponents;

  /// The components used by the [MultiDayBody].
  final MultiDayBodyComponents? multiDayBodyComponents;

  /// The styles of the components used by the [MultiDayBody].
  final MultiDayBodyComponentStyles? multiDayBodyComponentStyles;

  /// The [MultiDayBodyConfiguration] that will be used by the [MultiDayBody].
  final MultiDayBodyConfiguration? multiDayBodyConfiguration;

  /// The [MultiDayHeaderConfiguration] that will be used by the [MonthBody].
  final MultiDayHeaderConfiguration? monthBodyConfiguration;

  /// The components used by the [MonthBody].
  final MonthBodyComponents? monthBodyComponents;

  /// The styles of the components used by the [MonthBody].
  final MonthBodyComponentStyles? monthBodyComponentStyles;

  const CalendarBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.tileComponents,
    required this.multiDayTileComponents,
    this.multiDayBodyConfiguration,
    this.monthBodyConfiguration,
    this.multiDayBodyComponents,
    this.multiDayBodyComponentStyles,
    this.monthBodyComponents,
    this.monthBodyComponentStyles,
  });

  @override
  Widget build(BuildContext context) {
    late final provider = CalendarProvider.maybeOf<T>(context);
    final viewController =
        calendarController?.viewController ?? provider?.viewController;

    assert(
      viewController != null,
      'The $CalendarController<$T> must have a $ViewController<$T> attached to it. \n'
      'If you are using the $CalendarController<$T> directly, make sure to attach a $ViewController<$T> to it.',
    );

    if (viewController is MultiDayViewController<T>) {
      return MultiDayBody(
        eventsController: eventsController,
        calendarController: calendarController,
        configuration: multiDayBodyConfiguration,
        callbacks: callbacks,
        tileComponents: tileComponents,
        components: multiDayBodyComponents,
        componentStyles: multiDayBodyComponentStyles,
      );
    } else if (viewController is MonthViewController<T>) {
      return MonthBody(
        eventsController: eventsController,
        calendarController: calendarController,
        callbacks: callbacks,
        tileComponents: multiDayTileComponents,
        configuration: monthBodyConfiguration,
        components: monthBodyComponents,
        styles: monthBodyComponentStyles,
      );
    } else {
      throw UnimplementedError();
    }
  }
}
