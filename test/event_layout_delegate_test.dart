import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import 'utilities.dart';

void main() {
  final date = DateTime(2025);
  final events = [
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 1), end: date.copyWith(hour: 2))),
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 2), end: date.copyWith(hour: 3))),
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 3), end: date.copyWith(hour: 4))),
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 5), end: date.copyWith(hour: 6))),
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 7), end: date.copyWith(hour: 8))),
  ];

  // TODO: test at different height per minutes
  final heightPerminutes = [0.6, 0.7, 0.8, 0.9, 1.0];
  const width = 400.0;

  Key getKey(int index) => Key('event_$index');

  group('overlapLayoutStrategy', () {
    testWidgets('height per minute ', (tester) async {
      await tester.pumpWidget(
        wrapWithMaterialApp(
          SizedBox(
            width: width,
            child: CustomMultiChildLayout(
              delegate: overlapLayoutStrategy(events, date, TimeOfDayRange.allDay(), 0.7, null),
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
