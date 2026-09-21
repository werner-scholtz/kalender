// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/gutter_widths.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// The month week number sits at the top of its row.
const _monthWeekNumberDefaults = WeekNumberStyle(alignment: Alignment.topCenter);

/// The range of week [row] of a month page that starts at the start of [visibleRange].
FloatingDateTimeRange monthWeekRange(FloatingDateTimeRange visibleRange, int row) {
  final start = visibleRange.start.add(Duration(days: row * DateTime.daysPerWeek));
  return FloatingDateTimeRange(
    start: start,
    end: start.add(const Duration(days: DateTime.daysPerWeek)),
  );
}

/// The week number column width from [GutterWidths], or a measurement outside a [KalenderView].
double _width(BuildContext context) {
  return GutterWidths.maybeOf(context)?.weekNumber ??
      context.components.monthComponents.bodyComponents.buildWeekNumberWidth(context);
}

class MonthWeekNumberGutter extends StatelessWidget {
  final FloatingDateTimeRange visibleRange;
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
    final theme = KalenderTheme.of(context);
    return KalenderTheme(
      data: theme.copyWith(weekNumberStyle: _monthWeekNumberDefaults.merge(theme.weekNumberStyle)),
      child: SizedBox(
        width: _width(context),
        child: Column(
          children: List.generate(numberOfRows, (index) {
            final range = monthWeekRange(visibleRange, index);
            return Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(top: index == 0 ? dividerSide : BorderSide.none, bottom: dividerSide),
                ),
                child: Builder(
                  builder: (context) => weekNumberBuilder(context, range.forLocation(location: context.location)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MonthWeekNumberSpacer extends StatelessWidget {
  const MonthWeekNumberSpacer({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: _width(context));
}
