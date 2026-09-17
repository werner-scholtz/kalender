// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';

/// Dart's list sort is insertion sort up to 32 elements and quicksort above, so
/// the order has to hold on both sides of that size.
void main() {
  OverlapLayoutDelegate delegateFor(List<KalenderEvent> events) {
    return OverlapLayoutDelegate(
      events: events,
      heightPerMinute: 1,
      date: FloatingDateTime(2024, 1, 1),
      location: null,
      timeOfDayRange: KalenderTimeRange.allDay(),
      minimumTileHeight: null,
      layoutCache: EventLayoutDelegateCache(),
    );
  }

  /// [count] events starting five minutes apart, lasting 30, 60 or 90 minutes in turn.
  List<KalenderEvent> events(int count) {
    return [
      for (var i = 0; i < count; i++)
        KalenderEvent(
          id: '$i',
          start: DateTime.utc(2024, 1, 1, 0, i * 5),
          end: DateTime.utc(2024, 1, 1, 0, i * 5 + 30 * (i % 3 + 1)),
        ),
    ];
  }

  /// Longest first, and within one duration the latest start first.
  List<String> expected(int count) {
    return [
      for (final remainder in [2, 1, 0])
        for (var i = count - 1; i >= 0; i--)
          if (i % 3 == remainder) '$i',
    ];
  }

  for (final count in [9, 40]) {
    test('$count events sort by duration, then by start', () {
      final sorted = delegateFor(events(count)).sortEvents(events(count));
      expect(sorted.map((event) => event.id), expected(count));
    });
  }
}
