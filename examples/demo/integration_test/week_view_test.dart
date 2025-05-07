import 'package:demo/data/event.dart';
import 'package:demo/widgets/navigation_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo/main.dart';
import 'package:kalender/kalender.dart';

enum EventRanges {
  range1,
  range2,
  range3,
  range4,
  range5,
  ;

  DateTimeRange range(DateTime date) {
    switch (this) {
      case EventRanges.range1:
        return DateTimeRange(start: date.copyWith(hour: 1), end: date.copyWith(hour: 6));
      case EventRanges.range2:
        return DateTimeRange(start: date.copyWith(hour: 2), end: date.copyWith(hour: 8));
      case EventRanges.range3:
        return DateTimeRange(start: date.copyWith(hour: 10), end: date.copyWith(hour: 12));
      case EventRanges.range4:
        return DateTimeRange(start: date.copyWith(hour: 12), end: date.copyWith(hour: 15));
      case EventRanges.range5:
        return DateTimeRange(start: date.copyWith(hour: 15), end: date.copyWith(hour: 20));
    }
  }
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final today = DateTime.now().startOfDay;
  final start = today.copyWith(year: today.year - 1);
  final end = today.copyWith(year: today.year + 1);
  final displayRange = DateTimeRange(start: start, end: end);
  final dates = displayRange.dates();
  final numberOfDays = dates.length;

  testWidgets('Calender perf test', (tester) async {
    await tester.pumpWidget(App(calendarDisplayRange: displayRange));

    final nextPageButton = find.byKey(NavigationHeader.nextPageKey);
    final previousPageButton = find.byKey(NavigationHeader.previousPageKey);

    final appState = tester.state<AppState>(find.byType(App));
    // Add some events to the calendar.
    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range1.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await binding.traceAction(
      () async {
        for (var i = 0; i < 25; i++) {
          // Navigate to the previous page.
          await tester.tap(previousPageButton);
          await tester.pumpAndSettle();
        }

        for (var i = 0; i < 25; i++) {
          // Navigate to the previous page.
          await tester.tap(nextPageButton);
          await tester.pumpAndSettle();
        }
      },
      reportKey: 'one_event_timeline',
    );

    await tester.pumpAndSettle();

    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range2.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );
    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range3.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );
    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range4.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );
    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range5.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );
    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range1.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );
    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range2.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );
    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range3.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );
    appState.eventsController.addEvents(
      List.generate(
        numberOfDays,
        (i) => CalendarEvent(
          dateTimeRange: EventRanges.range4.range(dates[i]),
          data: Event(title: 'item_$i', description: 'item_$i'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await binding.traceAction(
      () async {
        for (var i = 0; i < 25; i++) {
          // Navigate to the previous page.
          await tester.tap(previousPageButton);
          await tester.pumpAndSettle();
        }

        for (var i = 0; i < 25; i++) {
          // Navigate to the previous page.
          await tester.tap(nextPageButton);
          await tester.pumpAndSettle();
        }
      },
      reportKey: 'ten_event_timeline',
    );
  });
}
