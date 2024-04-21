import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_event.dart';
import 'package:kalender/src/models/calendar/view_state/multi_day_view_state.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day_page_gesture_detector.dart';
import 'package:kalender/src/components/event_groups/event_group_widget.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/event_group_controllers/event_group_controller.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_style.dart';

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

    final components = CalendarStyleProvider.of(context).components;

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
            (scope.state as MultiDayViewState).heightPerMinute.value;

        final verticalStep =
            heightPerMinute * viewConfiguration.verticalStepDuration.inMinutes;

        final newEventVerticalStep =
            heightPerMinute * viewConfiguration.newEventDuration.inMinutes;

        return ListenableBuilder(
          listenable: scope.eventsController,
          builder: (context, child) {
            // Get the list of events that are visible on the tile stack.
            final Iterable<CalendarEvent<T>> visibleEvents;
            if (viewConfiguration.showMultiDayHeader) {
              visibleEvents = scope.eventsController.getDayEventsFromDateRange(
                visibleDateRange,
              );
            } else {
              visibleEvents = scope.eventsController.getEventsFromDateRange(
                visibleDateRange,
              );
            }

            controller.visibleEvents = visibleEvents;

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

            final daySeparator = Positioned(
              left: viewConfiguration.daySeparatorLeftOffset.toDouble(),
              width: daySeparatorWidth,
              top: 0,
              bottom: 0,
              child: components.daySeparatorBuilder(
                viewConfiguration.numberOfDays,
                dayWidth,
              ),
            );

            final gestureDetector = MultiDayPageGestureDetector<T>(
              viewConfiguration: viewConfiguration,
              visibleDates: visibleDateRange.datesSpanned,
              heightPerMinute: heightPerMinute,
              verticalStep: newEventVerticalStep,
            );

            final eventWidgetGroups = generateEventGroupWidgets(
              eventGroups: eventGroups,
              visibleDates: visibleDates,
              dayWidth: dayWidth,
              heightPerMinute: heightPerMinute,
              verticalStep: verticalStep,
              horizontalStep: dayWidth,
              snapPoints: snapPoints,
            );

            Widget? changingEventGroups;
            if (selectedEvent != null) {
              changingEventGroups = ListenableBuilder(
                listenable: selectedEvent,
                builder: (context, child) {
                  final selectedEventWidgetGroups =
                      EventGroupController<T>().generateTileGroups(
                    visibleDates: visibleDates,
                    events: [selectedEvent],
                  );

                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    fit: StackFit.expand,
                    children: [
                      ...generateEventGroupWidgets(
                        eventGroups: selectedEventWidgetGroups,
                        visibleDates: visibleDates,
                        dayWidth: dayWidth,
                        heightPerMinute: heightPerMinute,
                        isChanging: true,
                        verticalStep: verticalStep,
                        horizontalStep: dayWidth,
                        snapPoints: snapPoints,
                      ),
                    ],
                  );
                },
              );
            }

            Widget? timeIndicator;
            if (DateTime.now().isWithin(visibleDateRange)) {
              timeIndicator = Positioned(
                left: left(
                  visibleDates.indexOf(DateTime.now().startOfDay),
                  dayWidth,
                ),
                top: 0,
                bottom: 0,
                width: dayWidth,
                child: components.timeIndicatorBuilder.call(
                  heightPerMinute,
                  dayWidth,
                ),
              );
            }

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                daySeparator,
                gestureDetector,
                ...eventWidgetGroups,
                if (changingEventGroups != null) changingEventGroups,
                if (timeIndicator != null) timeIndicator,
              ],
            );
          },
        );
      },
    );
  }

  Iterable<Widget> generateEventGroupWidgets({
    required Iterable<EventGroup<T>> eventGroups,
    required List<DateTime> visibleDates,
    required List<DateTime> snapPoints,
    required double dayWidth,
    required double heightPerMinute,
    required double verticalStep,
    required double horizontalStep,
    bool isChanging = false,
  }) {
    return eventGroups.map(
      (eventGroup) {
        final dayIndex = visibleDates.indexOf(eventGroup.date);
        return Positioned(
          left: left(dayIndex, dayWidth),
          width: dayWidth,
          top: 0,
          bottom: 0,
          child: EventGroupWidget<T>(
            eventGroup: eventGroup,
            heightPerMinute: heightPerMinute,
            isChanging: isChanging,
            visibleDateTimeRange: visibleDateRange,
            verticalStep: verticalStep,
            horizontalStep: horizontalStep,
            snapPoints: snapPoints,
          ),
        );
      },
    );
  }

  double left(int dayIndex, double dayWidth) {
    return ((dayIndex * dayWidth + (dayIndex + 1)) +
        viewConfiguration.daySeparatorLeftOffset);
  }

  bool showSelectedTile(CalendarEventsController<T> controller) {
    if (viewConfiguration.showMultiDayHeader) {
      return controller.hasChangingEvent &&
          !controller.selectedEvent!.isMultiDayEvent;
    } else {
      return controller.hasChangingEvent;
    }
  }
}
