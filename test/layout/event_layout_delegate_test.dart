// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  final date = DateTime(2025);
  final floatingDate = FloatingDateTime.fromDateTime(date);

  // Events 0 and 1 share the boundary minute 01:30 and events 2 and 3 are back-to-back hours. None of them overlap,
  // so every strategy renders each tile at full width.
  final events = [
    KalenderEvent(start: date.copyWith(hour: 1, minute: 29), end: date.copyWith(hour: 1, minute: 30)),
    KalenderEvent(
      start: date.copyWith(hour: 1, minute: 30),
      end: date.copyWith(hour: 1, minute: 59, second: 59, microsecond: 999999),
    ),
    KalenderEvent(start: date.copyWith(hour: 2), end: date.copyWith(hour: 3)),
    KalenderEvent(start: date.copyWith(hour: 3), end: date.copyWith(hour: 4)),
  ];

  final heightPerMinutes = List.generate(100, (i) => 0.1 + i / 100);
  const containerWidth = 400.0;
  const containerHeight = 800.0;

  Key getKey(int index) => Key('event_$index');

  Widget buildLayout(EventLayoutDelegate delegate) {
    return wrapWithMaterialApp(
      SizedBox(
        width: containerWidth,
        height: containerHeight,
        child: CustomMultiChildLayout(
          delegate: delegate,
          children: List.generate(
            events.length,
            (index) => LayoutId(
              key: getKey(index),
              id: index,
              child: Container(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }

  void expectAllTilesRendered(WidgetTester tester) {
    for (var i = 0; i < events.length; i++) {
      final finder = find.byKey(getKey(i));
      expect(finder, findsOneWidget, reason: 'event $i should be rendered');

      final size = tester.getSize(finder);
      expect(size.width, containerWidth, reason: 'event $i width');

      final topLeft = tester.getTopLeft(finder);
      expect(topLeft.dy, greaterThanOrEqualTo(0), reason: 'event $i top should be within container');
      expect(
        topLeft.dy + size.height,
        lessThanOrEqualTo(containerHeight),
        reason: 'event $i bottom should be within container',
      );
    }
  }

  const strategies = [
    ('OverlapLayoutStrategy', EventLayoutStrategy.overlap()),
    ('SideBySideLayoutStrategy', EventLayoutStrategy.sideBySide()),
  ];

  for (final (name, strategy) in strategies) {
    group(name, () {
      for (final heightPerMinute in heightPerMinutes) {
        testWidgets('height per minute $heightPerMinute', (tester) async {
          await tester.pumpWidget(
            buildLayout(
              strategy.createDelegate(
                events: events,
                date: floatingDate,
                timeOfDayRange: KalenderTimeRange.allDay(),
                heightPerMinute: heightPerMinute,
                minimumTileHeight: null,
                cache: null,
                location: null,
              ),
            ),
          );
          await tester.pumpAndSettle();
          expectAllTilesRendered(tester);
        });
      }
    });
  }
}
