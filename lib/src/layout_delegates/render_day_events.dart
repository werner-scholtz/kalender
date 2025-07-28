import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';

typedef GenerateDayLayoutFrame<T extends Object?> = MultiDayLayoutFrame<T> Function({
  required DateTime date,
  required TimeOfDayRange timeOfDayRange,
  required double heightPerMinute,
  required List<CalendarEvent<T>> events,
});

mixin DayEventsHelpers {
  DateTime get date;
  double get heightPerMinute;
  TimeOfDayRange get timeOfDayRange;
  List<CalendarEvent> get events;

  /// Calculates the height of an event based on the [CalendarEvent]s duration on the [date] and [heightPerMinute].
  ///
  /// [event] - The event to calculate the height of.
  /// [heightPerMinute] - The per minute of the current view.
  double calculateHeight(CalendarEvent event) {
    // Get the duration for the event on the specified date.
    final duration = event.dateTimeRangeAsUtc.dateTimeRangeOnDate(date)?.duration ?? Duration.zero;

    // Calculate the height based on the duration and height per minute.
    // TODO: This locks in the granularity to minutes, this might have to change at some point.
    final height = (duration.inSeconds / 60) * heightPerMinute;
    return height;
  }

  /// Calculates the distance from the start of the [date] to the start of the [event].
  ///
  /// * Note: this takes into account the [TimeOfDayRange] of the [EventLayoutDelegate].
  double calculateDistanceFromStart(CalendarEvent event) {
    // Get the start time of the event on the specified date.
    final eventStart = event.dateTimeRangeAsUtc.dateTimeRangeOnDate(date)?.start ?? date.startOfDay;

    // find the start of the current day. TODO: this can be calculated once and stored.
    final dateStart = timeOfDayRange.start.toDateTime(date);

    // Calculate the distance from the start of the day to the start of the event.
    return eventStart.difference(dateStart).inMinutes * heightPerMinute;
  }

  /// Vertical layout of the events.
  ///
  /// Calculates the top and bottom of each event, and ensues that they are within the bounds of the widget.
  ///
  /// [size] - The size of the widget.
  List<VerticalLayoutData> calculateVerticalLayoutData(Size size) {
    final layoutEvents = <VerticalLayoutData>[];

    for (final event in events) {
      final id = event.id;
      var top = calculateDistanceFromStart(event);
      final height = calculateHeight(event);
      var bottom = top + height;

      final overlap = size.height - bottom;
      // Check if the event is outside the bounds of the widget.
      if (overlap.isNegative) {
        // Update the top and bottom to fit within the bounds.
        top += overlap;
        bottom += overlap;
      }

      // Round top and bottom to one decimal place.
      // This is to prevent floating point errors from causing issues with the layout.
      top = (top * 10).roundToDouble() / 10;
      bottom = (bottom * 10).roundToDouble() / 10;

      layoutEvents.add(VerticalLayoutData(id: id, top: top, bottom: bottom));
    }

    return layoutEvents;
  }

  /// Groups the [VerticalLayoutData] into horizontal groups.
  List<HorizontalGroupData> groupVerticalLayoutData(
    List<VerticalLayoutData> verticalData,
  ) {
    final horizontalGroups = <HorizontalGroupData>[];

    for (final data in verticalData) {
      final (id, top, bottom) = (data.id, data.top, data.bottom);

      // If the layout data is already in a group, skip it.
      if (horizontalGroups.any((group) => group.containsId(id))) continue;

      // Find the index of the group that overlaps with the layout data.
      final groupIndex = horizontalGroups.indexWhere((group) {
        return group.overlaps(top, bottom);
      });

      // If a group was found that overlaps, add the layout data to that group.
      if (groupIndex != -1) {
        final group = horizontalGroups.elementAt(groupIndex);
        group.add(data);
      } else {
        // If no group was found, create a new group with the layout data.
        horizontalGroups.add(HorizontalGroupData(data));
      }
    }

    return horizontalGroups;
  }
}

/// This is an attempt to improve performance by using a custom RenderBox
/// Fine-grained control over rebuilds - Only relayout when specific properties change
/// Better hit testing - More efficient event detection
/// Optimized painting - Paint only what's needed
/// Direct child management - No widget tree overhead
class DayEventsRenderWidget extends MultiChildRenderObjectWidget {
  const DayEventsRenderWidget({
    super.key,
    required this.date,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    required this.events,
    required super.children,
  });

  final List<CalendarEvent> events;
  final DateTime date;
  final TimeOfDayRange timeOfDayRange;
  final double heightPerMinute;

  @override
  RenderDayEvents createRenderObject(BuildContext context) {
    return RenderDayEvents(
      events: events,
      date: date,
      timeOfDayRange: timeOfDayRange,
      heightPerMinute: heightPerMinute,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderDayEvents renderObject) {
    renderObject
      .._events = events
      .._date = date
      .._timeOfDayRange = timeOfDayRange
      .._heightPerMinute = heightPerMinute;
  }
}

class EventParentData extends ContainerBoxParentData<RenderBox> {
  /// [CalendarEvent.id] is used to identify the event.
  int? id;
}

class RenderDayEvents extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, EventParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, EventParentData>,
        DayEventsHelpers {
  RenderDayEvents({
    required List<CalendarEvent> events,
    required DateTime date,
    required TimeOfDayRange timeOfDayRange,
    required double heightPerMinute,
  })  : _events = events,
        _date = date,
        _timeOfDayRange = timeOfDayRange,
        _heightPerMinute = heightPerMinute;

  List<CalendarEvent> _events;
  @override
  List<CalendarEvent> get events => _events;
  set events(List<CalendarEvent> value) {
    if (_events == value) return;
    _events = value;
    _invalidateLayout();
  }

  DateTime _date;
  @override
  DateTime get date => _date;
  set date(DateTime value) {
    if (_date == value) return;
    _date = value;
    _invalidateLayout();
  }

  TimeOfDayRange _timeOfDayRange;
  @override
  TimeOfDayRange get timeOfDayRange => _timeOfDayRange;
  set timeOfDayRange(TimeOfDayRange value) {
    if (_timeOfDayRange == value) return;
    _timeOfDayRange = value;
    _invalidateLayout();
  }

  double _heightPerMinute;
  @override
  double get heightPerMinute => _heightPerMinute;
  set heightPerMinute(double value) {
    if (_heightPerMinute == value) return;
    _heightPerMinute = value;
    _invalidateLayout();
  }

  void _invalidateLayout() => markNeedsLayout();

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! EventParentData) {
      child.parentData = EventParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    final verticalLayoutData = calculateVerticalLayoutData(size);
    final horizontalGroups = groupVerticalLayoutData(verticalLayoutData);

    for (final data in horizontalGroups) {}

    for (var i = 0; i < horizontalGroups.length; i++) {
      final group = horizontalGroups.elementAt(i);

      final layoutData = <EventLayoutData>[];
      for (final data in group.verticalLayoutData) {
        // Check with how many already laid out events this event overlaps.
        final overlaps = layoutData.where((e) => e.overlaps(data));
        final numberOfOverlaps = overlaps.length + 1;

        double? lastWidth;
        if (overlaps.isNotEmpty) lastWidth = overlaps.reduce((e, f) => e.width <= f.width ? e : f).width;

        double width;
        double xOffset;
        if (lastWidth == null) {
          width = size.width / numberOfOverlaps;
          xOffset = width * (numberOfOverlaps - 1);
        } else {
          // TODO: make this adjustable ?
          width = lastWidth / 1.8;
          xOffset = size.width - width;
        }

        // Layout the tile.
        layoutChild(data.id, BoxConstraints.tightFor(width: width, height: data.height));

        // Position the tile.
        positionChild(data.id, Offset(xOffset, data.top));

        // Add the layout data to the list.
        layoutData.add(EventLayoutData(left: xOffset, right: size.width, verticalLayoutData: data));
      }
    }
  }
}
