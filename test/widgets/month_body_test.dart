// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart' show WeekDayHeaders;

import '../utilities.dart';

void _expectMonthRows(WidgetTester tester, int rows) {
  expect(find.byType(MonthGrid), findsOneWidget);
  expect(find.byType(MonthWeek), findsNWidgets(rows));
}

void main() {
  group('MonthBody Tests', () {
    late DefaultEventsController eventsController;

    final defaultDisplayRange = KalenderDateTimeRange(start: DateTime(2023), end: DateTime(2026));

    setUp(() {
      eventsController = DefaultEventsController();
    });

    Future<void> pumpMonthView(
      WidgetTester tester,
      DateTime initialDateTime, {
      KalenderDateTimeRange? displayRange,
      bool showWeekNumbers = false,
      KalenderComponents? components,
      MonthBodyConfiguration? bodyConfiguration,
      KalenderThemeData? theme,
    }) {
      final kalenderController = KalenderController(
        viewConfiguration: MonthViewConfiguration.singleMonth(
          displayRange: displayRange ?? defaultDisplayRange,
          initialDateTime: initialDateTime,
          showWeekNumbers: showWeekNumbers,
        ),
      );
      final view = KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        components: components,
        views: [
          MonthViewParts(
            header: const SizedBox.shrink(),
            body: MonthBody(configuration: bodyConfiguration),
          ),
        ],
      );

      return pumpAndSettleWithMaterialApp(tester, theme == null ? view : KalenderTheme(data: theme, child: view));
    }

    // January 2025 starts on a Wednesday and fits in 5 rows. October 2023 starts on a Sunday and needs 6.
    final rowCountCases = <({String name, DateTime initialDateTime, int expectedRows})>[
      (name: 'January 2025', initialDateTime: DateTime(2025, 1), expectedRows: 5),
      (name: 'October 2023', initialDateTime: DateTime(2023, 10), expectedRows: 6),
    ];

    for (final c in rowCountCases) {
      testWidgets('renders ${c.expectedRows} week rows for ${c.name}', (tester) async {
        await pumpMonthView(tester, c.initialDateTime);
        _expectMonthRows(tester, c.expectedRows);
      });
    }

    // #140
    testWidgets('monthDayCellBuilder is called per day with focused-month flags', (tester) async {
      final byDate = <DateTime, MonthDayCellDetails>{};

      final components = KalenderComponents(
        monthComponents: MonthComponents(
          bodyComponents: MonthBodyComponents(
            monthDayCellBuilder: (context, details) {
              byDate[DateTime(details.date.year, details.date.month, details.date.day)] = details;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      await pumpMonthView(tester, DateTime(2025, 1), components: components);

      expect(byDate.map((date, details) => MapEntry(date, details.isInFocusedMonth)), {
        for (var day = 0; day < 35; day++) DateTime(2024, 12, 30 + day): DateTime(2024, 12, 30 + day).month == 1,
      });
    });

    testWidgets('builds no day-cell background layer without a custom builder', (tester) async {
      await pumpMonthView(tester, DateTime(2025, 1));

      expect(find.byType(MonthDayCell), findsNothing);
    });

    testWidgets('shadeAdjacentMonths shades only adjacent-month days', (tester) async {
      final components = KalenderComponents(
        monthComponents: MonthComponents(
          bodyComponents: MonthBodyComponents(monthDayCellBuilder: MonthDayCell.shadeAdjacentMonths()),
        ),
      );

      await pumpMonthView(tester, DateTime(2025, 1), components: components);

      final shade = Theme.of(
        tester.element(find.byType(MonthDayCell).first),
      ).colorScheme.onSurface.withValues(alpha: 0.08);
      final shaded = tester.widgetList<ColoredBox>(find.byType(ColoredBox)).where((box) => box.color == shade).length;

      expect(shaded, 4);
      expect(find.byType(MonthDayCell), findsNWidgets(31));
    });

    testWidgets('shadeAdjacentMonths uses a custom color when given', (tester) async {
      const custom = Color(0xFF123456);
      final components = KalenderComponents(
        monthComponents: MonthComponents(
          bodyComponents: MonthBodyComponents(monthDayCellBuilder: MonthDayCell.shadeAdjacentMonths(color: custom)),
        ),
      );

      await pumpMonthView(tester, DateTime(2025, 1), components: components);

      final shaded = tester.widgetList<ColoredBox>(find.byType(ColoredBox)).where((box) => box.color == custom).length;

      expect(shaded, 4);
    });

    // #266
    testWidgets('renders a month when the displayRange spans a single month', (tester) async {
      await pumpMonthView(
        tester,
        DateTime(2026, 5),
        displayRange: KalenderDateTimeRange(start: DateTime(2026, 5), end: DateTime(2026, 5, 31)),
      );

      _expectMonthRows(tester, 5);
    });

    testWidgets('each week row renders 7 day-number headers', (tester) async {
      const rows = 5;
      await pumpMonthView(tester, DateTime(2025, 1));

      _expectMonthRows(tester, rows);
      expect(find.byType(WeekDayHeaders), findsNWidgets(rows));
      expect(find.byType(MonthDayHeader), findsNWidgets(rows * DateTime.daysPerWeek));
    });

    testWidgets('does not render week numbers by default', (tester) async {
      await pumpMonthView(tester, DateTime(2025, 1));

      expect(find.byType(WeekNumber), findsNothing);
    });

    testWidgets('renders one week number per row when enabled', (tester) async {
      const rows = 5;
      await pumpMonthView(tester, DateTime(2025, 1), showWeekNumbers: true);

      _expectMonthRows(tester, rows);
      expect(find.byType(WeekNumber), findsNWidgets(rows));
    });

    testWidgets('keeps the month grid at 7 day columns when week numbers are enabled', (tester) async {
      await pumpMonthView(tester, DateTime(2025, 1), showWeekNumbers: true);

      // The grid draws one column line more than the number of day columns.
      final columnLines = find.descendant(
        of: find.descendant(of: find.byType(MonthGrid).first, matching: find.byType(Row)),
        matching: find.byType(Container),
      );

      expect(columnLines, findsNWidgets(8));
    });

    testWidgets('the month grid paints its lines at the default thickness', (tester) async {
      await pumpMonthView(tester, DateTime(2025, 1));

      final context = tester.element(find.byType(MonthGrid));
      final color = KalenderTheme.of(context).monthGridStyle!.color!;

      expect(tester.renderObject(find.byType(MonthGrid)), paints..path(color: color, style: PaintingStyle.stroke));
    });

    testWidgets('the month grid paints a filled line when given a thickness', (tester) async {
      const color = Color(0xFF00FF00);
      await pumpMonthView(
        tester,
        DateTime(2025, 1),
        theme: const KalenderThemeData(monthGridStyle: MonthGridStyle(color: color, thickness: 2)),
      );

      expect(tester.renderObject(find.byType(MonthGrid)), paints..path(color: color, style: PaintingStyle.fill));
    });

    final weekNumberAlignmentCases = <(String, KalenderThemeData?, Alignment)>[
      ('the month week number sits at the top of its row by default', null, Alignment.topCenter),
      (
        'a theme keeps the top alignment it does not mention',
        const KalenderThemeData(weekNumberStyle: WeekNumberStyle(tooltip: 'Week')),
        Alignment.topCenter,
      ),
      (
        'the theme can move the month week number off the top',
        const KalenderThemeData(weekNumberStyle: WeekNumberStyle(alignment: Alignment.bottomCenter)),
        Alignment.bottomCenter,
      ),
      (
        'applies custom week number alignment from the theme',
        const KalenderThemeData(weekNumberStyle: WeekNumberStyle(alignment: Alignment.topCenter)),
        Alignment.topCenter,
      ),
    ];

    for (final (name, theme, alignment) in weekNumberAlignmentCases) {
      testWidgets(name, (tester) async {
        await pumpMonthView(tester, DateTime(2025, 1), showWeekNumbers: true, theme: theme);

        expect(
          find.descendant(
            of: find.byType(WeekNumber),
            matching: find.byWidgetPredicate((w) => w is Align && w.alignment == alignment),
          ),
          findsNWidgets(5),
        );
      });
    }

    // #255: a tileHeight taller than any week row leaves room for no tiles.
    const tallTileHeight = 1000.0;

    testWidgets('shows no overflow button in month view when there are no events (#255)', (tester) async {
      await pumpMonthView(
        tester,
        DateTime(2025, 1),
        bodyConfiguration: const MonthBodyConfiguration(tileHeight: tallTileHeight),
      );

      expect(find.byType(MonthBody), findsOneWidget);
      expect(find.byType(MultiDayPortalOverlayButton), findsNothing);
    });

    testWidgets('shows exactly one overflow button for a single event when max is 0 (#255)', (tester) async {
      eventsController.addEvent(KalenderEvent(start: DateTime(2025, 1, 15, 9), end: DateTime(2025, 1, 15, 10)));

      await pumpMonthView(
        tester,
        DateTime(2025, 1),
        bodyConfiguration: const MonthBodyConfiguration(tileHeight: tallTileHeight),
      );

      expect(find.byType(MultiDayPortalOverlayButton), findsOneWidget);

      final button = tester.widget<MultiDayPortalOverlayButton>(find.byType(MultiDayPortalOverlayButton));
      expect(button.numberOfHiddenRows, greaterThan(0));
    });

    // #235: a custom strategy wired through MonthBodyConfiguration in a full month view.
    group('custom multiDayLayoutStrategy (#235)', () {
      late _RecordingStrategy strategy;

      setUp(() => strategy = _RecordingStrategy());

      testWidgets('renders month view without error and is invoked', (tester) async {
        final event = KalenderEvent(start: DateTime(2025, 1, 15, 9), end: DateTime(2025, 1, 15, 10));
        eventsController.addEvent(event);

        await pumpMonthView(
          tester,
          DateTime(2025, 1),
          bodyConfiguration: MonthBodyConfiguration(multiDayLayoutStrategy: strategy),
        );

        expect(strategy.invoked, isTrue);
        expect(find.byKey(Key('MultiDayEventTile-${event.id}')), findsOneWidget);
      });

      testWidgets('renders without error when there are no events', (tester) async {
        await pumpMonthView(
          tester,
          DateTime(2025, 1),
          bodyConfiguration: MonthBodyConfiguration(multiDayLayoutStrategy: strategy),
        );

        expect(strategy.invoked, isTrue);
      });
    });
  });
}

/// Delegates to the built-in row assignment and records that it ran.
class _RecordingStrategy extends MultiDayLayoutStrategy {
  bool invoked = false;

  @override
  MultiDayLayoutFrame generateFrame({
    required FloatingDateTimeRange visibleRange,
    required List<KalenderEvent> events,
    required TextDirection textDirection,
    required Location? location,
    required MultiDayLayoutFrameCache? cache,
  }) {
    invoked = true;
    return defaultMultiDayFrameGenerator(
      visibleRange: visibleRange,
      events: events,
      textDirection: textDirection,
      location: location,
      cache: cache,
    );
  }
}
