import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_overlay_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// This widget is used to display multi-day events.
///
/// It fetches the events that need to be rendered from the [EventsController],
/// the [EventsController] is also listened to in-case events are added or updated.
///
/// This widget also takes responsibility for updating the [CalendarController.visibleEvents],
/// unlike the DayEventsWidget that can clear the visibleEvents it only adds the events that are visible.
///
/// * Note: When a event is being modified by the user it renders that event in a separate [CustomMultiChildLayout],
///         This is somewhat expensive computationally as it lays out all the events again to determine the position
///         of the event being modified. See todo for a possible solution.
class MultiDayEventWidget extends StatefulWidget {
  /// The controller that holds the events.
  final EventsController eventsController;

  /// The configuration that will be used to layout the multi-day events.
  final HorizontalConfiguration configuration;

  /// The range of dates that are visible.
  final InternalDateTimeRange internalDateTimeRange;

  /// The maximum number of vertical events that can be displayed.
  final int? maxNumberOfVerticalEvents;

  /// The cache used to store layout frames for multi-day events.
  final MultiDayLayoutFrameCache? multiDayCache;

  /// The builders used to create overlay widgets for multi-day events.
  final OverlayBuilders? overlayBuilders;

  /// The styles used for overlay widgets for multi-day events.
  final OverlayStyles? overlayStyles;

  /// Creates a new [MultiDayEventWidget].
  const MultiDayEventWidget({
    super.key,
    required this.eventsController,
    required this.configuration,
    required this.internalDateTimeRange,
    required this.maxNumberOfVerticalEvents,
    required this.multiDayCache,
    required this.overlayBuilders,
    required this.overlayStyles,
  });

  @override
  State<MultiDayEventWidget> createState() => _MultiDayEventWidgetState();
}

class _MultiDayEventWidgetState extends State<MultiDayEventWidget> {
  ValueNotifier<Location?>? _locationNotifier;

  /// The list of visible events.
  List<CalendarEvent> _visibleEvents = [];

  @override
  void initState() {
    super.initState();

    widget.eventsController.addListener(_updateEvents);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _locationNotifier = context.locationNotifier;
        _updateEvents();
        _locationNotifier?.addListener(_updateEvents);
      }
    });
  }

  @override
  void dispose() {
    widget.eventsController.removeListener(_updateEvents);
    _locationNotifier?.removeListener(_updateEvents);
    super.dispose();
  }

  /// Updates the list of visible events if there are changes.
  void _updateEvents() {
    final visibleEvents = widget.eventsController.eventsFromDateTimeRange(
      widget.internalDateTimeRange,
      includeDayEvents: widget.configuration.allowSingleDayEvents,
      includeMultiDayEvents: true,
      location: _locationNotifier?.value,
    );

    if (!listEquals(_visibleEvents, visibleEvents.toList())) {
      // Update the state with the new visible events.
      setState(() => _visibleEvents = visibleEvents.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update the visible events in the calendar controller.
    final controller = context.calendarController();
    controller.visibleEvents.value = {...controller.visibleEvents.value, ..._visibleEvents};

    return MultiDayEventLayoutWidget(
      events: _visibleEvents,
      internalDateTimeRange: widget.internalDateTimeRange,
      textDirection: Directionality.of(context),
      configuration: widget.configuration,
      maxNumberOfVerticalEvents: widget.maxNumberOfVerticalEvents,
      multiDayCache: widget.multiDayCache,
      multiDayOverlayBuilders: widget.overlayBuilders,
      multiDayOverlayStyles: widget.overlayStyles,
      location: context.location,
    );
  }
}

/// A widget that lays out events spanning multiple days in a calendar view.
///
/// The [MultiDayEventLayoutWidget] is responsible for arranging and displaying
/// events that occur over multiple days in a visually organized manner. It ensures
/// that overlapping or adjacent events are properly aligned and do not overlap
/// visually.
///
/// This widget is used by month views and in day view headers, for displaying multi-day activities.
class MultiDayEventLayoutWidget extends StatefulWidget {
  /// The configuration that will be used to layout the multi-day events.
  final HorizontalConfiguration configuration;

  /// The range of dates that are visible.
  final InternalDateTimeRange internalDateTimeRange;

  /// The list of events that will be laid out.
  ///
  /// * Note: not all of these events will necessarily be visible,
  final List<CalendarEvent> events;

  /// The directionality of the widget.
  final TextDirection textDirection;

  /// The maximum number of vertical events that can be displayed.
  final int? maxNumberOfVerticalEvents;

  /// The cache used to store layout frames for multi-day events.
  final MultiDayLayoutFrameCache? multiDayCache;

  /// The builders used to create overlay widgets for multi-day events.
  final OverlayBuilders? multiDayOverlayBuilders;

  /// The styles used for overlay widgets for multi-day events.
  final OverlayStyles? multiDayOverlayStyles;

  final Location? location;

  const MultiDayEventLayoutWidget({
    required this.events,
    required this.internalDateTimeRange,
    required this.configuration,
    required this.textDirection,
    required this.maxNumberOfVerticalEvents,
    required this.multiDayCache,
    required this.multiDayOverlayBuilders,
    required this.multiDayOverlayStyles,
    required this.location,
    super.key,
  });

  @override
  State<MultiDayEventLayoutWidget> createState() => _MultiDayEventLayoutWidgetState();
}

class _MultiDayEventLayoutWidgetState extends State<MultiDayEventLayoutWidget> {
  /// The range of dates that the events will be laid out on.
  late InternalDateTimeRange _dateTimeRange = widget.internalDateTimeRange;

  /// The layout frame that contains all the data needed to display the events.
  MultiDayLayoutFrame? _frame;

  /// Get the render box of the widget.
  RenderBox getRenderBox() => context.findRenderObject() as RenderBox;

  /// The function that generates the layout frame for the events.
  GenerateMultiDayLayoutFrame get generateMultiDayLayoutFrame =>
      widget.configuration.generateMultiDayLayoutFrame ?? defaultMultiDayFrameGenerator;

  /// Returns the maximum number of vertical events that can be displayed.
  int maxNumberOfRows(MultiDayLayoutFrame frame) {
    final max = widget.maxNumberOfVerticalEvents ?? widget.configuration.maximumNumberOfVerticalEvents;
    return max == null ? frame.totalNumberOfRows : min(frame.totalNumberOfRows, max);
  }

  @override
  void initState() {
    super.initState();
    _frame = generateMultiDayLayoutFrame(
      visibleDateTimeRange: _dateTimeRange,
      events: widget.events,
      textDirection: widget.textDirection,
      cache: widget.multiDayCache,
      location: widget.location,
    );
  }

  @override
  void didUpdateWidget(covariant MultiDayEventLayoutWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final shouldUpdateCache = !oldWidget.events.equals(widget.events) ||
        oldWidget.configuration != widget.configuration ||
        oldWidget.textDirection != widget.textDirection;

    final didUpdate = shouldUpdateCache || oldWidget.internalDateTimeRange != widget.internalDateTimeRange;

    if (didUpdate) {
      _dateTimeRange = widget.internalDateTimeRange;

      if (shouldUpdateCache) {
        widget.multiDayCache?.removeCache(_dateTimeRange);
      }

      setState(() {
        _frame = generateMultiDayLayoutFrame(
          visibleDateTimeRange: _dateTimeRange,
          events: widget.events,
          textDirection: widget.textDirection,
          cache: widget.multiDayCache,
          location: widget.location,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final frame = _frame;
    if (frame == null) return const SizedBox.shrink();

    final maxNumberOfRows = this.maxNumberOfRows(frame);
    final (events, layoutInfo) = frame.visibleEvents(maxNumberOfRows);

    // The multi-day events widget is used to display the events that span multiple days.
    final multiDayEventsWidget = CustomMultiChildLayout(
      delegate: MultiDayLayout(
        dateTimeRange: widget.internalDateTimeRange,
        layoutInfo: layoutInfo,
        numberOfRows: maxNumberOfRows,
        tileHeight: widget.configuration.tileHeight,
      ),
      children: events.map((item) {
        final event = item;
        final id = event.id;

        return LayoutId(
          id: id,
          key: MultiDayEventTile.tileKey(id),
          child: Padding(
            padding: widget.configuration.eventPadding,
            child: MultiDayEventTile(
              event: event,
              callbacks: context.callbacks(),
              tileComponents: context.tileComponents(),
              interaction: context.interaction,
              dateTimeRange: widget.internalDateTimeRange,
              resizeAxis: Axis.horizontal,
            ),
          ),
        );
      }).toList(),
    );

    // The drop target widget is used to show the drop target for the event that is being dragged.
    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: context.calendarController().selectedEvent,
      builder: (context, event, child) {
        if (event == null) return const SizedBox();
        if (!widget.configuration.allowSingleDayEvents && !event.isMultiDayEvent) return const SizedBox();
        if (!event.internalRange(location: context.location).overlaps(widget.internalDateTimeRange)) {
          return const SizedBox();
        }
        final frame = generateMultiDayLayoutFrame(
          visibleDateTimeRange: widget.internalDateTimeRange,
          events: [event],
          textDirection: widget.textDirection,
          // TODO: check
          cache: null,
          location: widget.location,
        );

        return CustomMultiChildLayout(
          delegate: MultiDayLayout(
            dateTimeRange: widget.internalDateTimeRange,
            layoutInfo: frame.layoutInfo,
            numberOfRows: frame.totalNumberOfRows,
            tileHeight: widget.configuration.tileHeight,
          ),
          children: [
            LayoutId(
              id: event.id,
              child: event.id == context.calendarController().selectedEventId
                  ? Padding(
                      padding: widget.configuration.eventPadding,
                      child: context.tileComponents().dropTargetTile?.call(event) ?? const SizedBox(),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            multiDayEventsWidget,
            PassThroughPointer(child: dropTargetWidget),
          ],
        ),
        if (frame.totalNumberOfRows > maxNumberOfRows)
          Row(
            children: frame.columnRowMap.entries.map((entry) {
              final column = entry.key;
              final row = entry.value;
              final date = frame.dateFromColumn(column);
              final eventsForColumn = frame.eventsForColumn(column);
              late final numberOfHiddenRows = (row + 1) - maxNumberOfRows;

              late final overlayPortal = widget.multiDayOverlayBuilders?.multiDayOverlayPortalBuilder?.call(
                    date: date,
                    events: eventsForColumn,
                    numberOfHiddenRows: numberOfHiddenRows,
                    tileHeight: widget.configuration.tileHeight,
                    getMultiDayEventLayoutRenderBox: getRenderBox,
                    overlayTileBuilder: _overlayEventTileBuilder,
                    overlayBuilders: widget.multiDayOverlayBuilders,
                    overlayStyles: widget.multiDayOverlayStyles,
                  ) ??
                  MultiDayOverlayPortal(
                    key: MultiDayOverlayPortal.getKey(date),
                    date: date,
                    events: eventsForColumn,
                    numberOfHiddenRows: numberOfHiddenRows,
                    tileHeight: widget.configuration.tileHeight,
                    getMultiDayEventLayoutRenderBox: getRenderBox,
                    overlayBuilders: widget.multiDayOverlayBuilders,
                    overlayStyles: widget.multiDayOverlayStyles,
                    overlayTileBuilder: _overlayEventTileBuilder,
                  );

              return Expanded(
                child: row >= maxNumberOfRows ? overlayPortal : const SizedBox.shrink(),
              );
            }).toList(),
          ),
      ],
    );
  }

  /// The function that builds the overlay event tile for the event.
  MultiDayOverlayEventTile _overlayEventTileBuilder(
    CalendarEvent event,
    InternalDateTimeRange dateTimeRange,
    VoidCallback dismissOverlay,
  ) {
    return MultiDayOverlayEventTile(
      event: event,
      dateTimeRange: dateTimeRange,
      callbacks: context.callbacks(),
      tileComponents: context.tileComponents(),
      dismissOverlay: dismissOverlay,
      interaction: context.interaction,
    );
  }
}
