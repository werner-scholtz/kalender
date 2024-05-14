import 'package:flutter/material.dart';
import 'package:kalender/src/calendar_view.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/components/day_tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/providers/multi_day_body_provider.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_event_groups_stack.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_page_gesture_detector.dart';

/// TODO: Add documentation
class MultiDayPageView<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final DayTileComponents<T> tileComponents;
  final CalendarCallbacks<T>? callbacks;
  final ValueNotifier<CalendarEvent<T>?> eventBeingDragged;

  /// Creates a [MultiDayPageView].
  const MultiDayPageView({
    super.key,
    required this.eventsController,
    required this.tileComponents,
    required this.callbacks,
    required this.calendarController,
    required this.eventBeingDragged,
  });

  @override
  Widget build(BuildContext context) {
    final provider = MultiDayBodyProvider.of(context);

    // Retrieve needed values from the provider.
    final viewConfiguration = provider.viewConfiguration;
    final pageController = provider.pageController;
    final numberOfPages = provider.numberOfPages;
    final pageScrollPhysics = provider.pageScrollPhysics;
    final visibleDateTimeRange = provider.visibleDateTimeRange;
    final timelineWidth = provider.timelineWidth;
    final dayWidth = provider.dayWidth;
    final timeOfDayRange = provider.timeOfDayRange;
    final heightPerMinute = provider.heightPerMinuteValue;
    final showAllEvents = provider.showAllEvents;
    final components = provider.components;
    final componentStyles = provider.componentStyles;
    final daySeparatorStyle = componentStyles?.daySeparatorStyle;
    final timeIndicatorStyle = componentStyles?.timeIndicatorStyle;
    final pageNavigation = provider.viewConfiguration.pageNavigationFunctions;

    return PageView.builder(
      key: ValueKey(viewConfiguration.name),
      controller: pageController,
      itemCount: numberOfPages,
      physics: pageScrollPhysics,
      onPageChanged: (index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
        visibleDateTimeRange.value = visibleRange;
      },
      itemBuilder: (context, index) {
        final visibleDateTimeRange = pageNavigation.dateTimeRangeFromIndex(
          index,
        );

        final visibleDates = visibleDateTimeRange.datesSpanned;
        final timeIndicatorDateIndex = visibleDates.indexWhere(
          (date) => date.isToday,
        );

        final daySeparator =
            components?.daySeparator?.call(daySeparatorStyle) ??
                DaySeparator(style: daySeparatorStyle);

        final daySeparators = List.generate(
          viewConfiguration.numberOfDays,
          (index) {
            final left = timelineWidth + (dayWidth * index);

            return Positioned(
              top: 0,
              bottom: 0,
              left: left,
              child: daySeparator,
            );
          },
        );

        Widget? timeIndicator;
        if (timeIndicatorDateIndex != -1) {
          final left = dayWidth * timeIndicatorDateIndex;

          final indicator = components?.timeIndicator?.call(
                timeOfDayRange,
                heightPerMinute,
                timelineWidth,
                timeIndicatorStyle,
              ) ??
              TimeIndicator(
                timeOfDayRange: timeOfDayRange,
                heightPerMinute: heightPerMinute,
                timelineWidth: timelineWidth,
                style: timeIndicatorStyle,
              );

          timeIndicator = Positioned(
            top: 0,
            bottom: 0,
            left: left,
            width: dayWidth + timelineWidth,
            child: indicator,
          );
        }

        final events = ListenableBuilder(
          listenable: eventsController,
          builder: (context, child) {
            final visibleEvents = eventsController.eventsFromDateTimeRange(
              visibleDateTimeRange,
              includeDayEvents: true,
              includeMultiDayEvents: showAllEvents,
            );

            return MultiDayEventGroupsStack(
              visibleEvents: visibleEvents,
              components: tileComponents,
              visibleDateTimeRange: visibleDateTimeRange,
              callbacks: callbacks,
              eventBeingDragged: eventBeingDragged,
              eventsController: eventsController,
            );
          },
        );

        final gestureDetector = MultiDayPageGestureDetector(
          eventsController: eventsController,
          eventBeingDragged: eventBeingDragged,
          visibleDateTimeRange: visibleDateTimeRange,
          callbacks: callbacks,
        );

        return Stack(
          fit: StackFit.passthrough,
          children: [
            ...daySeparators,
            Positioned.fill(left: timelineWidth, child: gestureDetector),
            Positioned.fill(left: timelineWidth, child: events),
            if (timeIndicator != null) timeIndicator,
          ],
        );
      },
    );
  }
}
