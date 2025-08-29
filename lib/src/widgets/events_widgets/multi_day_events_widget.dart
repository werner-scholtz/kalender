import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_event_tile.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_overlay_event_tile.dart';
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
class MultiDayEventWidget<T extends Object?> extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;
  final int? maxNumberOfRows;
  final double tileHeight;
  final bool showAllEvents;
  final GenerateMultiDayLayoutFrame<T>? generateMultiDayLayoutFrame;
  final MultiDayLayoutFrameCache<T> multiDayCache;
  final EdgeInsets? eventPadding;
  final OverlayBuilders<T>? overlayBuilders;
  final OverlayStyles? overlayStyles;

  const MultiDayEventWidget({
    super.key,
    required this.visibleDateTimeRange,
    required this.showAllEvents,
    required this.tileHeight,
    required this.maxNumberOfRows,
    required this.eventPadding,
    required this.generateMultiDayLayoutFrame,
    required this.overlayBuilders,
    required this.overlayStyles,
    required this.multiDayCache,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: check if this needs to rebuild as often as it is currently.

    final controller = context.calendarController<T>();
    final eventsController = context.eventsController<T>();

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
        controller.visibleEvents.value = {
          ...controller.visibleEvents.value,
          ...visibleEvents,
        };

        return MultiDayEventLayoutWidget<T>(
          events: visibleEvents.toList(),
          eventsController: eventsController,
          visibleDateTimeRange: visibleDateTimeRange,
          showAllEvents: showAllEvents,
          tileHeight: tileHeight,
          maxNumberOfVerticalEvents: maxNumberOfRows,
          generateMultiDayLayoutFrame: generateMultiDayLayoutFrame,
          multiDayCache: multiDayCache,
          textDirection: Directionality.of(context),
          multiDayOverlayBuilders: overlayBuilders,
          multiDayOverlayStyles: overlayStyles,
          eventPadding: eventPadding,
        );
      },
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
/// This widget is used by month views and in day view headers, for  displaying multi-day activities.
class MultiDayEventLayoutWidget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final DateTimeRange visibleDateTimeRange;
  final bool showAllEvents;
  final double tileHeight;
  final int? maxNumberOfVerticalEvents;
  final EdgeInsets? eventPadding;
  final OverlayBuilders<T>? multiDayOverlayBuilders;
  final OverlayStyles? multiDayOverlayStyles;

  /// The list of events that will be laid out.
  ///
  /// * Note: not all of these events will necessarily be visible,
  ///         it depends on [maxNumberOfVerticalEvents].
  final List<CalendarEvent<T>> events;

  /// The function that generates the layout frame for the events.
  final GenerateMultiDayLayoutFrame<T>? generateMultiDayLayoutFrame;

  /// The cache used for the multi-day event layout.
  final MultiDayLayoutFrameCache<T> multiDayCache;

  /// The directionality of the widget.
  final TextDirection textDirection;
  const MultiDayEventLayoutWidget({
    required this.events,
    required this.eventsController,
    required this.visibleDateTimeRange,
    required this.showAllEvents,
    required this.tileHeight,
    required this.maxNumberOfVerticalEvents,
    required this.eventPadding,
    required this.generateMultiDayLayoutFrame,
    required this.textDirection,
    required this.multiDayOverlayBuilders,
    required this.multiDayOverlayStyles,
    required this.multiDayCache,
    super.key,
  });

  @override
  State<MultiDayEventLayoutWidget<T>> createState() => _MultiDayEventLayoutWidgetState<T>();
}

class _MultiDayEventLayoutWidgetState<T extends Object?> extends State<MultiDayEventLayoutWidget<T>> {
  /// The range of dates that the events will be laid out on.
  late DateTimeRange _dateTimeRange;

  /// The layout frame that contains all the data needed to display the events.
  late MultiDayLayoutFrame<T> _frame;

  /// Get the render box of the widget.
  RenderBox getRenderBox() => context.findRenderObject() as RenderBox;

  /// The function that generates the layout frame for the events.
  GenerateMultiDayLayoutFrame<T> get generateMultiDayLayoutFrame =>
      widget.generateMultiDayLayoutFrame ?? defaultMultiDayFrameGenerator<T>;

  @override
  void initState() {
    super.initState();
    _dateTimeRange = widget.visibleDateTimeRange;
    _frame = generateMultiDayLayoutFrame(
      visibleDateTimeRange: _dateTimeRange,
      events: widget.events,
      textDirection: widget.textDirection,
      cache: widget.multiDayCache,
    );
  }

  @override
  void didUpdateWidget(covariant MultiDayEventLayoutWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final shouldUpdateCache = !oldWidget.events.equals(widget.events) ||
        oldWidget.generateMultiDayLayoutFrame != widget.generateMultiDayLayoutFrame ||
        oldWidget.textDirection != widget.textDirection;

    final didUpdate = shouldUpdateCache ||
        oldWidget.visibleDateTimeRange != widget.visibleDateTimeRange ||
        oldWidget.tileHeight != widget.tileHeight ||
        oldWidget.maxNumberOfVerticalEvents != widget.maxNumberOfVerticalEvents ||
        oldWidget.showAllEvents != widget.showAllEvents ||
        oldWidget.multiDayCache != widget.multiDayCache;

    if (didUpdate) {
      _dateTimeRange = widget.visibleDateTimeRange;

      if (shouldUpdateCache) {
        widget.multiDayCache.removeCache(_dateTimeRange);
      }

      setState(() {
        _frame = generateMultiDayLayoutFrame(
          visibleDateTimeRange: _dateTimeRange,
          events: widget.events,
          textDirection: widget.textDirection,
          cache: widget.multiDayCache,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final (events, layoutInfo) = _frame.visibleEvents(widget.maxNumberOfVerticalEvents);

    final maxNumberOfRows = widget.maxNumberOfVerticalEvents == null
        ? _frame.totalNumberOfRows
        : min(_frame.totalNumberOfRows, widget.maxNumberOfVerticalEvents!);

    // The multi-day events widget is used to display the events that span multiple days.
    final multiDayEventsWidget = CustomMultiChildLayout(
      delegate: MultiDayLayout(
        dateTimeRange: widget.visibleDateTimeRange,
        layoutInfo: layoutInfo,
        numberOfRows: maxNumberOfRows,
        tileHeight: widget.tileHeight,
      ),
      children: events.map((item) {
        final event = item;
        final id = event.id;

        return LayoutId(
          id: id,
          key: MultiDayEventTile.tileKey(id),
          child: Padding(
            padding: widget.eventPadding ?? const EdgeInsets.all(0),
            child: MultiDayEventTile<T>(
              event: event,
              callbacks: context.callbacks<T>(),
              tileComponents: context.tileComponents<T>(),
              interaction: context.interaction,
              dateTimeRange: widget.visibleDateTimeRange,
            ),
          ),
        );
      }).toList(),
    );

    // The drop target widget is used to show the drop target for the event that is being dragged.
    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: context.calendarController<T>().selectedEvent,
      builder: (context, event, child) {
        if (event == null) return const SizedBox();
        if (!widget.showAllEvents && !event.isMultiDayEvent) return const SizedBox();
        if (!event.dateTimeRangeAsUtc.overlaps(widget.visibleDateTimeRange)) return const SizedBox();
        final frame = generateMultiDayLayoutFrame(
          visibleDateTimeRange: widget.visibleDateTimeRange,
          events: [event],
          textDirection: widget.textDirection,
        );

        return CustomMultiChildLayout(
          delegate: MultiDayLayout(
            dateTimeRange: widget.visibleDateTimeRange,
            layoutInfo: frame.layoutInfo,
            numberOfRows: frame.totalNumberOfRows,
            tileHeight: widget.tileHeight,
          ),
          children: [
            LayoutId(
              id: event.id,
              child: event.id == -1 || event.id == context.calendarController<T>().selectedEventId
                  ? Padding(
                      padding: widget.eventPadding ?? const EdgeInsets.all(0),
                      child: context.tileComponents<T>().dropTargetTile?.call(event) ?? const SizedBox(),
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
        if (_frame.totalNumberOfRows > maxNumberOfRows)
          Row(
            children: _frame.columnRowMap.entries.map((entry) {
              final column = entry.key;
              final row = entry.value;
              final date = _frame.dateFromColumn(column);
              final eventsForColumn = _frame.eventsForColumn(column);
              late final numberOfHiddenRows = (row + 1) - maxNumberOfRows;

              late final overlayPortal = widget.multiDayOverlayBuilders?.multiDayOverlayPortalBuilder?.call(
                    date: date,
                    events: eventsForColumn,
                    numberOfHiddenRows: numberOfHiddenRows,
                    tileHeight: widget.tileHeight,
                    getMultiDayEventLayoutRenderBox: getRenderBox,
                    overlayBuilders: widget.multiDayOverlayBuilders,
                    overlayStyles: widget.multiDayOverlayStyles,
                  ) ??
                  MultiDayOverlayPortal<T>(
                    key: MultiDayOverlayPortal.getKey(date),
                    date: date,
                    events: eventsForColumn,
                    numberOfHiddenRows: numberOfHiddenRows,
                    tileHeight: widget.tileHeight,
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
  MultiDayOverlayEventTile<T> _overlayEventTileBuilder(
    CalendarEvent<T> event,
    DateTimeRange dateTimeRange,
    VoidCallback dismissOverlay,
  ) {
    return MultiDayOverlayEventTile<T>(
      event: event,
      dateTimeRange: dateTimeRange,
      callbacks: context.callbacks<T>(),
      tileComponents: context.tileComponents<T>(),
      dismissOverlay: dismissOverlay,
      interaction: context.interaction,
    );
  }
}
