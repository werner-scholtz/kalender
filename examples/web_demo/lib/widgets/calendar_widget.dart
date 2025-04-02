import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/components/calendar_header.dart';
import 'package:web_demo/widgets/components/event_tiles.dart';
import 'package:web_demo/widgets/event_overlay_portal.dart';
import 'package:web_demo/widgets/resize_handle.dart';
import 'package:web_demo/widgets/zoom.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarController<Event> controller;
  final EventsController<Event> eventsController;
  final ViewConfiguration viewConfiguration;
  final List<ViewConfiguration> viewConfigurations;
  final void Function(ViewConfiguration value) onSelected;
  final MultiDayBodyConfiguration bodyConfiguration;
  final MultiDayHeaderConfiguration<Event> headerConfiguration;
  final bool showHeader;
  final ValueNotifier<CalendarInteraction>? interactionHeader;
  final ValueNotifier<CalendarInteraction>? interactionBody;
  final ValueNotifier<CalendarSnapping>? snapping;

  const CalendarWidget({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.viewConfigurations,
    required this.onSelected,
    required this.bodyConfiguration,
    required this.headerConfiguration,
    required this.showHeader,
    this.interactionHeader,
    this.interactionBody,
    this.snapping,
  });

  /// The drag anchor strategy for the feedback tile.
  Offset dragAnchorStrategy(Draggable draggable, BuildContext context, Offset position) {
    final renderObject = context.findRenderObject()! as RenderBox;
    return Offset(20, renderObject.size.height / 2);
  }

  TileComponents<Event> get _tileComponents {
    return TileComponents<Event>(
      tileBuilder: EventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  TileComponents<Event> get _multiDayTileComponents {
    return TileComponents<Event>(
      tileBuilder: MultiDayEventTile.builder,
      overlayTileBuilder: OverlayEventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarZoomDetector(
      controller: controller,
      child: CalendarView<Event>(
        calendarController: controller,
        eventsController: eventsController,
        viewConfiguration: viewConfiguration,
        callbacks: CalendarCallbacks<Event>(
          onEventTapped: (event, renderBox) => EventOverlayPortal.createEventOverlay(context, event, renderBox),
          onEventCreate: (event) => event.copyWith(data: const Event(title: 'New Event')),
          onEventCreated: (event) => eventsController.addEvent(event),
          onTapped: (date) {
            final newEvent = CalendarEvent<Event>(
              dateTimeRange: DateTimeRange(start: date, end: date.add(const Duration(minutes: 45))),
            );
            eventsController.addEvent(newEvent);
          },
          onMultiDayTapped: (dateRange) {
            final newEvent = CalendarEvent<Event>(dateTimeRange: dateRange);
            eventsController.addEvent(newEvent);
          },
        ),
        header: Material(
          color: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: NavigationHeader(
                  controller: controller,
                  viewConfigurations: viewConfigurations,
                  viewConfiguration: viewConfiguration,
                  onSelected: onSelected,
                ),
              ),
              if (showHeader)
                CalendarHeader<Event>(
                  multiDayTileComponents: _multiDayTileComponents,
                  multiDayHeaderConfiguration: headerConfiguration,
                  interaction: interactionHeader,
                ),
            ],
          ),
        ),
        body: CalendarBody<Event>(
          multiDayTileComponents: _tileComponents,
          monthTileComponents: _multiDayTileComponents,
          multiDayBodyConfiguration: bodyConfiguration,
          monthBodyConfiguration: headerConfiguration,
          interaction: interactionBody,
          snapping: snapping,
        ),
      ),
    );
  }
}
