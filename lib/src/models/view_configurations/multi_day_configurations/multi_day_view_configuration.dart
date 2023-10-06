import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [MultiDayViewConfiguration]s.
abstract class MultiDayViewConfiguration extends ViewConfiguration {
  const MultiDayViewConfiguration();

  /// The number of days to display.
  int get numberOfDays;

  /// The width of the timeline.
  double get timelineWidth;

  /// The overlap of the hourLines and the timeline.
  double get daySeparatorLeftOffset;

  /// The vertical step duration.
  Duration get horizontalStepDuration;

  /// The duration of a new event.
  Duration get newEventDuration;

  /// Paint the week number.
  bool get paintWeekNumber;

  /// The duration where the vertical drag will snap to.
  Duration get verticalSnapRange;

  /// Enable snapping to events.
  bool get eventSnapping;

  /// Enable snapping to the time indicator.
  bool get timeIndicatorSnapping;

  /// The first day of the week.
  int get firstDayOfWeek;

  /// Can create new events.
  bool get createEvents;

  /// Can create new multiDay events.
  bool get createMultiDayEvents;

  /// The height of the multiDay tiles.
  double get multiDayTileHeight;

  /// The duration of the vertical drag step.
  Duration get verticalStepDuration;

  MultiDayViewConfiguration copyWith({
    int? numberOfDays,
    double? timelineWidth,
    double? daySeparatorLeftOffset,
    double? multiDayTileHeight,
    Duration? verticalStepDuration,
    Duration? verticalSnapRange,
    Duration? newEventDuration,
    bool? paintWeekNumber,
    bool? eventSnapping,
    bool? timeIndicatorSnapping,
    int? firstDayOfWeek,
    bool? createEvents,
    bool? createMultiDayEvents,
    String? name,
  });
}
