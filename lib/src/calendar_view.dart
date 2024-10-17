import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/calendar_layout_delegate.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarView<T extends Object?> extends StatefulWidget {
  /// The [EventsController] that will be used to populate the events in the calendar view.
  final EventsController<T> eventsController;

  /// The [CalendarController] that is used to control the calendar view.
  final CalendarController<T> calendarController;

  /// The [ViewConfiguration] that will be used to render the calendar view.
  final ViewConfiguration viewConfiguration;

  /// The [CalendarCallbacks] used by the [CalendarView]
  final CalendarCallbacks<T>? callbacks;

  /// The components and styles used by the calendar.
  ///
  /// Components: [MultiDayComponents], [MonthComponents]
  /// Styles: [MultiDayComponentStyles], [MonthComponentStyles]
  final CalendarComponents? components;

  /// The header widget that will be displayed above the body.
  final Widget? header;

  /// The body widget that will be displayed below the header.
  final Widget? body;

  /// Creates a [CalendarView] widget.
  ///
  /// This widget creates a [ViewController] based on the [viewConfiguration].
  /// It then attaches the [ViewController] to the [calendarController].
  const CalendarView({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.viewConfiguration,
    this.callbacks,
    this.components,
    this.header,
    this.body,
  });

  @override
  State<CalendarView<T>> createState() => _CalendarViewState<T>();
}

class _CalendarViewState<T> extends State<CalendarView<T>> {
  /// The [ViewController] that will be used by the children of the [CalendarView].
  late ViewController<T> _viewController;

  @override
  void initState() {
    super.initState();
    _viewController = _createViewController();

    // Attach the view controller when the widget is initialized.
    widget.calendarController.attach(_viewController);
  }

  @override
  void didUpdateWidget(covariant CalendarView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the view configuration has changed, recreate the view controller.
    if (widget.viewConfiguration != oldWidget.viewConfiguration) {
      setState(() {
        final initialDate = _viewController.visibleDateTimeRange.value.start;
        _viewController = _createViewController(initialDate: initialDate);
        widget.calendarController.attach(_viewController);
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    // Detach the view controller when the widget is deactivated.
    widget.calendarController.detach();
  }

  @override
  void activate() {
    super.activate();
    // Reattach the view controller when the widget is reactivated.
    widget.calendarController.attach(_viewController);
  }

  /// Create the [ViewController] based on the [ViewConfiguration].
  ViewController<T> _createViewController({DateTime? initialDate}) {
    final viewConfiguration = widget.viewConfiguration;

    return switch (viewConfiguration.runtimeType) {
      MultiDayViewConfiguration => MultiDayViewController<T>(
          viewConfiguration: viewConfiguration as MultiDayViewConfiguration,
          visibleDateTimeRange: widget.calendarController.visibleDateTimeRange,
          visibleEvents: widget.calendarController.visibleEvents,
          initialDate: widget.calendarController.initialDate,
        ),
      MonthViewConfiguration => MonthViewController<T>(
          viewConfiguration: viewConfiguration as MonthViewConfiguration,
          visibleEvents: widget.calendarController.visibleEvents,
          initialDate: widget.calendarController.initialDate,
        ),
      _ => throw ErrorHint('Unsupported ViewConfiguration'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bodyId = widget.body == null ? null : 1;
    final headerId = widget.header == null ? null : 0;

    return CalendarProvider<T>(
      eventsController: widget.eventsController,
      calendarController: widget.calendarController,
      callbacks: widget.callbacks,
      components: widget.components,
      child: CustomMultiChildLayout(
        delegate: CalendarLayoutDelegate(headerId, bodyId),
        children: [
          if (bodyId != null)
            LayoutId(
              id: bodyId,
              child: widget.body!,
            ),
          if (headerId != null)
            LayoutId(
              id: headerId,
              child: widget.header!,
            ),
        ],
      ),
    );
  }
}
