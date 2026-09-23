// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';

import '../utilities.dart';

void expectNoOverlaps(List<Rect> rects) {
  for (var i = 0; i < rects.length; i++) {
    for (var j = i + 1; j < rects.length; j++) {
      expect(rects[i].overlaps(rects[j]), isFalse, reason: 'Rect ${i + 1} overlaps with Rect ${j + 1}');
    }
  }
}

void main() {
  group('MultiDayEventLayoutWidget', () {
    late DefaultEventsController eventsController;
    late KalenderController controller;

    final tileComponents = TileComponents(
      tileBuilder: (context, event, tileRange) => Container(key: ValueKey(event.id), child: Text(event.id.toString())),
      dropTargetTile: (context, event) => Container(key: const ValueKey('drop-target')),
    );

    final start = FloatingDateTime(2025, 3, 24);
    final end = FloatingDateTime(2025, 3, 31);
    final visibleRange = FloatingDateTimeRange(start: start, end: end);

    setUp(() {
      eventsController = DefaultEventsController();
      controller = KalenderController(viewConfiguration: MultiDayViewConfiguration.week());
    });

    Widget buildLayoutWidget({required HorizontalConfiguration configuration, double? width, double? height}) {
      return wrapWithMaterialApp(
        TestProvider(
          kalenderController: controller,
          eventsController: eventsController,
          tileComponents: tileComponents,
          child: SizedBox(
            width: width,
            height: height,
            child: MultiDayEventLayoutWidget(
              events: eventsController.events.toList(),
              floatingRange: visibleRange,
              textDirection: TextDirection.ltr,
              multiDayOverlayBuilders: null,
              configuration: configuration,
              maxNumberOfVerticalEvents: null,
              multiDayCache: null,
              location: null,
            ),
          ),
        ),
      );
    }

    List<String?> overflowButtonTexts(WidgetTester tester) => [
      for (final element in find.byKey(MultiDayPortalOverlayButton.textKey).evaluate()) (element.widget as Text).data,
    ];

    // Regression: an empty event list counted as one row.
    testWidgets('No overflow buttons when there are no events', (tester) async {
      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 2),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MultiDayPortalOverlayButton), findsNothing);
    });

    // Regression: a negative maxNumberOfVerticalEvents miscounted hidden rows and showed buttons on empty days.
    testWidgets('Overflow button count is correct when maxNumberOfVerticalEvents is 0', (tester) async {
      // The events end at midnight of the 26th, so they span 2 of the 7 columns.
      final events = [
        KalenderEvent(
          start: start,
          end: start.copyWith(day: start.day + 2),
        ),
        KalenderEvent(
          start: start,
          end: start.copyWith(day: start.day + 2),
        ),
      ];
      eventsController.addEvents(events);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(events[0].id)), findsNothing);
      expect(find.byKey(ValueKey(events[1].id)), findsNothing);

      expect(find.byType(MultiDayPortalOverlayButton), findsNWidgets(2));

      for (final button in tester.widgetList(find.byType(MultiDayPortalOverlayButton))) {
        expect((button as MultiDayPortalOverlayButton).numberOfHiddenRows, greaterThan(0));
      }
    });

    testWidgets('Basic', (tester) async {
      final events = [
        KalenderEvent(
          start: start,
          end: start.copyWith(day: start.day + 3),
        ),
        KalenderEvent(
          start: start,
          end: start.copyWith(day: start.day + 3),
        ),
        KalenderEvent(start: start, end: start.add(const Duration(hours: 6))),
      ];
      eventsController.addEvents(events);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 2),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(events[0].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[1].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[2].id)), findsNothing);

      expect(find.byType(MultiDayPortalOverlayButton), findsOneWidget);

      expect(overflowButtonTexts(tester), ['+1']);
    });

    testWidgets('Drop target layout uses the selected event span during horizontal resize', (tester) async {
      final storedEvent = KalenderEvent(start: DateTime(2025, 3, 24), end: DateTime(2025, 3, 25));
      eventsController.addEvent(storedEvent);

      const dayWidth = 80.0;
      const tileHeight = 40.0;

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MonthBodyConfiguration(tileHeight: tileHeight),
          width: dayWidth * 7,
          height: tileHeight * 3,
        ),
      );
      await tester.pumpAndSettle();

      controller.selectEvent(storedEvent, internal: true);
      await tester.pump();

      final initialWidth = tester.getSize(find.byKey(const ValueKey('drop-target'))).width;

      controller.selectEvent(
        storedEvent.withDateTimeRange(KalenderDateTimeRange(start: DateTime(2025, 3, 24), end: DateTime(2025, 3, 27))),
        internal: true,
      );
      await tester.pump();

      final resizedWidth = tester.getSize(find.byKey(const ValueKey('drop-target'))).width;

      expect(resizedWidth, greaterThan(initialWidth));
      expect(resizedWidth, greaterThan(dayWidth * 2.5));
    });

    testWidgets('Multiple events', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |------1------||-----2----|
      ///   |--3--||---4---||---5-----|
      ///                  |-----6----|

      final events = [
        KalenderEvent(start: DateTime(2025, 3, 24), end: DateTime(2025, 3, 27)),
        KalenderEvent(start: DateTime(2025, 3, 27), end: DateTime(2025, 3, 30)),
        KalenderEvent(start: DateTime(2025, 3, 24), end: DateTime(2025, 3, 25)),
        KalenderEvent(start: DateTime(2025, 3, 25), end: DateTime(2025, 3, 28)),
        KalenderEvent(start: DateTime(2025, 3, 28), end: DateTime(2025, 3, 30)),
        KalenderEvent(start: DateTime(2025, 3, 27), end: DateTime(2025, 3, 30)),
      ];
      eventsController.addEvents(events);

      const tileHeight = 50.0;
      const dayWidth = 50.0;

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MultiDayHeaderConfiguration(tileHeight: tileHeight, maximumNumberOfVerticalEvents: 3),
          width: dayWidth * 7,
          height: tileHeight * 3,
        ),
      );
      await tester.pumpAndSettle();

      for (final event in events) {
        expect(find.byKey(ValueKey(event.id)), findsOneWidget, reason: 'Event ${event.id} should be visible');
      }

      expectNoOverlaps([for (final event in events) tester.getRect(find.byKey(ValueKey(event.id)))]);
    });

    testWidgets('Button values', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |-----1-------||-----2----|
      ///        |----3---|
      ///                  | +1 || +1 |
      /// _______________________________
      ///                 |------4----|
      final events = [
        KalenderEvent(start: DateTime(2025, 3, 24), end: DateTime(2025, 3, 27)),
        KalenderEvent(start: DateTime(2025, 3, 27), end: DateTime(2025, 3, 30)),
        KalenderEvent(start: DateTime(2025, 3, 25), end: DateTime(2025, 3, 28)),
        KalenderEvent(start: DateTime(2025, 3, 27), end: DateTime(2025, 3, 30)),
      ];
      eventsController.addEvents(events);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 2),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(events[0].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[1].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[2].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[3].id)), findsNothing);

      expect(find.byType(MultiDayPortalOverlayButton), findsNWidgets(3));

      expect(overflowButtonTexts(tester), ['+1', '+1', '+1']);
    });

    testWidgets('Sorting by start time', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |-----2-------|
      ///   |-3-|
      ///   |----1--------|
      ///   | +1 |
      /// _______________________________
      ///   |-4-|
      final events = [
        KalenderEvent(
          start: start.copyWith(hour: 6),
          end: start.copyWith(day: start.day + 3),
        ),
        KalenderEvent(
          start: start,
          end: start.copyWith(day: start.day + 3),
        ),
        KalenderEvent(start: start.copyWith(hour: 3), end: start.copyWith(hour: 6)),
        KalenderEvent(start: start.copyWith(hour: 7), end: start.copyWith(hour: 10)),
      ];
      eventsController.addEvents(events);

      int startTimeComparator(KalenderEvent a, KalenderEvent b) => a.start.compareTo(b.start);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: MultiDayHeaderConfiguration(
            maximumNumberOfVerticalEvents: 3,
            tileHeight: 50.0,
            multiDayLayoutStrategy: _ComparatorStrategy(startTimeComparator),
            eventPadding: const EdgeInsets.all(0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(events[0].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[1].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[2].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[3].id)), findsNothing);

      expect(find.byType(MultiDayPortalOverlayButton), findsOneWidget);

      expect(overflowButtonTexts(tester), ['+1']);

      final pos0 = tester.getTopLeft(find.byKey(ValueKey(events[0].id)));
      final pos1 = tester.getTopLeft(find.byKey(ValueKey(events[1].id)));
      final pos2 = tester.getTopLeft(find.byKey(ValueKey(events[2].id)));

      expect(pos1.dy, lessThan(pos2.dy));
      expect(pos2.dy, lessThan(pos0.dy));

      expectNoOverlaps([for (final event in events.take(3)) tester.getRect(find.byKey(ValueKey(event.id)))]);
    });

    testWidgets('Sorting by end time', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |-3-|
      ///   |-2-|
      ///   |-1-|
      ///   | +1 |
      /// _______________________________
      ///   |-4-|
      final events = [
        KalenderEvent(start: start, end: start.copyWith(hour: 12)),
        KalenderEvent(start: start, end: start.copyWith(hour: 8)),
        KalenderEvent(start: start.copyWith(hour: 3), end: start.copyWith(hour: 4)),
        KalenderEvent(start: start.copyWith(hour: 3), end: start.copyWith(hour: 16)),
      ];
      eventsController.addEvents(events);

      int endTimeComparator(KalenderEvent a, KalenderEvent b) => a.end.compareTo(b.end);

      await tester.pumpWidget(
        buildLayoutWidget(
          configuration: MultiDayHeaderConfiguration(
            tileHeight: 50.0,
            maximumNumberOfVerticalEvents: 3,
            multiDayLayoutStrategy: _ComparatorStrategy(endTimeComparator),
            eventPadding: const EdgeInsets.all(0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(events[0].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[1].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[2].id)), findsOneWidget);
      expect(find.byKey(ValueKey(events[3].id)), findsNothing);

      expect(find.byType(MultiDayPortalOverlayButton), findsOneWidget);

      expect(overflowButtonTexts(tester), ['+1']);

      final pos0 = tester.getTopLeft(find.byKey(ValueKey(events[0].id)));
      final pos1 = tester.getTopLeft(find.byKey(ValueKey(events[1].id)));
      final pos2 = tester.getTopLeft(find.byKey(ValueKey(events[2].id)));

      expect(pos2.dy, lessThan(pos1.dy));
      expect(pos1.dy, lessThan(pos0.dy));

      expectNoOverlaps([for (final event in events.take(3)) tester.getRect(find.byKey(ValueKey(event.id)))]);
    });
  });
}

/// Keeps the built-in row assignment but orders the events with [comparator],
/// which [MultiDayLayoutStrategy] itself does not expose.
class _ComparatorStrategy extends MultiDayLayoutStrategy {
  const _ComparatorStrategy(this.comparator);

  final int Function(KalenderEvent, KalenderEvent) comparator;

  @override
  MultiDayLayoutFrame generateFrame({
    required FloatingDateTimeRange visibleRange,
    required List<KalenderEvent> events,
    required TextDirection textDirection,
    required Location? location,
    required MultiDayLayoutFrameCache? cache,
  }) {
    return defaultMultiDayFrameGenerator(
      visibleRange: visibleRange,
      events: events,
      textDirection: textDirection,
      cache: cache,
      location: location,
      eventComparator: comparator,
    );
  }

  @override
  bool operator ==(Object other) => other is _ComparatorStrategy && other.comparator == comparator;

  @override
  int get hashCode => comparator.hashCode;
}
