import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import 'utilities.dart';

void main() {
  final date = DateTime(2025);
  final internalDate = InternalDateTime.fromDateTime(date);

  // Events deliberately chosen to exercise boundary-touching behavior:
  //   - event 0 (01:29–01:30) and event 1 (01:30–01:59:59…) share an exact
  //     boundary minute but do NOT overlap in vertical layout terms.
  //   - events 2 and 3 are back-to-back whole hours, also non-overlapping.
  // None of the events overlap, so every strategy should render each tile at
  // full width.
  final events = [
    CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: date.copyWith(hour: 1, minute: 29),
        end: date.copyWith(hour: 1, minute: 30),
      ),
    ),
    CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: date.copyWith(hour: 1, minute: 30),
        end: date.copyWith(hour: 1, minute: 59, second: 59, microsecond: 999999),
      ),
    ),
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 2), end: date.copyWith(hour: 3))),
    CalendarEvent(dateTimeRange: DateTimeRange(start: date.copyWith(hour: 3), end: date.copyWith(hour: 4))),
  ];

  final heightPerMinutes = List.generate(100, (i) => 0.1 + i / 100);
  const containerWidth = 400.0;
  const containerHeight = 800.0;

  Key getKey(int index) => Key('event_$index');

  /// Builds a [CustomMultiChildLayout] with the given [delegate] inside a
  /// fixed-size [SizedBox] and returns the pumped widget.
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

  /// Asserts that every event tile is visible, has the expected [width], and is
  /// positioned within the container bounds.
  void expectAllTilesRendered(WidgetTester tester, {double expectedWidth = containerWidth}) {
    for (var i = 0; i < events.length; i++) {
      final finder = find.byKey(getKey(i));
      expect(finder, findsOneWidget, reason: 'event $i should be rendered');

      final size = tester.getSize(finder);
      expect(size.width, expectedWidth, reason: 'event $i width');

      final topLeft = tester.getTopLeft(finder);
      expect(topLeft.dy, greaterThanOrEqualTo(0), reason: 'event $i top should be within container');
      expect(
        topLeft.dy + size.height,
        lessThanOrEqualTo(containerHeight),
        reason: 'event $i bottom should be within container',
      );
    }
  }

  group('overlapLayoutStrategy', () {
    for (final heightPerMinute in heightPerMinutes) {
      testWidgets('height per minute $heightPerMinute', (tester) async {
        await tester.pumpWidget(
          buildLayout(
            overlapLayoutStrategy(events, internalDate, TimeOfDayRange.allDay(), heightPerMinute, null, null, null),
          ),
        );
        await tester.pumpAndSettle();
        expectAllTilesRendered(tester);
      });
    }
  });

  group('sideBySideLayoutStrategy', () {
    for (final heightPerMinute in heightPerMinutes) {
      testWidgets('height per minute $heightPerMinute', (tester) async {
        await tester.pumpWidget(
          buildLayout(
            sideBySideLayoutStrategy(events, internalDate, TimeOfDayRange.allDay(), heightPerMinute, null, null, null),
          ),
        );
        await tester.pumpAndSettle();
        expectAllTilesRendered(tester);
      });
    }
  });
}
