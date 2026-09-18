// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/drag_targets/schedule_drag_target.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';
import 'package:kalender/src/widgets/internal_components/gesture_callbacks_detector.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Displays events as a vertical list.
///
/// One list for a [ContinuousScheduleViewController], one list per page for a [PaginatedScheduleViewController].
///
/// {@category Views}
class ScheduleBody extends StatelessWidget {
  /// Configuration options for the schedule body behavior and appearance.
  ///
  /// If not provided, default [ScheduleBodyConfiguration] will be used.
  final ScheduleBodyConfiguration? configuration;

  const ScheduleBody({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final kalenderController = context.kalenderController;
    assert(
      kalenderController.viewController is ScheduleViewController,
      'The KalenderController\'s $ViewController needs to be a $ScheduleViewController',
    );
    final viewController = kalenderController.viewController as ScheduleViewController;
    final configuration = this.configuration ?? ScheduleBodyConfiguration();
    if (viewController is ContinuousScheduleViewController) {
      return SchedulePositionList(
        eventsController: context.eventsController,
        viewController: viewController,
        range: viewController.viewConfiguration.pageIndexCalculator.floatingRange(context.location),
        currentPage: 0,
        paginated: false,
        configuration: configuration,
        location: context.location,
      );
    } else if (viewController is PaginatedScheduleViewController) {
      return PaginatedSchedule(viewController: viewController, configuration: configuration);
    } else {
      throw Exception(
        'The view controller is not a $PaginatedScheduleViewController or $ContinuousScheduleViewController',
      );
    }
  }
}

/// A [PageView] of [SchedulePositionList]s for a [PaginatedScheduleViewController].
///
/// Each page shows the date range its index maps to.
///
/// {@category Views}
class PaginatedSchedule extends StatefulWidget {
  /// The controller specifically for paginated schedule view.
  final PaginatedScheduleViewController viewController;

  /// Configuration for schedule body behavior.
  final ScheduleBodyConfiguration configuration;

  const PaginatedSchedule({super.key, required this.viewController, required this.configuration});

  @override
  State<PaginatedSchedule> createState() => _PaginatedScheduleState();
}

class _PaginatedScheduleState extends State<PaginatedSchedule> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.viewController.pageController,
      itemCount: widget.viewController.viewConfiguration.pageIndexCalculator.numberOfPages(context.location),
      physics: widget.configuration.pageScrollPhysics,
      onPageChanged: (value) {
        final range = widget.viewController.viewConfiguration.pageIndexCalculator.rangeFromIndex(
          value,
          context.location,
        );
        context.callbacks?.onPageChanged?.call(range.forLocation(location: context.location));
      },
      itemBuilder: (context, index) {
        return SchedulePositionList(
          eventsController: context.eventsController,
          viewController: widget.viewController,
          range: widget.viewController.viewConfiguration.pageIndexCalculator.rangeFromIndex(index, context.location),
          currentPage: index,
          paginated: true,
          configuration: widget.configuration,
          location: context.location,
        );
      },
    );
  }
}

/// A scrollable list of the schedule items in [range], tracking the position of every item.
///
/// Items are [MonthItem] headers, [EventItem] rows and, per [ScheduleBodyConfiguration.emptyDay], [EmptyItem] rows.
///
/// {@category Views}
class SchedulePositionList extends StatefulWidget {
  /// The controller managing the events displayed in this list.
  final EventsController eventsController;

  /// The schedule view controller for this specific view.
  final ScheduleViewController viewController;

  /// Configuration options for the schedule body behavior.
  final ScheduleBodyConfiguration configuration;

  /// The date range to display in this list.
  final FloatingDateTimeRange range;

  /// The current page index (used in paginated views).
  final int currentPage;

  /// Whether this list is part of a paginated view.
  final bool paginated;

  /// The location for date calculations, used for features like "today" highlighting.
  final Location? location;

  const SchedulePositionList({
    super.key,
    required this.eventsController,
    required this.viewController,
    required this.range,
    required this.currentPage,
    required this.paginated,
    required this.configuration,
    required this.location,
  });

  @override
  State<SchedulePositionList> createState() => _SchedulePositionListState();
}

class _SchedulePositionListState extends State<SchedulePositionList> {
  // Convenience getters for accessing widget properties
  ScheduleViewController get viewController => widget.viewController;
  EventsController get eventsController => widget.eventsController;
  KalenderController get kalenderController => context.kalenderController;
  KalenderCallbacks? get callbacks => context.callbacks;
  ScheduleComponents get components => context.components.scheduleComponents;
  ScheduleViewConfiguration get viewConfiguration => widget.viewController.viewConfiguration;

  /// Controller for programmatically scrolling to specific items in the list.
  final ItemScrollController _itemScrollController = ItemScrollController();

  /// Listener for tracking which items are currently visible in the viewport.
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  @override
  void didUpdateWidget(covariant SchedulePositionList oldWidget) {
    _removeListeners(oldWidget.eventsController);
    _setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _removeListeners(eventsController);
    _setup();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _removeListeners(eventsController);
    super.dispose();
  }

  void _setup() {
    _setupViewController();
    _generateMap();
    _addListeners();
  }

  void _addListeners() {
    eventsController.addListener(_updateMap);
    _itemPositionsListener.itemPositions.addListener(_positionListener);
  }

  void _removeListeners(EventsController controller) {
    controller.removeListener(_updateMap);
    _itemPositionsListener.itemPositions.removeListener(_positionListener);
  }

  void _setupViewController() {
    viewController.itemScrollController = _itemScrollController;
    viewController.itemPositionsListener = _itemPositionsListener;
    viewController.currentPage = widget.currentPage;
  }

  void _updateMap() => setState(_generateMap);

  /// Refills the view controller with the items for [SchedulePositionList.range].
  void _generateMap() {
    final dates = widget.range.dates();
    viewController.clear();

    var hasAddedMonth = false;

    for (final date in dates) {
      final events = eventsController.eventsInRange(
        date.dayRange,
        multiDayRule: widget.viewController.viewConfiguration.multiDayRule,
        location: widget.location,
      );

      if (events.isEmpty) {
        if (widget.paginated && !hasAddedMonth) {
          _addMonthItem(date);
          hasAddedMonth = true;
        }

        switch (widget.configuration.emptyDay) {
          case EmptyDayBehavior.show:
            // Record the empty day as the first (only) row of its date so it can
            // be scrolled or animated to directly.
            viewController.addItem(item: EmptyItem(), date: date, isFirst: true);
            continue;

          case EmptyDayBehavior.showOnlyToday:
            final now = widget.viewController.viewConfiguration.nowCallback?.call();
            if (date.isToday(location: widget.location, now: now)) {
              viewController.addItem(item: EmptyItem(), date: date, isFirst: true);
            }
            continue;

          case EmptyDayBehavior.hide:
            continue;
        }
      }

      if (!widget.paginated || !hasAddedMonth) _addMonthItem(date);

      for (final (index, event) in events.indexed) {
        final isFirst = index == 0;
        viewController.addItem(item: EventItem(event.id, isFirst), date: date, isFirst: isFirst);
      }
    }
  }

  /// Adds a [MonthItem] for [date] unless the previous item is in the same month.
  void _addMonthItem(FloatingDateTime date) {
    final previousDateItem = viewController.dateTimeItemIndex(widget.currentPage).keys.lastOrNull;
    if (previousDateItem == null || previousDateItem.startOfMonth != date.startOfMonth) {
      viewController.addItem(item: MonthItem(), date: date);
    }
  }

  /// Publishes the visible date range and the visible events from the item positions.
  void _positionListener() {
    final itemPositions = _itemPositionsListener.itemPositions.value;
    if (itemPositions.isNotEmpty) {
      final indices = itemPositions.map((position) => position.index);
      final first = indices.reduce(min);
      final last = indices.reduce(max);

      final start = viewController.dateTimeFromIndex(first);
      final end = viewController.dateTimeFromIndex(last);
      if (start != null && end != null) {
        kalenderController.floatingVisibleRange.value = FloatingDateTimeRange(start: start, end: end.endOfDay);
      }

      final events = itemPositions.map((position) {
        final item = viewController.item(position.index);
        if (item is! EventItem) return null;
        final eventId = item.eventId;
        return eventsController.byId(eventId);
      });

      // A ValueNotifier compares sets by identity, so assign only when the contents changed.
      final visibleEvents = events.nonNulls.toSet();
      if (!const SetEquality<KalenderEvent>().equals(viewController.visibleEvents.value, visibleEvents)) {
        viewController.visibleEvents.value = visibleEvents;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScrollablePositionedList.builder(
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          itemCount: viewController.itemCount,
          initialScrollIndex: viewController.initialScrollIndex(viewController.initialDate),
          physics: widget.configuration.scrollPhysics,
          itemBuilder: (context, index) {
            final item = viewController.item(index);
            final date = viewController.dateTimeFromIndex(index)!;

            final leadingWidth = widget.configuration.leadingWidth;
            Widget leadingSlot(Widget? child) => SizedBox(width: leadingWidth, child: child);

            late final leading = components.buildLeadingDate(context, date);

            if (item is MonthItem) {
              final locale = context.locale;
              return components.monthItemBuilder?.call(
                    context,
                    date.monthRange.forLocation(location: context.location),
                  ) ??
                  ListTile(title: Text(date.monthNameLocalized(locale)));
            } else if (item is EmptyItem) {
              final child = _EmptyDayGestures(
                date: date,
                child: ListTile(
                  minLeadingWidth: 0,
                  leading: leadingSlot(leading),
                  title: components.emptyItemBuilder?.call(
                    context,
                    date.dayRange.forLocation(location: context.location),
                  ),
                ),
              );
              return components.buildScheduleTileHighlight(context, date, viewController.highlightedRange, child);
            } else if (item is EventItem) {
              final showDate = item.isFirst;
              final event = eventsController.byId(item.eventId)!;
              final tileComponents = context.tileComponents as ScheduleTileComponents;

              final child = ListTile(
                minLeadingWidth: 0,
                leading: leadingSlot(showDate ? leading : null),
                title: ScheduleEventTile(
                  key: ScheduleEventTile.tileKey(event.id),
                  event: event,
                  tileComponents: tileComponents,
                  floatingRange: date.dayRange,
                  resizeAxis: null,
                ),
              );

              return components.buildScheduleTileHighlight(context, date, viewController.highlightedRange, child);
            } else {
              throw Exception('Unknown item type: ${item.runtimeType}');
            }
          },
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ScheduleDragTarget(
                eventsController: eventsController,
                kalenderController: kalenderController,
                callbacks: callbacks,
                viewController: viewController,
                constraints: constraints,
                paginated: widget.paginated,
                pageTriggerConfiguration: widget.configuration.pageTriggerConfiguration,
                scrollTriggerConfiguration: widget.configuration.scrollTriggerConfiguration,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Reports the [KalenderCallbacks.onTapped] family for an empty day, the way an empty month cell does.
class _EmptyDayGestures extends StatelessWidget {
  const _EmptyDayGestures({required this.date, required this.child});

  final FloatingDateTime date;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final callbacks = Callbacks.maybeOf(context);
    if (callbacks == null) return child;

    OnGesture<MultiDayDetail>? report(void Function(DateTime)? plain, void Function(TapDetail)? withDetail) {
      if (plain == null && withDetail == null) return null;
      return (detail) {
        plain?.call(date.forLocation(location: context.location));
        withDetail?.call(detail);
      };
    }

    return GestureCallbacksDetector<MultiDayDetail>(
      callbacks: GestureCallbacks(
        onTap: report(callbacks.onTapped, callbacks.onTappedWithDetail),
        onSecondaryTap: report(callbacks.onSecondaryTapped, callbacks.onSecondaryTappedWithDetail),
        onLongPress: report(callbacks.onLongPressed, callbacks.onLongPressedWithDetail),
        onSecondaryLongPress: report(callbacks.onSecondaryLongPressed, callbacks.onSecondaryLongPressedWithDetail),
      ),
      detail: (renderBox, localOffset) => MultiDayDetail(
        dateTimeRange: date.dayRange.forLocation(location: context.location),
        renderBox: renderBox,
        localOffset: localOffset,
      ),
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
