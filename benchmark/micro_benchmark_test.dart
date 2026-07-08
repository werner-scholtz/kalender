// Micro-benchmarks for kalender's pure-Dart hot paths.
//
// Run with:
//   flutter test benchmark/micro_benchmark_test.dart
//
// Results are written to `build/micro_results.json` in the
// github-action-benchmark `customSmallerIsBetter` format:
//   [ { "name": ..., "unit": "us", "value": ... }, ... ]
//
// These exercise CPU-bound algorithms with no widget tree, so they are far
// less noisy than the frame-profiling suite and are the primary regression
// signal for the library's own code.

import 'dart:convert';
import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter/widgets.dart' show TextDirection;
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import 'fixtures.dart';

/// Sink used to defeat dead-code elimination: every benchmark folds its result
/// in here and we print it at the end so the compiler cannot prove the work is
/// unused.
int _sink = 0;

/// Base class that measures the cost of a single [run] call (in microseconds).
///
/// [BenchmarkBase] defaults `exercise()` to 10 `run()` calls; we override it to
/// a single call so [BenchmarkBase.measure] reports per-`run` microseconds.
abstract class _KalenderBenchmark extends BenchmarkBase {
  _KalenderBenchmark(super.name);

  @override
  void exercise() => run();
}

/// `InternalDateTimeRange.dates()` — linear day expansion, called all over the
/// layout and event-store code.
///
/// A single expansion is sub-microsecond and dominated by timer/JIT noise, so
/// we measure a fixed [_batch] of calls per run. This is also realistic:
/// `dates()` is invoked many times per frame (once per event in several code
/// paths), so a batch reflects the actual per-frame cost.
class _DatesBenchmark extends _KalenderBenchmark {
  _DatesBenchmark(this.days) : super('dates x$_batch / ${days}d');
  static const _batch = 200;
  final int days;
  late InternalDateTimeRange range;

  @override
  void setup() {
    range = InternalDateTimeRange(
      start: benchmarkStart,
      end: benchmarkStart.add(Duration(days: days)),
    );
  }

  @override
  void run() {
    var count = 0;
    for (var i = 0; i < _batch; i++) {
      count ^= range.dates().length;
    }
    _sink ^= count;
  }
}

/// `defaultMultiDayFrameGenerator` — O(N²·D) multi-day event row assignment.
class _MultiDayFrameBenchmark extends _KalenderBenchmark {
  _MultiDayFrameBenchmark(this.eventCount, this.days)
      : super('multiDayFrame / ${eventCount}ev x ${days}d');
  final int eventCount;
  final int days;
  late InternalDateTimeRange range;
  late List<CalendarEvent> events;

  @override
  void setup() {
    range = InternalDateTimeRange(
      start: benchmarkStart,
      end: benchmarkStart.add(Duration(days: days)),
    );
    events = generateMultiDayEvents(start: benchmarkStart, days: days, count: eventCount);
  }

  @override
  void run() {
    final frame = defaultMultiDayFrameGenerator(
      visibleDateTimeRange: range,
      events: events,
      textDirection: TextDirection.ltr,
      location: null,
    );
    _sink ^= frame.hashCode;
  }
}

/// `defaultMultiDayFrameGenerator` with dense single-day events, matching the
/// month/week header layout at a realistic event density (50 events per day).
/// This is the path behind the reported month/week navigation jank.
class _MultiDayFrameDenseBenchmark extends _KalenderBenchmark {
  _MultiDayFrameDenseBenchmark(this.eventsPerDay, this.days)
      : super('multiDayFrame / ${eventsPerDay}ev-per-day x ${days}d');
  final int eventsPerDay;
  final int days;
  late InternalDateTimeRange range;
  late List<CalendarEvent> events;

  @override
  void setup() {
    range = InternalDateTimeRange(
      start: benchmarkStart,
      end: benchmarkStart.add(Duration(days: days)),
    );
    events = generateDayEvents(start: benchmarkStart, days: days, eventsPerDay: eventsPerDay);
  }

  @override
  void run() {
    final frame = defaultMultiDayFrameGenerator(
      visibleDateTimeRange: range,
      events: events,
      textDirection: TextDirection.ltr,
      location: null,
    );
    _sink ^= frame.hashCode;
  }
}

/// `findLongestChain` — DFS overlap-depth used to size side-by-side tiles;
/// flagged in-code as "expensive, use sparingly".
class _LongestChainBenchmark extends _KalenderBenchmark {
  _LongestChainBenchmark(this.count) : super('findLongestChain / ${count}ev');
  final int count;
  late SideBySideLayoutDelegate delegate;
  late List<VerticalLayoutData> data;

  @override
  void setup() {
    delegate = SideBySideLayoutDelegate(
      events: const [],
      heightPerMinute: 1.0,
      date: InternalDateTime(2024, 1, 1),
      location: null,
      timeOfDayRange: TimeOfDayRange.allDay(),
      minimumTileHeight: null,
      layoutCache: EventLayoutDelegateCache(),
    );
    // Staircase overlap: each event overlaps a handful of neighbours, giving a
    // realistic bounded chain depth rather than a pathological fully-dense set.
    data = [
      for (var i = 0; i < count; i++)
        VerticalLayoutData(id: i, top: i * 10.0, bottom: i * 10.0 + 35.0),
    ];
  }

  @override
  void run() => _sink ^= delegate.findLongestChain(data);
}

/// `DefaultEventsController.eventsFromDateTimeRange` — the per-frame event query
/// path (covers `eventIdsFromDateTimeRange` + type filtering). A full year of
/// events is loaded once; the benchmark queries a [queryDays]-day window.
class _EventQueryBenchmark extends _KalenderBenchmark {
  _EventQueryBenchmark(this.queryDays) : super('eventsFromRange / query ${queryDays}d');
  final int queryDays;
  late DefaultEventsController controller;
  late InternalDateTimeRange queryRange;

  @override
  void setup() {
    controller = DefaultEventsController();
    controller.addEvents(generateDayEvents(start: benchmarkStart, days: 365, eventsPerDay: 10));
    queryRange = InternalDateTimeRange(
      start: benchmarkStart,
      end: benchmarkStart.add(Duration(days: queryDays)),
    );
  }

  @override
  void run() => _sink ^= controller.eventsFromDateTimeRange(queryRange).length;
}

void main() {
  test('micro benchmarks', () {
    final benchmarks = <_KalenderBenchmark>[
      _DatesBenchmark(7),
      _DatesBenchmark(30),
      _DatesBenchmark(90),
      _DatesBenchmark(365),
      _MultiDayFrameBenchmark(100, 30),
      _MultiDayFrameBenchmark(300, 30),
      _MultiDayFrameDenseBenchmark(50, 7), // week at 50 events/day
      _MultiDayFrameDenseBenchmark(50, 35), // month at 50 events/day
      _LongestChainBenchmark(60),
      _EventQueryBenchmark(1),
      _EventQueryBenchmark(7),
      _EventQueryBenchmark(30),
    ];

    final results = <Map<String, dynamic>>[];
    for (final benchmark in benchmarks) {
      final microseconds = benchmark.measure();
      results.add({'name': benchmark.name, 'unit': 'us', 'value': microseconds});
      // ignore: avoid_print
      print('${benchmark.name}: ${microseconds.toStringAsFixed(3)} us');
    }

    final output = File('build/micro_results.json');
    output.parent.createSync(recursive: true);
    output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(results));

    // ignore: avoid_print
    print('Wrote ${results.length} results to ${output.path} (sink=$_sink)');
    expect(results, isNotEmpty);
  }, timeout: const Timeout(Duration(minutes: 5)),);
}
