import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/gutter_widths.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// The month grid puts the week number at the top of its row rather than
/// centring it, which is where every other week number sits.
const _monthWeekNumberDefaults = WeekNumberStyle(alignment: Alignment.topCenter);

/// The style the month week number is drawn with.
///
/// [KalenderThemeData.weekNumberStyle] wins over the top alignment, resolved from
/// the nearest scope like every other style.
WeekNumberStyle _resolveStyle(BuildContext context) {
  return _monthWeekNumberDefaults.merge(KalenderTheme.of(context).weekNumberStyle);
}

/// The width the calendar measured for the week number column.
///
/// Falls back to measuring where there is no [GutterWidths], which is the case
/// outside a [KalenderView].
double _width(BuildContext context) {
  return GutterWidths.maybeOf(context)?.weekNumber ??
      context.components.monthComponents.bodyComponents.buildWeekNumberWidth(context);
}

class MonthWeekNumberGutter extends StatelessWidget {
  final InternalDateTimeRange visibleRange;
  final int numberOfRows;
  final WeekNumberBuilder weekNumberBuilder;
  final BorderSide dividerSide;

  const MonthWeekNumberGutter({
    super.key,
    required this.visibleRange,
    required this.numberOfRows,
    required this.weekNumberBuilder,
    required this.dividerSide,
  });

  @override
  Widget build(BuildContext context) {
    return KalenderTheme(
      data: KalenderTheme.of(context).copyWith(weekNumberStyle: _resolveStyle(context)),
      child: SizedBox(
        width: _width(context),
        child: Column(
          children: List.generate(
            numberOfRows,
            (index) {
              final range = _rangeForRow(index);
              return Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      top: index == 0 ? dividerSide : BorderSide.none,
                      bottom: dividerSide,
                    ),
                  ),
                  child: Builder(
                    builder: (context) => weekNumberBuilder(context, range.forLocation(location: context.location)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  InternalDateTimeRange _rangeForRow(int index) {
    final start = visibleRange.start.add(Duration(days: index * DateTime.daysPerWeek));
    return InternalDateTimeRange(start: start, end: start.add(const Duration(days: DateTime.daysPerWeek)));
  }
}

class MonthWeekNumberSpacer extends StatelessWidget {
  const MonthWeekNumberSpacer({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: _width(context));
}
