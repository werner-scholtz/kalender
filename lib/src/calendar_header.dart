import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarHeader<T extends Object?> extends StatefulWidget {
  final EventsController<T>? eventsController;
  final CalendarController<T>? calendarController;

  /// The callbacks used by the [CalendarBody].
  ///
  /// This provides a way to override the [CalendarCallbacks] passed to the [CalendarView].
  final CalendarCallbacks<T>? callbacks;

  /// MultiDay

  /// The [MultiDayHeaderConfiguration] that will be used by the [MultiDayHeader].
  final MultiDayHeaderConfiguration<T>? multiDayHeaderConfiguration;

  /// The tile components used by the [MultiDayHeader].
  final TileComponents<T>? multiDayTileComponents;

  /// The interaction notifier used by the [MultiDayHeader].
  final ValueNotifier<CalendarInteraction>? interaction;

  /// Month

  /// Creates a CalendarHeader widget.
  ///
  /// This creates the correct header based on the [ViewController] inside the [CalendarController]
  /// - [MultiDayHeader]
  /// - [MonthHeader]
  /// - [ScheduleHeader]
  ///
  const CalendarHeader({
    super.key,
    required this.multiDayTileComponents,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    this.multiDayHeaderConfiguration,
    this.interaction,
  });

  @override
  State<CalendarHeader<T>> createState() => _CalendarHeaderState<T>();
}

class _CalendarHeaderState<T extends Object?> extends State<CalendarHeader<T>> {
  @override
  Widget build(BuildContext context) {
    late final provider = CalendarProvider.maybeOf<T>(context);
    final viewController = widget.calendarController?.viewController ?? provider?.viewController;

    assert(
      viewController != null,
      'The $CalendarController<$T> must have a $ViewController<$T> attached to it. \n'
      'If you are using the $CalendarController<$T> directly, make sure to attach a $ViewController<$T> to it.',
    );

    if (viewController is MultiDayViewController<T>) {
      return MultiDayHeader<T>(
        eventsController: widget.eventsController,
        calendarController: widget.calendarController,
        callbacks: widget.callbacks,
        tileComponents: widget.multiDayTileComponents,
        configuration: widget.multiDayHeaderConfiguration,
        interaction: widget.interaction,
      );
    } else if (viewController is MonthViewController<T>) {
      return MonthHeader<T>(
        calendarController: widget.calendarController,
      );
    } else if (viewController is ScheduleViewController<T>) {
      return ScheduleHeader<T>();
    } else {
      throw UnimplementedError();
    }
  }
}
