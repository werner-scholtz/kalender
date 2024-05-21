import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarHeader<T extends Object?> extends StatelessWidget {
  /// The [EventsController] that will be used by the [CalendarHeader].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [CalendarHeader].
  final CalendarController<T>? calendarController;

  /// The callbacks used by the [CalendarHeader].
  final CalendarCallbacks<T>? callbacks;

  /// The tile components used by the [MonthBody] and [MultiDayHeader].
  final TileComponents<T> multiDayTileComponents;

  const CalendarHeader({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.multiDayTileComponents,
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

    return switch (viewController.runtimeType) {
      MultiDayViewController => MultiDayHeader(
          eventsController: eventsController,
          calendarController: calendarController,
          callbacks: callbacks,
          tileComponents: multiDayTileComponents,
        ),
      MonthViewController => MonthHeader(),
      _ => Container(),
    };
  }
}
