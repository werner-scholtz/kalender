// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/main.dart';
import 'package:testing/test_configuration.dart';

import 'utils.dart';

enum ReportKeys { loadingEvents, navigation, scrolling }

/// Test scenario configuration.
class TestScenario {
  final String name;
  final List<TimeOfDayRange> eventRanges;

  const TestScenario({required this.name, required this.eventRanges});
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Week', () {
    final testConfig = TestConfiguration.week();
    final List<Map<String, dynamic>> allResults = [];

    // Define test scenarios with different event loads
    final scenarios = [
      TestScenario(name: '1 event per day', eventRanges: timeOfDayRanges.take(1).toList()),
      TestScenario(name: '5 events per day', eventRanges: timeOfDayRanges.take(5).toList()),
      TestScenario(name: '15 events per day', eventRanges: timeOfDayRanges.take(15).toList()),
    ];

    // Run tests for each scenario
    for (final scenario in scenarios) {
      testWidgets('Test with ${scenario.name}', (WidgetTester tester) async {
        final results = await _profileTest(
          tester: tester,
          binding: binding,
          testConfig: testConfig,
          scenario: scenario,
        );

        allResults.add({'scenario': scenario.name, 'results': results});
      });
    }

    // Print comparison table after all tests
    tearDownAll(() {
      _printComparisonTable(allResults);
      _writeJsonResults(allResults);
    });
  });
}

/// Runs a performance test with the given scenario.
Future<Map<String, Map<String, dynamic>>> _profileTest({
  required WidgetTester tester,
  required IntegrationTestWidgetsFlutterBinding binding,
  required TestConfiguration testConfig,
  required TestScenario scenario,
}) async {
  print('Running performance test: ${scenario.name}');

  await tester.pumpWidget(MyApp(config: testConfig));
  await tester.pumpAndSettle();

  testConfig.eventsController.clearEvents();
  await tester.pumpAndSettle();

  final current = TestConfiguration.selectedDate;
  testConfig.calendarController.animateToDate(current);
  await tester.pumpAndSettle(Duration(milliseconds: 100));

  final eventBatches = <List<CalendarEvent<Event>>>[];
  for (var range in scenario.eventRanges) {
    final events = TestConfiguration.generate([range]);
    eventBatches.add(events);
  }

  // Profile adding events.
  // This gives a good indication of how adding events affects performance.
  await tester.profile(
    binding: binding,
    test: () async {
      for (var batch in eventBatches) {
        await tester.pumpAndSettle(Duration(milliseconds: 100));
        testConfig.eventsController.addEvents(batch);
      }
    },
    reportKey: ReportKeys.loadingEvents.name,
  );

  // Profile navigation.
  // This gives a good indication of how navigation affects performance.
  await tester.profile(
    binding: binding,
    test: () async {
      await tester.pumpAndSettle(Duration(milliseconds: 250));
      testConfig.calendarController.animateToDate(current.copyWith(day: current.day - 7));
      await tester.pumpAndSettle(Duration(milliseconds: 250));
      testConfig.calendarController.animateToDate(current);
      await tester.pumpAndSettle(Duration(milliseconds: 250));
      testConfig.calendarController.animateToDate(current.copyWith(day: current.day + 7));
      await tester.pumpAndSettle(Duration(milliseconds: 250));
      testConfig.calendarController.animateToDate(current.copyWith(day: current.day + 14));
      await tester.pumpAndSettle(Duration(milliseconds: 250));
      testConfig.calendarController.animateToDate(current);
      await tester.pumpAndSettle(Duration(milliseconds: 250));
    },
    reportKey: ReportKeys.navigation.name,
  );

  final scrollable = find.descendant(
    of: find.byKey(MultiDayBody.singleChildScrollViewKey),
    matching: find.byType(Scrollable).at(0),
  );
  final startFinder = find.byKey(TimeLine.getTimeKey(1));
  final endFinder = find.byKey(TimeLine.getTimeKey(23));

  // Profile scrolling.
  // This gives a good indication of how scrolling affects performance.
  await tester.profile(
    binding: binding,
    test: () async {
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
    },
    reportKey: ReportKeys.scrolling.name,
  );

  final results = <String, Map<String, dynamic>>{};
  for (var reportKey in ReportKeys.values) {
    final report = binding.reportData?[reportKey.name];
    if (report != null) {
      results[reportKey.name] = Map<String, dynamic>.from(report);
    }
  }

  return results;
}

void _printComparisonTable(List<Map<String, dynamic>> allResults) {
  if (allResults.isEmpty) return;

  print('\n${'=' * 120}');
  print('PERFORMANCE COMPARISON TABLE');
  print('=' * 120);

  // Print header
  final header =
      'Scenario'.padRight(20) +
      'Test'.padRight(15) +
      'Frames'.padRight(10) +
      'Avg Build (ms)'.padRight(15) +
      '99th Build (ms)'.padRight(15) +
      'Missed Frames'.padRight(15) +
      'GC (N/O)'.padRight(12) +
      'Avg Raster (ms)';
  print(header);
  print('-' * 120);

  // Print data for each scenario
  for (final result in allResults) {
    final scenario = result['scenario'] as String;
    final results = result['results'] as Map<String, Map<String, dynamic>>;

    for (final reportKey in ReportKeys.values) {
      final report = results[reportKey.name];
      if (report == null) continue;

      final row =
          scenario.padRight(20) +
          reportKey.name.padRight(15) +
          '${report['frame_count'] ?? 0}'.padRight(10) +
          '${report['average_frame_build_time_millis']?.toStringAsFixed(2) ?? 'N/A'}'.padRight(15) +
          '${report['99th_percentile_frame_build_time_millis']?.toStringAsFixed(2) ?? 'N/A'}'
              .padRight(15) +
          '${report['missed_frame_build_budget_count'] ?? 0}'.padRight(15) +
          '${report['new_gen_gc_count'] ?? 0}/${report['old_gen_gc_count'] ?? 0}'.padRight(12) +
          '${report['average_frame_rasterizer_time_millis']?.toStringAsFixed(2) ?? 'N/A'}';
      print(row);
    }
    print('-' * 120);
  }
}

void _writeJsonResults(List<Map<String, dynamic>> allResults) {
  final jsonResults = {
    'timestamp': DateTime.now().toIso8601String(),
    'results': allResults,
    'summary': _generateSummary(allResults),
  };

  try {
    final file = File('performance_results.json');
    file.createSync();
    file.writeAsStringSync(jsonEncoder.convert(jsonResults));
    print('\nResults written to: ${file.absolute.path}');
    
    // Also create a summary file for CI
    final summaryFile = File('performance_summary.json');
    summaryFile.writeAsStringSync(jsonEncoder.convert(jsonResults['summary']));
  } catch (e) {
    print('Error writing results: $e');
  }
}

Map<String, dynamic> _generateSummary(List<Map<String, dynamic>> allResults) {
  final summary = <String, dynamic>{};
  
  for (final result in allResults) {
    final scenario = result['scenario'] as String;
    final results = result['results'] as Map<String, Map<String, dynamic>>;
    
    summary[scenario] = {};
    for (final reportKey in ReportKeys.values) {
      final report = results[reportKey.name];
      if (report != null) {
        summary[scenario][reportKey.name] = {
          'avg_build_time': report['average_frame_build_time_millis'],
          'missed_frames': report['missed_frame_build_budget_count'],
          'frame_count': report['frame_count'],
        };
      }
    }
  }
  
  return summary;
}

final jsonEncoder = JsonEncoder.withIndent('  ');
