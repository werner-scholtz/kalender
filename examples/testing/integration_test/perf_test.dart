import 'dart:convert';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kalender/kalender.dart';
import 'package:perf_profiling/main.dart';

enum ReportKeys { loadingEvents, navigation, scrolling }

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Week', () {
    testWidgets('Num of events', (WidgetTester tester) async {
      // Initialize the app with a week configuration
      final testConfig = TestConfiguration.week();
      await tester.pumpWidget(MyApp(config: testConfig));
      await tester.pumpAndSettle();

      final events = TestConfiguration.generate([
        TimeOfDayRange(
          start: const TimeOfDay(hour: 22, minute: 0),
          end: const TimeOfDay(hour: 23, minute: 0),
        ),
      ]);

      // Profile loading events.
      await binding.watchPerformance(() async {
        await tester.pumpAndSettle();
        testConfig.eventsController.addEvents(events);
        await tester.pumpAndSettle();
      }, reportKey: ReportKeys.loadingEvents.name);

      // Profile navigation.
      await binding.watchPerformance(() async {
        await tester.pumpAndSettle();
        testConfig.calendarController.animateToDate(TestConfiguration.start);
        await tester.pumpAndSettle();
        testConfig.calendarController.animateToDate(TestConfiguration.end);
        await tester.pumpAndSettle();
        testConfig.calendarController.animateToDate(TestConfiguration.selectedDate);
        await tester.pumpAndSettle();
      }, reportKey: ReportKeys.navigation.name);

      // Identify the scrollable widget.
      final scrollable = find.descendant(
        of: find.byKey(MultiDayBody.singleChildScrollViewKey),
        matching: find.byType(Scrollable).at(0),
      );
      // Verify the Scrollable widget exists
      expect(scrollable, findsOneWidget);

      // Identifiers for the start and end of the scrollable area.
      final startFinder = find.byKey(TimeLine.getTimeKey(1));
      expect(startFinder, findsOneWidget);

      final endFinder = find.byKey(TimeLine.getTimeKey(23));
      expect(endFinder, findsOneWidget);

      // Profile scrolling.
      await binding.watchPerformance(() async {
        await tester.pumpAndSettle(Duration(milliseconds: 100));
        for (var i = 0; i < 10; i++) {
          // Scroll to the start of the scrollable area.
          await tester.scrollUpAndDown(
            startTarget: startFinder,
            endTarget: endFinder,
            scrollable: scrollable,
            scrollStep: 10,
          );
          await tester.pump(Duration(milliseconds: 10));
        }
      }, reportKey: ReportKeys.scrolling.name);

      for (var reportKey in ReportKeys.values) {
        final report = binding.reportData?[reportKey.name];
        if (report == null) {
          print('No performance data for $reportKey');
          continue;
        }
        final prettyJson = const JsonEncoder.withIndent('  ').convert(report);
        print('Performance Results ${reportKey.name}:\n$prettyJson');
      }
    });
  });
}

extension Test on WidgetTester {
  Future<void> desktopScrollUntilVisible({
    required Finder target,
    required Finder scrollable,
    required Offset scrollStep,
    int maxIteration = 100,
    Duration duration = const Duration(milliseconds: 10),
  }) async {
    final testPointer = TestPointer(1, PointerDeviceKind.mouse);
    testPointer.hover(getCenter(scrollable));

    int iteration = 0;
    while (iteration < maxIteration && target.evaluate().isEmpty) {
      await sendEventToBinding(testPointer.scroll(scrollStep));
      await pump(duration);
      iteration++;
    }

    if (target.evaluate().isNotEmpty) {
      await Scrollable.ensureVisible(element(target));
    } else {
      throw StateError('Target widget not found after $iteration scrolls.');
    }
  }

  Future<void> scrollUpAndDown({
    required Finder startTarget,
    required Finder endTarget,
    required Finder scrollable,
    required double scrollStep,
    int maxIteration = 100,
    Duration duration = const Duration(milliseconds: 50),
  }) async {
    await desktopScrollUntilVisible(
      target: startTarget,
      scrollable: scrollable,
      scrollStep: Offset(0, -scrollStep),
      maxIteration: maxIteration,
      duration: duration,
    );

    await pump();

    await desktopScrollUntilVisible(
      target: endTarget,
      scrollable: scrollable,
      scrollStep: Offset(0, scrollStep),
      maxIteration: maxIteration,
      duration: duration,
    );
  }
}
