import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/mixins/snap_points.dart';

class MockSnapPoint with SnapPoints {}

void main() {
  group('SnapPoint Tests', () {
    final points = MockSnapPoint();

    final testEvents = [
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2024, 1, 1, 10), end: DateTime(2024, 1, 1, 11))),
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2024, 1, 1, 11), end: DateTime(2024, 1, 1, 12))),
      CalendarEvent(dateTimeRange: DateTimeRange(start: DateTime(2024, 1, 1, 12), end: DateTime(2024, 1, 1, 13))),
    ];

    test('addEventSnapPoints', () {
      points.addEventSnapPoints(testEvents.toSet(), null);
      expect(points.snapPoints.length, 6);
      expect(points.snapPoints[0], InternalDateTime(2024, 1, 1, 10));
      expect(points.snapPoints[1], InternalDateTime(2024, 1, 1, 11));
      expect(points.snapPoints[2], InternalDateTime(2024, 1, 1, 11));
      expect(points.snapPoints[3], InternalDateTime(2024, 1, 1, 12));
      expect(points.snapPoints[4], InternalDateTime(2024, 1, 1, 12));
      expect(points.snapPoints[5], InternalDateTime(2024, 1, 1, 13));
    });

    test('add / remove SnapPoint', () {
      points.addSnapPoint(InternalDateTime(2024, 1, 1, 14));
      expect(points.snapPoints.length, 7);
      expect(points.snapPoints[6], DateTime.utc(2024, 1, 1, 14));

      points.removeSnapPoint(InternalDateTime(2024, 1, 1, 14));
      expect(points.snapPoints.length, 6);
      expect(points.snapPoints.contains(InternalDateTime(2024, 1, 1, 14)), false);
    });

    test('findSnapPoint', () {
      const snapRange = Duration(hours: 1);
      var snapPoint = points.findSnapPoint(InternalDateTime(2024, 1, 1, 10, 5), snapRange);
      expect(snapPoint, DateTime.utc(2024, 1, 1, 10));

      snapPoint = points.findSnapPoint(InternalDateTime(2024, 1, 1, 10, 29), snapRange);
      expect(snapPoint, DateTime.utc(2024, 1, 1, 10));

      snapPoint = points.findSnapPoint(InternalDateTime(2024, 1, 1, 10, 30), snapRange);
      expect(snapPoint, DateTime.utc(2024, 1, 1, 11));

      snapPoint = points.findSnapPoint(InternalDateTime(2024, 1, 1, 10, 31), snapRange);
      expect(snapPoint, DateTime.utc(2024, 1, 1, 11));

      final noSnapPoint = points.findSnapPoint(InternalDateTime(2024, 1, 1, 8, 59), snapRange);
      expect(noSnapPoint, null);
    });
  });
}
