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

  /// Creates a copy of this with the given fields replaced.
  ScheduleComponentStyles copyWith({
    ScheduleDateStyle? scheduleDateStyle,
    ScheduleTileHighlightStyle? scheduleTileHighlightStyle,
  }) {
    return ScheduleComponentStyles(
      scheduleDateStyle: scheduleDateStyle ?? this.scheduleDateStyle,
      scheduleTileHighlightStyle: scheduleTileHighlightStyle ?? this.scheduleTileHighlightStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleComponentStyles &&
        other.scheduleDateStyle == scheduleDateStyle &&
        other.scheduleTileHighlightStyle == scheduleTileHighlightStyle;
  }

  @override
  int get hashCode => Object.hash(scheduleDateStyle, scheduleTileHighlightStyle);
}
