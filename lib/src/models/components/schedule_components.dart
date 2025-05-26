import 'package:kalender/src/widgets/components/schedule_date.dart';
import 'package:kalender/src/widgets/components/schedule_tile_highlight.dart';

/// A class containing custom widget builders for the [ScheduleBody`].
class ScheduleComponents<T extends Object?> {
  /// A function that builds the day header widget.
  final ScheduleDateBuilder dayHeaderBuilder;

  /// A function that builds the highlight tile widget.
  final ScheduleTileHighlightBuilder scheduleTileHighlightBuilder;

  ScheduleComponents({
    this.dayHeaderBuilder = ScheduleDate.builder,
    this.scheduleTileHighlightBuilder = ScheduleTileHighlight.builder,
  });
}
