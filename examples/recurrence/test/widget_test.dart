import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recurrence/main.dart';
import 'package:recurrence/recurrence.dart';

void main() {
  testWidgets('App renders without errors', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  group('RecurrenceType.generateDateTimeRanges', () {
    final first = DateTimeRange(start: DateTime(2025, 1, 6, 9), end: DateTime(2025, 1, 6, 10));

    test('daily steps one day at a time', () {
      final ranges = RecurrenceType.daily.generateDateTimeRanges(first, 3);
      expect(ranges.length, 3);
      expect(ranges[0].start, DateTime(2025, 1, 6, 9));
      expect(ranges[1].start, DateTime(2025, 1, 7, 9));
      expect(ranges[2].start, DateTime(2025, 1, 8, 9));
    });

    test('weekly steps seven days at a time', () {
      final ranges = RecurrenceType.weekly.generateDateTimeRanges(first, 2);
      expect(ranges[1].start, DateTime(2025, 1, 13, 9));
    });

    test('none yields a single range regardless of count', () {
      expect(RecurrenceType.none.generateDateTimeRanges(first, 5).length, 1);
    });
  });
}
