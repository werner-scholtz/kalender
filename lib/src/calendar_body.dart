import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The calendar body, is a generic widget that creates the relevant widget based on the [ViewController].
class CalendarBody<T extends Object?> extends StatelessWidget {
  @Deprecated('This will be removed in the future, use CalendarProvider instead.')
  final EventsController<T>? eventsController;
  @Deprecated('This will be removed in the future, use CalendarProvider instead.')
  final CalendarController<T>? calendarController;

  /// The callbacks used by the [CalendarBody].
  ///
  /// This provides a way to override the [CalendarCallbacks] passed to the [CalendarView].
  final CalendarCallbacks<T>? callbacks;

  /// The tile components used by the [MultiDayBody].
  final TileComponents<T>? multiDayTileComponents;

  /// The [MultiDayBodyConfiguration] that will be used by the [MultiDayBody].
  final MultiDayBodyConfiguration? multiDayBodyConfiguration;

  /// The tile components used by the [MonthBody] and [MultiDayHeader].
  /// TODO: convert to MonthTileCompoenents.
  final TileComponents<T>? monthTileComponents;

  /// The [MultiDayHeaderConfiguration] that will be used by the [MonthBody].
  final MultiDayHeaderConfiguration<T>? monthBodyConfiguration;

  /// The tile components used by the [ScheduleBody].
  final ScheduleTileComponents<T>? scheduleTileComponents;

  /// The configuration used by the schedule body.
  final ScheduleBodyConfiguration? scheduleBodyConfiguration;

  /// The [CalendarInteraction] that will be used by the [CalendarBody].
  final ValueNotifier<CalendarInteraction>? interaction;

  /// The snapping that will be used by the [CalendarBody].
  final ValueNotifier<CalendarSnapping>? snapping;

  /// The height per minute used by the [CalendarBody].
  final ValueNotifier<double>? heightPerMinute;

  /// Creates a CalendarBody widget.
  ///
  /// This creates the correct body based on the [ViewController] inside the [CalendarController]
  /// - [MultiDayBody]
  /// - [MonthBody]
  /// - [ScheduleBody]
  ///
  const CalendarBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    this.interaction,
    this.snapping,
    this.heightPerMinute,
    this.multiDayTileComponents,
    this.multiDayBodyConfiguration,
    this.monthTileComponents,
    this.monthBodyConfiguration,
    this.scheduleTileComponents,
    this.scheduleBodyConfiguration,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.provider<T>();
    final viewController = context.calendarController<T>().viewController;
    final callbacks = this.callbacks ?? provider.callbacks;
    final interaction = this.interaction ?? ValueNotifier(CalendarInteraction());
    final snapping = this.snapping ?? ValueNotifier(const CalendarSnapping());

    return Callbacks<T>(
      callbacks: callbacks,
      child: Interaction(
        notifier: interaction,
        child: switch (viewController) {
          MultiDayViewController<T>() => TileComponentProvider<T>(
              tileComponents: multiDayTileComponents ?? TileComponents.defaultComponents<T>(),
              child: HeightPerMinuteProvider(
                notifier: viewController.heightPerMinute,
                child: Snapping(
                  notifier: snapping,
                  child: MultiDayBody<T>(configuration: multiDayBodyConfiguration),
                ),
              ),
            ),
          MonthViewController<T>() => TileComponentProvider<T>(
              tileComponents: monthTileComponents ?? TileComponents.defaultComponents<T>(),
              child: MonthBody<T>(configuration: monthBodyConfiguration),
            ),
          ScheduleViewController<T>() => TileComponentProvider<T>(
              tileComponents: scheduleTileComponents ?? ScheduleTileComponents.defaultComponents<T>(),
              child: ScheduleBody<T>(configuration: scheduleBodyConfiguration),
            ),
          _ => throw ErrorHint(
              'Unsupported ViewController type: ${viewController.runtimeType}. '
              'Make sure to use the correct CalendarBody for the ViewController.',
            ),
        },
      ),
    );
  }
}
