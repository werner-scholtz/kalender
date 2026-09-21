// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart' show CursorNavigationTrigger;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// The [DragTarget] over a [SchedulePositionList]. A drop lands on the day of the row under the cursor.
class ScheduleDragTarget extends StatefulWidget {
  final EventsController eventsController;
  final KalenderController kalenderController;
  final KalenderCallbacks? callbacks;
  final ScheduleViewController viewController;
  final int page;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final BoxConstraints constraints;
  final bool paginated;

  final PageTriggerConfiguration pageTriggerConfiguration;
  final HorizontalTriggerWidgetBuilder? leftPageTrigger;
  final HorizontalTriggerWidgetBuilder? rightPageTrigger;

  final ScrollTriggerConfiguration scrollTriggerConfiguration;
  final HorizontalTriggerWidgetBuilder? topScrollTrigger;
  final HorizontalTriggerWidgetBuilder? bottomScrollTrigger;

  const ScheduleDragTarget({
    super.key,
    required this.eventsController,
    required this.kalenderController,
    required this.callbacks,
    required this.viewController,
    required this.page,
    required this.itemScrollController,
    required this.itemPositionsListener,
    required this.constraints,
    required this.paginated,
    required this.pageTriggerConfiguration,
    this.leftPageTrigger,
    this.rightPageTrigger,
    required this.scrollTriggerConfiguration,
    this.topScrollTrigger,
    this.bottomScrollTrigger,
  });

  @override
  State<ScheduleDragTarget> createState() => _ScheduleDragTargetState();
}

class _ScheduleDragTargetState extends State<ScheduleDragTarget> with DragTargetUtilities {
  @override
  double get dayWidth => widget.constraints.maxWidth;

  @override
  List<DateTime> get visibleDates => throw UnimplementedError();

  @override
  EventsController get eventsController => widget.eventsController;

  @override
  KalenderController get controller => widget.kalenderController;

  @override
  KalenderCallbacks? get callbacks => widget.callbacks;

  @override
  bool get multiDayDragTarget => false;

  // The height of the viewport, used for cursor navigation.
  double get viewPortHeight => widget.constraints.maxHeight;

  ScheduleViewController get viewController => widget.viewController;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: (details) {
        return onWillAcceptWithDetails(
          details,
          onResize: (event, direction) => false,
          onReschedule: (event) {
            const height = 24.0;

            context.feedbackWidgetSizeNotifier.value = Size(dayWidth, height);
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

        final pageTrigger = widget.pageTriggerConfiguration;
        final scrollTrigger = widget.scrollTriggerConfiguration;

        late final rightTrigger = CursorNavigationTrigger.page(
          configuration: pageTrigger,
          viewController: viewController,
          forward: true,
          pageWidth: dayWidth,
          builder: widget.rightPageTrigger,
        );

        late final leftTrigger = CursorNavigationTrigger.page(
          configuration: pageTrigger,
          viewController: viewController,
          forward: false,
          pageWidth: dayWidth,
          builder: widget.leftPageTrigger,
        );

        final triggerHeight = scrollTrigger.triggerHeight?.call(viewPortHeight) ?? viewPortHeight / 20;
        CursorNavigationTrigger scrollTrig(bool forward, VerticalTriggerWidgetBuilder? builder) {
          return CursorNavigationTrigger.scroll(
            configuration: scrollTrigger,
            onTrigger: () {
              final positions = widget.itemPositionsListener.itemPositions.value;
              if (positions.isEmpty) return;

              // The item nearest the edge we are scrolling toward, then one past it.
              final indices = positions.map((position) => position.index);
              final edge = forward ? indices.reduce(max) : indices.reduce(min);
              final targetIndex = forward ? edge + 1 : edge - 1;
              if (targetIndex < 0 || targetIndex >= viewController.itemCountForPage(widget.page)) return;

              widget.itemScrollController.scrollTo(
                index: targetIndex,
                duration: scrollTrigger.animationDuration,
                curve: scrollTrigger.animationCurve,
              );
            },
            viewPortHeight: viewPortHeight,
            triggerHeight: triggerHeight,
            width: dayWidth,
            builder: builder,
          );
        }

        final topScrollTrigger = scrollTrig(false, widget.topScrollTrigger);
        final bottomScrollTrigger = scrollTrig(true, widget.bottomScrollTrigger);

        return Stack(
          children: [
            PositionedDirectional(start: 0, end: 0, child: topScrollTrigger),
            PositionedDirectional(start: 0, end: 0, bottom: 0, child: bottomScrollTrigger),
            if (widget.paginated) PositionedDirectional(start: 0, top: 0, bottom: 0, child: leftTrigger),
            if (widget.paginated) PositionedDirectional(end: 0, top: 0, bottom: 0, child: rightTrigger),
          ],
        );
      },
    );
  }

  @override
  FloatingDateTime? calculateCursorDateTime(Offset offset, {Offset feedbackWidgetOffset = Offset.zero}) {
    final localCursorPosition = calculateLocalCursorPosition(offset);
    if (localCursorPosition == null) return null;

    final itemPositions = widget.itemPositionsListener.itemPositions.value;
    final proportionalOffset = localCursorPosition.dy / widget.constraints.maxHeight;
    final itemIndex = itemPositions
        .where((item) => item.itemLeadingEdge <= proportionalOffset && item.itemTrailingEdge >= proportionalOffset)
        .map((item) => item.index)
        .firstOrNull;

    if (itemIndex == null) return null;

    final date = viewController.dateTimeFromIndexForPage(widget.page, itemIndex);

    if (date == null) return null;
    return FloatingDateTime.fromDateTime(date);
  }

  @override
  KalenderEvent? rescheduleEvent(KalenderEvent event, FloatingDateTime cursorDateTime) {
    // The highlight marks whole rows, so it stays anchored to the target day.
    widget.viewController.highlightedRange.value = FloatingDateTimeRange(
      start: cursorDateTime,
      end: cursorDateTime.add(event.duration),
    );

    return rescheduleToDate(event, cursorDateTime);
  }

  @override
  void onAcceptWithDetails(DragTargetDetails<Object?> details) {
    super.onAcceptWithDetails(details);
    widget.viewController.highlightedRange.value = null;
  }

  @override
  void onLeave(Object? details) {
    super.onLeave(details);
    widget.viewController.highlightedRange.value = null;
  }

  @override
  KalenderEvent? resizeEvent(KalenderEvent event, ResizeDirection direction, DateTime cursorDateTime) => null;
}
