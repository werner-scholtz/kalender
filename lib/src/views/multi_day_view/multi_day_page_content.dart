import 'package:flutter/material.dart';
import 'package:kalender/kalender_scope.dart';
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
  });

  final MultiDayViewConfiguration viewConfiguration;
  final DateTimeRange visibleDateRange;
  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final visibleDates = visibleDateRange.datesSpanned;
        final dayWidth = constraints.maxWidth / visibleDates.length;
        final heightPerMinute =
            (scope.state as MultiDayViewState).heightPerMinute!.value;
        final verticalStep =
            heightPerMinute * viewConfiguration.verticalStepDuration.inMinutes;

        final newEventVerticalStep =
            heightPerMinute * viewConfiguration.newEventDuration.inMinutes;

        return ListenableBuilder(
          listenable: scope.eventsController,
          builder: (context, child) {
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

            // Generate the snap data.
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
              children: [
                scope.components.daySeparatorBuilder(
                  viewConfiguration.numberOfDays,
                ),
                MultiDayPageGestureDetector<T>(
                  viewConfiguration: viewConfiguration,
                  visibleDates: visibleDateRange.datesSpanned,
                  heightPerMinute: heightPerMinute,
                  verticalStep: newEventVerticalStep,
                ),
                ...eventGroups.map(
                  (tileGroup) => Positioned(
                    left: (visibleDates.indexOf(tileGroup.date) * dayWidth)
                        .roundToDouble(),
                    width: dayWidth.roundToDouble(),
                    top: calculateTop(
                      tileGroup.start.difference(tileGroup.date),
                      heightPerMinute,
                    ).roundToDouble(),
                    height: calculateHeight(
                      tileGroup.duration,
                      heightPerMinute,
                    ).roundToDouble(),
                    child: EventGroupWidget<T>(
                      eventGroup: tileGroup,
                      snapData: snapData,
                      isChanging: false,
                    ),
                  ),
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
                          ...selectedDayTileGroup.map(
                            (tileGroup) => Positioned(
                              left: (visibleDates.indexOf(tileGroup.date) *
                                      dayWidth)
                                  .roundToDouble(),
                              width: dayWidth.roundToDouble(),
                              top: calculateTop(
                                tileGroup.start.difference(tileGroup.date),
                                heightPerMinute,
                              ).roundToDouble(),
                              height: calculateHeight(
                                tileGroup.duration,
                                heightPerMinute,
                              ).roundToDouble(),
                              child: EventGroupWidget<T>(
                                eventGroup: tileGroup,
                                snapData: snapData,
                                isChanging: true,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                if (DateTime.now().isWithin(visibleDateRange))
                  scope.components.timeIndicatorBuilder.call(
                    visibleDates,
                    heightPerMinute,
                    dayWidth,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  double calculateTop(Duration timeBeforeStart, double heightPerMinute) {
    return timeBeforeStart.inMinutes * heightPerMinute;
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return duration.inMinutes * heightPerMinute;
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
