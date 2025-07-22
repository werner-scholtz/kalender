import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarHeader<T extends Object?> extends StatelessWidget {
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
    this.multiDayTileComponents,
    this.multiDayHeaderConfiguration,
    this.callbacks,
    this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.provider<T>();
    final viewController = context.calendarController<T>().viewController;
    final callbacks = this.callbacks ?? provider.callbacks;
    final interaction = this.interaction ?? ValueNotifier(CalendarInteraction());

    return Callbacks(
      callbacks: callbacks,
      child: switch (viewController) {
        MultiDayViewController<T>() => Interaction(
            notifier: interaction,
            child: TileComponentProvider(
              tileComponents: multiDayTileComponents ?? TileComponents.defaultComponents<T>(),
              child: MultiDayHeader<T>(configuration: multiDayHeaderConfiguration),
            ),
          ),
        MonthViewController<T>() => MonthHeader<T>(),
        ScheduleViewController<T>() => ScheduleHeader<T>(),
        _ => throw ErrorHint(
            'Unsupported ViewController type: ${viewController.runtimeType}. '
            'Make sure to use the correct CalendarHeader for the ViewController.',
          )
      },
    );
  }
}
