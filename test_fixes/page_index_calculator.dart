// The input for `fix_page_index_calculator.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:kalender/kalender.dart';

final range = KalenderDateTimeRange(start: DateTime.utc(2025), end: DateTime.utc(2026));

final day = DayIndexCalculator(dateTimeRange: range);
final week = WeekIndexCalculator(dateTimeRange: range, firstDayOfWeek: DateTime.monday, daysToDisplay: 7);
final standardWeek = WeekIndexCalculator.week(dateTimeRange: range, firstDayOfWeek: DateTime.monday);
final workWeek = WeekIndexCalculator.workWeek(dateTimeRange: range);
final custom = CustomIndexCalculator(dateTimeRange: range, numberOfDays: 3);
final month = MonthIndexCalculator(dateTimeRange: range, firstDayOfWeek: DateTime.monday);
final schedule = ContinuousScheduleIndexCalculator(dateTimeRange: range);
final paginated = PaginatedScheduleIndexCalculator(dateTimeRange: range);
