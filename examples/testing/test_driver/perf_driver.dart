// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

enum Scenario {
  scenario1(10);
  // scenario2(20);

  const Scenario(this.numberOfEvents);
  final int numberOfEvents;

  String getReportKey(Views view, ReportKeys key) =>
      '${name.toLowerCase()}-${view.name}-${key.name}';
}

enum ReportKeys { loadingEvents, navigation, scrolling }

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
          if (!data.containsKey(key)) {
            continue;
          }

          final timeline = driver.Timeline.fromJson(data[key] as Map<String, dynamic>);
          final timelineSummary = driver.TimelineSummary.summarize(timeline);

          // Extract key metrics
          final frameCount = timeline.events?.length ?? 0;

          await timelineSummary.writeTimelineToFile(key, pretty: true, includeSummary: true);

          final metricsStr =
              '\n- Avg Build: ${timelineSummary.summaryJson['average_frame_build_time_millis']}ms'
              '\n- 99th Build: ${timelineSummary.summaryJson['99th_percentile_frame_build_time_millis']}ms'
              '\n- Avg Raster: ${timelineSummary.summaryJson['average_frame_rasterizer_time_millis']}\n';

          summary[key] = timelineSummary.summaryJson;

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
