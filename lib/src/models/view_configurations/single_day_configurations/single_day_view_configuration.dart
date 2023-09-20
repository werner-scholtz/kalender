import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [SingleDayViewConfiguration]s.
abstract class SingleDayViewConfiguration implements ViewConfiguration {
  const SingleDayViewConfiguration();

  /// The width of the timeline.
  double get timelineWidth;

  /// The overlap of the hourLines and the timeline.
  double get hourLineTimelineOverlap;

  /// The height of the multiDay tiles.
  double get multiDayTileHeight;

  /// The size of the minute slots.
  ///
  /// This determines the initial [DateTimeRange] of a new [CalendarEvent].
  Duration get slotSize;

  /// The duration of the vertical drag step.
  Duration get verticalStepDuration;

  /// The duration where the vertical drag will snap to.
  Duration get verticalSnapRange;

  /// Enable snapping to events.
  bool get eventSnapping;

  /// Enable snapping to the time indicator.
  bool get timeIndicatorSnapping;

  @override
  double calculateDayWidth(double pageWidth) {
    return pageWidth;
  }
}
