// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// #472: timeline labels are positioned by the segments before them. The last segment is shorter than the rest unless
// the range divides evenly, which KalenderTimeRange.allDay does.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
  });

  tearDown(() {
    eventsController.dispose();
    kalenderController.dispose();
  });

  Future<void> pumpDay(WidgetTester tester, KalenderTimeRange timeOfDayRange) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(
          displayRange: year2025DisplayRange,
          timeOfDayRange: timeOfDayRange,
          initialTimeOfDay: timeOfDayRange.start,
          initialDateTime: DateTime(2025),
        ),
        body: KalenderBody(
          multiDayTileComponents: TileComponents(tileBuilder: (context, event, range) => const SizedBox()),
        ),
      ),
    );
  }

  /// The vertical position of every timeline label, in the order it is drawn.
  List<double> labelPositions(WidgetTester tester) {
    final positions = <double>[];
    for (var hour = 0; hour < KalenderTime.hoursPerDay; hour++) {
      for (var minute = 0; minute < KalenderTime.minutesPerHour; minute += 5) {
        final finder = find.byKey(TimeLine.getTimeKey(hour, minute));
        if (finder.evaluate().isEmpty) continue;
        positions.add(tester.getTopLeft(finder).dy);
      }
    }
    return positions;
  }

  /// Asserts the labels run down the timeline in order, evenly spaced.
  void expectEvenlySpaced(WidgetTester tester) {
    final positions = labelPositions(tester);
    expect(positions.length, greaterThan(2), reason: 'the range should show several labels');

    final spacing = positions[1] - positions[0];
    expect(spacing, greaterThan(0), reason: 'the labels run down the timeline');
    for (var i = 1; i < positions.length; i++) {
      expect(
        positions[i] - positions[i - 1],
        moreOrLessEquals(spacing, epsilon: 0.5),
        reason: 'label $i sits one segment below the one before it',
      );
    }
  }

  testWidgets('the all day range labels are evenly spaced', (tester) async {
    await pumpDay(tester, KalenderTimeRange.allDay());
    expectEvenlySpaced(tester);
  });

  final shortLastSegmentCases = [
    // 09:00 to 18:00 leaves a one minute segment at the end.
    (name: 'a range ending on a segment boundary', end: const KalenderTime(hour: 18, minute: 0)),
    // 09:00 to 17:30 leaves a 31 minute segment at the end.
    (name: 'a range ending part way through a segment', end: const KalenderTime(hour: 17, minute: 30)),
  ];

  for (final (:name, :end) in shortLastSegmentCases) {
    testWidgets('$name labels its last segment in place', (tester) async {
      await pumpDay(tester, KalenderTimeRange(start: const KalenderTime(hour: 9, minute: 0), end: end));
      expectEvenlySpaced(tester);
    });
  }

  testWidgets('the labels line up with the hour lines', (tester) async {
    final range = KalenderTimeRange(
      start: const KalenderTime(hour: 9, minute: 0),
      end: const KalenderTime(hour: 18, minute: 0),
    );
    await pumpDay(tester, range);

    final content = tester.getRect(find.byType(HourLines));
    final positions = labelPositions(tester);
    final spacing = positions[1] - positions[0];

    // The last label marks the end of the range, one segment below the one
    // before it and within the drawn area.
    expect(positions.last - positions[positions.length - 2], moreOrLessEquals(spacing, epsilon: 0.5));
    expect(positions.last, lessThan(content.bottom));
  });
}
