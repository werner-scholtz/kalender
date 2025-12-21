import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';

import 'utilities.dart';

void main() {
  group('MultiDayEventLayoutWidget', () {
    final eventsController = DefaultEventsController();
    final controller = CalendarController();
    final tileComponents = TileComponents(
      tileBuilder: (event, tileRange) => Container(
        key: ValueKey(event.id),
        child: Text(event.id.toString()),
      ),
    );

    final start = DateTime(2025, 3, 24);
    final end = DateTime(2025, 3, 31);
    final visibleRange = InternalDateTimeRange(start: start.asUtc, end: end.asUtc);

    ValueKey<String> getKey(String data) => ValueKey(data);

    /// Clear the events controller after each test.
    tearDown(eventsController.clearEvents);

    testWidgets('Basic', (tester) async {
      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(hours: 6))),
        ),
      ];
      eventsController.addEvents(events);

      await tester.pumpWidget(
        wrapWithMaterialApp(
          TestProvider(
            calendarController: controller,
            eventsController: eventsController,
            tileComponents: tileComponents,
            child: MultiDayEventLayoutWidget(
              events: eventsController.events.toList(),
              internalDateTimeRange: visibleRange,
              textDirection: TextDirection.ltr,
              multiDayOverlayBuilders: null,
              multiDayOverlayStyles: null,
              configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 2),
              maxNumberOfVerticalEvents: null,
              multiDayCache: null,
              location: null,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the events are laid out correctly
      expect(find.byKey(getKey(events[0].id)), findsOneWidget);
      expect(find.byKey(getKey(events[1].id)), findsOneWidget);
      // This should be hidden as it exceeds the max number of vertical events.
      expect(find.byKey(getKey(events[2].id)), findsNothing);

      final buttonFinder = find.byType(MultiDayPortalOverlayButton);
      final numberOfButtons = tester.widgetList(buttonFinder).length;
      // Verify that the number of buttons is correct.
      expect(numberOfButtons, 1);

      // Verify that the button contains the correct text.
      expect(
        (find.byKey(MultiDayPortalOverlayButton.textKey).evaluate().single.widget as Text).data!.contains('1'),
        isTrue,
      );
    });

    testWidgets('Multiple events', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |------1------||-----2----|
      ///   |--3--||---4---||---5-----|
      ///                  |-----6----|

      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 27),
          ),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 25),
          ),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 25),
            end: DateTime(2025, 3, 28),
          ),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 28),
            end: DateTime(2025, 3, 30),
          ),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),

        ),
      ];
      eventsController.addEvents(events);

      const tileHeight = 50.0;
      const dayWidth = 50.0;

      await tester.pumpWidget(
        wrapWithMaterialApp(
          TestProvider(
            calendarController: controller,
            eventsController: eventsController,
            tileComponents: tileComponents,
            child: SizedBox(
              key: const ValueKey('test'),
              width: dayWidth * 7,
              height: tileHeight * 3,
              child: MultiDayEventLayoutWidget(
                events: eventsController.events.toList(),
                internalDateTimeRange: visibleRange,
                textDirection: TextDirection.ltr,
                multiDayOverlayBuilders: null,
                multiDayOverlayStyles: null,
                configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 3),
                maxNumberOfVerticalEvents: null,
                multiDayCache: null,
                location: null,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the events are present.
      expect(find.byKey(getKey(events[0].id)), findsOneWidget);
      expect(find.byKey(getKey(events[1].id)), findsOneWidget);
      expect(find.byKey(getKey(events[2].id)), findsOneWidget);
      expect(find.byKey(getKey(events[3].id)), findsOneWidget);
      expect(find.byKey(getKey(events[4].id)), findsOneWidget);
      expect(find.byKey(getKey(events[5].id)), findsOneWidget);

      /// Check that the events are not overlapping.
      final rects = [
        tester.getRect(find.byKey(getKey(events[0].id))),
        tester.getRect(find.byKey(getKey(events[1].id))),
        tester.getRect(find.byKey(getKey(events[2].id))),
        tester.getRect(find.byKey(getKey(events[3].id))),
        tester.getRect(find.byKey(getKey(events[4].id))),
        tester.getRect(find.byKey(getKey(events[5].id))),
      ];

      for (var i = 0; i < rects.length; i++) {
        for (var j = i + 1; j < rects.length; j++) {
          expect(
            rects[i].overlaps(rects[j]),
            isFalse,
            reason: 'Rect ${i + 1} overlaps with Rect ${j + 1}',
          );
        }
      }
    });

    testWidgets('Button values', (tester) async {
      ///   24   25   26   27   28   29  30
      ///   |-----1-------||-----2----|
      ///        |----3---|
      ///                  | +1 || +1 |
      /// _______________________________
      ///                 |------4----|
      final events = [
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 27),
          ),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 25),
            end: DateTime(2025, 3, 28),
          ),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),

        ),
      ];
      eventsController.addEvents(events);

      await tester.pumpWidget(
        wrapWithMaterialApp(
          TestProvider(
            calendarController: controller,
            eventsController: eventsController,
            tileComponents: tileComponents,
            child: MultiDayEventLayoutWidget(
              events: eventsController.events.toList(),
              internalDateTimeRange: visibleRange,
              textDirection: TextDirection.ltr,
              multiDayOverlayBuilders: null,
              multiDayOverlayStyles: null,
              configuration: const MultiDayHeaderConfiguration(tileHeight: 50.0, maximumNumberOfVerticalEvents: 2),
              maxNumberOfVerticalEvents: null,
              multiDayCache: null,
              location: null,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the events are present.
      expect(find.byKey(getKey(events[0].id)), findsOneWidget);
      expect(find.byKey(getKey(events[1].id)), findsOneWidget);
      expect(find.byKey(getKey(events[2].id)), findsOneWidget);
      expect(find.byKey(getKey(events[3].id)), findsNothing);

      final buttonFinder = find.byType(MultiDayPortalOverlayButton);
      expect(buttonFinder, findsNWidgets(3));

      final buttonTextFinder = find.byKey(MultiDayPortalOverlayButton.textKey);
      buttonTextFinder.evaluate().forEach((element) {
        final text = (element.widget as Text).data;
        expect(text, isNotNull, reason: 'Button text should not be null');
        expect(text!.contains('1'), isTrue, reason: 'Button text should contain the number "1" but found: "$text"');
      });
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
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 6), end: start.copyWith(day: start.day + 3)),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 3), end: start.copyWith(hour: 6)),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 7), end: start.copyWith(hour: 10)),

        ),
      ];
      eventsController.addEvents(events);
      int customComparator(CalendarEvent a, CalendarEvent b) {
        return a.start.compareTo(b.start);
      }

      const tileHeight = 50.0;

      await tester.pumpWidget(
        wrapWithMaterialApp(
          TestProvider(
            calendarController: controller,
            eventsController: eventsController,
            tileComponents: tileComponents,
            child: MultiDayEventLayoutWidget(
              events: eventsController.events.toList(),
              internalDateTimeRange: visibleRange,
              configuration: MultiDayHeaderConfiguration(
                maximumNumberOfVerticalEvents: 3,
                tileHeight: tileHeight,
                generateMultiDayLayoutFrame: ({
                  required events,
                  required textDirection,
                  required visibleDateTimeRange,
                  required location,
                  cache,
                }) =>
                    defaultMultiDayFrameGenerator(
                  visibleDateTimeRange: visibleDateTimeRange,
                  events: events,
                  textDirection: textDirection,
                  cache: cache,
                  location: location,
                  eventComparator: customComparator,
                ),
                eventPadding: const EdgeInsets.all(0),
              ),
              textDirection: TextDirection.ltr,
              multiDayOverlayBuilders: null,
              multiDayOverlayStyles: null,
              maxNumberOfVerticalEvents: null,
              multiDayCache: null,
              location: null,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the events are laid out correctly
      expect(find.byKey(getKey(events[0].id)), findsOneWidget);
      expect(find.byKey(getKey(events[1].id)), findsOneWidget);
      expect(find.byKey(getKey(events[3].id)), findsNothing);

      final buttonFinder = find.byType(MultiDayPortalOverlayButton);
      expect(buttonFinder, findsOneWidget);

      final buttonTextFinder = find.byKey(MultiDayPortalOverlayButton.textKey);
      buttonTextFinder.evaluate().forEach((element) {
        final text = (element.widget as Text).data;
        expect(text, isNotNull, reason: 'Button text should not be null');
        expect(text!.contains('1'), isTrue, reason: 'Button text should contain the number "1" but found: "$text"');
      });

      // Get positions of each event
      final pos1 = tester.getTopLeft(find.byKey(getKey(events[0].id)));
      final pos2 = tester.getTopLeft(find.byKey(getKey(events[1].id)));
      final pos3 = tester.getTopLeft(find.byKey(getKey(events[2].id)));

      expect(pos2.dy, lessThan(pos3.dy));
      expect(pos3.dy, lessThan(pos1.dy));

      // Ensure that the rects do not overlap
      final rects = [
        tester.getRect(find.byKey(getKey(events[0].id))),
        tester.getRect(find.byKey(getKey(events[1].id))),
        tester.getRect(find.byKey(getKey(events[2].id))),
      ];

      for (var i = 0; i < rects.length; i++) {
        for (var j = i + 1; j < rects.length; j++) {
          expect(
            rects[i].overlaps(rects[j]),
            isFalse,
            reason: 'Rect ${i + 1} overlaps with Rect ${j + 1}',
          );
        }
      }
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
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(hour: 12)),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(hour: 8)),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 3), end: start.copyWith(hour: 4)),

        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: start.copyWith(hour: 3), end: start.copyWith(hour: 16)),

        ),
      ];
      eventsController.addEvents(events);
      int customComparator(CalendarEvent a, CalendarEvent b) {
        return a.end.compareTo(b.end);
      }

      await tester.pumpWidget(
        wrapWithMaterialApp(
          TestProvider(
            calendarController: controller,
            eventsController: eventsController,
            tileComponents: tileComponents,
            child: MultiDayEventLayoutWidget(
              events: eventsController.events.toList(),
              internalDateTimeRange: visibleRange,
              configuration: MultiDayHeaderConfiguration(
                tileHeight: 50.0,
                maximumNumberOfVerticalEvents: 3,
                generateMultiDayLayoutFrame: ({
                  required events,
                  required textDirection,
                  required visibleDateTimeRange,
                  required location,
                  cache,
                }) =>
                    defaultMultiDayFrameGenerator(
                  visibleDateTimeRange: visibleDateTimeRange,
                  events: events,
                  textDirection: textDirection,
                  eventComparator: customComparator,
                  cache: cache,
                  location: location,
                ),
                eventPadding: const EdgeInsets.all(0),
              ),
              textDirection: TextDirection.ltr,
              multiDayOverlayBuilders: null,
              multiDayOverlayStyles: null,
              maxNumberOfVerticalEvents: null,
              multiDayCache: null,
              location: null,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the events are laid out correctly
      expect(find.byKey(getKey(events[0].id)), findsOneWidget);
      expect(find.byKey(getKey(events[1].id)), findsOneWidget);
      expect(find.byKey(getKey(events[2].id)), findsOneWidget);
      expect(find.byKey(getKey(events[3].id)), findsNothing);

      final buttonFinder = find.byType(MultiDayPortalOverlayButton);
      expect(buttonFinder, findsOneWidget);

      final buttonTextFinder = find.byKey(MultiDayPortalOverlayButton.textKey);
      buttonTextFinder.evaluate().forEach((element) {
        final text = (element.widget as Text).data;
        expect(text, isNotNull, reason: 'Button text should not be null');
        expect(text!.contains('1'), isTrue, reason: 'Button text should contain the number "1" but found: "$text"');
      });

      // Get positions of each event
      final pos1 = tester.getTopLeft(find.byKey(getKey(events[0].id)));
      final pos2 = tester.getTopLeft(find.byKey(getKey(events[1].id)));
      final pos3 = tester.getTopLeft(find.byKey(getKey(events[2].id)));

      expect(pos3.dy, lessThan(pos2.dy));
      expect(pos2.dy, lessThan(pos1.dy));

      // Ensure that the rects do not overlap
      final rects = [
        tester.getRect(find.byKey(getKey(events[0].id))),
        tester.getRect(find.byKey(getKey(events[1].id))),
        tester.getRect(find.byKey(getKey(events[2].id))),
      ];

      for (var i = 0; i < rects.length; i++) {
        for (var j = i + 1; j < rects.length; j++) {
          expect(
            rects[i].overlaps(rects[j]),
            isFalse,
            reason: 'Rect ${i + 1} overlaps with Rect ${j + 1}',
          );
        }
      }
    });
  });
}
