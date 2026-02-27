import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/snap_points.dart';

class MockSnapPoint with SnapPoints {}

void main() {
  // Three consecutive 1-hour events: 10–11, 11–12, 12–13.
  // Adding them as snap points produces 6 entries (start + end per event):
  //   10:00, 11:00, 11:00, 12:00, 12:00, 13:00
  final testEvents = [
    CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2024, 1, 1, 10), end: DateTime(2024, 1, 1, 11))),
    CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2024, 1, 1, 11), end: DateTime(2024, 1, 1, 12))),
    CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2024, 1, 1, 12), end: DateTime(2024, 1, 1, 13))),
  ];

  late MockSnapPoint points;

  setUp(() => points = MockSnapPoint());

  group('addEventSnapPoints', () {
    test('adds start and end of each event', () {
      points.addEventSnapPoints(testEvents.toSet(), null);
      expect(points.snapPoints, [
        InternalDateTime(2024, 1, 1, 10),
        InternalDateTime(2024, 1, 1, 11),
        InternalDateTime(2024, 1, 1, 11),
        InternalDateTime(2024, 1, 1, 12),
        InternalDateTime(2024, 1, 1, 12),
        InternalDateTime(2024, 1, 1, 13),
      ]);
    });
  });

  group('addSnapPoint / removeSnapPoint', () {
    test('add increases length and contains the new point', () {
      points.addSnapPoint(InternalDateTime(2024, 1, 1, 14));
      expect(points.snapPoints.length, 1);
      expect(points.snapPoints, contains(InternalDateTime(2024, 1, 1, 14)));
    });

    test('remove decreases length and no longer contains the point', () {
      points.addSnapPoint(InternalDateTime(2024, 1, 1, 14));
      points.removeSnapPoint(InternalDateTime(2024, 1, 1, 14));
      expect(points.snapPoints, isEmpty);
    });
  });

  group('clearSnapPoints', () {
    test('removes all snap points', () {
      points.addEventSnapPoints(testEvents.toSet(), null);
      expect(points.snapPoints, isNotEmpty);
      points.clearSnapPoints();
      expect(points.snapPoints, isEmpty);
    });
  });

  group('findSnapPoint', () {
    // Pre-populate with the 6 event snap points for all findSnapPoint tests.
    setUp(() => points.addEventSnapPoints(testEvents.toSet(), null));

    const snapRange = Duration(hours: 1);

    test('returns null when list is empty', () {
      final empty = MockSnapPoint();
      expect(empty.findSnapPoint(InternalDateTime(2024, 1, 1, 10), snapRange), isNull);
    });

    test('cursor exactly on a snap point returns that point', () {
      final snapPoint = points.findSnapPoint(InternalDateTime(2024, 1, 1, 10), snapRange);
      expect(snapPoint, InternalDateTime(2024, 1, 1, 10));
    });

    test('cursor close to 10:00 snaps to 10:00 (before midpoint)', () {
      expect(
        points.findSnapPoint(InternalDateTime(2024, 1, 1, 10, 5), snapRange),
        InternalDateTime(2024, 1, 1, 10),
      );
      expect(
        points.findSnapPoint(InternalDateTime(2024, 1, 1, 10, 29), snapRange),
        InternalDateTime(2024, 1, 1, 10),
      );
    });

    test('cursor at or past midpoint snaps to 11:00', () {
      // At exactly 10:30 both 10:00 and 11:00 are equidistant; implementation picks 11:00.
      expect(
        points.findSnapPoint(InternalDateTime(2024, 1, 1, 10, 30), snapRange),
        InternalDateTime(2024, 1, 1, 11),
      );
      expect(
        points.findSnapPoint(InternalDateTime(2024, 1, 1, 10, 31), snapRange),
        InternalDateTime(2024, 1, 1, 11),
      );
    });

    test('cursor out of range on the low side returns null', () {
      expect(
        points.findSnapPoint(InternalDateTime(2024, 1, 1, 8, 59), snapRange),
        isNull,
      );
    });

    test('cursor out of range on the high side returns null', () {
      expect(
        points.findSnapPoint(InternalDateTime(2024, 1, 1, 14, 1), snapRange),
        isNull,
      );
    });
  });
}
