import 'package:kalender/src/widgets/components/schedule_date.dart';

/// A class containing custom widget builders for the [MonthBody] and [MonthHeader].
class ScheduleComponents<T extends Object?> {
  /// A function that builds the day header widget.
  final ScheduleDateBuilder dayHeaderBuilder;

  ScheduleComponents({
    this.dayHeaderBuilder = ScheduleDate.builder,
  });
}
