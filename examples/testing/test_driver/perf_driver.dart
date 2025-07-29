// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

enum Scenario {
  One_Event_Per_Day(1),
  Ten_Events_Per_Day(10);

  const Scenario(this.numberOfEvents);
  final int numberOfEvents;

  String getReportKey(Views view, ReportKeys key, int run) =>
      '${name.toLowerCase()}-${view.name}-${key.name}-$run';

  static String baseKeyFromReportKey(String key) {
    return key.split('-').take(3).join('-');
  }
}

enum ReportKeys { loadingEvents, navigation, scrolling, rescheduling, resizing }

enum Views { week, month, schedule }

const numberOfRuns = 3;

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        final average = {};

        final keys = [
          for (var run = 1; run <= numberOfRuns; run++)
            for (final scenario in Scenario.values)
              for (var view in Views.values)
                for (var key in ReportKeys.values) scenario.getReportKey(view, key, run),
        ];

        print('\n=== Performance Profiling Summary ===');
        print('Total expected reports: ${keys.length}');
        print('Available data keys: ${data.keys.length}');
        print('\nProcessing reports...\n');

        for (final key in keys) {
          print('Processing: $key');
          if (!data.containsKey(key) || data[key] == null) {
            print('❌ Missing data for key: $key');
            continue;
          }

          print((data[key] as Map<String, dynamic>).length);

          final timeline = driver.Timeline.fromJson(data[key] as Map<String, dynamic>);
          final timelineSummary = driver.TimelineSummary.summarize(timeline);
          final frameCount = timeline.events?.length ?? 0;
          await timelineSummary.writeTimelineToFile(key, pretty: true, includeSummary: true);
          final metricsStr =
              '\n- Avg Build: ${timelineSummary.summaryJson['average_frame_build_time_millis']}ms'
              '\n- 90th Build: ${timelineSummary.summaryJson['90th_percentile_frame_build_time_millis']}ms'
              '\n- 99th Build: ${timelineSummary.summaryJson['99th_percentile_frame_build_time_millis']}ms'
              '\n- Worst Build: ${timelineSummary.summaryJson['worst_frame_build_time_millis']}ms'
              '\n- Missed Build Budget: ${timelineSummary.summaryJson['missed_frame_build_budget_count']}'
              '\n- Avg Rasterizer: ${timelineSummary.summaryJson['average_frame_rasterizer_time_millis']}ms'
              '\n- 90th Rasterizer: ${timelineSummary.summaryJson['90th_percentile_frame_rasterizer_time_millis']}ms'
              '\n- 99th Rasterizer: ${timelineSummary.summaryJson['99th_percentile_frame_rasterizer_time_millis']}ms'
              '\n- Worst Rasterizer: ${timelineSummary.summaryJson['worst_frame_rasterizer_time_millis']}ms'
              '\n- Missed Rasterizer Budget: ${timelineSummary.summaryJson['missed_frame_rasterizer_budget_count']}'
              '\n- Frame Count: ${timelineSummary.summaryJson['frame_count']}'
              '\n- Rasterizer Count: ${timelineSummary.summaryJson['frame_rasterizer_count']}'
              '\n- New Gen GC Count: ${timelineSummary.summaryJson['new_gen_gc_count']}'
              '\n- Old Gen GC Count: ${timelineSummary.summaryJson['old_gen_gc_count']}';

          final summary = {
            'average_frame_build_time_millis':
                timelineSummary.summaryJson['average_frame_build_time_millis'],
            '90th_percentile_frame_build_time_millis':
                timelineSummary.summaryJson['90th_percentile_frame_build_time_millis'],
            '99th_percentile_frame_build_time_millis':
                timelineSummary.summaryJson['99th_percentile_frame_build_time_millis'],
            'worst_frame_build_time_millis':
                timelineSummary.summaryJson['worst_frame_build_time_millis'],
            'missed_frame_build_budget_count':
                timelineSummary.summaryJson['missed_frame_build_budget_count'],
            'average_frame_rasterizer_time_millis':
                timelineSummary.summaryJson['average_frame_rasterizer_time_millis'],
            'stddev_frame_rasterizer_time_millis':
                timelineSummary.summaryJson['stddev_frame_rasterizer_time_millis'],
            '90th_percentile_frame_rasterizer_time_millis':
                timelineSummary.summaryJson['90th_percentile_frame_rasterizer_time_millis'],
            '99th_percentile_frame_rasterizer_time_millis':
                timelineSummary.summaryJson['99th_percentile_frame_rasterizer_time_millis'],
            'worst_frame_rasterizer_time_millis':
                timelineSummary.summaryJson['worst_frame_rasterizer_time_millis'],
            'missed_frame_rasterizer_budget_count':
                timelineSummary.summaryJson['missed_frame_rasterizer_budget_count'],
            'frame_count': timelineSummary.summaryJson['frame_count'],
            'frame_rasterizer_count': timelineSummary.summaryJson['frame_rasterizer_count'],
            'new_gen_gc_count': timelineSummary.summaryJson['new_gen_gc_count'],
            'old_gen_gc_count': timelineSummary.summaryJson['old_gen_gc_count'],
          };

          final baseKey = Scenario.baseKeyFromReportKey(key);
          var current = average[baseKey];

          if (current != null) {
            current = _calculateAverage(current, summary);
          } else {
            current = summary;
          }

          average[baseKey] = current;

          print('✅ Processed: $key ($frameCount events)$metricsStr');
        }

        final summaryFile = File('performance_summary.json');
        const encoder = JsonEncoder.withIndent('  ');
        await summaryFile.writeAsString(encoder.convert(average));
      } else {
        print('❌ No profiling data received');
      }
    },
  );
}

Map<String, dynamic> _calculateAverage(Map<String, dynamic> a, Map<String, dynamic> b) {
  final result = <String, dynamic>{};
  a.forEach((key, value) {
    if (b.containsKey(key) && value is num && b[key] is num) {
      result[key] = (value + b[key]) / 2;
    }
  });
  return result;
}
