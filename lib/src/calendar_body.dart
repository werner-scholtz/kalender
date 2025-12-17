import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The calendar body, is a generic widget that creates the relevant widget based on the [ViewController].
class CalendarBody<T extends Object?> extends StatefulWidget {
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
  final HorizontalConfiguration<T>? monthBodyConfiguration;

  /// The tile components used by the [ScheduleBody].
  final ScheduleTileComponents<T>? scheduleTileComponents;

  /// The configuration used by the schedule body.
  final ScheduleBodyConfiguration? scheduleBodyConfiguration;

  /// The [CalendarInteraction] that will be used by the [CalendarBody].
  final CalendarInteraction? interaction;

  /// The snapping that will be used by the [CalendarBody].
  final CalendarSnapping? snapping;

  /// Creates a CalendarBody widget.
  ///
  /// This creates the correct body based on the [ViewController] inside the [CalendarController]
  /// - [MultiDayBody]
  /// - [MonthBody]
  /// - [ScheduleBody]
  ///
  const CalendarBody({
    super.key,
    this.callbacks,
    this.interaction,
    this.snapping,
    this.multiDayTileComponents,
    this.multiDayBodyConfiguration,
    this.monthTileComponents,
    this.monthBodyConfiguration,
    this.scheduleTileComponents,
    this.scheduleBodyConfiguration,
  });

  @override
  State<CalendarBody<T>> createState() => _CalendarBodyState<T>();
}

class _CalendarBodyState<T extends Object?> extends State<CalendarBody<T>> {
  late CalendarCallbacks<T>? _callbacks;
  late ValueNotifier<CalendarInteraction> _interaction;
  late ValueNotifier<CalendarSnapping> _snapping;

  @override
  void initState() {
    super.initState();
    _callbacks = widget.callbacks;
    _interaction = ValueNotifier(widget.interaction ?? CalendarInteraction());
    _snapping = ValueNotifier(widget.snapping ?? const CalendarSnapping());
  }

  @override
  void didUpdateWidget(covariant CalendarBody<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.callbacks != widget.callbacks) {
      _callbacks = widget.callbacks;
    }
    if (oldWidget.interaction != widget.interaction) {
      _interaction.value = widget.interaction ?? CalendarInteraction();
    }
    if (oldWidget.snapping != widget.snapping) {
      _snapping.value = widget.snapping ?? const CalendarSnapping();
    }
  }

  @override
  void dispose() {
    _interaction.dispose();
    _snapping.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewController = context.calendarController<T>().viewController;
    return Callbacks<T>(
      callbacks: _callbacks ?? context.callbacks<T>(),
      child: Interaction(
        notifier: _interaction,
        child: switch (viewController) {
          MultiDayViewController<T>() => TileComponentProvider<T>(
              tileComponents: widget.multiDayTileComponents ?? TileComponents.defaultComponents<T>(),
              child: HeightPerMinute(
                notifier: viewController.heightPerMinute,
                child: Snapping(
                  notifier: _snapping,
                  child: MultiDayBody<T>(configuration: widget.multiDayBodyConfiguration),
                ),
              ),
            ),
          MonthViewController<T>() => TileComponentProvider<T>(
              tileComponents: widget.monthTileComponents ?? TileComponents.defaultComponents<T>(),
              child: MonthBody<T>(configuration: widget.monthBodyConfiguration),
            ),
          ScheduleViewController<T>() => TileComponentProvider<T>(
              tileComponents: widget.scheduleTileComponents ?? ScheduleTileComponents.defaultComponents<T>(),
              child: ScheduleBody<T>(configuration: widget.scheduleBodyConfiguration),
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
