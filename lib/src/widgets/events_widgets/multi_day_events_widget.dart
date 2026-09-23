// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/day_overlay.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// Displays the multi-day events from the [EventsController] and rebuilds when they change.
///
/// Adds the events it shows to [KalenderController.visibleEvents] without clearing it.
class MultiDayEventWidget extends StatefulWidget {
  /// The controller that holds the events.
  final EventsController eventsController;

  /// The configuration that will be used to layout the multi-day events.
  final HorizontalConfiguration configuration;

  /// The range of dates that are visible.
  final FloatingDateTimeRange floatingRange;

  /// The maximum number of vertical events that can be displayed.
  final int? maxNumberOfVerticalEvents;

  /// The cache used to store layout frames for multi-day events.
  final MultiDayLayoutFrameCache? multiDayCache;

  /// The builders used to create overlay widgets for multi-day events.
  final OverlayBuilders? overlayBuilders;

  const MultiDayEventWidget({
    super.key,
    required this.eventsController,
    required this.configuration,
    required this.floatingRange,
    required this.maxNumberOfVerticalEvents,
    required this.multiDayCache,
    required this.overlayBuilders,
  });

  @override
  State<MultiDayEventWidget> createState() => _MultiDayEventWidgetState();
}

class _MultiDayEventWidgetState extends State<MultiDayEventWidget> {
  ValueNotifier<Location?>? _locationNotifier;

  /// The list of visible events.
  List<KalenderEvent> _events = [];

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
    final visibleEvents = widget.eventsController
        .eventsInRange(
          widget.floatingRange,
          multiDayRule: context.multiDayRule,
          includeDayEvents: widget.configuration.allowSingleDayEvents,
          includeMultiDayEvents: true,
          location: _locationNotifier?.value,
        )
        .toList();

    if (eventLayoutChanged(visibleEvents, _events)) {
      // Update the state with the new visible events.
      setState(() => _events = visibleEvents);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = context.kalenderController;
        // A new set notifies listeners even when its contents match, so assign only when something is added.
        final current = controller.visibleEvents.value;
        if (_events.any((event) => !current.contains(event))) {
          controller.visibleEvents.value = {...current, ..._events};
        }
      }
    });

    return MultiDayEventLayoutWidget(
      events: _events,
      floatingRange: widget.floatingRange,
      textDirection: Directionality.of(context),
      configuration: widget.configuration,
      maxNumberOfVerticalEvents: widget.maxNumberOfVerticalEvents,
      multiDayCache: widget.multiDayCache,
      multiDayOverlayBuilders: widget.overlayBuilders,
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
  final FloatingDateTimeRange floatingRange;

  /// The list of events that will be laid out.
  ///
  /// * Note: not all of these events will necessarily be visible,
  final List<KalenderEvent> events;

  /// The directionality of the widget.
  final TextDirection textDirection;

  /// The maximum number of vertical events that can be displayed.
  final int? maxNumberOfVerticalEvents;

  /// The cache used to store layout frames for multi-day events.
  final MultiDayLayoutFrameCache? multiDayCache;

  /// The builders used to create overlay widgets for multi-day events.
  final OverlayBuilders? multiDayOverlayBuilders;

  final Location? location;

  const MultiDayEventLayoutWidget({
    required this.events,
    required this.floatingRange,
    required this.configuration,
    required this.textDirection,
    required this.maxNumberOfVerticalEvents,
    required this.multiDayCache,
    required this.multiDayOverlayBuilders,
    required this.location,
    super.key,
  });

  @override
  State<MultiDayEventLayoutWidget> createState() => _MultiDayEventLayoutWidgetState();
}

class _MultiDayEventLayoutWidgetState extends State<MultiDayEventLayoutWidget> {
  /// The layout frame that contains all the data needed to display the events.
  MultiDayLayoutFrame? _frame;

  /// Get the render box of the widget.
  RenderBox getRenderBox() => context.findRenderObject() as RenderBox;

  /// The one overlay of this widget. It shows the open day while that day is in the widget's range.
  final _portalController = OverlayPortalController();

  /// The row of boxes the overlay card is positioned from, one per column.
  final _anchorsKey = GlobalKey();

  KalenderController? _kalenderController;

  /// The strategy that generates the layout frame for the events.
  MultiDayLayoutStrategy get multiDayLayoutStrategy => widget.configuration.multiDayLayoutStrategy;

  /// Returns the maximum number of vertical events that can be displayed.
  int maxNumberOfRows(MultiDayLayoutFrame frame) {
    final max = widget.maxNumberOfVerticalEvents ?? widget.configuration.maximumNumberOfVerticalEvents;
    return max == null ? frame.totalNumberOfRows : min(frame.totalNumberOfRows, max);
  }

  @override
  void initState() {
    super.initState();
    _frame = multiDayLayoutStrategy.generateFrame(
      visibleRange: widget.floatingRange,
      events: widget.events,
      textDirection: widget.textDirection,
      cache: widget.multiDayCache,
      location: widget.location,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.kalenderController;
    if (controller == _kalenderController) return;
    _kalenderController?.openDayOverlay.removeListener(_onOpenDayChanged);
    _kalenderController = controller..openDayOverlay.addListener(_onOpenDayChanged);
    _syncOverlayAfterFrame();
  }

  @override
  void dispose() {
    final controller = _kalenderController;
    controller?.openDayOverlay.removeListener(_onOpenDayChanged);
    final day = _openDay;
    if (controller != null && day != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.openDayOverlay.value == day) controller.hideDayOverlay();
      });
    }
    super.dispose();
  }

  /// The open day, when it is in the widget's range.
  FloatingDateTime? get _openDay {
    final day = _kalenderController?.openDayOverlay.value;
    return day != null && day.isWithin(widget.floatingRange) ? day : null;
  }

  /// Opens or closes the overlay. The card follows [KalenderController.openDayOverlay] on its own.
  void _onOpenDayChanged() {
    final open = _openDay != null;
    if (open == _portalController.isShowing) return;
    open ? _portalController.show() : _portalController.hide();
  }

  /// The portal cannot open or close while the tree is built.
  void _syncOverlayAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onOpenDayChanged();
    });
  }

  /// The column of [date], counting from the left.
  int _columnOf(FloatingDateTime date) {
    final days = date.difference(widget.floatingRange.start).inDays;
    return widget.textDirection == TextDirection.ltr ? days : widget.floatingRange.dates().length - 1 - days;
  }

  RenderBox _anchorBox(int column) {
    final row = _anchorsKey.currentContext!.findRenderObject()! as RenderFlex;
    var child = row.firstChild!;
    for (var i = 0; i < column; i++) {
      child = row.childAfter(child)!;
    }
    return child;
  }

  Widget _buildOverlay(BuildContext context, MultiDayLayoutFrame frame) {
    final controller = _kalenderController!;
    return ValueListenableBuilder(
      valueListenable: controller.openDayOverlay,
      builder: (context, _, _) {
        final day = _openDay;
        if (day == null) return const SizedBox.shrink();
        final column = _columnOf(day);
        return buildDayOverlay(
          context,
          date: day,
          events: frame.eventsForColumn(column),
          tileHeight: widget.configuration.tileHeight,
          portalController: DayOverlayController(openDayOverlay: controller.openDayOverlay, date: day),
          overlayTileBuilder: _overlayEventTileBuilder,
          getMultiDayEventLayoutRenderBox: getRenderBox,
          getOverlayPortalRenderBox: () => _anchorBox(column),
          overlayBuilders: widget.multiDayOverlayBuilders,
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant MultiDayEventLayoutWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final shouldUpdateCache =
        !oldWidget.events.equals(widget.events) ||
        oldWidget.configuration != widget.configuration ||
        oldWidget.textDirection != widget.textDirection;

    final didUpdate = shouldUpdateCache || oldWidget.floatingRange != widget.floatingRange;

    if (didUpdate) {
      if (oldWidget.floatingRange != widget.floatingRange) _syncOverlayAfterFrame();

      if (shouldUpdateCache) {
        // The events, configuration, and text direction apply to every range,
        // not just the current one, so a change invalidates every cached frame.
        // The paged headers rebuild each range in its own widget, but the
        // free-scroll band is a single widget whose range moves as it scrolls.
        // Dropping only the current range would leave stale frames for the
        // windows it scrolls back to, so clear the whole cache.
        widget.multiDayCache?.clearAll();
      }

      setState(() {
        _frame = multiDayLayoutStrategy.generateFrame(
          visibleRange: widget.floatingRange,
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

    final multiDayEventsWidget = CustomMultiChildLayout(
      delegate: MultiDayLayout(
        range: widget.floatingRange,
        layoutInfo: layoutInfo,
        numberOfRows: maxNumberOfRows,
        tileHeight: widget.configuration.tileHeight,
      ),
      children: [
        for (final event in events)
          LayoutId(
            id: event.id,
            key: MultiDayEventTile.tileKey(event.id),
            child: Padding(
              padding: widget.configuration.eventPadding,
              child: MultiDayEventTile(
                event: event,
                tileComponents: context.tileComponents,
                floatingRange: widget.floatingRange,
                resizeAxis: Axis.horizontal,
              ),
            ),
          ),
      ],
    );

    // The drop target widget is used to show the drop target for the event that is being dragged.
    final dropTargetWidget = ValueListenableBuilder(
      valueListenable: context.kalenderController.selectedEvent,
      builder: (context, event, child) {
        if (event == null) return const SizedBox();
        if (!widget.configuration.allowSingleDayEvents &&
            !event.spansMultipleDays(location: context.location, defaultRule: context.multiDayRule)) {
          return const SizedBox();
        }
        if (!event.floatingRange(location: context.location).overlaps(widget.floatingRange)) {
          return const SizedBox();
        }

        final previewEvents = widget.events.toList();
        final selectedEventIndex = previewEvents.indexWhere(
          (item) => item.id == context.kalenderController.selectedEventId,
        );
        if (selectedEventIndex != -1) {
          previewEvents[selectedEventIndex] = event;
        } else {
          previewEvents.insert(0, event);
        }

        final frame = multiDayLayoutStrategy.generateFrame(
          visibleRange: widget.floatingRange,
          events: previewEvents,
          textDirection: widget.textDirection,
          cache: null,
          location: widget.location,
        );

        final layoutInfo = frame.layoutInfo.where((info) => info.id == event.id).toList();
        if (layoutInfo.isEmpty) return const SizedBox();

        final maxNumberOfRows = this.maxNumberOfRows(frame);
        if (layoutInfo.first.row >= maxNumberOfRows) return const SizedBox();

        return CustomMultiChildLayout(
          delegate: MultiDayLayout(
            range: widget.floatingRange,
            layoutInfo: layoutInfo,
            numberOfRows: maxNumberOfRows,
            tileHeight: widget.configuration.tileHeight,
          ),
          children: [
            LayoutId(
              id: event.id,
              child: event.id == context.kalenderController.selectedEventId
                  ? Padding(
                      padding: widget.configuration.eventPadding,
                      child: context.tileComponents.dropTargetTile?.call(context, event) ?? const SizedBox(),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );

    final numberOfColumns = widget.floatingRange.dates().length;

    // Frame columns count from the left in both directions.
    final anchors = Row(
      key: _anchorsKey,
      textDirection: TextDirection.ltr,
      children: [for (var column = 0; column < numberOfColumns; column++) const Expanded(child: SizedBox.shrink())],
    );

    return OverlayPortal(
      controller: _portalController,
      overlayChildBuilder: (context) => _buildOverlay(context, frame),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              multiDayEventsWidget,
              PassThroughPointer(child: dropTargetWidget),
            ],
          ),
          anchors,
          if (frame.totalNumberOfRows > maxNumberOfRows)
            Row(
              textDirection: TextDirection.ltr,
              children: [
                for (final MapEntry(key: column, value: row) in frame.columnRowMap.entries)
                  Expanded(
                    child: row < maxNumberOfRows
                        ? const SizedBox.shrink()
                        : _buildOverlayPortal(context, frame, column, (row + 1) - maxNumberOfRows),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildOverlayPortal(BuildContext context, MultiDayLayoutFrame frame, int column, int numberOfHiddenRows) {
    final overlayBuilders = widget.multiDayOverlayBuilders;
    final date = frame.dateFromColumn(column);
    return overlayBuilders?.multiDayOverlayPortalBuilder?.call(
          context,
          date: date,
          events: frame.eventsForColumn(column),
          numberOfHiddenRows: numberOfHiddenRows,
          tileHeight: widget.configuration.tileHeight,
          overlayBuilders: overlayBuilders,
        ) ??
        MultiDayOverlayPortal(
          key: MultiDayOverlayPortal.getKey(date),
          date: date,
          numberOfHiddenRows: numberOfHiddenRows,
          overlayBuilders: overlayBuilders,
        );
  }

  MultiDayEventOverlayTile _overlayEventTileBuilder(
    BuildContext context,
    KalenderEvent event,
    FloatingDateTimeRange floatingRange,
    VoidCallback dismissOverlay,
  ) {
    return MultiDayEventOverlayTile(
      key: MultiDayEventOverlayTile.tileKey(event.id),
      floatingRange: floatingRange,
      tileComponents: context.tileComponents,
      dismissOverlay: dismissOverlay,
      event: event,
      resizeAxis: null,
    );
  }
}
