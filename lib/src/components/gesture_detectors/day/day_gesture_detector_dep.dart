import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// A widget that detects gestures on a day.
/// TODO: Create a builder for a [DayGestureDetector].
class DayGestureDetector<T> extends StatefulWidget {
  const DayGestureDetector({
    super.key,
    required this.height,
    required this.width,
    required this.heightPerMinute,
    required this.visibleDateRange,
    required this.minuteSlotSize,
  });

  /// The height of the area.
  final double height;

  /// The width of the area.
  final double width;

  /// The height per minute.
  final double heightPerMinute;

  /// The visible date range.
  final DateTimeRange visibleDateRange;

  /// The size of a slot.
  final Duration minuteSlotSize;

  @override
  State<DayGestureDetector<T>> createState() => _DayGestureDetectorState<T>();
}

class _DayGestureDetectorState<T> extends State<DayGestureDetector<T>> {
  CalendarScope<T> get scope => CalendarScope.of<T>(context);
  CalendarEventsController<T> get controller => scope.eventsController;
  bool get isMobileDevice => scope.platformData.isMobileDevice;

  double cursorOffset = 0;
  int numberOfSlotsSelected = 0;

  late List<DateTime> visibleDates;

  /// The height of a slot.
  late double heightPerSlot;

  /// The number of slots in a day.
  late int slots = (hoursADay * 60) ~/ widget.minuteSlotSize.inMinutes;

  @override
  void initState() {
    super.initState();
    visibleDates = widget.visibleDateRange.datesSpanned;
    heightPerSlot = widget.minuteSlotSize.inMinutes * widget.heightPerMinute;
  }

  @override
  void didUpdateWidget(covariant DayGestureDetector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    visibleDates = widget.visibleDateRange.datesSpanned;
    heightPerSlot = widget.minuteSlotSize.inMinutes * widget.heightPerMinute;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: <Widget>[
          for (int day = 0; day < visibleDates.length; day++)
            for (int i = 0; i < slots; i++)
              Positioned(
                left: (widget.width * day),
                top: heightPerSlot * i,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () =>
                      _onTap(calculateDateTimeRange(visibleDates[day], i)),
                  onVerticalDragStart: isMobileDevice
                      ? null
                      : (details) => _onVerticalDragStart(
                            details,
                            calculateDateTimeRange(visibleDates[day], i),
                          ),
                  onVerticalDragEnd: isMobileDevice ? null : _onVerticalDragEnd,
                  onVerticalDragUpdate: isMobileDevice
                      ? null
                      : (details) => _onVerticalDragUpdate(
                            details,
                            calculateDateTimeRange(visibleDates[day], i),
                          ),
                  child: SizedBox(
                    width: widget.width,
                    height: heightPerSlot,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  /// Handles the onTap event.
  void _onTap(DateTimeRange dateTimeRange) async {
    if (controller.selectedEvent != null) {
      controller.deselectEvent();
      return;
    }

    // Set the selected event to a new event.
    scope.eventsController.selectEvent(
      CalendarEvent<T>(
        dateTimeRange: dateTimeRange,
      ),
    );

    await scope.functions.onCreateEvent?.call(
      scope.eventsController.selectedEvent!,
    );
  }

  /// Handles the vertical drag start event.
  void _onVerticalDragStart(
    DragStartDetails details,
    DateTimeRange initialDateTimeRange,
  ) {
    cursorOffset = 0;
    scope.eventsController.selectEvent(
      CalendarEvent<T>(
        dateTimeRange: initialDateTimeRange,
      ),
    );
  }

  /// Handles the vertical drag end event.
  void _onVerticalDragEnd(DragEndDetails details) async {
    cursorOffset = 0;

    await scope.functions.onCreateEvent?.call(
      scope.eventsController.selectedEvent!,
    );
  }

  /// Handles the vertical drag update event.
  void _onVerticalDragUpdate(
    DragUpdateDetails details,
    DateTimeRange initialDateTimeRange,
  ) {
    cursorOffset += details.delta.dy;

    final newNumberOfSlotsSelected = cursorOffset ~/ heightPerSlot;
    if (newNumberOfSlotsSelected != numberOfSlotsSelected) {
      numberOfSlotsSelected = newNumberOfSlotsSelected;

      DateTimeRange dateTimeRange;
      if (numberOfSlotsSelected.isNegative) {
        dateTimeRange = DateTimeRange(
          start: initialDateTimeRange.start.add(
            Duration(
              minutes: widget.minuteSlotSize.inMinutes * numberOfSlotsSelected,
            ),
          ),
          end: initialDateTimeRange.end,
        );
      } else {
        dateTimeRange = DateTimeRange(
          start: initialDateTimeRange.start,
          end: initialDateTimeRange.end.add(
            Duration(
              minutes: widget.minuteSlotSize.inMinutes * numberOfSlotsSelected,
            ),
          ),
        );
      }

      scope.eventsController.selectedEvent?.dateTimeRange = dateTimeRange;
    }
  }

  /// Calculate the [DateTimeRange] of a slot.
  DateTimeRange calculateDateTimeRange(DateTime date, int i) => DateTimeRange(
        start: DateTime(
          date.year,
          date.month,
          date.day,
          0,
          widget.minuteSlotSize.inMinutes * i,
        ),
        end: DateTime(
          date.year,
          date.month,
          date.day,
          0,
          widget.minuteSlotSize.inMinutes * (i + 1),
        ),
      );
}
