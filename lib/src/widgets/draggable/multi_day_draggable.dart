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
                    onTap: callbacks?.hasOnTapped == true
                        ? () => _report(context, callbacks?.onTapped, callbacks?.onTappedWithDetail, date, position)
                        : null,
                    onSecondaryTap: callbacks?.hasOnSecondaryTapped == true
                        ? () => _report(
                            context,
                            callbacks?.onSecondaryTapped,
                            callbacks?.onSecondaryTappedWithDetail,
                            date,
                            position,
                          )
                        : null,
                    onLongPress: callbacks?.hasOnLongPressed == true
                        ? () => _report(
                            context,
                            callbacks?.onLongPressed,
                            callbacks?.onLongPressedWithDetail,
                            date,
                            position,
                          )
                        : null,
                    onSecondaryLongPress: callbacks?.hasOnSecondaryLongPressed == true
                        ? () => _report(
                            context,
                            callbacks?.onSecondaryLongPressed,
                            callbacks?.onSecondaryLongPressedWithDetail,
                            date,
                            position,
                          )
                        : null,
                    child: context.interaction.allowEventCreation
                        ? switch (context.interaction.createEventGesture) {
                            EventInteractionGesture.tap => Draggable<Create>.new,
                            EventInteractionGesture.longPress => LongPressDraggable<Create>.new,
                          }(
                            onDragStarted: () => createNewEvent(context, date, position),
                            onDraggableCanceled: onDragFinished,
                            onDragEnd: onDragFinished,
                            dragAnchorStrategy: pointerDragAnchorStrategy,
                            data: Create(controllerId: controller.id),
                            feedback: Container(color: Colors.transparent, width: 1, height: 1),
                            child: Container(color: Colors.transparent),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  /// Reports a gesture at [position] in the column of [date] to [plain] and [withDetail].
  void _report(
    BuildContext context,
    void Function(DateTime date)? plain,
    void Function(TapDetail detail)? withDetail,
    FloatingDateTime date,
    Offset position,
  ) {
    plain?.call(date.forLocation(location: context.location));

    if (withDetail == null) return;
    final range = calculateFloatingRange(date, position);
    final renderBox = context.findRenderObject() as RenderBox;
    withDetail(
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
