import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/utils.dart';
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
          child: Builder(
            builder: (context) => EventOverlayPortal(
              location: context.location.value,
              child: const CalendarWidget(),
            ),
          ),
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
  bool _showConfig = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowCustomize = constraints.maxWidth > 500;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ZoomDetector(
                controller: context.controller,
                child: CalendarView(
                    location: context.location.value,
                    locale: Localizations.localeOf(context).toLanguageTag(),
                    calendarController: context.controller,
                    eventsController: context.eventsController,
                    viewConfiguration: context.configuration.viewConfiguration,
                    callbacks: _callbacks,
                    header: Column(
                      spacing: 4,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: NavigationHeader(
                              controller: context.controller,
                              viewConfigurations: context.configuration.viewConfigurations,
                              viewConfiguration: context.configuration.viewConfiguration,
                              onToggleConfig:
                                  canShowCustomize ? () => setState(() => _showConfig = !_showConfig) : null,
                              configVisible: _showConfig,
                            ),
                          ),
                        ),
                        if (context.configuration.showHeader)
                          ValueListenableBuilder(
                            valueListenable: context.configuration.interactionHeader,
                            builder: (context, value, child) {
                              return Container(
                                padding: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).colorScheme.outlineVariant.withAlpha(100),
                                    ),
                                  ),
                                ),
                                child: CalendarHeader(
                                  multiDayTileComponents: _multiDayTileComponents,
                                  multiDayHeaderConfiguration: context.configuration.multiDayHeaderConfiguration,
                                  interaction: value,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    body: ValueListenableBuilder(
                      valueListenable: context.configuration.interactionBody,
                      builder: (context, interactionBody, child) {
                        return ValueListenableBuilder(
                          valueListenable: context.configuration.snapping,
                          builder: (context, snapping, child) {
                            return CalendarBody(
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
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.centerLeft,
                child: _showConfig
                    ? SizedBox(
                        width: min(constraints.maxWidth * 0.35, 400),
                        child: CalendarConfigurationWidget(configuration: context.configuration),
                      )
                    : const SizedBox.shrink(),
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

  TileComponents get _tileComponents {
    return TileComponents(
      tileBuilder: (event, range) => EventTile.builder(event as Event, range),
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) => TileWhenDragging.builder(event as Event),
      dragAnchorStrategy: _dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  TileComponents get _multiDayTileComponents {
    return TileComponents(
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

  ScheduleTileComponents get _scheduleTileComponents {
    return ScheduleTileComponents(
      tileBuilder: (event, range) => MultiDayEventTile.builder(event as Event, range),
      overlayTileBuilder: (event, range) => OverlayEventTile.builder(event as Event, range),
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) => TileWhenDragging.builder(event as Event),
      dragAnchorStrategy: _dragAnchorStrategy,
    );
  }

  CalendarCallbacks get _callbacks {
    return CalendarCallbacks(
      onEventTapped: (event, renderBox) => EventOverlayPortal.createEventOverlay(context, event, renderBox),
      onEventCreate: (event) => Event(
        dateTimeRange: DateTimeRange(start: event.start, end: event.end),
        title: context.l10n.newEventTitle,
      ),
      onEventCreated: (event) => context.eventsController.addEvent(event),
      onEventChanged: (event, updatedEvent) => context.eventsController.updateEvent(
        event: event,
        updatedEvent: updatedEvent,
      ),
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
    context.eventsController.addEvent(Event(dateTimeRange: range, title: context.l10n.newEventTitle));
  }
}
