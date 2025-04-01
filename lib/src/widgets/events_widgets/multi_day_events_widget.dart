import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_event_layout_widget.dart';

/// This widget is renders all the multi-day event tiles that are visible on the provided dateTimeRange.
///
/// It fetches the events that need to be rendered from the [EventsController],
/// the [EventsController] is also listened to in-case events are added or updated.
///
/// This widget also takes responsibility for updating the [CalendarController.visibleEvents],
/// unlike the DayEventsWidget that can clear the visibleEvents it only adds the events that are visible.
///
/// TODO: Change docs
/// To render the event tiles it uses [CustomMultiChildLayout],
/// along with a [defaultMultiDayLayoutStrategy] or custom strategy defined by the user.
///
/// * Note: When a event is being modified by the user it renders that event in a separate [CustomMultiChildLayout],
///         This is somewhat expensive computationally as it lays out all the events again to determine the position
///         of the event being modified. See todo for a possible solution.
class MultiDayEventWidget<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final DateTimeRange visibleDateTimeRange;
  final TileComponents<T> tileComponents;
  final CalendarCallbacks<T>? callbacks;
  final double dayWidth;
  final int? maxNumberOfRows;
  final double tileHeight;
  final bool showAllEvents;
  final GenerateMultiDayLayoutFrame<T> generateMultiDayLayoutFrame;
  final ValueNotifier<CalendarInteraction> interaction;

  final OverlayBuilders<T>? overlayBuilders;
  final OverlayStyles? overlayStyles;

  const MultiDayEventWidget({
    super.key,
    required this.visibleDateTimeRange,
    required this.eventsController,
    required this.controller,
    required this.tileComponents,
    required this.dayWidth,
    required this.showAllEvents,
    required this.tileHeight,
    required this.maxNumberOfRows,
    required this.interaction,
    required this.callbacks,
    required this.generateMultiDayLayoutFrame,
    required this.overlayBuilders,
    required this.overlayStyles,
  });

  ValueNotifier<Set<CalendarEvent<T>>> get visibleEventsNotifier => controller.visibleEvents;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: eventsController,
      builder: (context, child) {
        // Get the visible events from the events controller.
        final visibleEvents = eventsController.eventsFromDateTimeRange(
          visibleDateTimeRange,
          includeDayEvents: showAllEvents,
          includeMultiDayEvents: true,
        );

        // Add the events to the visible events notifier.
        visibleEventsNotifier.value = {...visibleEventsNotifier.value, ...visibleEvents};

        return MultiDayEventLayoutWidget<T>(
          events: visibleEvents.toList(),
          eventsController: eventsController,
          controller: controller,
          visibleDateTimeRange: visibleDateTimeRange,
          tileComponents: tileComponents,
          callbacks: callbacks,
          dayWidth: dayWidth,
          showAllEvents: showAllEvents,
          tileHeight: tileHeight,
          maxNumberOfVerticalEvents: maxNumberOfRows,
          interaction: interaction,
          generateFrame: generateMultiDayLayoutFrame,
          textDirection: Directionality.of(context),
          multiDayOverlayBuilders: overlayBuilders,
          multiDayOverlayStyles: overlayStyles,
        );
      },
    );
  }
}
