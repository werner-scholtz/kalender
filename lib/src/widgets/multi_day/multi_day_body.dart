import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/day_drag_target.dart';
import 'package:kalender/src/widgets/draggable/day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';
import 'package:kalender/src/widgets/internal_components/timeline_sizer.dart';

/// This widget is used to display a multi-day body.
///
/// The multi-day body has two big parts to it:
/// 1. The content:
///   - Static content such as [HourLines] and [TimeLine].
///   - Dynamic content such as the [PageView] which displays:
///     [DaySeparator], [DayEventDraggableWidgets], [DayEventsWidget] and the [TimeIndicator]
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

  /// The key used to identify the content of the [MultiDayBody].
  static const contentKey = ValueKey('contentKey');

  @override
  Widget build(BuildContext context) {
    final eventsController = context.eventsController<T>();
    final controller = context.calendarController<T>();
    final components = context.components<T>();
    final callbacks = context.callbacks<T>();

    assert(
      controller.viewController is MultiDayViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MultiDayViewController<$T>',
    );

    final viewController = controller.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final timeOfDayRange = viewConfiguration.timeOfDayRange;
    final numberOfDays = viewConfiguration.numberOfDays;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final selectedEvent = controller.selectedEvent;
    final bodyConfiguration = this.configuration ?? MultiDayBodyConfiguration();

    final styles = components?.multiDayComponentStyles?.bodyStyles;
    final bodyComponents = components?.multiDayComponents?.bodyComponents ?? MultiDayBodyComponents<T>();

    final bodyProvider = context.bodyProvider<T>();
    final tileComponents = bodyProvider.tileComponents;
    final interaction = bodyProvider.interaction;
    final snapping = bodyProvider.snapping;

    return ValueListenableBuilder(
      valueListenable: viewController.heightPerMinute,
      builder: (context, heightPerMinute, child) {
        // Calculate the height of the page.
        final dayDuration = timeOfDayRange.duration;
        final pageHeight = heightPerMinute * dayDuration.inMinutes;

        final hourLines = _getHourLines(styles, bodyComponents, heightPerMinute, timeOfDayRange);
        final timeIndicator = _getTimeIndicator(styles, bodyComponents, timeOfDayRange, heightPerMinute);
        final timeline = _getTimeline(
          styles,
          bodyComponents,
          heightPerMinute,
          timeOfDayRange,
          selectedEvent,
          viewController,
        );

        return Stack(
          children: [
            Scrollbar(
              controller: viewController.scrollController,
              child: SingleChildScrollView(
                controller: viewController.scrollController,
                physics: configuration?.scrollPhysics,
                child: SizedBox(
                  height: pageHeight,
                  child: Row(
                    children: [
                      // The timeline is always on the left side of the page, but should not scroll with the pageview.
                      SizedBox(height: pageHeight, child: timeline),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final pageWidth = constraints.maxWidth;
                            final dayWidth = pageWidth / viewConfiguration.numberOfDays;

                            return Stack(
                              children: [
                                Positioned.fill(child: hourLines),
                                Positioned.fill(
                                  child: PageView.builder(
                                    padEnds: false,
                                    key: ValueKey(viewConfiguration.hashCode),
                                    controller: viewController.pageController,
                                    itemCount: viewController.numberOfPages,
                                    physics: configuration?.pageScrollPhysics,
                                    onPageChanged: (index) {
                                      final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);

                                      if (viewConfiguration.type == MultiDayViewType.freeScroll) {
                                        final range = DateTimeRange(
                                          start: visibleRange.start,
                                          end: visibleRange.start.addDays(numberOfDays),
                                        );
                                        viewController.visibleDateTimeRange.value = range;
                                      } else {
                                        viewController.visibleDateTimeRange.value = visibleRange;
                                      }
                                      
                                      // TODO: we need to udate the visible events here.
                                      // This is because freeScroll builds multiple pages at once.
                                      final events = eventsController.eventsFromDateTimeRange(
                                        visibleRange,
                                        includeDayEvents: true,
                                        includeMultiDayEvents: configuration?.showMultiDayEvents ?? false,
                                      );
                                      controller.visibleEvents.value = events.toSet();

                                      callbacks?.onPageChanged?.call(viewController.visibleDateTimeRange.value.asLocal);
                                    },
                                    itemBuilder: (context, index) {
                                      final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
                                      final daySeparators = _generateDaySeparators(
                                        styles,
                                        bodyComponents,
                                        numberOfDays,
                                        dayWidth,
                                      );

                                      final events = DayEventsWidget<T>(
                                        eventsController: eventsController,
                                        controller: controller,
                                        configuration: bodyConfiguration,
                                        dayWidth: dayWidth,
                                        heightPerMinute: heightPerMinute,
                                        visibleDateTimeRange: visibleRange,
                                        timeOfDayRange: timeOfDayRange,
                                      );

                                      final draggable = DayEventDraggableWidgets<T>(
                                        controller: controller,
                                        callbacks: callbacks,
                                        visibleDateTimeRange: visibleRange,
                                        timeOfDayRange: timeOfDayRange,
                                        dayWidth: dayWidth,
                                        pageHeight: pageHeight,
                                        heightPerMinute: heightPerMinute,
                                        interaction: interaction,
                                        snapping: snapping,
                                      );

                                      return Stack(
                                        key: contentKey,
                                        clipBehavior: Clip.none,
                                        children: [
                                          ...daySeparators,
                                          Positioned.fill(child: draggable),
                                          Positioned.fill(child: events),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                TimeIndicatorPositioner<T>(
                                  viewController: viewController,
                                  dayWidth: dayWidth,
                                  pageWidth: pageWidth,
                                  initialPage: viewController.initialPage,
                                  child: timeIndicator,
                                ),
                              ],
                            );
                          },
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
                            eventsController: eventsController,
                            calendarController: controller,
                            viewController: viewController,
                            scrollController: viewController.scrollController,
                            callbacks: callbacks,
                            tileComponents: tileComponents,
                            bodyConfiguration: bodyConfiguration,
                            timeOfDayRange: timeOfDayRange,
                            pageWidth: pageWidth,
                            dayWidth: dayWidth,
                            viewPortHeight: pageHeight,
                            heightPerMinute: heightPerMinute,
                            leftPageTrigger: bodyComponents.leftTriggerBuilder,
                            rightPageTrigger: bodyComponents.rightTriggerBuilder,
                            topScrollTrigger: bodyComponents.topTriggerBuilder,
                            bottomScrollTrigger: bodyComponents.bottomTriggerBuilder,
                            snapping: snapping,
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
      },
    );
  }

  /// Gets the time indicator widget for the multi-day body.
  Widget _getTimeIndicator(
    MultiDayBodyComponentStyles? styles,
    MultiDayBodyComponents<dynamic> bodyComponents,
    TimeOfDayRange timeOfDayRange,
    double heightPerMinute,
  ) {
    final timeIndicatorStyle = styles?.timeIndicatorStyle;
    late final timeIndicator = bodyComponents.timeIndicator.call(
      timeOfDayRange,
      heightPerMinute,
      0, // TODO: remove this
      timeIndicatorStyle,
    );
    return timeIndicator;
  }

  /// Gets the timeline widget for the multi-day body.
  Widget _getTimeline(
    MultiDayBodyComponentStyles? styles,
    MultiDayBodyComponents<dynamic> bodyComponents,
    double heightPerMinute,
    TimeOfDayRange timeOfDayRange,
    ValueNotifier<CalendarEvent<dynamic>?> selectedEvent,
    MultiDayViewController<dynamic> viewController,
  ) {
    final timelineStyle = styles?.timelineStyle;
    final timeline = bodyComponents.timeline.call(
      heightPerMinute,
      timeOfDayRange,
      timelineStyle,
      selectedEvent,
      viewController.visibleDateTimeRange,
    );
    return timeline;
  }

  /// Gets the hour lines widget for the multi-day body.
  Widget _getHourLines(
    MultiDayBodyComponentStyles? styles,
    MultiDayBodyComponents<dynamic> bodyComponents,
    double heightPerMinute,
    TimeOfDayRange timeOfDayRange,
  ) {
    final hourLinesStyle = styles?.hourLinesStyle;
    final hourLines = bodyComponents.hourLines.call(heightPerMinute, timeOfDayRange, hourLinesStyle);
    return hourLines;
  }

  /// Generates the day separators for the multi-day body.
  List<PositionedDirectional> _generateDaySeparators(
    MultiDayBodyComponentStyles? styles,
    MultiDayBodyComponents<dynamic> bodyComponents,
    int numberOfDays,
    double dayWidth,
  ) {
    final daySeparatorStyle = styles?.daySeparatorStyle;
    final daySeparator = bodyComponents.daySeparator.call(daySeparatorStyle);
    final daySeparators = List.generate(
      numberOfDays + 1,
      (index) {
        final left = dayWidth * index;
        return PositionedDirectional(
          top: 0,
          bottom: 0,
          start: left,
          child: daySeparator,
        );
      },
    );
    return daySeparators;
  }
}
