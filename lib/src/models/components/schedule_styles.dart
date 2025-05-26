import 'package:kalender/src/widgets/components/schedule_date.dart';
import 'package:kalender/src/widgets/components/schedule_tile_highlight.dart';

class ScheduleComponentStyles {
  /// The style for the schedule date.
  final ScheduleDateStyle scheduleDateStyle;

  /// The style for the schedule tile highlight.
  final ScheduleTileHighlightStyle scheduleTileHighlightStyle;

  const ScheduleComponentStyles({
    this.scheduleDateStyle = const ScheduleDateStyle(),
    this.scheduleTileHighlightStyle = const ScheduleTileHighlightStyle(),
  });
}
