import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarProvider<T extends Object?> extends InheritedWidget {
  /// The [EventsController] that will be used by the Calendar.
  final EventsController<T> eventsController;

  /// The [CalendarController] that will be used by the Calendar.
  final CalendarController<T> calendarController;

  /// The [CalendarCallbacks] that will be used by the Calendar.
  final CalendarCallbacks<T>? callbacks;

  /// Components used by the CalendarView.
  final CalendarComponents? components;

  /// The [ViewController] used by the [CalendarController] to controller this view.
  ViewController get viewController {
    final viewController = calendarController.viewController;
    if (viewController == null) throw ErrorHint('Calendar not attached');
    return viewController;
  }

  /// The [ViewConfiguration] used by the [ViewController].
  ViewConfiguration get viewConfiguration => viewController.viewConfiguration;

  const CalendarProvider({
    required this.calendarController,
    required this.eventsController,
    required this.callbacks,
    required this.components,
    required super.child,
    super.key,
  });

  static CalendarProvider<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarProvider<T>>();
  }

  static CalendarProvider<T> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    assert(result != null, 'No CalendarProvider of <$T> found.');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant CalendarProvider<T> oldWidget) {
    return false;
  }
}
