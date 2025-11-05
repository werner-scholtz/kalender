import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions/internal.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart';

import 'utilities.dart';

void main() {
  final start = DateTime(2025, 3, 24);

  final events = [
    CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: start.copyWith(hour: start.hour - 1),
        end: start.copyWith(hour: start.hour + 1),
      ),
      data: 1,
    ),
    CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: start,
        end: start.copyWith(hour: start.hour + 2),
      ),
      data: 2,
    ),
    CalendarEvent(
      dateTimeRange: DateTimeRange(
        start: start.copyWith(day: start.day + 1),
        end: start.copyWith(day: start.day + 1, hour: start.hour + 3),
      ),
      data: 3,
    ),
  ];

  // Create the necessary controllers
  final eventsController = DefaultEventsController<int>()..addEvents(events);

  testWidgets('DayEventsWidget lays out events correctly', (tester) async {
    final calendarController = CalendarController<int>();
    final viewController = MultiDayViewController<int>(
      viewConfiguration: MultiDayViewConfiguration.singleDay(),
      visibleDateTimeRange: ValueNotifier<DateTimeRange>(
        DateTimeRange(start: start.startOfDay, end: start.endOfDay),
      ),
      visibleEvents: ValueNotifier({}),
    );
    calendarController.attach(viewController);

    const configuration = MultiDayBodyConfiguration();
    // The range to display in the DayEventsWidget.
    final displayRange = start.asUtc.startOfDay.weekRange();

    // Build the DayEventsWidget
    await tester.pumpWidget(
      wrapWithMaterialApp(
        TestProvider(
          calendarController: calendarController,
          eventsController: eventsController,
          tileComponents: TileComponents<int>(
            tileBuilder: (event, tileRange) => Container(
              key: ValueKey(event.data!),
              child: Text(event.data.toString()),
            ),
          ),
          child: SizedBox(
            width: 700,
            child: MultiDayEventsRow<int>(
              configuration: configuration,
              visibleDateTimeRange: displayRange,
              viewController: viewController,
            ),
          ),
        ),
      ),
    );

    // Verify that the events are laid out correctly
    expect(find.byKey(const ValueKey(1)), findsOneWidget);
    expect(find.byKey(const ValueKey(2)), findsOneWidget);
    expect(find.byKey(const ValueKey(3)), findsOneWidget);

    // Verify the positions of the events
    final event1Finder = find.byKey(const ValueKey(1));
    final event2Finder = find.byKey(const ValueKey(2));
    final event3Finder = find.byKey(const ValueKey(3));

    final event1TopLeft = tester.getTopLeft(event1Finder);
    final event2TopLeft = tester.getTopLeft(event2Finder);
    final event3TopLeft = tester.getTopLeft(event3Finder);

    // We expect that event 1 and 2 start at the same position.
    expect(event1TopLeft.dy, equals(event2TopLeft.dy));
    // We expect that event 3 is is to the right of event 1 and 2.
    expect(event1TopLeft.dx, lessThan(event3TopLeft.dx));
    expect(event2TopLeft.dx, lessThan(event3TopLeft.dx));

    final event1BottomRight = tester.getBottomRight(event1Finder);
    final event2BottomRight = tester.getBottomRight(event2Finder);
    final event3BottomRight = tester.getBottomRight(event3Finder);

    // We expect that the second event extends further down the screen than the first event.
    expect(event1BottomRight.dy, lessThan(event2BottomRight.dy));

    // We expect that the third event extends further down the screen than the first and second events.
    expect(event1BottomRight.dy, lessThan(event3BottomRight.dy));
    expect(event2BottomRight.dy, lessThan(event3BottomRight.dy));
  });
}
