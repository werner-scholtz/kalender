import 'package:flutter/material.dart' show DateTimeRange, Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

// Regression tests for a datetime->pixel rounding bug where two back-to-back
// events (one ends exactly when the next begins) were laid out as overlapping
// (side-by-side) at certain zoom levels. The cause was computing an event's
// bottom as top + height (two conversions summed) while the next event's top
// used a single conversion, so their boundaries differed by a floating point
// hair and the 0.1px rounding could split them the wrong way.
void main() {
  CalendarEvent event(int startSeconds, int endSeconds) => CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime.utc(2024, 1, 1).add(Duration(seconds: startSeconds)),
          end: DateTime.utc(2024, 1, 1).add(Duration(seconds: endSeconds)),
        ),
      );

  int groupCountForTouchingPair({
    required int startSeconds,
    required int durationSeconds,
    required double heightPerMinute,
    double? minimumTileHeight,
  }) {
    final boundary = startSeconds + durationSeconds;
    final delegate = OverlapLayoutDelegate(
      events: [
        event(startSeconds, boundary),
        event(boundary, boundary + durationSeconds),
      ],
      heightPerMinute: heightPerMinute,
      date: InternalDateTime(2024, 1, 1),
      location: null,
      timeOfDayRange: TimeOfDayRange.allDay(),
      minimumTileHeight: minimumTileHeight,
      layoutCache: EventLayoutDelegateCache(),
    );
    final size = Size(300, heightPerMinute * 24 * 60);
    final bands = delegate.calculateVerticalLayoutData(size);
    return delegate.groupVerticalLayoutData(bands).length;
  }

  test('a previously failing case: two 5-minute events at zoom 2.05', () {
    // Before the fix this produced a single overlap group (side-by-side).
    expect(groupCountForTouchingPair(startSeconds: 0, durationSeconds: 300, heightPerMinute: 2.05), 2);
  });

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
            reason: 'touching events grouped as overlapping at '
                'start=${startSeconds}s duration=${durationSeconds}s hpm=$heightPerMinute',
          );
        }
      }
    }
  });

  test('the fix holds when minimumTileHeight is set but not triggered', () {
    // 30-minute events stay taller than the 24px minimum for hpm >= 0.8, so the
    // minimum floor does not apply and the boundaries must line up exactly.
    // (Below that the minimum legitimately inflates a tile past its neighbour,
    // which is separate expected behaviour, not the rounding bug.)
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
