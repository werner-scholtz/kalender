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
    required this.multiDayTileComponents,
    this.callbacks,
    this.multiDayHeaderConfiguration,
    this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.provider<T>();
    final viewController = provider.viewController;
    final callbacks = this.callbacks ?? provider.callbacks;
    final interaction = this.interaction ?? ValueNotifier(CalendarInteraction());

    return switch (viewController) {
      MultiDayViewController<T>() => HeaderProvider<T>(
          callbacks: callbacks,
          tileComponents: multiDayTileComponents ?? TileComponents.defaultComponents<T>(),
          interaction: interaction,
          child: MultiDayHeader<T>(
            configuration: multiDayHeaderConfiguration,
          ),
        ),
      MonthViewController<T>() => HeaderProvider<T>(
          callbacks: callbacks,
          tileComponents: TileComponents.defaultComponents<T>(),
          interaction: interaction,
          child: MonthHeader<T>(),
        ),
      ScheduleViewController<T>() => HeaderProvider<T>(
          callbacks: callbacks,
          tileComponents: TileComponents.defaultComponents<T>(),
          interaction: interaction,
          child: ScheduleHeader<T>(),
        ),
      _ => throw ErrorHint(
          'Unsupported ViewController type: ${viewController.runtimeType}. '
          'Make sure to use the correct CalendarHeader for the ViewController.',
        )
    };
  }
}
