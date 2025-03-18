import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarHeader<T extends Object?> extends StatelessWidget {
  final EventsController<T>? eventsController;
  final CalendarController<T>? calendarController;

  /// The callbacks used by the [CalendarBody].
  ///
  /// This provides a way to override the [CalendarCallbacks] passed to the [CalendarView].
  final CalendarCallbacks<T>? callbacks;

  /// MultiDay

  /// The [MultiDayHeaderConfiguration] that will be used by the [MultiDayHeader].
  final MultiDayHeaderConfiguration? multiDayHeaderConfiguration;

  /// The tile components used by the [MultiDayHeader].
  final TileComponents<T> multiDayTileComponents;

  /// Month

  /// Creates a CalendarHeader widget.
  ///
  /// This creates the correct header based on the [ViewController] inside the [CalendarController]
  /// - [MultiDayHeader]
  /// - [MonthHeader]
  ///
  const CalendarHeader({
    super.key,
    required this.multiDayTileComponents,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    this.multiDayHeaderConfiguration,
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
      );
    } else if (viewController is MonthViewController<T>) {
      return MonthHeader<T>(
        calendarController: calendarController,
      );
    } else {
      throw UnimplementedError();
    }
  }
}
