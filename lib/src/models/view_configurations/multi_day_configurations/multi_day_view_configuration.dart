import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [MultiDayViewConfiguration]s.
abstract class MultiDayViewConfiguration implements ViewConfiguration {
  const MultiDayViewConfiguration();

  // @override
  // final ViewType viewType = ViewType.multiDay;

  /// The width of the timeline.
  double get timelineWidth;

  /// The overlap of the hourlines and the timeline.
  double get hourlineTimelineOverlap;

  /// The height of the multiday tiles.
  double get multidayTileHeight;

  /// The vertical step duration.
  Duration get verticalDurationStep;

  /// The vertical step duration.
  Duration get horizontalDurationStep;

  /// The size of the minute slots.
  ///
  /// This determines the initial [DateTimeRange] of a new [CalendarEvent].
  SlotSize get minuteSlotSize;

  /// Paint the week number.
  bool get paintWeekNumber;

  /// Enable snapping to events.
  bool get eventSnapping;

  /// Enable snapping to the time indicator.
  bool get timeIndicatorSnapping;

  /// The first day of the week.
  int get firstDayOfWeek;
}
