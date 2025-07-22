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

  for (var scenario in Scenario.values) {
    for (var view in Views.values) {
      group("Profiling", () {
        late TestConfiguration config;
        setUp(() {
          config = TestConfiguration(viewConfiguration: view.viewConfiguration);
          config.eventsController.addEvents(
            TestConfiguration.generate(scenario.eventRanges),
          );
        });

        testWidgets('${scenario.name} Loading', (tester) async {
          config.eventsController.clearEvents();

          await tester.pumpWidget(MyApp(config: config));
          await tester.pumpAndSettle(Duration(seconds: 1));

          // 1. Profile loading events.
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

        testWidgets('${scenario.name} Navigation', (tester) async {
          await tester.pumpWidget(MyApp(config: config));
          await tester.pumpAndSettle(Duration(seconds: 1));

          final current = TestConfiguration.selectedDate;
          config.calendarController.jumpToDate(current);
          await tester.pumpAndSettle(Duration(seconds: 1));

          await binding.traceAction(() async {
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(
              current.copyWith(day: current.day - 7),
            );
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(current);
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(
              current.copyWith(day: current.day + 7),
            );
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(
              current.copyWith(day: current.day + 14),
            );
            await tester.pumpAndSettle(Duration(milliseconds: 250));
            config.calendarController.animateToDate(current);
            await tester.pumpAndSettle(Duration(milliseconds: 250));
          }, reportKey: scenario.getReportKey(view, ReportKeys.navigation));
        });

        testWidgets(
          '${scenario.name} Scrolling MultiDay',
          skip: view != Views.week,
          (tester) async {
            await tester.pumpWidget(MyApp(config: config));
            await tester.pumpAndSettle(Duration(seconds: 1));
            config.calendarController.jumpToDate(
              TestConfiguration.selectedDate,
            );
            await tester.pumpAndSettle(Duration(seconds: 1));

            // 1. Profile loading events.
            final eventBatches = <List<CalendarEvent<Event>>>[];
            for (var range in scenario.eventRanges) {
              final events = TestConfiguration.generate([range]);
              eventBatches.add(events);
            }

            final scrollable = find.descendant(
              of: find.byKey(MultiDayBody.singleChildScrollViewKey),
              matching: find.byType(Scrollable).at(0),
            );
            final startFinder = find.byKey(TimeLine.getTimeKey(1, 0));
            final endFinder = find.byKey(TimeLine.getTimeKey(23, 0));

            // Profile scrolling.
            // This gives a good indication of how scrolling affects performance.
            await binding.traceAction(() async {
              await tester.pumpAndSettle(Duration(milliseconds: 100));
              for (var i = 0; i < 10; i++) {
                await tester.scrollUpAndDown(
                  startTarget: startFinder,
                  endTarget: endFinder,
                  scrollable: scrollable,
                  scrollStep: 1,
                );
                await tester.pump(Duration(milliseconds: 10));
              }
            }, reportKey: scenario.getReportKey(view, ReportKeys.scrolling));
          },
        );
      });
    }
  }
}
