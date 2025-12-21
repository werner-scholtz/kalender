import 'package:kalender/src/widgets/components/schedule_date.dart';
import 'package:kalender/src/widgets/components/schedule_tile_highlight.dart';

/// A class containing custom widget builders for the [ScheduleBody`].
class ScheduleComponents {
  /// A function that builds the day header widget.
  final ScheduleDateBuilder leadingDateBuilder;

  /// A function that builds the highlight tile widget.
  final ScheduleTileHighlightBuilder scheduleTileHighlightBuilder;

  const ScheduleComponents({
    this.leadingDateBuilder = ScheduleDate.builder,
    this.scheduleTileHighlightBuilder = ScheduleTileHighlight.builder,
  });
}
