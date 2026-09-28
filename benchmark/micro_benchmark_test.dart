// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// Micro-benchmarks for kalender's pure-Dart code paths, run with `flutter test benchmark/micro_benchmark_test.dart`.
// Results go to `build/micro_results.json` in the github-action-benchmark `customSmallerIsBetter` format.

import 'dart:convert';
import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter/widgets.dart' show TextDirection;
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import 'fixtures.dart';

/// Every benchmark folds its result in here and the total is printed, so the compiler keeps the work.
int _sink = 0;

/// Measures one [run] call in microseconds. [BenchmarkBase.exercise] runs [run] ten times by default.
abstract class _KalenderBenchmark extends BenchmarkBase {
  _KalenderBenchmark(super.name);

  @override
  void exercise() => run();
}

/// `FloatingDateTimeRange.dates()` over [days] days, called [_batch] times per run. One call is below the timer's
/// resolution.
class _DatesBenchmark extends _KalenderBenchmark {
  _DatesBenchmark(this.days) : super('Date expansion · $days days (x$_batch)');
  static const _batch = 200;
  final int days;
  late FloatingDateTimeRange range;

  @override
  void setup() {
    range = FloatingDateTimeRange(
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

/// `defaultMultiDayFrameGenerator`, which assigns multi-day events to rows.
class _MultiDayFrameBenchmark extends _KalenderBenchmark {
  _MultiDayFrameBenchmark(this.eventCount, this.days) : super('Multi-day layout · $eventCount events over $days days');
  final int eventCount;
  final int days;
  late FloatingDateTimeRange range;
  late List<KalenderEvent> events;

  @override
  void setup() {
    range = FloatingDateTimeRange(
      start: benchmarkStart,
      end: benchmarkStart.add(Duration(days: days)),
    );
    events = generateMultiDayEvents(start: benchmarkStart, days: days, count: eventCount);
  }

  @override
  void run() {
    final frame = defaultMultiDayFrameGenerator(
      visibleRange: range,
      events: events,
      textDirection: TextDirection.ltr,
      location: null,
    );
    _sink ^= frame.hashCode;
  }
}

/// `defaultMultiDayFrameGenerator` with [eventsPerDay] single-day events per day, as in the week and month headers.
class _MultiDayFrameDenseBenchmark extends _KalenderBenchmark {
  _MultiDayFrameDenseBenchmark(this.eventsPerDay, this.days)
    : super('Multi-day layout · $eventsPerDay events/day over $days days');
  final int eventsPerDay;
  final int days;
  late FloatingDateTimeRange range;
  late List<KalenderEvent> events;

  @override
  void setup() {
    range = FloatingDateTimeRange(
      start: benchmarkStart,
      end: benchmarkStart.add(Duration(days: days)),
    );
    events = generateDayEvents(start: benchmarkStart, days: days, eventsPerDay: eventsPerDay);
  }

  @override
  void run() {
    final frame = defaultMultiDayFrameGenerator(
      visibleRange: range,
      events: events,
      textDirection: TextDirection.ltr,
      location: null,
    );
    _sink ^= frame.hashCode;
  }
}

/// `SideBySideLayoutDelegate.findLongestChain`, the overlap depth that sizes side-by-side tiles.
class _LongestChainBenchmark extends _KalenderBenchmark {
  _LongestChainBenchmark(this.count) : super('Overlap depth · $count events');
  final int count;
  late SideBySideLayoutDelegate delegate;
  late List<VerticalLayoutData> data;

  @override
  void setup() {
    delegate = SideBySideLayoutDelegate(
      events: const [],
      heightPerMinute: 1.0,
      date: FloatingDateTime(2024, 1, 1),
      location: null,
      timeOfDayRange: KalenderTimeRange.allDay(),
      minimumTileHeight: null,
      layoutCache: EventLayoutDelegateCache(),
    );
    // Each event overlaps the next few, so the chain depth stays bounded.
    data = [for (var i = 0; i < count; i++) VerticalLayoutData(id: i, top: i * 10.0, bottom: i * 10.0 + 35.0)];
  }

  @override
  void run() => _sink ^= delegate.findLongestChain(data);
}

/// `DefaultEventsController.eventsInRange` over [queryDays] days of a year with 10 events per day.
class _EventQueryBenchmark extends _KalenderBenchmark {
  _EventQueryBenchmark(this.queryDays) : super('Event query · $queryDays ${queryDays == 1 ? 'day' : 'days'}');
  final int queryDays;
  late DefaultEventsController controller;
  late FloatingDateTimeRange queryRange;

  @override
  void setup() {
    controller = DefaultEventsController();
    controller.addEvents(generateDayEvents(start: benchmarkStart, days: 365, eventsPerDay: 10));
    queryRange = FloatingDateTimeRange(
      start: benchmarkStart,
      end: benchmarkStart.add(Duration(days: queryDays)),
    );
  }

  @override
  void run() => _sink ^= controller.eventsInRange(multiDayRule: kDefaultMultiDayRule, queryRange).length;
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
  }, timeout: const Timeout(Duration(minutes: 5)));
}
