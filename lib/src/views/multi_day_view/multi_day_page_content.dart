import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day_page_gesture_detector.dart';
import 'package:kalender/src/components/event_groups/event_group_widget.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_view_state.dart';
import 'package:kalender/src/models/event_group_controllers/event_group_controller.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class MultiDayPageContent<T> extends StatelessWidget {
  const MultiDayPageContent({
    super.key,
    required this.viewConfiguration,
    required this.visibleDateRange,
    required this.controller,
    required this.hourHeight,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final DateTimeRange visibleDateRange;
  final CalendarController controller;
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final visibleDates = visibleDateRange.datesSpanned;

        final dayWidth = (((constraints.maxWidth -
                        viewConfiguration.daySeparatorLeftOffset) /
                    visibleDates.length) -
                1)
            .truncateToDouble();

        final daySeparatorWidth =
            dayWidth * visibleDates.length + (visibleDates.length + 1);

        final heightPerMinute =
            (scope.state as MultiDayViewState).heightPerMinute!.value;

        final verticalStep =
            heightPerMinute * viewConfiguration.verticalStepDuration.inMinutes;

        final newEventVerticalStep =
            heightPerMinute * viewConfiguration.newEventDuration.inMinutes;

        return ListenableBuilder(
          listenable: scope.eventsController,
          builder: (context, child) {
            // controller.state.

            // Get the list of events that are visible on the tile stack.
            final visibleEvents =
                scope.eventsController.getDayEventsFromDateRange(
              visibleDateRange,
            );

            // Generate the list of tile groups.
            final eventGroups = EventGroupController<T>().generateTileGroups(
              visibleDates: visibleDates,
              events: visibleEvents,
            );

            // Generate the list of tile groups for the selected event. (if applicable)
            final selectedEvent = showSelectedTile(scope.eventsController)
                ? scope.eventsController.selectedEvent
                : null;

            // Generate the list of snap points.
            final snapPoints = viewConfiguration.eventSnapping
                ? scope.eventsController
                    .getSnapPointsFromDateTimeRange(
                      visibleDateRange,
                    )
                    .toList()
                : <DateTime>[];

            // Create the snap data.
            final snapData = MultiDayPageData(
              snapPoints: snapPoints,
              snapToTimeIndicator: viewConfiguration.timeIndicatorSnapping,
              verticalSnapRange: viewConfiguration.verticalSnapRange,
              verticalStep: verticalStep,
              verticalStepDuration: viewConfiguration.verticalStepDuration,
              horizontalStepDuration: viewConfiguration.horizontalStepDuration,
              horizontalStep: dayWidth,
              visibleDateRange: visibleDateRange,
              heightPerMinute: heightPerMinute,
            );

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: viewConfiguration.daySeparatorLeftOffset.toDouble(),
                  width: daySeparatorWidth,
                  top: 0,
                  bottom: 0,
                  child: scope.components.daySeparatorBuilder(
                    viewConfiguration.numberOfDays,
                    dayWidth,
                  ),
                ),
                MultiDayPageGestureDetector<T>(
                  viewConfiguration: viewConfiguration,
                  visibleDates: visibleDateRange.datesSpanned,
                  heightPerMinute: heightPerMinute,
                  verticalStep: newEventVerticalStep,
                ),
                ...generateEventGroups(
                  eventGroups: eventGroups,
                  visibleDates: visibleDates,
                  dayWidth: dayWidth,
                  heightPerMinute: heightPerMinute,
                  snapData: snapData,
                ),
                if (selectedEvent != null)
                  ListenableBuilder(
                    listenable: selectedEvent,
                    builder: (context, child) {
                      final selectedDayTileGroup =
                          EventGroupController<T>().generateTileGroups(
                        visibleDates: visibleDates,
                        events: [selectedEvent],
                      );
                      return Stack(
                        children: [
                          ...generateEventGroups(
                            eventGroups: selectedDayTileGroup,
                            visibleDates: visibleDates,
                            dayWidth: dayWidth,
                            heightPerMinute: heightPerMinute,
                            snapData: snapData,
                            isChanging: true,
                          ),
                        ],
                      );
                    },
                  ),
                if (DateTime.now().isWithin(visibleDateRange))
                  Positioned(
                    left: left(
                      visibleDates.indexOf(DateTime.now().startOfDay),
                      dayWidth,
                    ),
                    top: 0,
                    bottom: 0,
                    width: dayWidth,
                    child: scope.components.timeIndicatorBuilder.call(
                      heightPerMinute,
                      dayWidth,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Iterable<Widget> generateEventGroups({
    required Iterable<EventGroup<T>> eventGroups,
    required List<DateTime> visibleDates,
    required double dayWidth,
    required double heightPerMinute,
    required MultiDayPageData snapData,
    bool isChanging = false,
  }) {
    return eventGroups.map(
      (tileGroup) {
        final dayIndex = visibleDates.indexOf(tileGroup.date);
        return Positioned(
          left: left(dayIndex, dayWidth),
          width: dayWidth,
          top: calculateTop(
            tileGroup.start.difference(tileGroup.date),
            heightPerMinute,
          ),
          height: calculateHeight(
            tileGroup.duration,
            heightPerMinute,
          ),
          child: EventGroupWidget<T>(
            eventGroup: tileGroup,
            snapData: snapData,
            isChanging: isChanging,
          ),
        );
      },
    );
  }

  double left(int dayIndex, double dayWidth) {
    return ((dayIndex * dayWidth + (dayIndex + 1)) +
        viewConfiguration.daySeparatorLeftOffset);
  }

  double calculateTop(Duration timeBeforeStart, double heightPerMinute) {
    return (timeBeforeStart.inMinutes * heightPerMinute).ceilToDouble();
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return ((duration.inSeconds / 60) * heightPerMinute).floorToDouble();
  }

  bool showSelectedTile(CalendarEventsController<T> controller) =>
      controller.hasChangingEvent && !controller.selectedEvent!.isMultiDayEvent;
}

class MultiDayPageData {
  MultiDayPageData({
    required this.snapPoints,
    required this.snapToTimeIndicator,
    required this.verticalSnapRange,
    required this.verticalStep,
    required this.verticalStepDuration,
    required this.horizontalStepDuration,
    required this.horizontalStep,
    required this.visibleDateRange,
    required this.heightPerMinute,
  });

  final List<DateTime> snapPoints;
  final bool snapToTimeIndicator;
  final Duration verticalSnapRange;
  final double verticalStep;
  final Duration verticalStepDuration;
  final Duration horizontalStepDuration;
  final double horizontalStep;
  final DateTimeRange visibleDateRange;
  final double heightPerMinute;
}
