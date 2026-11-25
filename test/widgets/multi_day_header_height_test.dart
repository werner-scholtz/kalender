// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:material_ui/material_ui.dart';

import '../utilities.dart';

/// The multi-day body keeps its position while header pages are shown for the first time (#675).
void main() {
  final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));
  final start = DateTime(2025, 6, 4);
  final week = MultiDayViewConfiguration.week(displayRange: range, initialDateTime: start);
  final day = MultiDayViewConfiguration.singleDay(displayRange: range, initialDateTime: start);
  const frames = [Duration(milliseconds: 16), Duration(milliseconds: 50)];

  /// Three all-day events on the start day and on the days of the next week and day pages.
  DefaultEventsController eventsController() {
    final controller = DefaultEventsController();
    for (final date in [start, DateTime(2025, 6, 5), DateTime(2025, 6, 11)]) {
      for (var i = 0; i < 3; i++) {
        controller.addEvent(KalenderEvent(start: date, end: date.add(const Duration(days: 1))));
      }
    }
    return controller;
  }

  List<ViewParts> views({required bool showTiles}) => [
    MultiDayViewParts(
      header: MultiDayHeader(configuration: MultiDayHeaderConfiguration(showTiles: showTiles)),
    ),
  ];

  double bodyTop(WidgetTester tester) => tester.getTopLeft(find.byType(MultiDayBody)).dy;

  /// The body's top after each of [count] frames of length [frame].
  Future<List<double>> recordTops(WidgetTester tester, {required int count, required Duration frame}) async {
    final tops = <double>[];
    for (var i = 0; i < count; i++) {
      await tester.pump(frame);
      tops.add(bodyTop(tester));
    }
    return tops;
  }

  for (final frame in frames) {
    final frameName = '${frame.inMilliseconds} ms frames';

    for (final (name, configuration) in [('week', week), ('day', day)]) {
      testWidgets('$name view: the body stays in place after the first frame, $frameName', (tester) async {
        tester.setViewSize(const Size(800, 600));
        final kalenderController = KalenderController(viewConfiguration: configuration);
        await tester.pumpWidget(
          wrapWithMaterialApp(
            KalenderView(
              eventsController: DefaultEventsController(),
              kalenderController: kalenderController,
              views: views(showTiles: false),
            ),
          ),
        );
        await tester.pump();
        final top = bodyTop(tester);

        expect(await recordTops(tester, count: 10, frame: frame), List.filled(10, top));
      });
    }

    for (final (name, configuration, showTiles) in [('week', week, false), ('day', day, true)]) {
      testWidgets('$name view, showTiles $showTiles: the body stays in place on a new page, $frameName', (
        tester,
      ) async {
        tester.setViewSize(const Size(800, 600));
        final kalenderController = KalenderController(viewConfiguration: configuration);
        await pumpKalender(
          tester,
          eventsController: eventsController(),
          kalenderController: kalenderController,
          views: views(showTiles: showTiles),
        );
        final top = bodyTop(tester);

        unawaited(kalenderController.animateToNextPage());
        final count = const Duration(milliseconds: 400).inMicroseconds ~/ frame.inMicroseconds;
        expect(await recordTops(tester, count: count, frame: frame), List.filled(count, top));
      });
    }

    testWidgets('week view: the body stays in place on a new page after going back, $frameName', (tester) async {
      tester.setViewSize(const Size(800, 600));
      final kalenderController = KalenderController(viewConfiguration: week);
      double height(DateTime date) =>
          date.isAfter(DateTime(2025, 6, 8)) && date.isBefore(DateTime(2025, 6, 16)) ? 40 : 100;
      await pumpKalender(
        tester,
        eventsController: DefaultEventsController(),
        kalenderController: kalenderController,
        views: views(showTiles: false),
        components: KalenderComponents(
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(
              dayHeaderBuilder: (context, date) => SizedBox(height: height(date), width: 10),
            ),
          ),
        ),
      );
      final top = bodyTop(tester);
      unawaited(kalenderController.animateToNextPage());
      await tester.pumpAndSettle();
      unawaited(kalenderController.animateToPreviousPage());
      await tester.pumpAndSettle();

      kalenderController.jumpToDate(DateTime(2025, 7, 2));
      expect(await recordTops(tester, count: 8, frame: frame), List.filled(8, top));
    });
  }
}
