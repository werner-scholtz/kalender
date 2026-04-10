import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/configuration/configuration_panel.dart';
import 'package:web_demo/widgets/calendar/detail_overlay.dart';
import 'package:web_demo/widgets/calendar/event_tiles.dart';
import 'package:web_demo/widgets/calendar/resize_handle.dart';
import 'package:web_demo/widgets/calendar/navigation_header.dart';
import 'package:web_demo/widgets/calendar/zoom.dart';

class Calendar extends StatelessWidget {
  final bool initialShowConfig;
  const Calendar({super.key, this.initialShowConfig = true});

  @override
  Widget build(BuildContext context) {
    return CalendarScope(
      child: Builder(
        builder: (context) => EventDetailOverlay(
          location: context.location.value,
          child: CalendarContent(initialShowConfig: initialShowConfig),
        ),
      ),
    );
  }
}

class CalendarContent extends StatefulWidget {
  final bool initialShowConfig;
  const CalendarContent({super.key, this.initialShowConfig = true});

  @override
  State<CalendarContent> createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  late bool _showConfig = widget.initialShowConfig;

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
                child: ListenableBuilder(
                  listenable: Listenable.merge([
                    context.configuration.viewConfigurationNotifier,
                    context.location,
                  ]),
                  builder: (context, _) => CalendarView(
                    location: context.location.value,
                    locale: Localizations.localeOf(context).toLanguageTag(),
                    calendarController: context.controller,
                    eventsController: context.eventsController,
                    viewConfiguration: context.configuration.viewConfiguration,
                    components: _components(context),
                    callbacks: _callbacks,
                    header: Column(
                      spacing: 4,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: !context.configuration.showHeader
                                ? Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).colorScheme.outlineVariant.withAlpha(100),
                                    ),
                                  )
                                : null,
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
                          ListenableBuilder(
                            listenable: Listenable.merge([
                              context.configuration.interactionHeader,
                              context.configuration.multiDayHeaderConfigurationNotifier,
                            ]),
                            builder: (context, _) {
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
                                  interaction: context.configuration.interactionBody.value,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    body: ListenableBuilder(
                      listenable: Listenable.merge([
                        context.configuration.interactionBody,
                        context.configuration.snapping,
                        context.configuration.multiDayBodyConfigurationNotifier,
                        context.configuration.monthBodyConfigurationNotifier,
                      ]),
                      builder: (context, _) {
                        return CalendarBody(
                          multiDayTileComponents: _tileComponents,
                          monthTileComponents: _multiDayTileComponents,
                          multiDayBodyConfiguration: context.configuration.multiDayBodyConfiguration,
                          monthBodyConfiguration: context.configuration.monthBodyConfiguration,
                          scheduleTileComponents: _scheduleTileComponents,
                          interaction: context.configuration.interactionBody.value,
                          snapping: context.configuration.snapping.value,
                        );
                      },
                    ),
                  ),
                ),
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
                        height: constraints.maxHeight,
                        child: ConfigurationPanel(
                          configuration: context.configuration,
                          onDismiss: () => setState(() => _showConfig = false),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
          ],
        );
      },
    );
  }

  CalendarComponents _components(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lineColor = cs.outlineVariant.withAlpha(60);
    final mutedText = TextStyle(color: cs.onSurfaceVariant);
    return CalendarComponents(
      multiDayComponentStyles: MultiDayComponentStyles(
        headerStyles: MultiDayHeaderComponentStyles(
          dayHeaderStyle: DayHeaderStyle(
            textStyle: mutedText,
            numberTextStyle: mutedText,
          ),
        ),
        bodyStyles: MultiDayBodyComponentStyles(
          hourLinesStyle: HourLinesStyle(color: lineColor),
          daySeparatorStyle: DaySeparatorStyle(color: lineColor),
        ),
      ),
      monthComponentStyles: MonthComponentStyles(
        bodyStyles: MonthBodyComponentStyles(
          monthGridStyle: MonthGridStyle(color: lineColor),
        ),
      ),
    );
  }

  /// The drag anchor strategy for the feedback tile.
  Offset _dragAnchorStrategy(Draggable draggable, BuildContext context, Offset position) {
    final renderObject = context.findRenderObject()! as RenderBox;
    return Offset(20, renderObject.size.height / 2);
  }

  TileComponents _buildTileComponents({
    required Widget Function(CalendarEvent, DateTimeRange) tileBuilder,
    Widget Function(CalendarEvent, DateTimeRange)? overlayTileBuilder,
  }) {
    return TileComponents(
      tileBuilder: tileBuilder,
      overlayTileBuilder: overlayTileBuilder,
      dropTargetTile: (event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (event) => TileWhenDragging.builder(event as Event),
      dragAnchorStrategy: _dragAnchorStrategy,
      verticalResizeHandle: const ResizeHandle.vertical(),
      horizontalResizeHandle: const ResizeHandle.horizontal(),
    );
  }

  TileComponents get _tileComponents =>
      _buildTileComponents(tileBuilder: (event, range) => EventTile.builder(event as Event, range));

  TileComponents get _multiDayTileComponents => _buildTileComponents(
        tileBuilder: (event, range) => MultiDayEventTile.builder(event as Event, range),
        overlayTileBuilder: (event, range) => MultiDayEventTile.overlayBuilder(event as Event, range),
      );

  ScheduleTileComponents get _scheduleTileComponents => ScheduleTileComponents(
        tileBuilder: (event, range) => MultiDayEventTile.builder(event as Event, range),
        overlayTileBuilder: (event, range) => MultiDayEventTile.overlayBuilder(event as Event, range),
        dropTargetTile: (event) => DropTargetTile.builder(event as Event),
        feedbackTileBuilder: (event, size) => FeedbackTile.builder(event as Event, size),
        tileWhenDraggingBuilder: (event) => TileWhenDragging.builder(event as Event),
        dragAnchorStrategy: _dragAnchorStrategy,
      );

  CalendarCallbacks get _callbacks => CalendarCallbacks(
        onEventTapped: (event, renderBox) {
          context.controller.deselectEvent();
          context.controller.selectEvent(event);
          EventDetailOverlay.createEventOverlay(context, event as Event, renderBox);
        },
        onTapped: (_) => context.controller.deselectEvent(),
        onEventCreate: (event) => Event(
          dateTimeRange: DateTimeRange(start: event.start, end: event.end),
          title: context.l10n.newEventTitle,
        ),
        onEventCreated: (event) => context.eventsController.addEvent(event),
        onEventChanged: (event, updatedEvent) => context.eventsController.updateEvent(
          event: event as Event,
          updatedEvent: updatedEvent as Event,
        ),
        onLongPressedWithDetail: (TapDetail detail) {
          final range = switch (detail) {
            DayDetail detail => DateTimeRange(start: detail.date, end: detail.date.add(const Duration(minutes: 45))),
            MultiDayDetail detail => detail.dateTimeRange,
            _ => throw Exception('Unsupported detail type: ${detail.runtimeType}'),
          };
          context.eventsController.addEvent(Event(dateTimeRange: range, title: context.l10n.newEventTitle));
        },
      );
}
