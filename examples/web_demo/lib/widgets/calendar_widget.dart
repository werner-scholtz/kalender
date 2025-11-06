import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/main.dart' show MyApp;
import 'package:web_demo/models/calendar_configuration.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/widgets/calendar_configuration.dart';
import 'package:web_demo/widgets/components/calendar_header.dart';
import 'package:web_demo/widgets/components/event_tiles.dart';
import 'package:web_demo/widgets/event_overlay_portal.dart';
import 'package:web_demo/widgets/resize_handle.dart';
import 'package:web_demo/widgets/zoom.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  static _CalendarWidgetState? _of(BuildContext context) {
    return context.findAncestorStateOfType<_CalendarWidgetState>();
  }

  static void setViewConfiguration(BuildContext context, ViewConfiguration value) {
    final state = _of(context);
    if (state == null) throw Exception('SingleCalendarViewState not found in context');
    state._configuration.viewConfiguration = value;
  }

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final _configuration = CalendarConfiguration();
  final _controller = CalendarController<Event>();
  EventsController<Event> get _eventsController => MyApp.eventsController(context);

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
              child: ListenableBuilder(
                listenable: _configuration,
                builder: (context, child) {
                  return ZoomDetector(
                    controller: _controller,
                    child: CalendarView<Event>(
                      location: context.location.value,
                      locale: Localizations.localeOf(context).toLanguageTag(),
                      calendarController: _controller,
                      eventsController: _eventsController,
                      viewConfiguration: _configuration.viewConfiguration,
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
                                controller: _controller,
                                viewConfigurations: _configuration.viewConfigurations,
                                viewConfiguration: _configuration.viewConfiguration,
                              ),
                            ),
                            if (_configuration.showHeader)
                              CalendarHeader<Event>(
                                multiDayTileComponents: _multiDayTileComponents,
                                multiDayHeaderConfiguration: _configuration.multiDayHeaderConfiguration,
                                interaction: _configuration.interactionHeader,
                              ),
                          ],
                        ),
                      ),
                      body: CalendarBody<Event>(
                        multiDayTileComponents: _tileComponents,
                        monthTileComponents: _multiDayTileComponents,
                        multiDayBodyConfiguration: _configuration.multiDayBodyConfiguration,
                        monthBodyConfiguration: _configuration.monthBodyConfiguration,
                        scheduleTileComponents: _scheduleTileComponents,
                        interaction: _configuration.interactionBody,
                        snapping: _configuration.snapping,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (canShowCustomize)
              Expanded(
                flex: 1,
                child: CalendarConfigurationWidget(configuration: _configuration),
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
      tileBuilder: EventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: _dragAnchorStrategy,
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
      dragAnchorStrategy: _dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  ScheduleTileComponents<Event> get _scheduleTileComponents {
    return ScheduleTileComponents<Event>(
      tileBuilder: MultiDayEventTile.builder,
      overlayTileBuilder: OverlayEventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: _dragAnchorStrategy,
    );
  }

  CalendarCallbacks<Event> get _callbacks {
    return CalendarCallbacks<Event>(
      onEventTapped: (event, renderBox) => EventOverlayPortal.createEventOverlay(context, event, renderBox),
      onEventCreate: (event) => event.copyWith(data: const Event(title: 'New Event')),
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
    _eventsController.addEvent(CalendarEvent<Event>(dateTimeRange: range));
  }
}
