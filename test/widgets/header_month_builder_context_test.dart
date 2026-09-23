// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// The multi-day header and month builders take a [BuildContext] and resolve
/// their own styles from it.
void main() {
  late DefaultEventsController eventsController;

  setUp(() => eventsController = DefaultEventsController());

  final tiles = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());

  Future<void> pump(
    WidgetTester tester,
    ViewConfiguration viewConfiguration, {
    KalenderComponents? components,
    KalenderThemeData? theme,
  }) async {
    final view = KalenderView(
      eventsController: eventsController,
      kalenderController: KalenderController(viewConfiguration: viewConfiguration),
      components: components,
      views: [
        MultiDayViewParts(
          header: MultiDayHeader(tileComponents: tiles),
          body: MultiDayBody(tileComponents: tiles),
        ),
        const MonthViewParts(),
      ],
    );
    await pumpAndSettleWithMaterialApp(tester, theme == null ? view : KalenderTheme(data: theme, child: view));
  }

  final displayRange = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 2));
  final week = MultiDayViewConfiguration.week(displayRange: displayRange);
  final month = MonthViewConfiguration.singleMonth(displayRange: displayRange);

  testWidgets('a custom day header resolves its style from the theme', (tester) async {
    await pump(
      tester,
      week,
      theme: const KalenderThemeData(dayHeaderStyle: DayHeaderStyle(textStyle: TextStyle(fontSize: 42))),
      components: KalenderComponents(
        multiDayComponents: MultiDayComponents(
          headerComponents: MultiDayHeaderComponents(
            dayHeaderBuilder: (context, date) => _Probe(KalenderTheme.of(context).dayHeaderStyle?.textStyle?.fontSize),
          ),
        ),
      ),
    );

    expect(tester.widgetList<_Probe<double>>(find.byType(_Probe<double>)).first.value, 42);
  });

  testWidgets('a custom week day header resolves its style from the theme', (tester) async {
    await pump(
      tester,
      month,
      theme: const KalenderThemeData(weekDayHeaderStyle: WeekDayHeaderStyle(textStyle: TextStyle(fontSize: 21))),
      components: KalenderComponents(
        monthComponents: MonthComponents(
          headerComponents: MonthHeaderComponents(
            weekDayHeaderBuilder: (context, date) =>
                _Probe(KalenderTheme.of(context).weekDayHeaderStyle?.textStyle?.fontSize),
          ),
        ),
      ),
    );

    expect(tester.widgetList<_Probe<double>>(find.byType(_Probe<double>)).first.value, 21);
  });

  testWidgets('a custom month grid builder receives the row count and a context', (tester) async {
    await pump(
      tester,
      month,
      theme: const KalenderThemeData(monthGridStyle: MonthGridStyle(thickness: 7)),
      components: KalenderComponents(
        monthComponents: MonthComponents(
          bodyComponents: MonthBodyComponents(
            monthGridBuilder: (context, numberOfRows) =>
                _Probe(KalenderTheme.of(context).monthGridStyle?.thickness, rows: numberOfRows),
          ),
        ),
      ),
    );

    final probe = tester.widgetList<_Probe<double>>(find.byType(_Probe<double>)).first;
    expect(probe.value, 7);
    expect(probe.rows, greaterThan(0));
  });

  testWidgets('the month week number builder resolves the top alignment the gutter uses', (tester) async {
    await pump(
      tester,
      MonthViewConfiguration.singleMonth(displayRange: displayRange, showWeekNumbers: true),
      components: KalenderComponents(
        monthComponents: MonthComponents(
          bodyComponents: MonthBodyComponents(
            weekNumberBuilder: (context, range) => _Probe(KalenderTheme.of(context).weekNumberStyle?.alignment),
          ),
        ),
      ),
    );

    final probes = tester.widgetList<_Probe<AlignmentGeometry>>(find.byType(_Probe<AlignmentGeometry>));
    expect(probes.first.value, Alignment.topCenter);
  });

  testWidgets('null builders render the package defaults', (tester) async {
    await pump(tester, month, components: const KalenderComponents());

    expect(find.byType(MonthGrid), findsOneWidget);
    expect(find.byType(MonthDayHeader), findsWidgets);
    expect(find.byType(WeekDayHeader), findsWidgets);
  });
}

/// Renders nothing. Carries a value its builder resolved from the context.
class _Probe<T> extends StatelessWidget {
  const _Probe(this.value, {this.rows});

  final T? value;
  final int? rows;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
