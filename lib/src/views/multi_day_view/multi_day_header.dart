import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/components/event_groups/multi_day_event_group_widget.dart';
import 'package:kalender/src/components/general/material_header/material_header.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day_header_gesture_detector.dart';
import 'package:kalender/src/models/event_group_controllers/multi_day_event_group.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class MultiDayHeader<T> extends StatelessWidget {
  const MultiDayHeader({
    super.key,
    required this.viewConfiguration,
  });

  final MultiDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    final components = CalendarStyleProvider.of(context).components;

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: scope.state.visibleDateTimeRangeNotifier,
        builder: (context, visibleDateTimeRange, child) {
          final calendarHeader = RepaintBoundary(
            child: components.calendarHeaderBuilder?.call(
              visibleDateTimeRange,
            ),
          );

          final StatelessWidget dayHeader;
          if (viewConfiguration.numberOfDays == 1) {
            dayHeader = SingleDayHeader<T>(
              viewConfiguration: viewConfiguration,
              visibleDateTimeRange: visibleDateTimeRange,
            );
          } else {
            dayHeader = MultipleDayHeader<T>(
              viewConfiguration: viewConfiguration,
              visibleDateTimeRange: visibleDateTimeRange,
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              calendarHeader,
              dayHeader,
            ],
          );
        },
      ),
    );
  }
}

class MultipleDayHeader<T> extends StatelessWidget {
  const MultipleDayHeader({
    super.key,
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final DateTimeRange visibleDateTimeRange;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    final components = CalendarStyleProvider.of(context).components;

    final weekNumber = SizedBox(
      width: viewConfiguration.timelineWidth +
          viewConfiguration.daySeparatorLeftOffset,
      child: Center(
        child: viewConfiguration.showWeekNumber
            ? components.weekNumberBuilder(visibleDateTimeRange)
            : null,
      ),
    );

    final daysHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...List.generate(
          viewConfiguration.numberOfDays,
          (index) => components.dayHeaderBuilder(
            visibleDateTimeRange.start.addDays(index),
            (date) => scope.functions.onDateTapped?.call(date),
          ),
        ),
      ],
    );

    final multiDayEventsHeader = AnimatedMultiDayEventsHeader<T>(
      viewConfiguration: viewConfiguration,
      visibleDateRange: visibleDateTimeRange,
    );

    return Row(
      children: [
        weekNumber,
        Expanded(
          child: Column(
            children: [
              if (viewConfiguration.showDayHeader) daysHeader,
              if (viewConfiguration.showMultiDayHeader) multiDayEventsHeader,
            ],
          ),
        ),
      ],
    );
  }
}

class SingleDayHeader<T> extends StatelessWidget {
  const SingleDayHeader({
    super.key,
    required this.viewConfiguration,
    required this.visibleDateTimeRange,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final DateTimeRange visibleDateTimeRange;

  @override
  Widget build(BuildContext context) {
    final components = CalendarStyleProvider.of(context).components;

    late final dateHeader = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: viewConfiguration.timelineWidth +
              viewConfiguration.daySeparatorLeftOffset,
          child: components.dayHeaderBuilder(
            visibleDateTimeRange.start,
            null,
          ),
        ),
      ],
    );

    late final dayHeaderSpacer = SizedBox(
      width: viewConfiguration.timelineWidth +
          viewConfiguration.daySeparatorLeftOffset,
    );

    final multiDayEventsHeader = AnimatedMultiDayEventsHeader<T>(
      viewConfiguration: viewConfiguration,
      visibleDateRange: visibleDateTimeRange,
    );

    final showDayHeader = viewConfiguration.showDayHeader;
    final showMultiDayEvents = viewConfiguration.showMultiDayHeader;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (showDayHeader) dateHeader,
        if (!showDayHeader && showMultiDayEvents) dayHeaderSpacer,
        if (showMultiDayEvents) Expanded(child: multiDayEventsHeader),
      ],
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

            final multiDayEventGroup = MultiDayEventGroup.fromEvents(
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
                    (multiDayEventGroup.maxNumberOfStackedEvents +
                        (viewConfiguration.createMultiDayEvents ? 1 : 0)),
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    MultiDayHeaderGestureDetector<T>(
                      createMultiDayEvents:
                          viewConfiguration.createMultiDayEvents,
                      createEventTrigger: viewConfiguration.createEventTrigger,
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
                              MultiDayEventGroup.fromEvents(
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
