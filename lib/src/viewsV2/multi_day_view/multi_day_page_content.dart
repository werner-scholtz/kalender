import 'package:flutter/material.dart';
import 'package:kalender/kalendar_scope.dart';
import 'package:kalender/src/components/general/time_indicator/time_indicator_v2.dart';
import 'package:kalender/src/components/gesture_detectors/day_gesture_detector_v2.dart';
import 'package:kalender/src/components/layout_delegates/tile_group_layout.dart';
import 'package:kalender/src/components/tiles/event_tile.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/event_group_controllers/event_group_controller.dart';
import 'package:kalender/src/models/tile_configurations/tile_configuration.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class MultiDayPageContent<T> extends StatelessWidget {
  const MultiDayPageContent({
    super.key,
    required this.viewConfiguration,
    required this.visibleDateRange,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final DateTimeRange visibleDateRange;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final visibleDates = visibleDateRange.datesSpanned;
        final dayWidth = constraints.maxWidth / visibleDates.length;
        final heightPerMinute = scope.state.heightPerMinute!.value;
        final verticalStep =
            heightPerMinute * viewConfiguration.verticalStepDuration.inMinutes;

        return ListenableBuilder(
          listenable: scope.eventsController,
          builder: (context, child) {
            // Get the list of events that are visible on the tile stack.
            final visibleEvents =
                scope.eventsController.getDayEventsFromDateRange(
              visibleDateRange,
            );

            // Generate the list of tile groups.
            final dayTileGroups = EventGroupController<T>().generateTileGroups(
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
                DayGestureDetectorV2(
                  viewConfiguration: viewConfiguration,
                  visibleDates: visibleDateRange.datesSpanned,
                ),
                ...dayTileGroups.map(
                  (tileGroup) => Positioned(
                    left: visibleDates.indexOf(tileGroup.date) * dayWidth,
                    width: dayWidth,
                    top: calculateTop(
                      tileGroup.start.difference(tileGroup.date),
                      heightPerMinute,
                    ),
                    height: calculateHeight(
                      tileGroup.duration,
                      heightPerMinute,
                    ),
                    child: TileGroup<T>(
                      tileGroup: tileGroup,
                      snapData: snapData,
                      isChanging: false,
                    ),
                  ),
                ),
                if (selectedEvent != null)
                  ListenableBuilder(
                    listenable: selectedEvent,
                    builder: (context, child) {
                      final selectedDayTileGroup = EventGroupController<T>()
                          .generateDayTileGroupsFromSingleEvent(
                        event: selectedEvent,
                      );
                      return Stack(
                        children: [
                          ...selectedDayTileGroup.map(
                            (tileGroup) => Positioned(
                              left: visibleDates.indexOf(tileGroup.date) *
                                  dayWidth,
                              width: dayWidth,
                              top: calculateTop(
                                tileGroup.start.difference(tileGroup.date),
                                heightPerMinute,
                              ),
                              height: calculateHeight(
                                tileGroup.duration,
                                heightPerMinute,
                              ),
                              child: TileGroup<T>(
                                tileGroup: tileGroup,
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
                  TimeIndicatorV2<T>(
                    visibleDates: visibleDates,
                    dayWidth: dayWidth,
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
      controller.hasChangingEvent &&
      !controller.isSelectedEventMultiDay &&
      (controller.isMoving || controller.isResizing);
}

class TileGroup<T> extends StatelessWidget {
  const TileGroup({
    super.key,
    required this.tileGroup,
    required this.isChanging,
    required this.snapData,
  });

  final EventGroup<T> tileGroup;
  final MultiDayPageData snapData;
  final bool isChanging;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    final children = <LayoutId>[];
    for (var i = 0; i < tileGroup.events.length; i++) {
      final event = tileGroup.events[i];

      // Check if the event is currently being moved.
      final isMoving = scope.eventsController.selectedEvent == event;
      children.add(
        LayoutId(
          id: i,
          child: EventTile(
            event: event,
            tileConfiguration: TileConfiguration(
              tileType: isChanging
                  ? TileType.selected
                  : isMoving
                      ? TileType.ghost
                      : TileType.normal,
              drawOutline: i >= 1,
              continuesBefore: event.start.isBefore(tileGroup.start),
              continuesAfter: event.end.isAfter(tileGroup.end),
            ),
            snapData: snapData,
            isChanging: isChanging,
          ),
        ),
      );
    }

    return CustomMultiChildLayout(
      delegate: TileGroupLayoutDelegateOverlap(
        startOfGroup: tileGroup.start,
        events: tileGroup.events,
        heightPerMinute: scope.state.heightPerMinute!.value,
      ),
      children: children,
    );
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return duration.inMinutes * heightPerMinute;
  }
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
