import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

class MultiDayDraggable<T extends Object?> extends StatelessWidget with NewDraggableWidget<T> {
  final DateTimeRange visibleDateTimeRange;
  const MultiDayDraggable({super.key, required this.visibleDateTimeRange});

  @override
  Widget build(BuildContext context) {
    final callbacks = context.callbacks<T>();
    final controller = context.calendarController<T>();

    var position = Offset.zero;
    return Listener(
      onPointerDown: (event) => position = event.localPosition,
      onPointerSignal: (event) => position = event.localPosition,
      onPointerMove: (event) => position = event.localPosition,
      child: GestureDetector(
        onTap: callbacks?.hasOnTapped == true ? () => _onTap(context, position, callbacks) : null,
        onLongPress: callbacks?.hasOnLongPressed == true ? () => _onLongPress(context, position, callbacks) : null,
        child: context.interaction.allowEventCreation
            ? switch (context.interaction.createEventGesture) {
                CreateEventGesture.tap => Draggable(
                    onDragStarted: () => createNewEvent(
                      context,
                      _calculateDateFromPosition(position, context),
                      position,
                      callbacks,
                      controller,
                    ),
                    onDraggableCanceled: (velocity, offset) => onDragFinished(controller, velocity, offset),
                    onDragEnd: (details) => onDragFinished(controller, details.velocity, details.offset),
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    data: Create(controllerId: controller.id),
                    feedback: Container(color: Colors.transparent, width: 1, height: 1),
                    child: Container(color: Colors.transparent),
                  ),
                CreateEventGesture.longPress => LongPressDraggable(
                    onDragStarted: () => createNewEvent(
                      context,
                      _calculateDateFromPosition(position, context),
                      position,
                      callbacks,
                      controller,
                    ),
                    onDraggableCanceled: (velocity, offset) => onDragFinished(controller, velocity, offset),
                    onDragEnd: (details) => onDragFinished(controller, details.velocity, details.offset),
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    data: Create(controllerId: controller.id),
                    feedback: Container(color: Colors.transparent, width: 1, height: 1),
                    child: Container(color: Colors.transparent),
                  ),
              }
            : null,
      ),
    );
  }

  DateTime _calculateDateFromPosition(Offset localPosition, BuildContext context) {
    final dateSizes = context.size!.width / visibleDateTimeRange.dates().length;
    final index = localPosition.dx ~/ dateSizes;
    return visibleDateTimeRange.dates()[index];
  }

  /// Notify the callbacks about the tap / longPress.
  void _onTap(BuildContext context, Offset localPosition, CalendarCallbacks<T>? callbacks) {
    final date = _calculateDateFromPosition(localPosition, context);
    callbacks?.onTapped?.call(date);

    if (callbacks?.onTappedWithDetail == null) return;
    final range = calculateDateTimeRange(date, localPosition, context).asLocal;
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onTappedWithDetail?.call(
      MultiDayDetail(dateTimeRange: range, renderBox: renderBox, localOffset: localPosition),
    );
  }

  void _onLongPress(BuildContext context, Offset localPosition, CalendarCallbacks<T>? callbacks) {
    final date = _calculateDateFromPosition(localPosition, context);

    callbacks?.onLongPressed?.call(date);

    if (callbacks?.onLongPressedWithDetail == null) return;
    final range = calculateDateTimeRange(date, localPosition, context).asLocal;
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onLongPressedWithDetail?.call(
      MultiDayDetail(dateTimeRange: range, renderBox: renderBox, localOffset: localPosition),
    );
  }

  @override
  DateTimeRange calculateDateTimeRange(DateTime date, Offset localPosition, BuildContext context) {
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
