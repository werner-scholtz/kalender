import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';
import 'package:kalender/src/widgets/drag_targets/day_drag_target.dart';
import 'package:kalender/src/widgets/draggable/day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';
import 'package:kalender/src/widgets/internal_components/timeline_sizer.dart';

/// This widget is used to display a multi-day body.
///
/// The multi-day body has two big parts to it:
/// 1. The content:
///   - Static content such as [HourLines] and [_TimeLine].
///   - Dynamic content such as the [PageView] which displays:
///     [DaySeparator], [DayDraggable], [DayEventsWidget] and the [TimeIndicator]
///
/// 2. The [DayDragTarget]
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

    final configuration = this.configuration ?? MultiDayBodyConfiguration();

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
                      child: DayDragTarget<T>(
                        controller: context.calendarController<T>(),
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
  const MultiDayPage({
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.configuration,
    required this.pageHeight,
  });

  final EventsController<T> eventsController;
  final MultiDayViewController<T> viewController;
  final MultiDayBodyConfiguration configuration;

  final double pageHeight;

  /// The key used to identify the content of the [MultiDayBody].
  static const contentKey = ValueKey('contentKey');

  @override
  State<MultiDayPage<T>> createState() => _MultiDayPageState<T>();
}

class _MultiDayPageState<T extends Object?> extends State<MultiDayPage<T>> {
  EventsController<T> get eventsController => widget.eventsController;
  MultiDayViewController<T> get controller => widget.viewController;
  MultiDayViewConfiguration get viewConfiguration => widget.viewController.viewConfiguration;
  PageNavigationFunctions get pageNavigation => viewConfiguration.pageNavigationFunctions;
  MultiDayBodyConfiguration get configuration => widget.configuration;

  @override
  void initState() {
    super.initState();
    _updateVisibleEvents(controller.initialPage);
  }

  void _updateVisibleEvents(int index) {
    final events = eventsController.eventsFromDateTimeRange(
      pageNavigation.dateTimeRangeFromIndex(index),
      includeDayEvents: true,
      includeMultiDayEvents: configuration.showMultiDayEvents,
    );
    controller.visibleEvents.value = events.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      padEnds: false,
      key: ValueKey(widget.viewController.viewConfiguration.hashCode),
      controller: widget.viewController.pageController,
      itemCount: widget.viewController.numberOfPages,
      physics: widget.configuration.pageScrollPhysics,
      onPageChanged: (index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);

        if (widget.viewController.viewConfiguration.type == MultiDayViewType.freeScroll) {
          final range = DateTimeRange(
            start: visibleRange.start,
            end: visibleRange.start.addDays(viewConfiguration.numberOfDays),
          );
          widget.viewController.visibleDateTimeRange.value = range;
        } else {
          widget.viewController.visibleDateTimeRange.value = visibleRange;
        }

        _updateVisibleEvents(index);

        final callbacks = context.callbacks<T>();
        callbacks?.onPageChanged?.call(widget.viewController.visibleDateTimeRange.value.asLocal);
      },
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);

        return Stack(
          key: MultiDayPage.contentKey,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  viewConfiguration.numberOfDays + 1,
                  (_) => DaySeparator.fromContext<T>(context),
                ),
              ),
            ),
            Positioned.fill(
              child: DayDraggable<T>(
                visibleDateTimeRange: visibleRange,
                timeOfDayRange: viewConfiguration.timeOfDayRange,
                pageHeight: widget.pageHeight,
              ),
            ),
            Positioned.fill(
              child: DayEventsWidget<T>(
                eventsController: context.eventsController<T>(),
                controller: context.calendarController<T>(),
                configuration: widget.configuration,
                visibleDateTimeRange: visibleRange,
                timeOfDayRange: viewConfiguration.timeOfDayRange,
              ),
            ),
          ],
        );
      },
    );
  }
}
