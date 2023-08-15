import 'package:kalender/src/models/calendar/slot_size.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [SingleDayViewConfiguration]s.
abstract class SingleDayViewConfiguration implements ViewConfiguration {
  const SingleDayViewConfiguration();

  @override
  double calculateDayWidth(double pageWidth) {
    /// This is unnecessary for [ViewType.singleDay]
    throw UnimplementedError();
  }

  /// The width of the timeline.
  double get timelineWidth;

  /// The overlap of the hourlines and the timeline.
  double get hourlineTimelineOverlap;

  /// The height of the multiday tiles.
  double get multidayTileHeight;

  /// The size of the minute slots.
  ///
  /// This determines the initial [DateTimeRange] of a new [CalendarEvent].
  SlotSize get slotSize;

  /// The duration of the vertical drag step.
  Duration get verticalStepDuration;

  /// The duration where the vertical drag will snap to.
  Duration get verticalSnapRange;

  /// Enable snapping to events.
  bool get eventSnapping;

  /// Enable snapping to the time indicator.
  bool get timeIndicatorSnapping;
}
