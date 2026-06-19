// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

enum Scenario {
  /// Realistic load.
  Ten_Events_Per_Day(10),

  /// Heavy load — where regressions in kalender's own layout/build code surface
  /// above Flutter framework overhead.
  Fifty_Events_Per_Day(50);

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

/// Number of repeats per workload. The summary uses the median across runs, so
/// more runs tightens the estimate against the ~6% run-to-run noise floor
/// measured on shared CI. Raised from 3 → 5.
///
/// Overridable via `KALENDER_PERF_RUNS` to trade precision for speed when
/// running locally.
final numberOfRuns = int.tryParse(Platform.environment['KALENDER_PERF_RUNS'] ?? '') ?? 5;

/// Build-frame metrics we keep as the actionable signal (lower is better).
///
/// Rasterizer metrics are deliberately excluded from the primary signal: under
/// Xvfb/llvmpipe (software rasterization, no GPU) the `missed_rasterizer_budget`
/// counter is pure noise (~50% run-to-run) and `avg_rasterizer_time`, while
/// stable, does not represent real-device GPU performance. The latter is kept
/// only as a clearly-labelled diagnostic in the `extra` field below.
const _buildMetric = 'average_frame_build_time_millis';
const _p90Metric = '90th_percentile_frame_build_time_millis';
const _p99Metric = '99th_percentile_frame_build_time_millis';
const _missedBuildMetric = 'missed_frame_build_budget_count';
const _rasterMetric = 'average_frame_rasterizer_time_millis';

const _trackedMetrics = [_buildMetric, _p90Metric, _p99Metric, _missedBuildMetric, _rasterMetric];

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data == null) {
        print('❌ No profiling data received');
        return;
      }

      // Collect every metric value per base key (scenario-view-workload) across
      // all runs, so we can take a robust median rather than a weighted mean.
      final byBaseKey = <String, Map<String, List<num>>>{};

      for (var run = 1; run <= numberOfRuns; run++) {
        for (final scenario in Scenario.values) {
          for (final view in Views.values) {
            for (final key in ReportKeys.values) {
              final reportKey = scenario.getReportKey(view, key, run);
              final raw = data[reportKey];
              if (raw == null) continue;

              final timeline = driver.Timeline.fromJson(raw as Map<String, dynamic>);
              final summary = driver.TimelineSummary.summarize(timeline);

              // Keep the raw timeline + summary as a debugging artifact.
              await summary.writeTimelineToFile(reportKey, pretty: true, includeSummary: true);

              final base = Scenario.baseKeyFromReportKey(reportKey);
              final metrics = byBaseKey.putIfAbsent(base, () => {});
              for (final metric in _trackedMetrics) {
                final value = summary.summaryJson[metric];
                if (value is num) {
                  metrics.putIfAbsent(metric, () => <num>[]).add(value);
                }
              }
            }
          }
        }
      }

      // Emit github-action-benchmark `customSmallerIsBetter` entries. We chart a
      // single headline series per base key (median average-build-time) to keep
      // the dashboard readable; the remaining metrics ride along in `extra`.
      final results = <Map<String, dynamic>>[];
      for (final entry in byBaseKey.entries) {
        final base = entry.key;
        final metrics = entry.value;

        final buildValues = metrics[_buildMetric];
        if (buildValues == null || buildValues.isEmpty) continue;

        final avgBuild = _median(buildValues);
        final iqr = _iqr(buildValues);

        String fmt(String metric, {String suffix = 'ms', int fraction = 2}) {
          final values = metrics[metric];
          if (values == null || values.isEmpty) return 'n/a';
          final median = _median(values);
          return suffix == 'ms' ? '${median.toStringAsFixed(fraction)}ms' : '${median.round()}';
        }

        final extra = 'p90_build=${fmt(_p90Metric)} '
            'p99_build=${fmt(_p99Metric)} '
            'missed_build=${fmt(_missedBuildMetric, suffix: 'count')} '
            'avg_raster_sw=${fmt(_rasterMetric)} '
            '(runs=${buildValues.length})';

        results.add({
          'name': '$base / avg_build_ms',
          'unit': 'ms',
          'value': avgBuild,
          'range': '± ${iqr.toStringAsFixed(2)}',
          'extra': extra,
        });

        print('✅ $base  avg_build=${avgBuild.toStringAsFixed(2)}ms (±${iqr.toStringAsFixed(2)})  $extra');
      }

      final output = File('build/frame_results.json');
      output.parent.createSync(recursive: true);
      output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(results));
      print('\nWrote ${results.length} frame results to ${output.path}');
    },
  );
}

/// Median of [values] (non-mutating).
double _median(List<num> values) {
  final sorted = [...values]..sort();
  final n = sorted.length;
  if (n == 0) return 0;
  final mid = n ~/ 2;
  return n.isOdd ? sorted[mid].toDouble() : (sorted[mid - 1] + sorted[mid]) / 2;
}

/// Interquartile range (Q3 − Q1) of [values], a robust spread estimate.
double _iqr(List<num> values) {
  final sorted = [...values]..sort();
  if (sorted.length < 2) return 0;

  double quantile(double p) {
    final index = p * (sorted.length - 1);
    final lo = index.floor();
    final hi = index.ceil();
    if (lo == hi) return sorted[lo].toDouble();
    return sorted[lo] + (sorted[hi] - sorted[lo]) * (index - lo);
  }

  return quantile(0.75) - quantile(0.25);
}
