import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/navigation_triggers.dart';
import 'package:kalender/src/models/view_configurations/export.dart';

/// The [InheritedWidget] that contains the internals of the [MultiDayBody].
///
/// This widget is used to pass the configuration and controllers down the widget tree.
class MultiDayBodyProvider<T extends Object?> extends InheritedWidget {
  /// The [MultiDayViewConfiguration] that will be used to display the [MultiDayBody].
  final MultiDayViewConfiguration viewConfiguration;

  /// The [DateTimeRange] that is currently visible.
  final ValueNotifier<DateTimeRange> visibleDateTimeRange;

  /// The [ValueNotifier] that contains the size of the feedback widget.
  final ValueNotifier<Size> dropTargetWidgetSize;

  /// The [PageController] that will be used to control the pages.
  final PageController pageController;

  /// The [ScrollPhysics] that will be used to control the page scrolling.
  final ScrollPhysics? pageScrollPhysics;

  /// The [ScrollController] that will be used to control the scrolling.
  final ScrollController scrollController;

  /// The styles of the components.
  final MultiDayBodyComponentStyles? componentStyles;

  /// The height per minute.
  final double heightPerMinute;

  final double viewportHeight;

  /// The width of the page.
  final double pageWidth;

  /// The width of a day.
  final double dayWidth;

  /// The number of pages that can be displayed by the [PageView].
  final int numberOfPages;

  TimeOfDayRange get timeOfDayRange => viewConfiguration.timeOfDayRange;

  DateTime get displayRangeStart => viewConfiguration.start;

  double get timelineWidth => viewConfiguration.timelineWidth;

  bool get showAllEvents => viewConfiguration.showMultiDayEvents;

  PageTriggerConfiguration get pageTriggerConfiguration {
    return viewConfiguration.pageTriggerConfiguration;
  }

  ScrollTriggerConfiguration get scrollTriggerConfiguration {
    return viewConfiguration.scrollTriggerConfiguration;
  }

  /// Creates a new [MultiDayBodyProvider].
  const MultiDayBodyProvider({
    required super.child,
    super.key,
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
    required this.dropTargetWidgetSize,
    required this.scrollController,
    required this.pageController,
    required this.pageScrollPhysics,
    required this.componentStyles,
    required this.heightPerMinute,
    required this.viewportHeight,
    required this.pageWidth,
    required this.dayWidth,
    required this.numberOfPages,
  });

  static MultiDayBodyProvider? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MultiDayBodyProvider>();
  }

  static MultiDayBodyProvider of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No $MultiDayBodyProvider found.');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant MultiDayBodyProvider oldWidget) {
    return false;
  }
}
