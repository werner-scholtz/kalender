// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart' show Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

// Tests that back-to-back events are not grouped as overlapping after their times are converted to pixels.
void main() {
  // Local times, because with location null the layout converts event times to the system timezone.
  KalenderEvent event(int startSeconds, int endSeconds) => KalenderEvent(
    start: DateTime(2024, 1, 1).add(Duration(seconds: startSeconds)),
    end: DateTime(2024, 1, 1).add(Duration(seconds: endSeconds)),
  );

  int groupCountForTouchingPair({
    required int startSeconds,
    required int durationSeconds,
    required double heightPerMinute,
    double? minimumTileHeight,
  }) {
    final boundary = startSeconds + durationSeconds;
    final delegate = OverlapLayoutDelegate(
      events: [event(startSeconds, boundary), event(boundary, boundary + durationSeconds)],
      heightPerMinute: heightPerMinute,
      date: FloatingDateTime(2024, 1, 1),
      location: null,
      timeOfDayRange: KalenderTimeRange.allDay(),
      minimumTileHeight: minimumTileHeight,
      layoutCache: EventLayoutDelegateCache(),
    );
    final size = Size(300, heightPerMinute * 24 * 60);
    final bands = delegate.calculateVerticalLayoutData(size);
    return delegate.groupVerticalLayoutData(bands).length;
  }

  test('touching events never overlap across a wide sweep of zoom, offsets and durations', () {
    for (final startSeconds in [0, 37, 613, 1801, 3599, 5000, 12345]) {
      for (final durationSeconds in [60, 300, 599, 900, 1234, 3600]) {
        for (var i = 0; i <= 400; i++) {
          final heightPerMinute = 0.1 + i * 0.005; // 0.1 .. 2.1
          final groups = groupCountForTouchingPair(
            startSeconds: startSeconds,
            durationSeconds: durationSeconds,
            heightPerMinute: heightPerMinute,
          );
          expect(
            groups,
            2,
            reason:
                'touching events grouped as overlapping at '
                'start=${startSeconds}s duration=${durationSeconds}s hpm=$heightPerMinute',
          );
        }
      }
    }
  });

  test('the fix holds when minimumTileHeight is set but not triggered', () {
    // 30-minute events stay taller than the 24px minimum for hpm >= 0.8, so the minimum does not apply.
    for (var i = 0; i <= 140; i++) {
      final heightPerMinute = 0.8 + i * 0.01; // 0.8 .. 2.2
      final groups = groupCountForTouchingPair(
        startSeconds: 0,
        durationSeconds: 1800, // 30 minutes
        heightPerMinute: heightPerMinute,
        minimumTileHeight: 24,
      );
      expect(groups, 2, reason: 'hpm=$heightPerMinute');
    }
  });
}
