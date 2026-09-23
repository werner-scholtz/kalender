// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/main.dart';
import 'package:testing/test_configuration.dart';
import '../test_driver/perf_driver.dart';
import 'utils.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profiling', () {
    for (var run = 1; run <= numberOfRuns; run++) {
      for (var scenario in Scenario.values) {
        for (var view in Views.values) {
          late TestConfiguration config;
          setUp(() {
            config = TestConfiguration(viewConfiguration: view.viewConfiguration);
            config.eventsController.addEvents(TestConfiguration.generate(scenario.eventRanges));
          });

          // 1. Profile loading events.
          testWidgets('${scenario.name} Loading', (tester) async {
            config.eventsController.clearEvents();
            final eventBatches = <List<KalenderEvent>>[];
            for (var range in scenario.eventRanges) {
              final events = TestConfiguration.generate([range]);
              eventBatches.add(events);
            }

            await tester.pumpWidget(MyApp(config: config));
            await tester.pumpAndSettle(Duration(milliseconds: 100));
            await binding.traceAction(() async {
              for (var batch in eventBatches) {
                await tester.pumpAndSettle(Duration(milliseconds: 100));
                config.eventsController.addEvents(batch);
                await tester.pumpAndSettle(Duration(milliseconds: 100));
              }
            }, reportKey: scenario.getReportKey(view, ReportKeys.loadingEvents, run));
            await tester.pumpAndSettle(Duration(milliseconds: 100));
          });

          // 2. Profile page navigation.
          testWidgets('${scenario.name} Navigation', (tester) async {
            await tester.pumpWidget(MyApp(config: config));
            await tester.pumpAndSettle(Duration(milliseconds: 100));

            final current = TestConfiguration.initialDateTime;
            config.kalenderController.jumpToDate(current);
            await tester.pumpAndSettle(Duration(milliseconds: 100));

            await binding.traceAction(() async {
              await tester.pumpAndSettle(Duration(milliseconds: 250));
              config.kalenderController.animateToDate(current.copyWith(day: current.day - 7));
              await tester.pumpAndSettle(Duration(milliseconds: 250));
              config.kalenderController.animateToDate(current);
              await tester.pumpAndSettle(Duration(milliseconds: 250));
              config.kalenderController.animateToDate(current.copyWith(day: current.day + 7));
              await tester.pumpAndSettle(Duration(milliseconds: 250));
              config.kalenderController.animateToDate(current.copyWith(day: current.day + 14));
              await tester.pumpAndSettle(Duration(milliseconds: 250));
              config.kalenderController.animateToDate(current);
              await tester.pumpAndSettle(Duration(milliseconds: 250));
            }, reportKey: scenario.getReportKey(view, ReportKeys.navigation, run));
          });

          // 3. Profile scrolling.
          testWidgets('${scenario.name} Scrolling', skip: view != Views.week, (tester) async {
            await tester.pumpWidget(MyApp(config: config));
            await tester.pumpAndSettle(Duration(milliseconds: 100));
            config.kalenderController.jumpToDate(TestConfiguration.initialDateTime);
            await tester.pumpAndSettle(Duration(milliseconds: 100));

            final scrollable = find.descendant(
              of: find.byKey(MultiDayBody.singleChildScrollViewKey),
              matching: find.byType(Scrollable).at(0),
            );
            final startFinder = find.byKey(TimeLine.getTimeKey(1, 0));
            final endFinder = find.byKey(TimeLine.getTimeKey(23, 0));

            await binding.traceAction(() async {
              await tester.pumpAndSettle(Duration(milliseconds: 100));
              for (var i = 0; i < 10; i++) {
                await tester.scrollUntilVisible(startFinder, 250.0, scrollable: scrollable);
                await tester.pump(Duration(milliseconds: 10));
                await tester.scrollUntilVisible(endFinder, -250.0, scrollable: scrollable);
                await tester.pump(Duration(milliseconds: 10));
              }
            }, reportKey: scenario.getReportKey(view, ReportKeys.scrolling, run));
          });

          // 4. Profile rescheduling.
          testWidgets('${scenario.name} Rescheduling', (tester) async {
            await tester.pumpWidget(MyApp(config: config));
            await tester.pumpAndSettle(Duration(milliseconds: 100));

            final body = calendarBody;
            final center = tester.getCenter(body);
            final topLeft = tester.getTopLeft(body) + const Offset(25, 25);
            final topRight = tester.getTopRight(body) + const Offset(-25, 25);
            final bottomLeft = tester.getBottomLeft(body) + const Offset(25, -25);
            final bottomRight = tester.getBottomRight(body) - const Offset(25, 25);

            final tile = firstTileInside(tileRects(tester, tileTypeOf(view)), pressableArea(tester, view));
            final dragStart = tile.center + const Offset(-2, 0);
            final before = snapshotEvents(config.eventsController);
            final drag = DragProbe(config.kalenderController);

            await binding.traceAction(() async {
              final dragGesture = await tester.startGesture(dragStart, pointer: 1);
              await tester.pump(Duration(milliseconds: 100));
              await performSegmentedDrag(dragGesture, tester, dragStart, topLeft);
              await tester.pumpAndSettle();
              await performSegmentedDrag(dragGesture, tester, topLeft, topRight);
              await tester.pumpAndSettle();
              await performSegmentedDrag(dragGesture, tester, topRight, bottomRight);
              await tester.pumpAndSettle();
              await performSegmentedDrag(dragGesture, tester, bottomRight, bottomLeft);
              await tester.pumpAndSettle();
              await performSegmentedDrag(dragGesture, tester, bottomLeft, center);
              await tester.pumpAndSettle();
              await dragGesture.up();
              await tester.pumpAndSettle(Duration(milliseconds: 100));
            }, reportKey: scenario.getReportKey(view, ReportKeys.rescheduling, run));

            drag.dispose();
            expect(drag.dragged, isTrue, reason: 'No drag started, so the trace measured idle frames.');
            // A schedule drop on the day the event came from changes nothing.
            if (view != Views.schedule) {
              expect(changedEvents(config.eventsController, before), hasLength(1), reason: 'The drop changed nothing.');
            }
          });

          // 5. Profile resizing.
          testWidgets('${scenario.name} Resizing', skip: view == Views.schedule, (tester) async {
            await tester.pumpWidget(MyApp(config: config));
            await tester.pumpAndSettle(Duration(milliseconds: 100));

            final tiles = tileRects(tester, tileTypeOf(view));
            final area = pressableArea(tester, view);
            final (dragStart, dragDelta) = switch (view) {
              Views.week => (endHandleInside(tiles, area, room: 50), const Offset(0, 50)),
              _ => (rightEdgeInside(tiles, area, room: 100), const Offset(100, 0)),
            };
            final before = snapshotEvents(config.eventsController);
            final drag = DragProbe(config.kalenderController);

            // The resize handles show for a hovering mouse. A touch pointer would press the tile and reschedule it.
            final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
            await gesture.addPointer(location: Offset.zero);
            addTearDown(gesture.removePointer);
            await tester.pump();

            await binding.traceAction(() async {
              await gesture.moveTo(dragStart);
              await tester.pumpAndSettle(Duration(milliseconds: 200));
              await gesture.down(dragStart);
              await performSegmentedDrag(gesture, tester, dragStart, dragStart + dragDelta);
              await tester.pumpAndSettle();

              await gesture.up();
              await tester.pumpAndSettle(Duration(milliseconds: 100));
            }, reportKey: scenario.getReportKey(view, ReportKeys.resizing, run));

            drag.dispose();
            expect(drag.dragged, isTrue, reason: 'No drag started, so the trace measured idle frames.');
            final changed = changedEvents(config.eventsController, before);
            expect(changed, hasLength(1), reason: 'The drop changed nothing.');
            final resized = config.eventsController.byId(changed.single)!;
            expect(
              resized.start,
              before[changed.single]!.$1,
              reason: 'The drag moved the event instead of resizing it.',
            );
          });
        }
      }
    }
  });
}
