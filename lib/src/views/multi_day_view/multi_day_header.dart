import 'package:flutter/material.dart';
import 'package:kalender/kalender_scope.dart';
import 'package:kalender/src/components/event_groups/multi_day_event_group_widget.dart';
import 'package:kalender/src/components/general/material_header/material_header.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day_header_gesture_detector.dart';
import 'package:kalender/src/models/event_group_controllers/multi_day_event_group_controller.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';

class MultiDayHeader<T> extends StatelessWidget {
  const MultiDayHeader({
    super.key,
    required this.viewConfiguration,
  });

  final MultiDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: scope.state.visibleDateTimeRangeNotifier,
        builder: (context, visibleDateTimeRange, child) {
          return Column(
            children: <Widget>[
              RepaintBoundary(
                child: scope.components.calendarHeaderBuilder?.call(
                  visibleDateTimeRange,
                ),
              ),
              if (viewConfiguration.numberOfDays == 1)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: viewConfiguration.timelineWidth,
                          child: scope.components.dayHeaderBuilder(
                            visibleDateTimeRange.start,
                            null,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    SizedBox(
                      width: viewConfiguration.timelineWidth,
                      child: Center(
                        child: viewConfiguration.paintWeekNumber
                            ? scope.components
                                .weekNumberBuilder(visibleDateTimeRange)
                            : null,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ...List.generate(
                                viewConfiguration.numberOfDays,
                                (index) => scope.components.dayHeaderBuilder(
                                  visibleDateTimeRange.start
                                      .add(Duration(days: index)),
                                  (date) =>
                                      scope.functions.onDateTapped?.call(date),
                                ),
                              ),
                            ],
                          ),
                          AnimatedMultiDayEventsHeader<T>(
                            viewConfiguration: viewConfiguration,
                            visibleDateRange: visibleDateTimeRange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class AnimatedMultiDayEventsHeader<T> extends StatelessWidget {
  const AnimatedMultiDayEventsHeader({
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
        final horizontalStep =
            constraints.maxWidth / viewConfiguration.numberOfDays;

        return ListenableBuilder(
          listenable: scope.eventsController,
          builder: (context, child) {
            final events =
                scope.eventsController.getMultiDayEventsFromDateRange(
              scope.state.visibleDateTimeRangeNotifier.value,
            );

            final multiDayEventGroup =
                MultiDayEventGroupController<T>().generateMultiDayEventGroup(
              events: events,
            );

            final selectedEvent = scope.eventsController.selectedEvent;

            final horizontalStepDuration =
                viewConfiguration.horizontalStepDuration;
            final multiDayTileHeight = viewConfiguration.multiDayTileHeight;

            return AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                height: viewConfiguration.multiDayTileHeight *
                    (multiDayEventGroup.maxNumberOfStackedEvents + 1),
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    MultiDayHeaderGestureDetector<T>(
                      createMultiDayEvents:
                          viewConfiguration.createMultiDayEvents,
                      visibleDateRange: visibleDateRange,
                      horizontalStep: horizontalStep,
                    ),
                    MultiDayEventGroupWidget<T>(
                      multiDayEventGroup: multiDayEventGroup,
                      visibleDateRange: visibleDateRange,
                      horizontalStep: horizontalStep,
                      horizontalStepDuration: horizontalStepDuration,
                      isChanging: false,
                      multiDayTileHeight: multiDayTileHeight,
                    ),
                    if (selectedEvent != null &&
                        scope.eventsController.selectedEvent!.isMultiDayEvent)
                      ListenableBuilder(
                        listenable: scope.eventsController.selectedEvent!,
                        builder: (context, child) {
                          final multiDayEventGroup =
                              MultiDayEventGroupController<T>()
                                  .generateMultiDayEventGroup(
                            events: [selectedEvent],
                          );

                          return MultiDayEventGroupWidget<T>(
                            multiDayEventGroup: multiDayEventGroup,
                            visibleDateRange: visibleDateRange,
                            horizontalStep: horizontalStep,
                            horizontalStepDuration: horizontalStepDuration,
                            isChanging: true,
                            multiDayTileHeight: multiDayTileHeight,
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
