import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/main.dart';
import 'package:testing/test_configuration.dart';
import 'package:testing/tiles.dart';
import '../test_driver/perf_driver.dart';
import 'utils.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (var scenario in Scenario.values) {
    for (var view in Views.values) {
      group("Profiling", () {
        late TestConfiguration config;
        setUp(() {
          config = TestConfiguration(viewConfiguration: view.viewConfiguration);
          config.eventsController.addEvents(TestConfiguration.generate(scenario.eventRanges));
        });

        // 1. Profile loading events.
        testWidgets('${scenario.name} Loading', (tester) async {
          config.eventsController.clearEvents();

          await tester.pumpWidget(MyApp(config: config));
          await tester.pumpAndSettle(Duration(seconds: 1));

          final eventBatches = <List<CalendarEvent<Event>>>[];
          for (var range in scenario.eventRanges) {
            final events = TestConfiguration.generate([range]);
            eventBatches.add(events);
          }

          await binding.traceAction(() async {
            for (var batch in eventBatches) {
              await tester.pumpAndSettle(Duration(milliseconds: 100));
              config.eventsController.addEvents(batch);
            }
          }, reportKey: scenario.getReportKey(view, ReportKeys.loadingEvents));
        });

        // 2. Profile page navigation.
        testWidgets('${scenario.name} Navigation', (tester) async {
          await tester.pumpWidget(MyApp(config: config));
          await tester.pumpAndSettle(Duration(seconds: 1));

          final current = TestConfiguration.selectedDate;
          config.calendarController.jumpToDate(current);
          await tester.pumpAndSettle(Duration(seconds: 1));

          await binding.traceAction(() async {
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(current.copyWith(day: current.day - 7));
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(current);
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(current.copyWith(day: current.day + 7));
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(current.copyWith(day: current.day + 14));
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(current);
            await tester.pumpAndSettle(Duration(milliseconds: 250));
          }, reportKey: scenario.getReportKey(view, ReportKeys.navigation));
        });

        // 3. Profile scrolling.
        testWidgets('${scenario.name} Scrolling', skip: view != Views.week, (tester) async {
          await tester.pumpWidget(MyApp(config: config));
          await tester.pumpAndSettle(Duration(milliseconds: 100));
          config.calendarController.jumpToDate(TestConfiguration.selectedDate);
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
          }, reportKey: scenario.getReportKey(view, ReportKeys.scrolling));
        });

        // 4. Profile rescheduling.
        testWidgets('${scenario.name} Rescheduling', (tester) async {
          await tester.pumpWidget(MyApp(config: config));
          await tester.pumpAndSettle(Duration(seconds: 1));

          final body = find.byType(CalendarBody<Event>);
          final center = tester.getCenter(body);
          final topLeft = tester.getTopLeft(body) + const Offset(25, 25);
          final topRight = tester.getTopRight(body) + const Offset(-25, 25);
          final bottomLeft = tester.getBottomLeft(body) + const Offset(25, -25);
          final bottomRight = tester.getBottomRight(body) - const Offset(25, 25);

          final tileFinder = find.byType(switch (view) {
            Views.week => EventTile,
            Views.month => MultiDayEventTile,
            Views.schedule => MultiDayEventTile,
          }).first;
          final dragStart = tester.getCenter(tileFinder) + const Offset(-2, 0);

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
          }, reportKey: scenario.getReportKey(view, ReportKeys.rescheduling));
        });

        // 5. Profile resizing.
        testWidgets('${scenario.name} Resizing', skip: view == Views.schedule, (tester) async {
          await tester.pumpWidget(MyApp(config: config));
          await tester.pumpAndSettle(Duration(seconds: 1));

          final tileFinder = find.byType(switch (view) {
            Views.week => EventTile,
            Views.month => MultiDayEventTile,
            _ => MultiDayEventTile,
          }).first;

          final size = tester.getSize(tileFinder);
          final dragStart =
              tester.getCenter(tileFinder) +
              switch (view) {
                Views.week => Offset(0, (size.height / 2) - 2),
                Views.month => Offset((size.width / 2) - 2, 0),
                _ => const Offset(0, 0),
              };

          await binding.traceAction(() async {
            final dragGesture = await tester.startGesture(dragStart, pointer: 1);
            await tester.pump(Duration(milliseconds: 100));
            await performSegmentedDrag(
              dragGesture,
              tester,
              dragStart,
              dragStart +
                  switch (view) {
                    Views.week => Offset(0, 50),
                    Views.month => Offset(100, 0),
                    _ => const Offset(0, 0),
                  },
            );
            await tester.pumpAndSettle();

            await dragGesture.up();
            await tester.pumpAndSettle(Duration(milliseconds: 100));
          }, reportKey: scenario.getReportKey(view, ReportKeys.resizing));
        });
      });
    }
  }
}
