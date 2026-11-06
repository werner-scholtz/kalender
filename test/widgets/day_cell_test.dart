// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart' show MultiDayEventsRow;
import 'package:linked_pageview/linked_pageview.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' show getLocation;

import '../utilities.dart';

/// The day cells of the multi-day body: one per day of a page, behind the hour lines, following the page.
void main() {
  final monday = DateTime(2025, 3, 24);
  final displayRange = KalenderDateTimeRange(start: DateTime(2025, 3, 3), end: DateTime(2025, 5, 5));
  DateTime now() => DateTime(2025, 3, 26, 10);

  final week = MultiDayViewConfiguration.week(displayRange: displayRange, initialDateTime: monday, nowCallback: now);
  final freeScroll = MultiDayViewConfiguration.freeScroll(
    numberOfDays: 7,
    displayRange: displayRange,
    initialDateTime: monday,
    nowCallback: now,
  );

  // Each cell is keyed by its details, so a test reads the details back from the tree.
  final components = KalenderComponents(
    multiDayComponents: MultiDayComponents(
      bodyComponents: MultiDayBodyComponents(
        dayCellBuilder: (context, details) => SizedBox.expand(key: ValueKey(details)),
      ),
    ),
  );
  final cellFinder = find.byWidgetPredicate((widget) => widget.key is ValueKey<DayCellDetails>);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() => eventsController = DefaultEventsController());
  tearDown(() {
    kalenderController.dispose();
    eventsController.dispose();
  });

  /// Pumps a view of [kalenderController]. Pumping again keeps the view and its view controller.
  Future<void> pumpView(
    WidgetTester tester, {
    KalenderComponents? components,
    KalenderCallbacks? callbacks,
    TextDirection textDirection = TextDirection.ltr,
    KalenderThemeData theme = const KalenderThemeData(),
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      Directionality(
        textDirection: textDirection,
        child: KalenderTheme(
          data: theme,
          child: KalenderView(
            eventsController: eventsController,
            kalenderController: kalenderController,
            components: components,
            callbacks: callbacks,
          ),
        ),
      ),
    );
  }

  Future<void> pump(
    WidgetTester tester,
    MultiDayViewConfiguration configuration, {
    KalenderComponents? components,
    KalenderCallbacks? callbacks,
    TextDirection textDirection = TextDirection.ltr,
    Location? location,
    KalenderThemeData theme = const KalenderThemeData(),
  }) {
    kalenderController = KalenderController(viewConfiguration: configuration, location: location);
    return pumpView(tester, components: components, callbacks: callbacks, textDirection: textDirection, theme: theme);
  }

  List<DayCellDetails> cells(WidgetTester tester) => [
    for (final widget in tester.widgetList(cellFinder)) (widget.key! as ValueKey<DayCellDetails>).value,
  ];

  /// The details of [count] days from [start], in [location] when given, with 26 March 2025 as today and the days of
  /// the month in [selected] as selected.
  List<DayCellDetails> daysFrom(
    DateTime start,
    int count, {
    double heightPerMinute = kDefaultHeightPerMinute,
    Location? location,
    Set<int> selected = const {},
  }) => [
    for (var day = 0; day < count; day++)
      DayCellDetails(
        date: location == null
            ? DateTime(start.year, start.month, start.day + day)
            : TZDateTime(location, start.year, start.month, start.day + day),
        isToday: start.month == 3 && start.day + day == 26,
        isSelected: selected.contains(start.day + day),
        timeOfDayRange: KalenderTimeRange.allDay(),
        heightPerMinute: heightPerMinute,
      ),
  ];

  /// The rectangle of every cell on screen, by date.
  Map<DateTime, Rect> cellRects(WidgetTester tester) => {
    for (final element in cellFinder.evaluate())
      (element.widget.key! as ValueKey<DayCellDetails>).value.date: tester.getRect(find.byWidget(element.widget)),
  };

  /// The rectangle of the events column of every date in [dates], widened by the padding around the column.
  Map<DateTime, Rect> columnRects(WidgetTester tester, Iterable<DateTime> dates) {
    final padding = const MultiDayBodyConfiguration().horizontalPadding;
    return {
      for (final date in dates)
        date: () {
          final column = tester.getRect(
            find.byKey(MultiDayEventsRow.columnKey(FloatingDateTime(date.year, date.month, date.day))),
          );
          return Rect.fromLTRB(column.left - padding.left, column.top, column.right + padding.right, column.bottom);
        }(),
    };
  }

  final views = [
    (name: 'week', configuration: week, expected: daysFrom(monday, 7)),
    (
      name: 'single day',
      configuration: MultiDayViewConfiguration.singleDay(
        displayRange: displayRange,
        initialDateTime: DateTime(2025, 3, 26),
        nowCallback: now,
      ),
      expected: daysFrom(DateTime(2025, 3, 26), 1),
    ),
    (
      name: 'custom',
      configuration: MultiDayViewConfiguration.custom(
        numberOfDays: 3,
        displayRange: KalenderDateTimeRange(start: monday, end: DateTime(2025, 5, 5)),
        initialDateTime: monday,
        nowCallback: now,
      ),
      expected: daysFrom(monday, 3),
    ),
    (name: 'free scroll', configuration: freeScroll, expected: daysFrom(monday, 7)),
  ];

  for (final view in views) {
    testWidgets('a ${view.name} view builds one cell per visible day', (tester) async {
      await pump(tester, view.configuration, components: components);

      expect(cells(tester), view.expected);
    });
  }

  for (final configuration in [(name: 'week', value: week), (name: 'free scroll', value: freeScroll)]) {
    for (final textDirection in TextDirection.values) {
      testWidgets('${configuration.name} cells cover their day columns in ${textDirection.name}', (tester) async {
        await pump(tester, configuration.value, components: components, textDirection: textDirection);

        final rects = cellRects(tester);
        expect(rects, columnRects(tester, rects.keys));
      });

      testWidgets('${configuration.name} cells follow a drag in ${textDirection.name}', (tester) async {
        await pump(tester, configuration.value, components: components, textDirection: textDirection);

        final gesture = await tester.startGesture(tester.getCenter(find.byType(MultiDayBody)));
        // The first move starts the drag and the second moves the page.
        final direction = textDirection == TextDirection.ltr ? -1.0 : 1.0;
        await gesture.moveBy(Offset(20 * direction, 0));
        await gesture.moveBy(Offset(200 * direction, 0));
        await tester.pump();

        final dragged = cellRects(tester);
        expect(dragged.keys, contains(DateTime(2025, 3, 31)));
        expect(dragged, columnRects(tester, dragged.keys));

        await gesture.up();
        await tester.pumpAndSettle();

        final settled = cellRects(tester);
        expect(settled, columnRects(tester, settled.keys));
      });
    }
  }

  testWidgets('the cells show the next page after navigation', (tester) async {
    await pump(tester, week, components: components);

    unawaited(kalenderController.animateToNextPage());
    await tester.pumpAndSettle();

    expect(cells(tester), daysFrom(DateTime(2025, 3, 31), 7));
  });

  testWidgets('a builder set after navigation starts on the visible page', (tester) async {
    await pump(tester, week);
    unawaited(kalenderController.animateToNextPage());
    await tester.pumpAndSettle();

    await pumpView(tester, components: components);

    expect(cells(tester), daysFrom(DateTime(2025, 3, 31), 7));
    final rects = cellRects(tester);
    expect(rects, columnRects(tester, rects.keys));
  });

  testWidgets('removing the builder after navigation keeps the page', (tester) async {
    await pump(tester, week, components: components);
    unawaited(kalenderController.animateToNextPage());
    await tester.pumpAndSettle();

    await pumpView(tester);

    expect(find.byKey(MultiDayEventsRow.columnKey(FloatingDateTime(2025, 3, 31))), findsOneWidget);
  });

  testWidgets('the cells are built before the hour lines', (tester) async {
    await pump(tester, week, components: components);

    final layers = tester.widgetList(
      find.byWidgetPredicate((widget) => widget is HourLines || widget.key is ValueKey<DayCellDetails>),
    );
    expect(layers.map((widget) => widget.runtimeType), [...List.filled(7, SizedBox), HourLines]);
  });

  for (final c in [
    (name: 'without a builder', components: null, theme: const KalenderThemeData(), pageViews: 1),
    (name: 'with a builder', components: components, theme: const KalenderThemeData(), pageViews: 2),
    (
      name: 'with a selection color',
      components: null,
      theme: const KalenderThemeData(dayCellStyle: DayCellStyle(selectedColor: Color(0xFF123456))),
      pageViews: 2,
    ),
  ]) {
    testWidgets('the body builds ${c.pageViews} page views ${c.name}', (tester) async {
      await pump(tester, week, components: c.components, theme: c.theme);

      expect(
        find.descendant(of: find.byType(MultiDayBody), matching: find.byType(LinkedPageView)),
        findsNWidgets(c.pageViews),
      );
    });
  }

  testWidgets('a cell takes no pointer events', (tester) async {
    final taps = <String>[];
    await pump(
      tester,
      week,
      components: KalenderComponents(
        multiDayComponents: MultiDayComponents(
          bodyComponents: MultiDayBodyComponents(
            dayCellBuilder: (context, details) =>
                GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => taps.add('cell')),
          ),
        ),
      ),
      callbacks: KalenderCallbacks(onTapped: (date) => taps.add('calendar')),
    );

    await tester.tapAt(tester.getCenter(find.byType(MultiDayBody)));
    await tester.pumpAndSettle();

    expect(taps, ['calendar']);
  });

  testWidgets('the cells rebuild with the height per minute', (tester) async {
    await pump(tester, week, components: components);

    kalenderController.multiDayViewController.heightPerMinute.value = 1.5;
    await tester.pumpAndSettle();

    expect(cells(tester), daysFrom(monday, 7, heightPerMinute: 1.5));
  });

  testWidgets('a cell date is the start of the day in the location', (tester) async {
    tz.initializeTimeZones();
    final location = getLocation('America/New_York');
    await pump(
      tester,
      MultiDayViewConfiguration.week(
        displayRange: displayRange,
        initialDateTime: TZDateTime(location, 2025, 3, 24, 12),
        nowCallback: now,
      ),
      components: components,
      location: location,
    );

    expect(cells(tester), daysFrom(monday, 7, location: location));
  });

  testWidgets('a cell reports whether its day is selected', (tester) async {
    await pump(tester, week, components: components);

    kalenderController.selectRange(KalenderDateTimeRange(start: DateTime(2025, 3, 25), end: DateTime(2025, 3, 27)));
    await tester.pumpAndSettle();
    expect(cells(tester), daysFrom(monday, 7, selected: {25, 26}));

    kalenderController.deselectRange();
    await tester.pumpAndSettle();
    expect(cells(tester), daysFrom(monday, 7));
  });

  testWidgets('a selection change rebuilds only the cells whose state changes', (tester) async {
    final builds = <int, int>{};
    await pump(
      tester,
      week,
      components: KalenderComponents(
        multiDayComponents: MultiDayComponents(
          bodyComponents: MultiDayBodyComponents(
            dayCellBuilder: (context, details) {
              builds.update(details.date.day, (count) => count + 1, ifAbsent: () => 1);
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    final before = Map.of(builds);

    kalenderController.selectDate(DateTime(2025, 3, 25));
    await tester.pumpAndSettle();

    expect(builds, {...before, 25: before[25]! + 1});
  });

  group('with a selection color and no builder', () {
    const color = Color(0xFF123456);
    const theme = KalenderThemeData(dayCellStyle: DayCellStyle(selectedColor: color));
    final tint = find.byWidgetPredicate((widget) => widget is ColoredBox && widget.color == color);

    testWidgets('a selected day is drawn over its column', (tester) async {
      await pump(tester, week, theme: theme);
      expect(tint, findsNothing);

      final day = DateTime(2025, 3, 25);
      kalenderController.selectDate(day);
      await tester.pumpAndSettle();

      expect(tester.getRect(tint), columnRects(tester, [day])[day]);
    });

    testWidgets('a builder draws the selection itself', (tester) async {
      await pump(tester, week, components: components, theme: theme);

      kalenderController.selectDate(DateTime(2025, 3, 25));
      await tester.pumpAndSettle();

      expect(tint, findsNothing);
    });
  });
}
