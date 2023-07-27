import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [ViewType.singleDay]
abstract class SingleDayViewConfiguration implements ViewConfiguration {
  const SingleDayViewConfiguration();

  @override
  final ViewType viewType = ViewType.singleDay;

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

  /// The vertical step duration.
  Duration get verticalDurationStep;

  /// The size of the minute slots.
  ///
  /// This determines the initial [DateTimeRange] of a new [CalendarEvent].
  SlotSize get minuteSlotSize;
}
