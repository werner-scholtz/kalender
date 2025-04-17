import 'package:kalender/src/widgets/components/day_header.dart';

/// A class containing custom widget builders for the [MonthBody] and [MonthHeader].
class ScheduleComponents<T extends Object?> {
  /// A function that builds the day header widget.
  final DayHeaderBuilder? dayHeaderBuilder;

  ScheduleComponents({
    this.dayHeaderBuilder = DayHeader.builder,
  });
}
