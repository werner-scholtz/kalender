import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// The multi-day header and month builders take a [BuildContext] and resolve
/// their own styles from it.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  final tiles = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());

  Future<void> pump(
    WidgetTester tester,
    ViewConfiguration viewConfiguration, {
    CalendarComponents? components,
    KalenderThemeData? theme,
  }) async {
    final view = KalenderView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: viewConfiguration,
      components: components,
      header: CalendarHeader(multiDayTileComponents: tiles),
      body: CalendarBody(multiDayTileComponents: tiles),
    );
    await pumpAndSettleWithMaterialApp(
      tester,
      theme == null ? view : KalenderTheme(data: theme, child: view),
    );
  }

  final displayRange = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 2));
  final week = MultiDayViewConfiguration.week(displayRange: displayRange);
  final month = MonthViewConfiguration.singleMonth(displayRange: displayRange);

  testWidgets('a custom day header resolves its style from the theme', (tester) async {
    await pump(
      tester,
      week,
      theme: const KalenderThemeData(dayHeaderStyle: DayHeaderStyle(textStyle: TextStyle(fontSize: 42))),
      components: CalendarComponents(
        multiDayComponents: MultiDayComponents(
          headerComponents: MultiDayHeaderComponents(
            dayHeaderBuilder: (context, date) => _Probe(KalenderTheme.of(context).dayHeaderStyle?.textStyle?.fontSize),
          ),
        ),
      ),
    );

    expect(tester.widgetList<_Probe>(find.byType(_Probe)).first.value, 42);
  });

  testWidgets('a custom week day header resolves its style from the theme', (tester) async {
    await pump(
      tester,
      month,
      theme: const KalenderThemeData(weekDayHeaderStyle: WeekDayHeaderStyle(textStyle: TextStyle(fontSize: 21))),
      components: CalendarComponents(
        monthComponents: MonthComponents(
          headerComponents: MonthHeaderComponents(
            weekDayHeaderBuilder: (context, date) =>
                _Probe(KalenderTheme.of(context).weekDayHeaderStyle?.textStyle?.fontSize),
          ),
        ),
      ),
    );

    expect(tester.widgetList<_Probe>(find.byType(_Probe)).first.value, 21);
  });

  testWidgets('a custom month grid builder receives the row count and a context', (tester) async {
    await pump(
      tester,
      month,
      theme: const KalenderThemeData(monthGridStyle: MonthGridStyle(thickness: 7)),
      components: CalendarComponents(
        monthComponents: MonthComponents(
          bodyComponents: MonthBodyComponents(
            monthGridBuilder: (context, numberOfRows) =>
                _Probe(KalenderTheme.of(context).monthGridStyle?.thickness, rows: numberOfRows),
          ),
        ),
      ),
    );

    final probe = tester.widgetList<_Probe>(find.byType(_Probe)).first;
    expect(probe.value, 7);
    expect(probe.rows, greaterThan(0));
  });

  testWidgets('the month week number builder resolves the top alignment the gutter uses', (tester) async {
    await pump(
      tester,
      MonthViewConfiguration.singleMonth(displayRange: displayRange, showWeekNumbers: true),
      components: CalendarComponents(
        monthComponents: MonthComponents(
          bodyComponents: MonthBodyComponents(
            weekNumberBuilder: (context, range) =>
                _AlignmentProbe(KalenderTheme.of(context).weekNumberStyle?.alignment),
          ),
        ),
      ),
    );

    final probes = tester.widgetList<_AlignmentProbe>(find.byType(_AlignmentProbe));
    expect(probes, isNotEmpty);
    expect(probes.first.alignment, Alignment.topCenter);
  });

  testWidgets('null builders render the package defaults', (tester) async {
    await pump(tester, month, components: const CalendarComponents());

    expect(find.byType(MonthGrid), findsOneWidget);
    expect(find.byType(MonthDayHeader), findsWidgets);
    expect(find.byType(WeekDayHeader), findsWidgets);
  });
}

/// Renders nothing. Carries a value its builder resolved from the context.
class _Probe extends StatelessWidget {
  const _Probe(this.value, {this.rows});

  final double? value;
  final int? rows;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Renders nothing. Carries the alignment its builder resolved from the context.
class _AlignmentProbe extends StatelessWidget {
  const _AlignmentProbe(this.alignment);

  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
