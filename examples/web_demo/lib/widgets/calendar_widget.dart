import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/main.dart' show MyApp;
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/components/calendar_header.dart';
import 'package:web_demo/widgets/components/event_tiles.dart';
import 'package:web_demo/widgets/event_overlay_portal.dart';
import 'package:web_demo/widgets/resize_handle.dart';
import 'package:web_demo/widgets/zoom.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarController<Event> controller;
  final ViewConfiguration viewConfiguration;
  final List<ViewConfiguration> viewConfigurations;
  final MultiDayBodyConfiguration multiDayBodyConfiguration;
  final MultiDayHeaderConfiguration<Event> multiDayHeaderConfiguration;
  final MonthBodyConfiguration<Event> monthBodyConfiguration;
  final ValueNotifier<CalendarInteraction> interactionHeader;
  final ValueNotifier<CalendarInteraction> interactionBody;
  final ValueNotifier<CalendarSnapping> snapping;
  final bool showHeader;

  const CalendarWidget({
    super.key,
    required this.controller,
    required this.viewConfiguration,
    required this.viewConfigurations,
    required this.multiDayBodyConfiguration,
    required this.multiDayHeaderConfiguration,
    required this.monthBodyConfiguration,
    required this.interactionHeader,
    required this.interactionBody,
    required this.snapping,
    required this.showHeader,
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
    final eventsController = MyApp.eventsController(context);
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
                  
                ),
              ),
              if (showHeader)
                CalendarHeader<Event>(
                  multiDayTileComponents: _multiDayTileComponents,
                  multiDayHeaderConfiguration: multiDayHeaderConfiguration,
                  interaction: interactionHeader,
                ),
            ],
          ),
        ),
        body: CalendarBody<Event>(
          multiDayTileComponents: _tileComponents,
          monthTileComponents: _multiDayTileComponents,
          multiDayBodyConfiguration: multiDayBodyConfiguration,
          monthBodyConfiguration: monthBodyConfiguration,
          interaction: interactionBody,
          snapping: snapping,
        ),
      ),
    );
  }
}
