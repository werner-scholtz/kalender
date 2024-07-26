import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

export 'package:kalender/src/extensions.dart';

///  * [defaultEventGroupLayoutStrategy], which displays the tile over each other.
typedef EventGroupLayoutStrategy<T extends Object?> = EventGroupLayoutDelegate Function(
  List<EventGroup<T>> groups,
  List<DateTime> visibleDates,
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double dayWidth,
);

/// A [EventLayoutStrategy] that lays out the tiles on top of each other.
EventGroupLayoutDelegate defaultEventGroupLayoutStrategy(
  List<EventGroup> groups,
  List<DateTime> visibleDates,
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double dayWidth,
) {
  return EventGroupDefaultLayoutDelegate(
    groups: groups,
    heightPerMinute: heightPerMinute,
    timeOfDayRange: timeOfDayRange,
    visibleDates: visibleDates,
    dayWidth: dayWidth,
  );
}

abstract class EventGroupLayoutDelegate<T extends Object?> extends MultiChildLayoutDelegate {
  EventGroupLayoutDelegate({
    required this.groups,
    required this.timeOfDayRange,
    required this.dayWidth,
    required this.heightPerMinute,
    required this.visibleDates,
  });

  final List<EventGroup<T>> groups;
  final TimeOfDayRange timeOfDayRange;
  final List<DateTime> visibleDates;
  final double dayWidth;
  final double heightPerMinute;

  /// Calculates the distance from the start of the day to the [dateTime].
  double calculateDistanceFromStartOfDay(EventGroup<T> group) {
    final dayStart = timeOfDayRange.start.toDateTime(group.date);
    return (group.start.difference(dayStart).inMinutes * heightPerMinute);
  }

  @override
  bool shouldRelayout(covariant EventGroupLayoutDelegate oldDelegate) {
    return oldDelegate.groups != groups ||
        oldDelegate.heightPerMinute != heightPerMinute ||
        oldDelegate.timeOfDayRange != timeOfDayRange;
  }
}

/// A [EventGroupLayoutDelegate] that lays out the tiles on top of each other.
class EventGroupDefaultLayoutDelegate<T extends Object?> extends EventGroupLayoutDelegate<T> {
  EventGroupDefaultLayoutDelegate({
    required super.groups,
    required super.heightPerMinute,
    required super.timeOfDayRange,
    required super.dayWidth,
    required super.visibleDates,
  });

  @override
  void performLayout(Size size) {
    final numberOfChildren = groups.length;

    for (var i = 0; i < numberOfChildren; i++) {
      final groupId = i;
      final group = groups[groupId];

      layoutChild(
        groupId,
        BoxConstraints(
          minWidth: dayWidth,
          maxWidth: dayWidth,
          minHeight: 0,
          maxHeight: size.height,
        ),
      );

      final dateNumber = visibleDates.indexOf(group.date);
      final groupXOffset = dayWidth * dateNumber;
      final groupYOffset = calculateDistanceFromStartOfDay(group);

      positionChild(
        groupId,
        Offset(groupXOffset, groupYOffset),
      );
    }
  }
}
