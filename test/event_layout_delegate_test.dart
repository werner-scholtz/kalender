import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import 'utilities.dart';

void main() {
  final date = DateTime.utc(2025);
  final events = [
    CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: date.copyWith(minute: 29),
        end: date.copyWith(minute: 30),
      ),
    ),
    CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: date.copyWith(minute: 30),
        end: date.copyWith(minute: 59, second: 59, microsecond: 999999),
      ),
    ),
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 1), end: date.copyWith(hour: 2))),
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 2), end: date.copyWith(hour: 3))),
  ];

  final heightPerMinutes = List.generate(100, (i) => 0.1 + i / 100);
  const width = 400.0;

  Key getKey(int index) => Key('event_$index');

  group('overlapLayoutStrategy', () {
    for (final heightPerMinute in heightPerMinutes) {
      testWidgets('height per minute $heightPerMinute', (tester) async {
        await tester.pumpWidget(
          wrapWithMaterialApp(
            SizedBox(
              width: width,
              height: 800,
              child: CustomMultiChildLayout(
                delegate: overlapLayoutStrategy(events, date, TimeOfDayRange.allDay(), heightPerMinute, null),
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
          ),
        );

        await tester.pumpAndSettle();
        for (var i = 0; i < events.length; i++) {
          final eventFinder = find.byKey(getKey(i));
          expect(eventFinder, findsOneWidget);
          final size = tester.getSize(eventFinder);
          expect(size.width, 400);
        }
      });
    }
  });

  group('sideBySideLayoutStrategy', () {
    testWidgets('height per minute ', (tester) async {
      await tester.pumpWidget(
        wrapWithMaterialApp(
          SizedBox(
            width: width,
            child: CustomMultiChildLayout(
              delegate: sideBySideLayoutStrategy(events, date, TimeOfDayRange.allDay(), 0.7, null),
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
        ),
      );

      await tester.pumpAndSettle();
      for (var i = 0; i < events.length; i++) {
        final eventFinder = find.byKey(getKey(i));
        expect(eventFinder, findsOneWidget);
        final size = tester.getSize(eventFinder);
        expect(size.width, 400);
      }
    });
  });
}
