import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_event_layout_widget.dart';

import 'utilities.dart';

void main() {
  testWidgets('MultiDayEventLayoutWidget (MonthView)', (tester) async {
    final controller = CalendarController<int>();
    final interaction = ValueNotifier(CalendarInteraction());
    final tileComponents = TileComponents<int>(
      tileBuilder: (event, tileRange) => Container(
        key: ValueKey(event.data!),
        child: Text(event.data.toString()),
      ),
    );

    final start = DateTime.utc(2025, 3, 24);
    final end = DateTime.utc(2025, 3, 31);
    final visibleRange = DateTimeRange(start: start, end: end);

    final events = [
      CalendarEvent<int>(dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)), data: 1),
      CalendarEvent<int>(dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)), data: 2),
      // CalendarEvent<int>(dateTimeRange: DateTimeRange(start: start, end: start.endOfDay.endOfDay), data: 2),
      CalendarEvent<int>(dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(seconds: 1))), data: 3),
    ];

    final eventsController = DefaultEventsController<int>()..addEvents(events);

    const tileHeight = 50.0;
    const dayWidth = 50.0;
    const maxNumberOfVerticalEvents = 2;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        MultiDayEventLayoutWidget<int>(
          events: eventsController.events.toList(),
          eventsController: eventsController,
          controller: controller,
          visibleDateTimeRange: visibleRange,
          tileComponents: tileComponents,
          callbacks: null,
          dayWidth: dayWidth,
          showAllEvents: true,
          tileHeight: tileHeight,
          maxNumberOfVerticalEvents: maxNumberOfVerticalEvents,
          interaction: interaction,
          generateFrame: defaultMultiDayGenerateFrame<int>,
          multiDayExpandBuilder: (date, renderBox) => const SizedBox(key: ValueKey('multiDayExpand')),
          textDirection: TextDirection.rtl,
        ),
      ),
    );

    // print(find.byKey(const ValueKey('multiDayExpand')).evaluate().length);

    // Verify that the events are laid out correctly
    expect(find.byKey(const ValueKey(1)), findsOneWidget);
    expect(find.byKey(const ValueKey(2)), findsOneWidget);
    // This should be hidden as it exceeds the max number of vertical events.
    expect(find.byKey(const ValueKey(3)), findsNothing);
    // Verify that only one expand 
    // expect(find.byKey(const ValueKey('multiDayExpand')), findsOneWidget);
  });

  // testWidgets('DayEventsWidget lays out events correctly', (tester) async {
  //   final calendarController = CalendarController<int>();
  //   final configuration = MultiDayBodyConfiguration();
  //   final interaction = ValueNotifier(CalendarInteraction());
  //   // The range to display in the DayEventsWidget.
  //   final displayRange = start.asUtc.startOfDay.weekRange;

  //   /// The time of day range to display in the DayEventsWidget.
  //   final timeOfDayRange = TimeOfDayRange.allDay();

  //   // Build the DayEventsWidget
  //   await tester.pumpWidget(
  //     wrapWithMaterialApp(
  //       DayEventsWidget<int>(
  //         eventsController: eventsController,
  //         controller: calendarController,
  //         callbacks: null,
  //         tileComponents: TileComponents<int>(
  //           tileBuilder: (event, tileRange) => Container(
  //             key: ValueKey(event.data!),
  //             child: Text(event.data.toString()),
  //           ),
  //         ),
  //         configuration: configuration,
  //         dayWidth: 100,
  //         heightPerMinute: 1,
  //         visibleDateTimeRange: displayRange,
  //         timeOfDayRange: timeOfDayRange,
  //         interaction: interaction,
  //       ),
  //     ),
  //   );

  //   // Verify that the events are laid out correctly
  //   expect(find.byKey(const ValueKey(1)), findsOneWidget);
  //   expect(find.byKey(const ValueKey(2)), findsOneWidget);
  //   expect(find.byKey(const ValueKey(3)), findsOneWidget);

  //   // Verify the positions of the events
  //   final event1Finder = find.byKey(const ValueKey(1));
  //   final event2Finder = find.byKey(const ValueKey(2));
  //   final event3Finder = find.byKey(const ValueKey(3));

  //   final event1TopLeft = tester.getTopLeft(event1Finder);
  //   final event2TopLeft = tester.getTopLeft(event2Finder);
  //   final event3TopLeft = tester.getTopLeft(event3Finder);

  //   // We expect that event 1 and 2 start at the same position.
  //   expect(event1TopLeft.dy, equals(event2TopLeft.dy));
  //   // We expect that event 3 is is to the right of event 1 and 2.
  //   expect(event1TopLeft.dx, lessThan(event3TopLeft.dx));
  //   expect(event2TopLeft.dx, lessThan(event3TopLeft.dx));

  //   final event1BottomRight = tester.getBottomRight(event1Finder);
  //   final event2BottomRight = tester.getBottomRight(event2Finder);
  //   final event3BottomRight = tester.getBottomRight(event3Finder);

  //   // We expect that the second event extends further down the screen than the first event.
  //   expect(event1BottomRight.dy, lessThan(event2BottomRight.dy));

  //   // We expect that the third event extends further down the screen than the first and second events.
  //   expect(event1BottomRight.dy, lessThan(event3BottomRight.dy));
  //   expect(event2BottomRight.dy, lessThan(event3BottomRight.dy));
  // });
}
