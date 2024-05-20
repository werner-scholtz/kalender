import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';

class MonthProvider<T extends Object?> extends InheritedWidget {
  final EventsController<T> eventsController;
  final MonthViewController<T> viewController;
  final TileComponents<T> tileComponents;
  final CalendarCallbacks<T>? callbacks;

  /// The width of the page.
  final double pageWidth;

  /// The height of the page.
  final double pageHeight;

  /// The width of a day.
  final double dayWidth;

  ValueNotifier<Size> get feedbackWidgetSize {
    return eventsController.feedbackWidgetSize;
  }

  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged {
    return viewController.eventBeingDragged;
  }

  ValueNotifier<DateTimeRange> get visibleDateTimeRange {
    return viewController.visibleDateTimeRange;
  }

  DateTimeRange get visibleDateTimeRangeValue {
    return visibleDateTimeRange.value;
  }

  MonthViewConfiguration get viewConfiguration {
    return viewController.viewConfiguration;
  }

  final MultiDayHeaderConfiguration bodyConfiguration;

  double get tileHeight => bodyConfiguration.tileHeight;

  /// Creates a new [MonthProvider].
  const MonthProvider({
    required super.child,
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.tileComponents,
    required this.pageWidth,
    required this.pageHeight,
    required this.dayWidth,
    required this.bodyConfiguration,
    required this.callbacks,
  });

  static MonthProvider<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MonthProvider<T>>();
  }

  static MonthProvider<T> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    assert(result != null, 'No $MonthProvider<$T> found.');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant MonthProvider oldWidget) {
    return false;
  }
}
