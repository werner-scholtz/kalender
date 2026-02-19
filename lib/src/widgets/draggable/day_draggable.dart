import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/draggable/new_draggable.dart';

/// This widget generates draggable widgets for each visible day.
/// - These draggable widgets are used to create new events.
///
class DayDraggable extends StatefulWidget {
  final InternalDateTimeRange visibleDateTimeRange;
  final TimeOfDayRange timeOfDayRange;
  final double pageHeight;

  const DayDraggable({
    super.key,
    required this.visibleDateTimeRange,
    required this.timeOfDayRange,
    required this.pageHeight,
  });

  @override
  State<DayDraggable> createState() => _DayDraggableState();
}

class _DayDraggableState extends State<DayDraggable> with NewDraggableWidget {
  @override
  CalendarCallbacks? get callbacks => context.callbacks();

  @override
  CalendarController get controller => context.calendarController();

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Row(
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
                                  dragAnchorStrategy: pointerDragAnchorStrategy,
                                  onDragStarted: () => createNewEvent(context, date, position),
                                  onDraggableCanceled: onDragFinished,
                                  onDragEnd: onDragFinished,
                                  data: Create(controllerId: controller.id),
                                  feedback: Container(color: Colors.transparent, width: 1, height: 1),
                                  child: Container(color: Colors.transparent, height: widget.pageHeight),
                                ),
                              CreateEventGesture.longPress => LongPressDraggable(
                                  dragAnchorStrategy: pointerDragAnchorStrategy,
                                  onDragStarted: () => createNewEvent(context, date, position),
                                  onDraggableCanceled: onDragFinished,
                                  onDragEnd: onDragFinished,
                                  data: Create(controllerId: controller.id),
                                  feedback: Container(color: Colors.transparent, width: 1, height: 1),
                                  child: Container(color: Colors.transparent, height: widget.pageHeight),
                                ),
                            }
                          : null,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Notify the callbacks about the tap / longPress.
  void _onTap(BuildContext context, InternalDateTime date, Offset localPosition) {
    final dateTime = _calculateTimeAndDate(date, localPosition);
    callbacks?.onTapped?.call(dateTime.forLocation(location: context.location));

    if (callbacks?.onTappedWithDetail == null) return;
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onTappedWithDetail?.call(
      DayDetail(renderBox: renderBox, localOffset: localPosition, date: dateTime),
    );
  }

  void _onLongPress(BuildContext context, InternalDateTime date, Offset position) {
    final dateTime = _calculateTimeAndDate(date, position);
    callbacks?.onLongPressed?.call(dateTime);

    if (callbacks?.onLongPressedWithDetail == null) return;
    final renderBox = context.findRenderObject() as RenderBox;
    callbacks?.onLongPressedWithDetail?.call(
      DayDetail(date: dateTime, renderBox: renderBox, localOffset: position),
    );
  }

  @override
  InternalDateTimeRange calculateDateTimeRange(InternalDateTime date, Offset localPosition) {
    final start = _calculateTimeAndDate(date, localPosition);
    final snapInterval = context.snapping.snapIntervalMinutes;
    final end = start.copyWith(minute: start.minute + snapInterval);
    return InternalDateTimeRange(start: start, end: end);
  }

  /// Calculate a DateTime from the [date] of the draggable and the [localPosition] of the cursor.
  InternalDateTime _calculateTimeAndDate(InternalDateTime date, Offset localPosition) {
    // Calculate the duration from the top of the page to the localPosition.
    final durationFromStart = localPosition.dy ~/ context.heightPerMinute;
    final durationFromTop = Duration(minutes: durationFromStart.round());

    // Calculate the start of the day.
    final startOfDay = widget.timeOfDayRange.start.toDateTime(date);

    // Calculate dateTime of the cursor.
    final startOfEvent = startOfDay.add(durationFromTop);

    // Snap the datetime based on the snap strategy.
    final snappedDateTime = context.snapping.eventSnapStrategy(
      startOfEvent,
      startOfDay,
      context.snapping.snapIntervalMinutes,
    );

    return snappedDateTime;
  }

  @override
  TapDetail createTapDetail(BuildContext context, InternalDateTimeRange range, Offset localPosition) {
    return DayDetail(
      date: range.start.forLocation(location: context.location),
      renderBox: context.findRenderObject() as RenderBox,
      localOffset: localPosition,
    );
  }
}
