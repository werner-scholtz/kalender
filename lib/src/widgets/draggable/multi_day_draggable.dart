import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

class MultiDayDraggable<T extends Object?> extends StatefulWidget {
  final DateTimeRange visibleDateTimeRange;
  const MultiDayDraggable({super.key, required this.visibleDateTimeRange});
  @override
  State<MultiDayDraggable<T>> createState() => _MultiDayDraggableState<T>();
}

class _MultiDayDraggableState<T extends Object?> extends State<MultiDayDraggable<T>> with NewDraggableWidget<T> {
  @override
  CalendarCallbacks<T>? get callbacks => context.callbacks<T>();

  @override
  CalendarController<T> get controller => context.calendarController<T>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final date in widget.visibleDateTimeRange.dates())
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
                    onLongPress:
                        callbacks?.hasOnLongPressed == true ? () => _onLongPress(context, date, position) : null,
                    child: context.interaction.allowEventCreation
                        ? switch (context.interaction.createEventGesture) {
                            CreateEventGesture.tap => Draggable(
                                onDragStarted: () => createNewEvent(context, date, position),
                                onDraggableCanceled: onDragFinished,
                                onDragEnd: onDragFinished,
                                dragAnchorStrategy: pointerDragAnchorStrategy,
                                data: Create(controllerId: controller.id),
                                feedback: Container(color: Colors.transparent, width: 1, height: 1),
                                child: Container(color: Colors.transparent),
                              ),
                            CreateEventGesture.longPress => LongPressDraggable(
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
  void _onTap(BuildContext context, DateTime date, Offset localPosition) {
    callbacks?.onTapped?.call(date);

    if (callbacks?.onTappedWithDetail == null) return;
    final range = calculateDateTimeRange(date, localPosition).asLocal;
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onTappedWithDetail?.call(
      MultiDayDetail(dateTimeRange: range, renderBox: renderBox, localOffset: localPosition),
    );
  }

  void _onLongPress(BuildContext context, DateTime date, Offset position) {
    callbacks?.onLongPressed?.call(date);

    if (callbacks?.onLongPressedWithDetail == null) return;
    final range = calculateDateTimeRange(date, position).asLocal;
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onLongPressedWithDetail?.call(
      MultiDayDetail(dateTimeRange: range, renderBox: renderBox, localOffset: position),
    );
  }

  @override
  DateTimeRange calculateDateTimeRange(DateTime date, Offset localPosition) {
    final start = date;
    final end = start.endOfDay;
    return DateTimeRange(start: start, end: end);
  }

  @override
  TapDetail createTapDetail(BuildContext context, DateTimeRange range, Offset localPosition) {
    return MultiDayDetail(
      dateTimeRange: range,
      renderBox: context.findRenderObject() as RenderBox,
      localOffset: localPosition,
    );
  }
}
