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

  String getReportKey(Views view, ReportKeys key) =>
      '${name.toLowerCase()}-${view.name}-${key.name}';
}

enum ReportKeys { loadingEvents, navigation, scrolling, rescheduling, resizing }

enum Views { week, month, schedule }


Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      final summary = <String, dynamic>{};

      if (data != null) {
        final keys = [
          for (final scenario in Scenario.values)
            for (var view in Views.values)
              for (var key in ReportKeys.values) scenario.getReportKey(view, key),
        ];

        print('\n=== Performance Profiling Summary ===');
        print('Total expected reports: ${keys.length}');
        print('Available data keys: ${data.keys.length}');
        print('\nProcessing reports...\n');

        for (final key in keys) {
          print('Processing: $key');
          if (!data.containsKey(key)) continue;
          
          final timeline = driver.Timeline.fromJson(data[key] as Map<String, dynamic>);
          final timelineSummary = driver.TimelineSummary.summarize(timeline);

          // Extract key metrics
          final frameCount = timeline.events?.length ?? 0;

          await timelineSummary.writeTimelineToFile(key, pretty: true, includeSummary: true);

          final metricsStr =
              '\n- Avg Build: ${timelineSummary.summaryJson['average_frame_build_time_millis']}ms'
              '\n- 99th Build: ${timelineSummary.summaryJson['99th_percentile_frame_build_time_millis']}ms'
              '\n- Avg Raster: ${timelineSummary.summaryJson['average_frame_rasterizer_time_millis']}\n';

          summary[key] = {
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

          print('✅ Processed: $key ($frameCount events)$metricsStr');
        }

        final summaryFile = File('performance_summary.json');
        const encoder = JsonEncoder.withIndent('  ');
        await summaryFile.writeAsString(encoder.convert(summary));
      } else {
        print('❌ No profiling data received');
      }
    },
  );
}