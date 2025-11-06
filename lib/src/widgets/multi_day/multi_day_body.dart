import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';
import 'package:kalender/src/widgets/drag_targets/vertical_drag_target.dart';
import 'package:kalender/src/widgets/draggable/day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';
import 'package:kalender/src/widgets/internal_components/timeline_sizer.dart';
import 'package:timezone/timezone.dart';

/// This widget is used to display a multi-day body.
///
/// The multi-day body has two big parts to it:
/// 1. The content:
///   - Static content such as [HourLines] and [TimeLine].
///   - Dynamic content such as the [PageView] which displays:
///     [DaySeparator], [DayDraggable], [MultiDayEventsRow] and the [TimeIndicator]
///
/// 2. The [VerticalDragTarget]
///    This is the drag target for all events that are being modified and how the calendar deals with rescheduling and resizing of events.
class MultiDayBody<T extends Object?> extends StatelessWidget {
  /// The [MultiDayBodyConfiguration] that will be used by the [MultiDayBody].
  final MultiDayBodyConfiguration? configuration;

  /// Creates a new [MultiDayBody].
  ///
  /// This widget is used to display events in a day/week view format.
  ///
  /// This widget is intended to be the body of a [CalendarView].
  const MultiDayBody({
    super.key,
    this.configuration,
  });

  /// The key used to identify the [SingleChildScrollView] of the [MultiDayBody].
  static const singleChildScrollViewKey = ValueKey('singleChildScrollViewKey');

  @override
  Widget build(BuildContext context) {
    final controller = context.calendarController<T>();

    assert(
      controller.viewController is MultiDayViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MultiDayViewController<$T>',
    );

    final viewController = controller.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final timeOfDayRange = viewConfiguration.timeOfDayRange;

    final configuration = this.configuration ?? const MultiDayBodyConfiguration();

    // Calculate the height of the page.
    final pageHeight = context.heightPerMinute * timeOfDayRange.duration.inMinutes;

    return Stack(
      children: [
        Scrollbar(
          controller: viewController.scrollController,
          child: SingleChildScrollView(
            key: singleChildScrollViewKey,
            controller: viewController.scrollController,
            physics: configuration.scrollPhysics,
            child: SizedBox(
              height: pageHeight,
              child: Row(
                children: [
                  // The timeline is always on the left side of the page, but should not scroll with the pageview.
                  SizedBox(height: pageHeight, child: TimeLine.fromContext<T>(context, timeOfDayRange)),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(child: HourLines.fromContext<T>(context, timeOfDayRange)),
                        Positioned.fill(
                          child: MultiDayPage<T>(
                            eventsController: context.eventsController<T>(),
                            viewController: viewController,
                            configuration: configuration,
                            pageHeight: pageHeight,
                          ),
                        ),
                        PositionedTimeIndicator<T>(
                          viewController: viewController,
                          initialPage: viewController.initialPage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // The DayDragTarget is positioned on top of the content.
        // It should not scroll with the content or move with the page view.
        // It should always be positioned at the top of the page.
        Positioned.fill(
          child: Row(
            children: [
              TimelineSizer<T>(child: const SizedBox()),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final pageHeight = constraints.maxHeight;
                    final pageWidth = constraints.maxWidth;
                    final dayWidth = constraints.maxWidth / viewConfiguration.numberOfDays;

                    return SizedBox(
                      height: pageHeight,
                      child: VerticalDragTarget<T>(
                        controller: controller,
                        viewController: viewController,
                        configuration: configuration,
                        pageWidth: pageWidth,
                        dayWidth: dayWidth,
                        viewPortHeight: pageHeight,
                        snapping: context.snappingNotifier,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MultiDayPage<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;

  /// The [MultiDayViewController] that will be used by the [MultiDayPage].
  final MultiDayViewController<T> viewController;

  /// The [MultiDayBodyConfiguration] that will be used by the [MultiDayPage].
  final MultiDayBodyConfiguration configuration;

  /// The height of the page.
  final double pageHeight;

  final Location? initialLocation;
  /// Creates a new [MultiDayPage].
  const MultiDayPage({
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.configuration,
    required this.pageHeight,
    this.initialLocation,
  });

  /// The key used to identify the content of the [MultiDayBody].
  static const contentKey = Key('MultiDayPage-Content');

  @override
  State<MultiDayPage<T>> createState() => _MultiDayPageState<T>();
}

class _MultiDayPageState<T extends Object?> extends State<MultiDayPage<T>> {
  PageNavigationFunctions get _pageNavigation => widget.viewController.viewConfiguration.pageNavigationFunctions;

  @override
  void initState() {
    super.initState();
    _initialPage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.eventsController.addListener(_currentPage);
    });
  }

  @override
  void dispose() {
    widget.eventsController.removeListener(_currentPage);
    super.dispose();
  }

  void _initialPage() => _updateVisibleEvents(widget.viewController.initialPage, widget.initialLocation);
  void _currentPage() => _updateVisibleEvents(widget.viewController.pageController.page?.round() ?? 0, context.location);

  /// Updates the visible events for the given page index.
  void _updateVisibleEvents(int index, Location? location) {
    final events = widget.eventsController.eventsFromDateTimeRange(
      _pageNavigation.dateTimeRangeFromIndex(index, location),
      includeDayEvents: true,
      includeMultiDayEvents: widget.configuration.showMultiDayEvents,
      location: location,
    );
    widget.viewController.visibleEvents.value = events.toSet();
  }

  int get _numberOfDays => widget.viewController.viewConfiguration.numberOfDays;
  bool get _isFreeScroll => widget.viewController.viewConfiguration.type == MultiDayViewType.freeScroll;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      padEnds: false,
      key: ValueKey(widget.viewController.viewConfiguration.hashCode),
      controller: widget.viewController.pageController,
      itemCount: widget.viewController.numberOfPages,
      physics: widget.configuration.pageScrollPhysics,
      onPageChanged: (index) {
        // Update the visible date time range based on the page index.
        final visibleRange = _pageNavigation.dateTimeRangeFromIndex(index, context.location);
        final range = _isFreeScroll ? InternalDateTimeRange(start: visibleRange.start, end: visibleRange.start.addDays(widget.viewController.viewConfiguration.numberOfDays)) : visibleRange;
        final controller = context.calendarController<T>();
        controller.setInternalDateTimeRange(range, context.location);

        // Update the visible events for the new page index.
        _updateVisibleEvents(index, context.location);

        // Call the onPageChanged callback if it was provided.
        final callbacks = context.callbacks<T>();
        callbacks?.onPageChanged?.call(controller.visibleDateTimeRange.value!);
      },
      itemBuilder: (context, index) {
        // Calculate the visible date time range for the current page index.
        final visibleRange = _pageNavigation.dateTimeRangeFromIndex(index, context.location);

        return Stack(
          key: MultiDayPage.contentKey,
          clipBehavior: Clip.none,
          children: [
            // HourLines are positioned behind the events.
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _isFreeScroll ? 1 : _numberOfDays + 1,
                  (_) => DaySeparator.fromContext<T>(context),
                ),
              ),
            ),

            // The draggable area for the creating events.
            Positioned.fill(
              child: DayDraggable<T>(
                visibleDateTimeRange: visibleRange,
                timeOfDayRange: widget.viewController.viewConfiguration.timeOfDayRange,
                pageHeight: widget.pageHeight,
              ),
            ),

            // The events row that displays the events for the current page.
            Positioned.fill(
              child: MultiDayEventsRow<T>(
                configuration: widget.configuration,
                visibleDateTimeRange: visibleRange,
                viewController: widget.viewController,
              ),
            ),
          ],
        );
      },
    );
  }
}
