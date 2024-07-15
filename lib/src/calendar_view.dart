import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/type_definitions.dart';

/// The callbacks used by the [MultiDayBody].
class CalendarCallbacks<T extends Object?> {
  final OnEventTapped<T>? onEventTapped;
  final OnEventChanged<T>? onEventChanged;
  final OnEventCreated? onEventCreated;
  final OnPageChanged? onPageChanged;

  const CalendarCallbacks({
    this.onEventTapped,
    this.onEventChanged,
    this.onEventCreated,
    this.onPageChanged,
  });
}

class CalendarView<T extends Object?> extends StatefulWidget {
  /// The [EventsController] that will be used by the [CalendarView].
  final EventsController<T> eventsController;

  /// The [CalendarController] that will be used by the [CalendarView].
  final CalendarController<T> calendarController;

  /// The [ViewConfiguration] that will be used by the [CalendarView].
  final ViewConfiguration viewConfiguration;

  final CalendarCallbacks<T>? callbacks;

  /// The header widget that will be displayed above the body.
  final Widget? header;

  /// The body widget that will be displayed below the header.
  final Widget? body;

  const CalendarView({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.viewConfiguration,
    this.callbacks,
    this.header,
    this.body,
  });

  @override
  State<CalendarView<T>> createState() => _CalendarViewState<T>();
}

class _CalendarViewState<T> extends State<CalendarView<T>> {
  late ViewController<T> _viewController;

  @override
  void initState() {
    super.initState();
    _viewController = _createViewController();
    widget.calendarController.attach(_viewController);
  }

  @override
  void didUpdateWidget(covariant CalendarView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewConfiguration != oldWidget.viewConfiguration) {
      setState(() {
        _viewController = _createViewController();
        widget.calendarController.attach(_viewController);
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.calendarController.detach();
  }

  @override
  void activate() {
    super.activate();
    widget.calendarController.attach(_viewController);
  }

  ViewController<T> _createViewController() {
    final viewConfiguration = widget.viewConfiguration;

    return switch (viewConfiguration.runtimeType) {
      MultiDayViewConfiguration => MultiDayViewController<T>(
          viewConfiguration: viewConfiguration as MultiDayViewConfiguration,
        ),
      MonthViewConfiguration => MonthViewController<T>(
          viewConfiguration: viewConfiguration as MonthViewConfiguration,
        ),
      _ => throw ErrorHint('Unsupported ViewConfiguration'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CalendarProvider<T>(
      eventsController: widget.eventsController,
      calendarController: widget.calendarController,
      callbacks: widget.callbacks,
      child: Column(
        children: [
          if (widget.header != null) widget.header!,
          if (widget.body != null) Expanded(child: widget.body!),
        ],
      ),
    );
  }
}
