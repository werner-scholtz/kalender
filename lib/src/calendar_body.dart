import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The calendar body, is a generic widget that creates the relevant widget based on the [ViewController].
class CalendarBody<T extends Object?> extends StatelessWidget {
  final EventsController<T>? eventsController;
  final CalendarController<T>? calendarController;

  /// The callbacks used by the [CalendarBody].
  ///
  /// This provides a way to override the [CalendarCallbacks] passed to the [CalendarView].
  final CalendarCallbacks<T>? callbacks;

  /// The tile components used by the [MultiDayBody].
  final TileComponents<T> multiDayTileComponents;

  /// The components used by the [MultiDayBody].
  final MultiDayBodyComponents? multiDayBodyComponents;

  /// The styles of the components used by the [MultiDayBody].
  final MultiDayBodyComponentStyles? multiDayBodyComponentStyles;

  /// The [MultiDayBodyConfiguration] that will be used by the [MultiDayBody].
  final MultiDayBodyConfiguration? multiDayBodyConfiguration;

  /// The tile components used by the [MonthBody] and [MultiDayHeader].
  final TileComponents<T> monthTileComponents;

  /// The components used by the [MonthBody].
  final MonthBodyComponents? monthBodyComponents;

  /// The styles of the components used by the [MonthBody].
  final MonthBodyComponentStyles? monthBodyComponentStyles;

  /// The [MultiDayHeaderConfiguration] that will be used by the [MonthBody].
  final MultiDayHeaderConfiguration? monthBodyConfiguration;

  /// Creates a CalendarBody widget.
  ///
  /// This creates the correct body based on the [ViewController] inside the [CalendarController]
  /// - [MultiDayBody]
  /// - [MonthBody]
  /// - TODO: add schedule view.
  ///
  const CalendarBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.multiDayTileComponents,
    this.multiDayBodyConfiguration,
    this.multiDayBodyComponents,
    this.multiDayBodyComponentStyles,
    required this.monthTileComponents,
    this.monthBodyConfiguration,
    this.monthBodyComponents,
    this.monthBodyComponentStyles,
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
      return MultiDayBody<T>(
        eventsController: eventsController,
        calendarController: calendarController,
        configuration: multiDayBodyConfiguration,
        callbacks: callbacks,
        tileComponents: multiDayTileComponents,
        components: multiDayBodyComponents,
        componentStyles: multiDayBodyComponentStyles,
      );
    } else if (viewController is MonthViewController<T>) {
      return MonthBody<T>(
        eventsController: eventsController,
        calendarController: calendarController,
        callbacks: callbacks,
        tileComponents: monthTileComponents,
        configuration: monthBodyConfiguration,
        components: monthBodyComponents,
        styles: monthBodyComponentStyles,
      );
    } else {
      throw UnimplementedError();
    }
  }
}
