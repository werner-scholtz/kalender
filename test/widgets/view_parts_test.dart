// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Which [ViewParts] a [KalenderView] shows, and what it builds from them.
void main() {
  final week = MultiDayViewConfiguration.week(displayRange: year2025DisplayRange);
  final day = MultiDayViewConfiguration.singleDay(displayRange: year2025DisplayRange);
  final month = MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange);
  final schedule = ScheduleViewConfiguration.continuous(displayRange: year2025DisplayRange);

  late DefaultEventsController eventsController;
  setUp(() => eventsController = DefaultEventsController());
  tearDown(() => eventsController.dispose());

  Future<KalenderController> pump(
    WidgetTester tester,
    ViewConfiguration configuration, {
    List<ViewParts>? views,
  }) async {
    final kalenderController = KalenderController(viewConfiguration: configuration);
    addTearDown(kalenderController.dispose);
    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      views: views,
    );
    return kalenderController;
  }

  group('the default views', () {
    for (final (configuration, header, body) in [
      (week, MultiDayHeader, MultiDayBody),
      (month, MonthHeader, MonthBody),
      (schedule, null, ScheduleBody),
    ]) {
      testWidgets('show the built-in widgets of ${configuration.name}', (tester) async {
        await pump(tester, configuration);
        expect(
          (header == null ? null : find.byType(header).evaluate().length, find.byType(body).evaluate().length),
          (header == null ? null : 1, 1),
        );
      });
    }
  });

  testWidgets('SizedBox.shrink shows no header and a null body the built-in one', (tester) async {
    await pump(tester, week, views: const [MultiDayViewParts(header: SizedBox.shrink())]);
    expect((find.byType(MultiDayHeader).evaluate().length, find.byType(MultiDayBody).evaluate().length), (0, 1));
  });

  group('picking the parts', () {
    for (final c in [
      (
        name: 'named parts win over unnamed ones',
        views: const <ViewParts>[
          MultiDayViewParts(body: Text('any')),
          MultiDayViewParts(name: 'Day', body: Text('day')),
        ],
        shown: 'day',
        printed: 0,
      ),
      (
        name: 'unnamed parts show a configuration no named parts accept',
        views: const <ViewParts>[
          MultiDayViewParts(name: 'Week', body: Text('week')),
          MultiDayViewParts(body: Text('any')),
        ],
        shown: 'any',
        printed: 0,
      ),
      (
        name: 'of two unnamed parts the first shows and one message is printed',
        views: const <ViewParts>[
          MultiDayViewParts(body: Text('first')),
          MultiDayViewParts(body: Text('second')),
        ],
        shown: 'first',
        printed: 1,
      ),
      (
        name: 'of two parts with one name the first shows and one message is printed',
        views: const <ViewParts>[
          MultiDayViewParts(name: 'Day', body: Text('first')),
          MultiDayViewParts(name: 'Day', body: Text('second')),
        ],
        shown: 'first',
        printed: 1,
      ),
    ]) {
      testWidgets(c.name, (tester) async {
        final printed = await collectPrints(() async {
          await pump(tester, day, views: c.views);
          tester.element(find.byType(KalenderView)).markNeedsBuild();
          await tester.pump();
        });

        expect((find.text(c.shown).evaluate().length, printed.length), (1, c.printed));
      });
    }
  });

  testWidgets('a configuration no parts accept fails an assertion', (tester) async {
    final kalenderController = KalenderController(viewConfiguration: week);
    addTearDown(kalenderController.dispose);
    await tester.pumpWidget(
      wrapWithMaterialApp(
        KalenderView(
          eventsController: eventsController,
          kalenderController: kalenderController,
          views: const [MonthViewParts()],
        ),
      ),
    );
    expect(
      tester.takeException(),
      isA<AssertionError>().having(
        (error) => error.message,
        'message',
        contains('MultiDayViewConfiguration named "Week"'),
      ),
    );
  });

  testWidgets('a header shared by every view keeps its state across views', (tester) async {
    final kalenderController = await pump(
      tester,
      week,
      views: const [
        MultiDayViewParts(header: _Counter()),
        MonthViewParts(header: _Counter()),
        ScheduleViewParts(header: _Counter()),
      ],
    );
    await tester.tap(find.byType(_Counter));
    await tester.pumpAndSettle();

    for (final configuration in [schedule, month, week]) {
      kalenderController.viewConfiguration = configuration;
      await tester.pumpAndSettle();
    }

    expect(tester.widget<Text>(find.byKey(const ValueKey('count'))).data, '1');
  });
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var _count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _count++),
      child: SizedBox(height: 40, child: Text('$_count', key: const ValueKey('count'))),
    );
  }
}
