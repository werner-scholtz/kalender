// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';
import 'package:kalender/src/models/mixins/snap_points.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/drag_targets/drag_target_helpers.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart';

/// A [StatefulWidget] that provides a [DragTarget] for [Create], [Resize], [Reschedule] objects.
///
/// The [VerticalDragTarget] specializes in accepting [Draggable] widgets for a multi day body.
class VerticalDragTarget extends StatefulWidget {
  final KalenderController controller;
  final MultiDayViewController viewController;
  final VerticalConfiguration configuration;

  final double pageWidth;
  final double dayWidth;
  final double viewPortHeight;

  final ValueNotifier<KalenderSnapping> snapping;

  const VerticalDragTarget({
    super.key,
    required this.controller,
    required this.viewController,
    required this.configuration,
    required this.pageWidth,
    required this.dayWidth,
    required this.viewPortHeight,
    required this.snapping,
  });

  @override
  State<VerticalDragTarget> createState() => _VerticalDragTargetState();

  /// The default [KalenderCallbacks.onWillAcceptWithDetailsVertical]. Accepts [Create], [Resize] and
  /// [Reschedule] payloads.
  static bool onWillAcceptWithDetails(
    DragTargetDetails<Object?> details,
    KalenderController controller,
    VerticalConfiguration configuration,
  ) {
    final viewController = controller.viewController;
    if (viewController is! MultiDayViewController) return false;
    final timeOfDayRange = viewController.viewConfiguration.timeOfDayRange;

    return DragTargetUtilities.handleDragDetails(
      details,
      onCreate: (controllerId) => controllerId == controller.id,
      onResize: (event, direction) => direction.vertical,
      onReschedule: (event) {
        // A multi-day event stays in the header, so the time of day range does
        // not constrain it. Accepted so that dropping here commits the date the
        // header has been previewing.
        final isMultiDay = event.spansMultipleDays(
          location: controller.location,
          defaultRule: controller.viewConfiguration.multiDayRule,
        );
        if (isMultiDay) return true;

        // Check if the event will fit within the time of day range.
        if (!timeOfDayRange.coversWholeDay && event.duration > timeOfDayRange.duration) return false;

        return true;
      },
      onOther: () => false,
    );
  }
}

class _VerticalDragTargetState extends State<VerticalDragTarget> with SnapPoints, DragTargetUtilities {
  @override
  EventsController get eventsController => context.eventsController;

  @override
  KalenderController get controller => widget.controller;

  // Every view controller sets this in its constructor.
  @override
  List<FloatingDateTime> get visibleDates => viewController.floatingVisibleRange.value!.dates();

  @override
  KalenderCallbacks? get callbacks => context.callbacks;

  @override
  double get dayWidth => widget.dayWidth;

  @override
  bool get multiDayDragTarget => false;

  MultiDayViewController get viewController => widget.viewController;
  ScrollController get scrollController => viewController.scrollController;
  KalenderTimeRange get timeOfDayRange => viewController.viewConfiguration.timeOfDayRange;

  VerticalConfiguration get bodyConfiguration => widget.configuration;
  PageTriggerConfiguration get pageTrigger => bodyConfiguration.pageTriggerConfiguration;
  ScrollTriggerConfiguration get scrollTrigger => bodyConfiguration.scrollTriggerConfiguration;

  KalenderSnapping get snapping => widget.snapping.value;
  int get snapIntervalMinutes => snapping.snapIntervalMinutes;
  bool get snapToTimeIndicator => snapping.snapToTimeIndicator;
  Duration get snapRange => snapping.snapRange;

  double get heightPerMinute => context.heightPerMinute;
  double get pageWidth => widget.pageWidth;
  double get viewPortHeight => widget.viewPortHeight;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateSnapPoints();
      widget.snapping.addListener(_updateSnapPoints);
      widget.viewController.visibleEvents.addListener(_updateSnapPoints);
    });
  }

  @override
  void didUpdateWidget(covariant VerticalDragTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snapping != widget.snapping) {
      oldWidget.snapping.removeListener(_updateSnapPoints);
      widget.snapping.addListener(_updateSnapPoints);
    }
    if (oldWidget.viewController != widget.viewController) {
      oldWidget.viewController.visibleEvents.removeListener(_updateSnapPoints);
      widget.viewController.visibleEvents.addListener(_updateSnapPoints);
    }
  }

  @override
  void dispose() {
    widget.snapping.removeListener(_updateSnapPoints);
    widget.viewController.visibleEvents.removeListener(_updateSnapPoints);
    super.dispose();
  }

  /// Update the snap points.
  void _updateSnapPoints() {
    if (!snapping.snapToOtherEvents) return;
    clearSnapPoints();
    addEventSnapPoints(widget.viewController.visibleEvents.value, context.location);
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: (details) {
        if (!isKalenderPayload(details, 'VerticalDragTarget')) return false;

        // First test if the details can be accepted at all.
        final accepted =
            callbacks?.onWillAcceptWithDetailsVertical?.call(details, controller, bodyConfiguration) ??
            VerticalDragTarget.onWillAcceptWithDetails(details, controller, bodyConfiguration);
        if (!accepted) return accepted;

        DragTargetUtilities.handleDragDetails(
          details,
          onCreate: (controllerId) {
            final newEvent = controller.newEvent;
            if (controller.selectedEvent.value != newEvent && newEvent != null) {
              controller.selectEvent(newEvent, internal: true);
            }
          },
          onResize: (event, direction) {
            if (controller.selectedEvent.value?.id != event.id) {
              // Re-select the event so that _selectedEventId is restored when the
              // cursor re-enters after having left the widget (onLeave clears it).
              controller.selectEvent(event, internal: true);
            }
          },
          onReschedule: (event) {
            final eventDuration = event.duration;
            final eventHeight = eventDuration.inMinutes * heightPerMinute;
            context.feedbackWidgetSizeNotifier.value = Size(dayWidth, eventHeight);
            controller.selectEvent(event, internal: true);
          },
          onOther: () {},
        );

        return true;
      },
      onMove: onMove,
      onAcceptWithDetails: onAcceptWithDetails,
      onLeave: onLeave,
      builder: (context, candidateData, rejectedData) {
        if (candidateData.firstOrNull == null) return const SizedBox();
        final components = context.components.multiDayComponents.bodyComponents;

        final rightTrigger = CursorNavigationTrigger.page(
          configuration: pageTrigger,
          viewController: viewController,
          forward: true,
          pageWidth: pageWidth,
          builder: components.rightTriggerBuilder,
        );

        final leftTrigger = CursorNavigationTrigger.page(
          configuration: pageTrigger,
          viewController: viewController,
          forward: false,
          pageWidth: pageWidth,
          builder: components.leftTriggerBuilder,
        );

        final triggerHeight = scrollTrigger.triggerHeight?.call(viewPortHeight) ?? viewPortHeight / 20;
        final scrollAmount = scrollTrigger.scrollAmount?.call(viewPortHeight) ?? viewPortHeight / 2.5;
        CursorNavigationTrigger scrollTrig(bool forward, VerticalTriggerWidgetBuilder? builder) {
          return CursorNavigationTrigger.scroll(
            configuration: scrollTrigger,
            onTrigger: () => scrollController.animateTo(
              scrollController.offset + (forward ? scrollAmount : -scrollAmount),
              duration: scrollTrigger.animationDuration,
              curve: scrollTrigger.animationCurve,
            ),
            viewPortHeight: viewPortHeight,
            triggerHeight: triggerHeight,
            width: pageWidth,
            builder: builder,
          );
        }

        final topScrollTrigger = scrollTrig(false, components.topTriggerBuilder);
        final bottomScrollTrigger = scrollTrig(true, components.bottomTriggerBuilder);

        return Stack(
          children: [
            PositionedDirectional(start: 0, end: 0, child: topScrollTrigger),
            PositionedDirectional(start: 0, end: 0, bottom: 0, child: bottomScrollTrigger),
            PositionedDirectional(start: 0, top: 0, bottom: 0, child: leftTrigger),
            PositionedDirectional(end: 0, top: 0, bottom: 0, child: rightTrigger),
          ],
        );
      },
    );
  }

  @override
  FloatingDateTime? calculateCursorDateTime(Offset offset, {Offset feedbackWidgetOffset = Offset.zero}) {
    final localCursorPosition = calculateLocalCursorPosition(offset, scrollOffset: Offset(0, scrollController.offset));
    if (localCursorPosition == null) return null;

    final date = dateAtColumn(context, visibleDates, localCursorPosition.dx, dayWidth);
    if (date == null) return null;

    final startOfDate = timeOfDayRange.start.toFloatingDateTime(date);

    final durationFromStart = localCursorPosition.dy ~/ heightPerMinute;
    final numberOfIntervals = (durationFromStart / snapIntervalMinutes).round();
    final duration = Duration(minutes: snapIntervalMinutes * numberOfIntervals);

    final cursorDateTime = FloatingDateTime.fromDateTime(startOfDate.add(duration));
    if (timeOfDayRange.coversWholeDay) return cursorDateTime;

    final endOfDate = startOfDate.add(timeOfDayRange.duration);
    if (cursorDateTime.isBefore(startOfDate)) return startOfDate;
    if (cursorDateTime.isAfter(endOfDate)) return endOfDate;
    return cursorDateTime;
  }

  @override
  KalenderEvent? rescheduleEvent(KalenderEvent event, FloatingDateTime cursorDateTime) {
    // A multi-day event is laid out in the header, so dragging it across the
    // body can only change which date it starts on. Updating it here is what
    // moves the header's drop target as the cursor crosses day columns.
    if (event.spansMultipleDays(location: context.location, defaultRule: context.multiDayRule)) {
      return rescheduleToDate(event, cursorDateTime);
    }

    FloatingDateTime start;

    if (timeOfDayRange.coversWholeDay) {
      start = cursorDateTime;
    } else {
      final startOfDate = timeOfDayRange.start.toFloatingDateTime(cursorDateTime);
      final endOfDate = startOfDate.add(timeOfDayRange.duration);
      if (cursorDateTime.isBefore(startOfDate)) {
        start = startOfDate;
      } else if (cursorDateTime.add(event.duration).isAfter(endOfDate)) {
        start = endOfDate.subtract(event.duration);
      } else {
        start = cursorDateTime;
      }
    }

    final duration = event.duration;
    var end = start.add(duration);

    late final now = FloatingDateTime.fromExternal(DateTime.now(), location: context.location);
    if (snapToTimeIndicator) addSnapPoint(now);

    final startSnapPoint = findSnapPoint(start, snapRange);
    if (startSnapPoint != null && startSnapPoint.isBefore(end)) {
      start = startSnapPoint;
      end = start.add(duration);
    }

    late final endSnapPoint = findSnapPoint(end, snapRange);
    final canUseEndSnapPoint = startSnapPoint == null && endSnapPoint != null && endSnapPoint.isAfter(start);
    if (canUseEndSnapPoint) {
      end = endSnapPoint;
      start = end.subtract(duration);
    }

    // Convert only start and recompute end from the original duration to avoid
    // the DST spring-forward gap collapsing start and end to the same UTC instant.
    final convertedStart = start.forLocation(location: context.location);
    final updatedEvent = event.withDateTimeRange(
      KalenderDateTimeRange(start: convertedStart, end: convertedStart.add(duration)),
    );

    if (snapToTimeIndicator) removeSnapPoint(now);

    return updatedEvent;
  }

  @override
  KalenderEvent? resizeEvent(KalenderEvent event, ResizeDirection direction, FloatingDateTime cursorDateTime) {
    if (!direction.vertical) return null;

    late final now = FloatingDateTime.fromExternal(DateTime.now(), location: context.location);
    if (snapToTimeIndicator) addSnapPoint(now);

    final cursorSnapPoint = findSnapPoint(cursorDateTime, snapRange) ?? cursorDateTime;

    if (snapToTimeIndicator) removeSnapPoint(now);

    final floatingRange = event.floatingRange(location: context.location);
    final dateTimeRange = switch (direction) {
      ResizeDirection.top => calculateRangeFromStart(floatingRange, cursorSnapPoint),
      ResizeDirection.bottom => calculateRangeFromEnd(floatingRange, cursorSnapPoint),
      _ => null,
    };
    if (dateTimeRange == null) return null;

    return event.withDateTimeRange(toLocationDateTimeRange(dateTimeRange));
  }

  @override
  KalenderEvent? createEvent(FloatingDateTime cursorDateTime) {
    final event = super.createEvent(cursorDateTime);
    if (event == null) return null;

    var range = newEvent!.floatingRange(location: context.location);

    if (cursorDateTime.isAfter(range.start)) {
      range = FloatingDateTimeRange(start: range.start, end: cursorDateTime);
    } else if (cursorDateTime.isBefore(range.start)) {
      range = FloatingDateTimeRange(start: cursorDateTime, end: range.start);
    }

    return event.withDateTimeRange(toLocationDateTimeRange(range));
  }
}
