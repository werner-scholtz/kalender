import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/main.dart' show MyApp;
import 'package:web_demo/models/event.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/widgets/calendar_configuration.dart';
import 'package:web_demo/widgets/components/calendar_header.dart';
import 'package:web_demo/widgets/components/event_tiles.dart';
import 'package:web_demo/widgets/event_overlay_portal.dart';
import 'package:web_demo/widgets/resize_handle.dart';
import 'package:web_demo/widgets/zoom.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerProvider(
      child: ConfigurationProvider(
        child: LocationProvider(
          child: const CalendarWidget(),
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  EventsController get _eventsController => MyApp.eventsController(context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowCustomize = constraints.maxWidth > 800;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ZoomDetector(
                controller: context.controller,
                child: CalendarView<Event>(
                    location: context.location.value,
                    locale: Localizations.localeOf(context).toLanguageTag(),
                    calendarController: context.controller,
                    eventsController: _eventsController,
                    viewConfiguration: context.configuration.viewConfiguration,
                    callbacks: _callbacks,
                    header: Material(
                      color: Theme.of(context).colorScheme.surface,
                      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                      elevation: 2,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: NavigationHeader(
                              controller: context.controller,
                              viewConfigurations: context.configuration.viewConfigurations,
                              viewConfiguration: context.configuration.viewConfiguration,
                            ),
                          ),
                          if (context.configuration.showHeader)
                            ValueListenableBuilder(
                              valueListenable: context.configuration.interactionHeader,
                              builder: (context, value, child) {
                                return CalendarHeader<Event>(
                                  multiDayTileComponents: _multiDayTileComponents,
                                  multiDayHeaderConfiguration: context.configuration.multiDayHeaderConfiguration,
                                  interaction: value,
                                );
                              },
                            )
                        ],
                      ),
                    ),
                    body: ValueListenableBuilder(
                      valueListenable: context.configuration.interactionBody,
                      builder: (context, interactionBody, child) {
                        return ValueListenableBuilder(
                          valueListenable: context.configuration.snapping,
                          builder: (context, snapping, child) {
                            return CalendarBody<Event>(
                              multiDayTileComponents: _tileComponents,
                              monthTileComponents: _multiDayTileComponents,
                              multiDayBodyConfiguration: context.configuration.multiDayBodyConfiguration,
                              monthBodyConfiguration: context.configuration.monthBodyConfiguration,
                              scheduleTileComponents: _scheduleTileComponents,
                              interaction: interactionBody,
                              snapping: snapping,
                            );
                          },
                        );
                      },
                    )),
              ),
            ),
            if (canShowCustomize)
              Expanded(
                flex: 1,
                child: CalendarConfigurationWidget(configuration: context.configuration),
              ),
          ],
        );
      },
    );
  }

  /// The drag anchor strategy for the feedback tile.
  Offset _dragAnchorStrategy(Draggable draggable, BuildContext context, Offset position) {
    final renderObject = context.findRenderObject()! as RenderBox;
    return Offset(20, renderObject.size.height / 2);
  }

  TileComponents<Event> get _tileComponents {
    return TileComponents<Event>(
      tileBuilder: (event, range) => EventTile.builder(event as Event, range),
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) => TileWhenDragging.builder(event as Event),
      dragAnchorStrategy: _dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  TileComponents<Event> get _multiDayTileComponents {
    return TileComponents<Event>(
     tileBuilder: (event, range) => MultiDayEventTile.builder(event as Event, range),
      overlayTileBuilder: (event, range) => OverlayEventTile.builder(event as Event, range),
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) => TileWhenDragging.builder(event as Event),
      dragAnchorStrategy: _dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  ScheduleTileComponents<Event> get _scheduleTileComponents {
    return ScheduleTileComponents<Event>(
      tileBuilder: (event, range) => MultiDayEventTile.builder(event as Event, range),
      overlayTileBuilder: (event, range) => OverlayEventTile.builder(event as Event, range),
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) => TileWhenDragging.builder(event as Event),
      dragAnchorStrategy: _dragAnchorStrategy,
    );
  }

  CalendarCallbacks<Event> get _callbacks {
    return CalendarCallbacks<Event>(
      onEventTapped: (event, renderBox) => EventOverlayPortal.createEventOverlay(context, event, renderBox),
      onEventCreate: (event) => Event(
        dateTimeRange: DateTimeRange(start: event.start, end: event.end),
        title: 'New Event',
      ),
      onEventCreated: (event) => _eventsController.addEvent(event),
      onTappedWithDetail: _createEvent,
      onLongPressedWithDetail: _createEvent,
    );
  }

  void _createEvent(TapDetail detail) {
    final range = switch (detail) {
      DayDetail detail => DateTimeRange(start: detail.date, end: detail.date.add(const Duration(minutes: 45))),
      MultiDayDetail detail => detail.dateTimeRange,
      _ => throw Exception('Unsupported detail type: ${detail.runtimeType}'),
    };
    _eventsController.addEvent(CalendarEvent(dateTimeRange: range));
  }
}
