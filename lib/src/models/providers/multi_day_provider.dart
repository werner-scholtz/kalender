import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';

class MultiDayProvider<T extends Object?> extends InheritedWidget {
  final EventsController<T> eventsController;
  final MultiDayViewController<T> viewController;
  final TileComponents<T> tileComponents;
  final CalendarCallbacks<T>? callbacks;

  /// The width of the page.
  final double pageWidth;

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

  MultiDayViewConfiguration get viewConfiguration {
    return viewController.viewConfiguration;
  }

  final MultiDayHeaderConfiguration headerConfiguration;

  double get timelineWidth => viewController.viewConfiguration.timelineWidth;
  double get tileHeight => headerConfiguration.tileHeight;

  /// Creates a new [MultiDayProvider].
  const MultiDayProvider({
    required super.child,
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.tileComponents,
    required this.pageWidth,
    required this.dayWidth,
    required this.headerConfiguration,
    this.callbacks,
  });

  static MultiDayProvider<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MultiDayProvider<T>>();
  }

  static MultiDayProvider<T> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    assert(result != null, 'No $MultiDayProvider<$T> found.');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant MultiDayProvider oldWidget) {
    return false;
  }
}
