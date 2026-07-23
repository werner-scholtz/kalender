import 'package:kalender/src/models/components/string_builders.dart';
import 'package:kalender/src/widgets/components/schedule_date.dart';
import 'package:kalender/src/widgets/components/schedule_tile_highlight.dart';

/// A class containing custom widget builders for the `ScheduleBody`.
class ScheduleComponents {
  /// A function that builds the day header widget.
  final ScheduleDateBuilder leadingDateBuilder;

  /// Builds the day name displayed above the day number.
  ///
  /// Defaults to the first three characters of the day name in the calendar's locale.
  final DateStringBuilder? leadingDateStringBuilder;

  /// A function that builds the highlight tile widget.
  final ScheduleTileHighlightBuilder scheduleTileHighlightBuilder;

  const ScheduleComponents({
    this.leadingDateBuilder = ScheduleDate.builder,
    this.leadingDateStringBuilder,
    this.scheduleTileHighlightBuilder = ScheduleTileHighlight.builder,
  });
}
