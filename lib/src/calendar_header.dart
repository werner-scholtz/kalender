import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarHeader<T extends Object?> extends StatefulWidget {
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
  final CalendarInteraction? interaction;

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
  State<CalendarHeader<T>> createState() => _CalendarHeaderState<T>();
}

class _CalendarHeaderState<T extends Object?> extends State<CalendarHeader<T>> {
  late CalendarCallbacks? _callbacks;
  late ValueNotifier<CalendarInteraction> _interaction;

  @override
  void initState() {
    super.initState();
    _callbacks = widget.callbacks;
    _interaction = ValueNotifier(widget.interaction ?? CalendarInteraction());
  }

  @override
  void didUpdateWidget(covariant CalendarHeader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.callbacks != widget.callbacks) {
      _callbacks = widget.callbacks;
    }
    if (oldWidget.interaction != widget.interaction) {
      _interaction.value = widget.interaction ?? CalendarInteraction();
    }
  }

  @override
  void dispose() {
    _interaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewController = context.calendarController<T>().viewController;
    return Callbacks(
      callbacks: _callbacks ?? context.callbacks<T>(),
      child: switch (viewController) {
        MultiDayViewController<T>() => Interaction(
            notifier: _interaction,
            child: TileComponentProvider(
              tileComponents: widget.multiDayTileComponents ?? TileComponents.defaultComponents<T>(),
              child: MultiDayHeader<T>(configuration: widget.multiDayHeaderConfiguration),
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
