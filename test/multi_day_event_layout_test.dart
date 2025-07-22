import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';

import 'utilities.dart';

void main() {
  group('MultiDayEventLayoutWidget', () {
    final eventsController = DefaultEventsController<int>();
    final controller = CalendarController<int>();
    final tileComponents = TileComponents<int>(
      tileBuilder: (event, tileRange) => Container(
        key: ValueKey(event.data!),
        child: Text(event.data.toString()),
      ),
    );

    final start = DateTime(2025, 3, 24);
    final end = DateTime(2025, 3, 31);
    final visibleRange = DateTimeRange(start: start.asUtc, end: end.asUtc);

    ValueKey<int> getKey(int data) => ValueKey(data);

    /// Clear the events controller after each test.
    tearDown(eventsController.clearEvents);

    testWidgets('Basic', (tester) async {
      final events = [
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)),
          data: 1,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)),
          data: 2,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(hours: 6))),
          data: 3,
        ),
      ];
      eventsController.addEvents(events);

      const tileHeight = 50.0;
      const maxNumberOfVerticalEvents = 2;

      await tester.pumpWidget(
        wrapWithMaterialApp(
          TestProvider(
            calendarController: controller,
            eventsController: eventsController,
            tileComponents: tileComponents,
            child: MultiDayEventLayoutWidget<int>(
              events: eventsController.events.toList(),
              eventsController: eventsController,
              visibleDateTimeRange: visibleRange,
              showAllEvents: true,
              tileHeight: tileHeight,
              maxNumberOfVerticalEvents: maxNumberOfVerticalEvents,
              generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator<int>,
              eventPadding: const EdgeInsets.all(0),
              textDirection: TextDirection.ltr,
              multiDayOverlayBuilders: null,
              multiDayOverlayStyles: null,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the events are laid out correctly
      expect(find.byKey(getKey(1)), findsOneWidget);
      expect(find.byKey(getKey(2)), findsOneWidget);
      // This should be hidden as it exceeds the max number of vertical events.
      expect(find.byKey(getKey(3)), findsNothing);

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
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 27),
          ),
          data: 1,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),
          data: 2,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 25),
          ),
          data: 3,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 25),
            end: DateTime(2025, 3, 28),
          ),
          data: 4,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 28),
            end: DateTime(2025, 3, 30),
          ),
          data: 5,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),
          data: 6,
        ),
      ];
      eventsController.addEvents(events);

      const tileHeight = 50.0;
      const dayWidth = 50.0;
      const maxNumberOfVerticalEvents = 3;

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
              child: MultiDayEventLayoutWidget<int>(
                events: eventsController.events.toList(),
                eventsController: eventsController,
                visibleDateTimeRange: visibleRange,
                showAllEvents: true,
                tileHeight: tileHeight,
                maxNumberOfVerticalEvents: maxNumberOfVerticalEvents,
                generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator<int>,
                eventPadding: const EdgeInsets.all(0),
                textDirection: TextDirection.ltr,
                multiDayOverlayBuilders: null,
                multiDayOverlayStyles: null,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the events are present.
      expect(find.byKey(getKey(1)), findsOneWidget);
      expect(find.byKey(getKey(2)), findsOneWidget);
      expect(find.byKey(getKey(3)), findsOneWidget);
      expect(find.byKey(getKey(4)), findsOneWidget);
      expect(find.byKey(getKey(5)), findsOneWidget);
      expect(find.byKey(getKey(6)), findsOneWidget);

      /// Check that the events are not overlapping.
      final rects = [
        tester.getRect(find.byKey(getKey(1))),
        tester.getRect(find.byKey(getKey(2))),
        tester.getRect(find.byKey(getKey(3))),
        tester.getRect(find.byKey(getKey(4))),
        tester.getRect(find.byKey(getKey(5))),
        tester.getRect(find.byKey(getKey(6))),
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
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 24),
            end: DateTime(2025, 3, 27),
          ),
          data: 1,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),
          data: 2,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 25),
            end: DateTime(2025, 3, 28),
          ),
          data: 3,
        ),
        CalendarEvent<int>(
          dateTimeRange: DateTimeRange(
            start: DateTime(2025, 3, 27),
            end: DateTime(2025, 3, 30),
          ),
          data: 4,
        ),
      ];
      eventsController.addEvents(events);

      const tileHeight = 50.0;
      const maxNumberOfVerticalEvents = 2;

      await tester.pumpWidget(
        wrapWithMaterialApp(
          TestProvider(
            calendarController: controller,
            eventsController: eventsController,
            tileComponents: tileComponents,
            child: MultiDayEventLayoutWidget<int>(
              events: eventsController.events.toList(),
              eventsController: eventsController,
              visibleDateTimeRange: visibleRange,
              showAllEvents: true,
              tileHeight: tileHeight,
              maxNumberOfVerticalEvents: maxNumberOfVerticalEvents,
              generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator<int>,
              eventPadding: const EdgeInsets.all(0),
              textDirection: TextDirection.ltr,
              multiDayOverlayBuilders: null,
              multiDayOverlayStyles: null,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the events are present.
      expect(find.byKey(getKey(1)), findsOneWidget);
      expect(find.byKey(getKey(2)), findsOneWidget);
      expect(find.byKey(getKey(3)), findsOneWidget);
      expect(find.byKey(getKey(4)), findsNothing);

      final buttonFinder = find.byType(MultiDayPortalOverlayButton);
      expect(buttonFinder, findsNWidgets(3));

      final buttonTextFinder = find.byKey(MultiDayPortalOverlayButton.textKey);
      buttonTextFinder.evaluate().forEach((element) {
        final text = (element.widget as Text).data;
        expect(text, isNotNull, reason: 'Button text should not be null');
        expect(text!.contains('1'), isTrue, reason: 'Button text should contain the number "1" but found: "$text"');
      });
    });
  });
}
