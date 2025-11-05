import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions/internal.dart';

/// A widget that positions a time indicator to follow the current page position.
///
/// The [PositionedTimeIndicator] calculates the position of a time indicator
/// based on the current page offset and positions it accordingly. It's designed
/// to work with multi-day calendar views where the time indicator needs to
/// track the current day across different pages.
///
/// The widget listens to page offset changes and automatically repositions
/// the time indicator to maintain proper alignment with the current view.
class PositionedTimeIndicator<T extends Object?> extends StatefulWidget {
  /// The [MultiDayViewController] that controls the calendar view.
  ///
  /// This controller provides access to the page offset and view configuration
  /// needed to calculate the time indicator position.
  final MultiDayViewController<T> viewController;

  /// The initial page number to start from.
  final int initialPage;

  /// An optional override for the current time.
  final DateTime? dateOverride;

  /// An optional child widget to display within the positioned indicator.
  final Widget? childOverride;

  /// Creates a [PositionedTimeIndicator].
  const PositionedTimeIndicator({
    super.key,
    required this.viewController,
    required this.initialPage,
    this.dateOverride,
    this.childOverride,
  });

  @override
  State<PositionedTimeIndicator<T>> createState() => _PositionedTimeIndicatorState<T>();
}

/// The state class for [PositionedTimeIndicator].
///
/// This class manages the positioning logic and listens to page offset changes
/// to keep the time indicator properly positioned relative to the current view.
class _PositionedTimeIndicatorState<T extends Object?> extends State<PositionedTimeIndicator<T>> {
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
  ///
  /// This will adjust the calculated left position for RTL layouts.
  double left(double pageWidth, double dayWidth) {
    var left = (pageOffset * pageWidth) + (todayIndex * dayWidth);

    if (Directionality.of(context) == TextDirection.rtl) {
      // In RTL mode, we need to adjust the left position to account for the reversed layout.
      left = pageWidth - (left + dayWidth);
    }

    return left;
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void didUpdateWidget(covariant PositionedTimeIndicator<T> oldWidget) {
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
    viewController = widget.viewController;
    viewController?.pageOffset.addListener(_listener);
    _setupDailyTimer();
    pageOffset = (todayPageNumber - widget.initialPage).toDouble();
  }

  /// Listener callback that triggers a rebuild when the page offset changes.
  ///
  /// This ensures the time indicator position is updated in real-time
  /// as the user scrolls through different pages.
  void _listener() {
    pageOffset = todayPageNumber - widget.viewController.pageOffset.value;

    // If the time indicator is off-screen, we can skip the rebuild to improve performance.
    // We still need to rebuild if the time indicator is within the visibility threshold
    // to ensure it appears/disappears correctly when scrolling into and out of view.
    if (pageOffset < -_visibilityThreshold || pageOffset > _visibilityThreshold) return;

    setState(() {});
  }

  /// Updates the today page number based on the current date.
  void _updatePageNumberAndIndex() {
    final now = (widget.dateOverride?.asUtc.startOfDay) ?? DateTime.now().asUtc.startOfDay;
    final pageNavigation = widget.viewController.viewConfiguration.pageNavigationFunctions;
    todayPageNumber = pageNavigation.indexFromDate(DateTime.now().asUtc, widget.viewController.location);
    final range = pageNavigation.dateTimeRangeFromIndex(todayPageNumber, widget.viewController.location);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final dayWidth = pageWidth / widget.viewController.viewConfiguration.numberOfDays;

        final left = this.left(pageWidth, dayWidth);
        final right = pageWidth - left - dayWidth;

        return Stack(
          children: [
            Positioned.fill(
              left: left,
              right: right,
              top: 0,
              bottom: 0,
              // Hide the time indicator when it's completely off-screen (more than 1 page away)
              child: pageOffset <= -_visibilityThreshold || pageOffset >= _visibilityThreshold
                  ? const SizedBox.shrink()
                  : widget.childOverride ??
                      TimeIndicator.fromContext<T>(
                        context,
                        widget.viewController.viewConfiguration.timeOfDayRange,
                      ),
            ),
          ],
        );
      },
    );
  }
}
