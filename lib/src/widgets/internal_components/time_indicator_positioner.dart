import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A widget that positions a time indicator to follow the current page position.
///
/// The [TimeIndicatorPositioner] calculates the position of a time indicator
/// based on the current page offset and positions it accordingly. It's designed
/// to work with multi-day calendar views where the time indicator needs to
/// track the current day across different pages.
///
/// The widget listens to page offset changes and automatically repositions
/// the time indicator to maintain proper alignment with the current view.
class TimeIndicatorPositioner<T extends Object?> extends StatefulWidget {
  /// The [MultiDayViewController] that controls the calendar view.
  ///
  /// This controller provides access to the page offset and view configuration
  /// needed to calculate the time indicator position.
  final MultiDayViewController<T> viewController;

  /// The widget to be positioned as the time indicator.
  ///
  /// This is typically a visual representation of the current time,
  /// such as a line or marker that shows the current time of day.
  final Widget child;

  /// The width of a single day column in the calendar view.
  ///
  /// This value is used to calculate the precise positioning of the
  /// time indicator within the day column.
  final double dayWidth;

  /// The total width of a single page in the calendar view.
  ///
  /// This represents the full width of the viewport and is used
  /// to calculate page-relative positioning.
  final double pageWidth;

  /// The initial page number to start from.
  final int initialPage;

  /// An optional override for the current time.
  final DateTime? dateOverride;

  /// Creates a [TimeIndicatorPositioner].
  const TimeIndicatorPositioner({
    super.key,
    required this.viewController,
    required this.child,
    required this.dayWidth,
    required this.pageWidth,
    required this.initialPage,
    this.dateOverride,
  });

  @override
  State<TimeIndicatorPositioner<T>> createState() => _TimeIndicatorPositionerState<T>();
}

/// The state class for [TimeIndicatorPositioner].
///
/// This class manages the positioning logic and listens to page offset changes
/// to keep the time indicator properly positioned relative to the current view.
class _TimeIndicatorPositionerState<T extends Object?> extends State<TimeIndicatorPositioner<T>> {
  /// The [MultiDayViewController] that controls the calendar view.
  MultiDayViewController<T>? viewController;

  /// The threshold for hiding the time indicator when it's off-screen.
  ///
  /// When the page offset is beyond this threshold (in either direction),
  /// the time indicator will be hidden to improve performance.
  static const double _visibilityThreshold = 1.0;

  /// Timer that triggers daily updates at midnight.
  Timer? _dailyUpdateTimer;

  /// The page number that contains today's date.
  ///
  /// This is calculated once during initialization and used as a reference
  /// point for positioning the time indicator.
  late int todayPageNumber;

  /// The index of today's date on the page that contains it.
  late int todayIndex;

  /// The current page offset relative to today's page.
  ///
  /// This value represents how far the current view has scrolled from
  /// the page containing today's date. A value of 0 means today's page
  /// is fully visible, positive values mean we're viewing future dates,
  /// and negative values mean we're viewing past dates.
  late double pageOffset;

  /// The calculated left position for the time indicator.
  ///
  /// This position is calculated based on the page offset and page width,
  /// determining where the time indicator should be positioned horizontally
  /// to align with the current day column.
  double get left => (pageOffset * widget.pageWidth) + (todayIndex * widget.dayWidth);

  @override
  void initState() {
    _setup();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimeIndicatorPositioner<T> oldWidget) {
    _setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _dailyUpdateTimer?.cancel();
    super.dispose();
  }

  /// Sets up the initial state of the time indicator positioner.
  void _setup() {
    viewController?.pageOffset.removeListener(_listener);
    this.viewController = widget.viewController;
    viewController?.pageOffset.addListener(_listener);
    _setupDailyTimer();
    pageOffset = (todayPageNumber - widget.initialPage).toDouble();
  }

  /// Listener callback that triggers a rebuild when the page offset changes.
  ///
  /// This ensures the time indicator position is updated in real-time
  /// as the user scrolls through different pages.
  void _listener() {
    // If the time indicator is off-screen, we can skip the rebuild to improve performance.
    // We still need to rebuild if the time indicator is within the visibility threshold
    // to ensure it appears/disappears correctly when scrolling into and out of view.
    if (pageOffset < -_visibilityThreshold || pageOffset > _visibilityThreshold) return;

    setState(() {
      // Update the page offset.
      pageOffset = todayPageNumber - widget.viewController.pageOffset.value;
    });
  }

  /// Updates the today page number based on the current date.
  void _updatePageNumberAndIndex() {
    final now = (widget.dateOverride?.asUtc.startOfDay) ?? DateTime.now().asUtc.startOfDay;
    final pageNavigation = widget.viewController.viewConfiguration.pageNavigationFunctions;
    todayPageNumber = pageNavigation.indexFromDate(DateTime.now().asUtc);
    final range = pageNavigation.dateTimeRangeFromIndex(todayPageNumber);
    todayIndex = range.dates().indexOf(now);
  }

  /// Sets up a timer that triggers every day at midnight to update the today page number.
  void _setupDailyTimer() {
    // Cancel any existing timer to avoid multiple timers running simultaneously
    _dailyUpdateTimer?.cancel();

    // Update the today page number immediately.
    _updatePageNumberAndIndex();

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    // Set up the first timer to trigger at the next midnight
    _dailyUpdateTimer = Timer(timeUntilMidnight, () {
      _updatePageNumberAndIndex();
      // Update the page offset to reflect the new today page
      pageOffset = todayPageNumber - widget.viewController.pageOffset.value;
      if (mounted) {
        setState(() {});
      }

      // Set up recurring daily timer
      _dailyUpdateTimer = Timer.periodic(const Duration(days: 1), (_) {
        _updatePageNumberAndIndex();
        pageOffset = todayPageNumber - widget.viewController.pageOffset.value;
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: left,
      right: widget.pageWidth - (left + widget.dayWidth),
      top: 0,
      bottom: 0,
      // Hide the time indicator when it's completely off-screen (more than 1 page away)
      child: pageOffset <= -_visibilityThreshold || pageOffset >= _visibilityThreshold
          ? const SizedBox.shrink()
          : widget.child,
    );
  }
}
