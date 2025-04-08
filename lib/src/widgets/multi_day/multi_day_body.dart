import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/day_drag_target.dart';
import 'package:kalender/src/widgets/draggable/day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/page_clipper.dart';
import 'package:kalender/src/widgets/internal_components/positioned_timeline.dart';
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
  /// The [EventsController] that will be used by the [MultiDayBody].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [MultiDayBody].
  final CalendarController<T>? calendarController;

  /// The [MultiDayBodyConfiguration] that will be used by the [MultiDayBody].
  final MultiDayBodyConfiguration? configuration;

  /// The callbacks used by the [MultiDayBody].
  final CalendarCallbacks<T>? callbacks;

  /// The tile components used by the [MultiDayBody].
  final TileComponents<T> tileComponents;

  /// The [ValueNotifier] containing the [heightPerMinute] value.
  final ValueNotifier<double>? heightPerMinute;

  /// The [ValueNotifier] containing the [CalendarInteraction] value.
  final ValueNotifier<CalendarInteraction>? interaction;

  /// The [ValueNotifier] containing the [CalendarSnapping] value.
  final ValueNotifier<CalendarSnapping>? snapping;

  /// Creates a new [MultiDayBody].
  ///
  /// This widget is used to display events in a day/week view format.
  ///
  /// This widget is intended to be the body of a [CalendarView].
  const MultiDayBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.tileComponents,
    this.heightPerMinute,
    this.configuration,
    this.interaction,
    this.snapping,
  });

  static const contentKey = ValueKey('contentKey');

  @override
  Widget build(BuildContext context) {
    final provider = CalendarProvider.maybeOf<T>(context);
    final eventsController = this.eventsController ?? CalendarProvider.eventsControllerOf(context);
    final calendarController = this.calendarController ?? CalendarProvider.calendarControllerOf(context);
    final callbacks = this.callbacks ?? CalendarProvider.callbacksOf(context);

    assert(
      calendarController.viewController is MultiDayViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MultiDayViewController<$T>',
    );

    final viewController = calendarController.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final timeOfDayRange = viewConfiguration.timeOfDayRange;
    final numberOfDays = viewConfiguration.numberOfDays;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final selectedEvent = calendarController.selectedEvent;
    final bodyConfiguration = this.configuration ?? MultiDayBodyConfiguration();

    final calendarComponents = provider?.components;
    final styles = calendarComponents?.multiDayComponentStyles?.bodyStyles;
    final components = calendarComponents?.multiDayComponents?.bodyComponents ?? const MultiDayBodyComponents();

    final interaction = this.interaction ?? ValueNotifier(CalendarInteraction());
    final snapping = this.snapping ?? ValueNotifier(const CalendarSnapping());

    // Override the height per minute if it is provided.
    if (heightPerMinute != null) {
      viewController.heightPerMinute = heightPerMinute!;
    }

    return ValueListenableBuilder(
      valueListenable: viewController.heightPerMinute,
      builder: (context, heightPerMinute, child) {
        // Calculate the height of the page.
        final dayDuration = timeOfDayRange.duration;
        final pageHeight = heightPerMinute * dayDuration.inMinutes;

        final hourLinesStyle = styles?.hourLinesStyle;
        final hourLines = components.hourLines.call(heightPerMinute, timeOfDayRange, hourLinesStyle);

        final timelineStyle = styles?.timelineStyle;
        final timeline = components.timeline.call(
          heightPerMinute,
          timeOfDayRange,
          timelineStyle,
          selectedEvent,
          viewController.visibleDateTimeRange,
        );

        final timeIndicatorStyle = styles?.timeIndicatorStyle;
        late final timeIndicator = components.timeIndicator.call(
          timeOfDayRange,
          heightPerMinute,
          0, // TODO: remove this
          timeIndicatorStyle,
        );

        final content = LayoutBuilder(
          key: contentKey,
          builder: (context, constraints) {
            final dayWidth = constraints.maxWidth / viewConfiguration.numberOfDays;

            final pageView = PageClipWidget(
              start: -16,
              child: PageView.builder(
                padEnds: false,
                key: ValueKey(viewConfiguration.hashCode),
                controller: viewController.pageController,
                itemCount: viewController.numberOfPages,
                physics: configuration?.pageScrollPhysics,
                clipBehavior: Clip.none,
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

                  callbacks?.onPageChanged?.call(viewController.visibleDateTimeRange.value.asLocal);
                },
                itemBuilder: (context, index) {
                  final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
                  final visibleDates = visibleRange.dates();

                  final daySeparatorStyle = styles?.daySeparatorStyle;
                  final daySeparator = components.daySeparator.call(daySeparatorStyle);
                  final daySeparators = List.generate(
                    numberOfDays + 1,
                    (index) {
                      final left = dayWidth * index;
                      return PositionedDirectional(top: 0, bottom: 0, start: left, child: daySeparator);
                    },
                  );

                  final events = DayEventsWidget<T>(
                    eventsController: eventsController,
                    controller: calendarController,
                    callbacks: callbacks,
                    tileComponents: tileComponents,
                    configuration: bodyConfiguration,
                    dayWidth: dayWidth,
                    heightPerMinute: heightPerMinute,
                    visibleDateTimeRange: visibleRange,
                    timeOfDayRange: timeOfDayRange,
                    interaction: interaction,
                  );

                  final draggable = DayEventDraggableWidgets<T>(
                    controller: calendarController,
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
                    clipBehavior: Clip.none,
                    children: [
                      ...daySeparators,
                      Positioned.fill(child: draggable),
                      Positioned.fill(child: events),
                      PositionedTimeIndicator(
                        visibleDates: visibleDates,
                        dayWidth: dayWidth,
                        child: timeIndicator,
                      ),
                    ],
                  );
                },
              ),
            );

            return pageView;
          },
        );

        final dragTarget = LayoutBuilder(
          builder: (context, constraints) {
            final pageHeight = constraints.maxHeight;
            final pageWidth = constraints.maxWidth;
            final dayWidth = constraints.maxWidth / viewConfiguration.numberOfDays;

            return SizedBox(
              height: pageHeight,
              child: DayDragTarget<T>(
                eventsController: eventsController,
                calendarController: calendarController,
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
                leftPageTrigger: components.leftTriggerBuilder,
                rightPageTrigger: components.rightTriggerBuilder,
                topScrollTrigger: components.topTriggerBuilder,
                bottomScrollTrigger: components.bottomTriggerBuilder,
                snapping: snapping,
              ),
            );
          },
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
                  child: Stack(
                    children: [
                      Positioned.fill(child: hourLines),
                      Row(
                        children: [
                          SizedBox(height: pageHeight, child: timeline),
                          Expanded(child: content),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: [
                  TimelineSizer<T>(child: const SizedBox()),
                  Expanded(child: dragTarget),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
