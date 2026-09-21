// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/drag_targets/drag_target_helpers.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart';

/// A [StatefulWidget] that provides a [DragTarget] for [Draggable] widgets containing a [Create], [Resize], [Reschedule] object.
///
/// The [HorizontalDragTarget] specializes in accepting [Draggable] widgets for a multi day header / month body.
class HorizontalDragTarget extends StatefulWidget {
  final FloatingDateTimeRange visibleRange;

  final HorizontalConfiguration configuration;

  final HorizontalTriggerWidgetBuilder? leftPageTrigger;
  final HorizontalTriggerWidgetBuilder? rightPageTrigger;

  const HorizontalDragTarget({
    super.key,
    required this.visibleRange,
    required this.configuration,
    required this.leftPageTrigger,
    required this.rightPageTrigger,
  });

  @override
  State<HorizontalDragTarget> createState() => _HorizontalDragTargetState();

  /// The default [KalenderCallbacks.onWillAcceptWithDetailsHorizontal]. Accepts [Create], [Resize] and
  /// [Reschedule] payloads.
  static bool onWillAcceptWithDetails(
    DragTargetDetails<Object?> details,
    KalenderController controller,
    HorizontalConfiguration configuration,
  ) {
    return DragTargetUtilities.handleDragDetails(
      details,
      onCreate: (controllerId) => controllerId == controller.id,
      onResize: (event, direction) => direction.horizontal,
      onReschedule: (event) {
        // If the configuration does not allow single-day events (e.g., multi-day header),
        // reject single-day events. They belong in the body, not the header.
        return configuration.allowSingleDayEvents ||
            event.spansMultipleDays(
              location: controller.viewController?.location,
              defaultRule: controller.viewController?.viewConfiguration.multiDayRule ?? kDefaultMultiDayRule,
            );
      },
      onOther: () => false,
    );
  }
}

class _HorizontalDragTargetState extends State<HorizontalDragTarget> with DragTargetUtilities {
  @override
  EventsController get eventsController => context.eventsController;
  @override
  KalenderController get controller => context.kalenderController;
  @override
  KalenderCallbacks? get callbacks => context.callbacks;
  @override
  List<FloatingDateTime> get visibleDates => widget.visibleRange.dates();
  @override
  bool get multiDayDragTarget => true;

  ViewController get viewController => controller.viewController!;
  PageTriggerConfiguration get pageTrigger => widget.configuration.pageTriggerConfiguration;

  @override
  double dayWidth = 0;
  double pageWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        pageWidth = constraints.maxWidth;
        dayWidth = pageWidth / visibleDates.length;
        return DragTarget(
          onWillAcceptWithDetails: (details) {
            if (!isKalenderPayload(details, 'HorizontalDragTarget')) return false;

            // First test if the details can be accepted at all.
            final accepted =
                callbacks?.onWillAcceptWithDetailsHorizontal?.call(details, controller, widget.configuration) ??
                HorizontalDragTarget.onWillAcceptWithDetails(details, controller, widget.configuration);
            if (!accepted) return false;

            return onWillAcceptWithDetails(
              details,
              onResize: (event, direction) {
                if (controller.selectedEvent.value?.id != event.id) {
                  // Re-select the event so that _selectedEventId is restored when the
                  // cursor re-enters after having left the widget (onLeave clears it).
                  controller.selectEvent(event, internal: true);
                }
                return direction.horizontal;
              },
              onReschedule: (event) {
                context.feedbackWidgetSizeNotifier.value = Size(
                  min(pageWidth, dayWidth * event.datesSpanned(location: context.location).length),
                  widget.configuration.tileHeight,
                );

                controller.selectEvent(event, internal: true);
                return true;
              },
            );
          },
          onMove: onMove,
          onAcceptWithDetails: onAcceptWithDetails,
          onLeave: onLeave,
          builder: (context, candidateData, rejectedData) {
            if (candidateData.firstOrNull == null) return const SizedBox();

            final rightTrigger = CursorNavigationTrigger.page(
              configuration: pageTrigger,
              viewController: viewController,
              forward: true,
              pageWidth: pageWidth,
              builder: widget.rightPageTrigger,
            );

            final leftTrigger = CursorNavigationTrigger.page(
              configuration: pageTrigger,
              viewController: viewController,
              forward: false,
              pageWidth: pageWidth,
              builder: widget.leftPageTrigger,
            );

            return Stack(
              children: [
                PositionedDirectional(end: 0, top: 0, bottom: 0, child: rightTrigger),
                PositionedDirectional(start: 0, top: 0, bottom: 0, child: leftTrigger),
              ],
            );
          },
        );
      },
    );
  }

  @override
  FloatingDateTime? calculateCursorDateTime(Offset offset, {Offset feedbackWidgetOffset = Offset.zero}) {
    final localCursorPosition = calculateLocalCursorPosition(offset);
    if (localCursorPosition == null) return null;

    return dateAtColumn(context, visibleDates, localCursorPosition.dx, dayWidth);
  }

  @override
  KalenderEvent? rescheduleEvent(KalenderEvent event, FloatingDateTime cursorDateTime) {
    // If the configuration does not allow single-day events (e.g., multi-day header),
    // return null to prevent updating the selection while dragging over this area.
    if (!widget.configuration.allowSingleDayEvents &&
        !event.spansMultipleDays(location: context.location, defaultRule: context.multiDayRule)) {
      return null;
    }

    return rescheduleToDate(event, cursorDateTime);
  }

  @override
  KalenderEvent? resizeEvent(KalenderEvent event, ResizeDirection direction, FloatingDateTime cursorDateTime) {
    final floatingRange = event.floatingRange(location: context.location);
    final range = switch (direction) {
      ResizeDirection.left => calculateRangeFromStart(floatingRange, cursorDateTime),
      ResizeDirection.right => calculateRangeFromEnd(floatingRange, cursorDateTime.endOfDay),
      _ => null,
    };
    if (range == null) return null;
    return event.withDateTimeRange(toLocationDateTimeRange(range));
  }

  @override
  KalenderEvent? createEvent(FloatingDateTime cursorDateTime) {
    final event = super.createEvent(cursorDateTime);
    if (event == null) return null;

    var range = newEvent!.floatingRange(location: context.location);
    final cursor = FloatingDateTime.fromDateTime(cursorDateTime);

    if ((cursor.isSameDay(range.start) || cursor.isSameDay(range.end)) || cursor.isAfter(range.start)) {
      range = FloatingDateTimeRange(start: range.start.startOfDay, end: cursor.endOfDay);
    } else if (cursor.isBefore(range.start)) {
      range = FloatingDateTimeRange(start: cursor, end: range.start.endOfDay);
    }

    return event.withDateTimeRange(toLocationDateTimeRange(range));
  }
}
