import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/navigation_triggers.dart';

/// TODO: remove this provider as well,

/// The [InheritedWidget] that contains the internals of the [MultiDayBody].
///
/// This widget is used to pass the configuration and controllers down the widget tree.
class MultiDayBodyDayProvider<T extends Object?> extends InheritedWidget {
  /// The [EventsController] that will be used to control the events.
  final EventsController<T> eventsController;

  /// The [CalendarCallbacks] that will be used to control the calendar.
  final CalendarCallbacks<T>? callbacks;

  /// The [MultiDayViewController] that will be used to control the view.
  final MultiDayViewController<T> viewController;

  /// The components that will be displayed in the [MultiDayBody].
  final MultiDayBodyComponents? components;

  /// The tile components that will be displayed in the [MultiDayBody].
  final TileComponents<T> tileComponents;

  /// The styles of the components.
  final MultiDayBodyComponentStyles? componentStyles;

  /// The [ValueNotifier] that contains the size of the feedback widget.
  final ValueNotifier<Size> feedbackWidgetSize;

  /// The height of the viewport.
  final double viewportHeight;

  /// The width of the page.
  final double pageWidth;

  /// The width of a day.
  final double dayWidth;

  final MultiDayBodyConfiguration bodyConfiguration;

  /// The [MultiDayViewConfiguration] that will be used to display the [MultiDayBody].
  MultiDayViewConfiguration get viewConfiguration =>
      viewController.viewConfiguration;

  /// The [DateTimeRange] that is currently visible.
  ValueNotifier<DateTimeRange> get visibleDateTimeRange =>
      viewController.visibleDateTimeRange;

  /// The [PageController] that will be used to control the pages.
  PageController get pageController => viewController.pageController;

  /// The [ScrollController] that will be used to control the scrolling.
  ScrollController get scrollController => viewController.scrollController;

  /// The [ValueNotifier] that contains the height per minute.
  ValueNotifier<double> get heightPerMinute => viewController.heightPerMinute;

  /// The value of the [heightPerMinute].
  double get heightPerMinuteValue => heightPerMinute.value;

  /// The number of pages that can be displayed by the [PageView].
  int get numberOfPages => viewController.numberOfPages;

  /// The [TimeOfDayRange] that can be displayed.
  TimeOfDayRange get timeOfDayRange => viewConfiguration.timeOfDayRange;

  /// The [DateTime] that marks the start of the display range.
  DateTime get displayRangeStart => viewConfiguration.start;

  /// The width of the timeline.
  double get timelineWidth => viewConfiguration.timelineWidth;

  /// Whether to show all events in the [MultiDayBody].
  bool get showAllEvents => bodyConfiguration.showMultiDayEvents;

  /// The [PageTriggerConfiguration] that will be used to control the page triggers.
  PageTriggerConfiguration get pageTriggerConfiguration =>
      bodyConfiguration.pageTriggerConfiguration;

  /// The [ScrollTriggerConfiguration] that will be used to control the scroll triggers.
  ScrollTriggerConfiguration get scrollTriggerConfiguration =>
      bodyConfiguration.scrollTriggerConfiguration;

  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged =>
      viewController.eventBeingDragged;

  /// Creates a new [MultiDayBodyDayProvider].
  const MultiDayBodyDayProvider({
    required super.child,
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.feedbackWidgetSize,
    required this.components,
    required this.componentStyles,
    required this.viewportHeight,
    required this.pageWidth,
    required this.dayWidth,
    required this.callbacks,
    required this.tileComponents,
    required this.bodyConfiguration,
  });

  static MultiDayBodyDayProvider<T>? maybeOf<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MultiDayBodyDayProvider<T>>();
  }

  static MultiDayBodyDayProvider<T> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    assert(result != null, 'No $MultiDayBodyDayProvider<$T> found.');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant MultiDayBodyDayProvider oldWidget) {
    return false;
  }
}
