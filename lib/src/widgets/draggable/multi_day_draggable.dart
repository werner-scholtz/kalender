// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

class MultiDayDraggable extends StatefulWidget {
  final FloatingDateTimeRange floatingRange;
  const MultiDayDraggable({super.key, required this.floatingRange});
  @override
  State<MultiDayDraggable> createState() => _MultiDayDraggableState();
}

class _MultiDayDraggableState extends State<MultiDayDraggable> with NewDraggableWidget {
  @override
  KalenderCallbacks? get callbacks => context.callbacks;

  @override
  KalenderController get controller => context.kalenderController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final date in widget.floatingRange.dates())
          Expanded(
            child: Builder(
              builder: (context) {
                var position = Offset.zero;
                return Listener(
                  onPointerDown: (event) => position = event.localPosition,
                  onPointerSignal: (event) => position = event.localPosition,
                  onPointerMove: (event) => position = event.localPosition,
                  child: GestureDetector(
                    onTap: callbacks?.hasOnTapped == true ? () => _onTap(context, date, position) : null,
                    onSecondaryTap: callbacks?.hasOnSecondaryTapped == true
                        ? () => _onSecondaryTap(context, date, position)
                        : null,
                    onLongPress: callbacks?.hasOnLongPressed == true
                        ? () => _onLongPress(context, date, position)
                        : null,
                    onSecondaryLongPress: callbacks?.hasOnSecondaryLongPressed == true
                        ? () => _onSecondaryLongPress(context, date, position)
                        : null,
                    child: context.interaction.allowEventCreation
                        ? switch (context.interaction.createEventGesture) {
                            EventInteractionGesture.tap => Draggable(
                              onDragStarted: () => createNewEvent(context, date, position),
                              onDraggableCanceled: onDragFinished,
                              onDragEnd: onDragFinished,
                              dragAnchorStrategy: pointerDragAnchorStrategy,
                              data: Create(controllerId: controller.id),
                              feedback: Container(color: Colors.transparent, width: 1, height: 1),
                              child: Container(color: Colors.transparent),
                            ),
                            EventInteractionGesture.longPress => LongPressDraggable(
                              onDragStarted: () => createNewEvent(context, date, position),
                              onDraggableCanceled: onDragFinished,
                              onDragEnd: onDragFinished,
                              dragAnchorStrategy: pointerDragAnchorStrategy,
                              data: Create(controllerId: controller.id),
                              feedback: Container(color: Colors.transparent, width: 1, height: 1),
                              child: Container(color: Colors.transparent),
                            ),
                          }
                        : null,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  /// Notify the callbacks about the tap / longPress.
  void _onTap(BuildContext context, FloatingDateTime date, Offset localPosition) {
    callbacks?.onTapped?.call(date.forLocation(location: context.location));

    if (callbacks?.onTappedWithDetail == null) return;
    final range = calculateFloatingRange(date, localPosition);
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onTappedWithDetail?.call(
      MultiDayDetail(
        dateTimeRange: range.forLocation(location: context.location),
        renderBox: renderBox,
        localOffset: localPosition,
      ),
    );
  }

  void _onLongPress(BuildContext context, FloatingDateTime date, Offset position) {
    callbacks?.onLongPressed?.call(date.forLocation(location: context.location));

    if (callbacks?.onLongPressedWithDetail == null) return;
    final range = calculateFloatingRange(date, position);
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onLongPressedWithDetail?.call(
      MultiDayDetail(
        dateTimeRange: range.forLocation(location: context.location),
        renderBox: renderBox,
        localOffset: position,
      ),
    );
  }

  void _onSecondaryTap(BuildContext context, FloatingDateTime date, Offset localPosition) {
    callbacks?.onSecondaryTapped?.call(date.forLocation(location: context.location));

    if (callbacks?.onSecondaryTappedWithDetail == null) return;
    final range = calculateFloatingRange(date, localPosition);
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onSecondaryTappedWithDetail?.call(
      MultiDayDetail(
        dateTimeRange: range.forLocation(location: context.location),
        renderBox: renderBox,
        localOffset: localPosition,
      ),
    );
  }

  void _onSecondaryLongPress(BuildContext context, FloatingDateTime date, Offset position) {
    callbacks?.onSecondaryLongPressed?.call(date.forLocation(location: context.location));

    if (callbacks?.onSecondaryLongPressedWithDetail == null) return;
    final range = calculateFloatingRange(date, position);
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onSecondaryLongPressedWithDetail?.call(
      MultiDayDetail(
        dateTimeRange: range.forLocation(location: context.location),
        renderBox: renderBox,
        localOffset: position,
      ),
    );
  }

  @override
  FloatingDateTimeRange calculateFloatingRange(FloatingDateTime date, Offset localPosition) => date.dayRange;

  @override
  TapDetail createTapDetail(BuildContext context, FloatingDateTimeRange range, Offset localPosition) {
    return MultiDayDetail(
      dateTimeRange: range.forLocation(location: context.location),
      renderBox: context.findRenderObject() as RenderBox,
      localOffset: localPosition,
    );
  }
}
