import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart';

import '../utilities.dart';

void main() {
  final start = DateTime(2025, 3, 24);
  final internalStart = InternalDateTime.fromDateTime(start);

  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late MultiDayViewController viewController;

  /// Standard test events: two overlapping same-day events + one next-day event.
  late List<CalendarEvent> events;

  setUp(() {
    events = [
      // Event 0: 23:00 day before → 01:00 start day (2h, crosses midnight)
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start.copyWith(hour: start.hour - 1),
          end: start.copyWith(hour: start.hour + 1),
        ),
      ),
      // Event 1: 00:00 → 02:00 on start day (2h)
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start,
          end: start.copyWith(hour: start.hour + 2),
        ),
      ),
      // Event 2: 00:00 → 03:00 on next day (3h)
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start.copyWith(day: start.day + 1),
          end: start.copyWith(day: start.day + 1, hour: start.hour + 3),
        ),
      ),
    ];

    eventsController = DefaultEventsController()..addEvents(events);
    calendarController = CalendarController();
    viewController = MultiDayViewController(
      viewConfiguration: MultiDayViewConfiguration.singleDay(),
      visibleDateTimeRange: ValueNotifier(
        InternalDateTimeRange(start: internalStart.startOfDay, end: internalStart.endOfDay),
      ),
      visibleEvents: ValueNotifier({}),
    );
    calendarController.attach(viewController);
  });

  /// Helper to pump a [MultiDayEventsRow] inside the required providers.
  Future<void> pumpEventsRow(
    WidgetTester tester, {
    MultiDayBodyConfiguration configuration = const MultiDayBodyConfiguration(),
    InternalDateTimeRange? range,
    TileComponents? tileComponents,
    double width = 700,
  }) async {
    final displayRange = range ?? InternalDateTimeRange.fromDateTimeRange(internalStart.startOfDay.weekRange());
    final tiles = tileComponents ??
        TileComponents(
          tileBuilder: (event, tileRange) => Container(
            key: ValueKey(event.id),
            child: Text(event.id.toString()),
          ),
        );

    await tester.pumpWidget(
      wrapWithMaterialApp(
        TestProvider(
          calendarController: calendarController,
          eventsController: eventsController,
          tileComponents: tiles,
          child: SizedBox(
            width: width,
            child: MultiDayEventsRow(
              configuration: configuration,
              internalRange: displayRange,
              viewController: viewController,
            ),
          ),
        ),
      ),
    );
  }

  /// Finder for an event tile by index into [events].
  Finder eventFinder(int index) => find.byKey(ValueKey(events[index].id));

  // ---------------------------------------------------------------------------
  // Layout
  // ---------------------------------------------------------------------------
  group('Layout', () {
    testWidgets('renders all events', (tester) async {
      await pumpEventsRow(tester);

      expect(eventFinder(0), findsOneWidget);
      expect(eventFinder(1), findsOneWidget);
      expect(eventFinder(2), findsOneWidget);
    });

    testWidgets('same-day events share vertical start position', (tester) async {
      await pumpEventsRow(tester);

      final top0 = tester.getTopLeft(eventFinder(0)).dy;
      final top1 = tester.getTopLeft(eventFinder(1)).dy;
      expect(top0, equals(top1));
    });

    testWidgets('next-day event is positioned to the right', (tester) async {
      await pumpEventsRow(tester);

      final x0 = tester.getTopLeft(eventFinder(0)).dx;
      final x1 = tester.getTopLeft(eventFinder(1)).dx;
      final x2 = tester.getTopLeft(eventFinder(2)).dx;

      expect(x0, lessThan(x2));
      expect(x1, lessThan(x2));
    });

    testWidgets('longer events extend further down', (tester) async {
      await pumpEventsRow(tester);

      final bottom0 = tester.getBottomRight(eventFinder(0)).dy;
      final bottom1 = tester.getBottomRight(eventFinder(1)).dy;
      final bottom2 = tester.getBottomRight(eventFinder(2)).dy;

      // Event 1 (2h) > Event 0 (2h starting earlier so shorter visible portion)
      expect(bottom0, lessThan(bottom1));
      // Event 2 (3h) > both
      expect(bottom0, lessThan(bottom2));
      expect(bottom1, lessThan(bottom2));
    });
  });

  // ---------------------------------------------------------------------------
  // Empty / single event
  // ---------------------------------------------------------------------------
  group('Edge cases', () {
    testWidgets('renders with no events', (tester) async {
      eventsController.clearEvents();
      await pumpEventsRow(tester);

      // Widget should still render without errors.
      expect(find.byType(MultiDayEventsRow), findsOneWidget);
    });

    testWidgets('renders a single event', (tester) async {
      eventsController.clearEvents();
      final singleEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start,
          end: start.copyWith(hour: 4),
        ),
      );
      eventsController.addEvent(singleEvent);
      events = [singleEvent]; // update local list for finder

      await pumpEventsRow(tester);

      expect(eventFinder(0), findsOneWidget);
    });

    testWidgets('renders short event (15 min)', (tester) async {
      eventsController.clearEvents();
      final shortEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start.copyWith(hour: 10),
          end: start.copyWith(hour: 10, minute: 15),
        ),
      );
      eventsController.addEvent(shortEvent);
      events = [shortEvent];

      await pumpEventsRow(tester);

      expect(eventFinder(0), findsOneWidget);
      // The tile should have a non-zero height (respecting minimumTileHeight).
      final size = tester.getSize(eventFinder(0));
      expect(size.height, greaterThan(0));
    });
  });

  // ---------------------------------------------------------------------------
  // Dynamic updates
  // ---------------------------------------------------------------------------
  group('Dynamic updates', () {
    testWidgets('adding an event updates the widget', (tester) async {
      await pumpEventsRow(tester);

      // Initially 3 events.
      expect(eventFinder(0), findsOneWidget);
      expect(eventFinder(1), findsOneWidget);
      expect(eventFinder(2), findsOneWidget);

      // Add a 4th event on the same day.
      final newEvent = CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: start.copyWith(hour: 5),
          end: start.copyWith(hour: 7),
        ),
      );
      eventsController.addEvent(newEvent);
      events.add(newEvent);
      await tester.pump();

      expect(eventFinder(3), findsOneWidget);
    });

    testWidgets('removing an event updates the widget', (tester) async {
      await pumpEventsRow(tester);

      expect(eventFinder(0), findsOneWidget);

      final eventToRemove = events[0];
      eventsController.removeEvent(eventToRemove);
      await tester.pump();

      expect(find.byKey(ValueKey(eventToRemove.id)), findsNothing);
    });

    testWidgets('clearing all events updates the widget', (tester) async {
      await pumpEventsRow(tester);

      expect(eventFinder(0), findsOneWidget);

      eventsController.clearEvents();
      await tester.pump();

      expect(eventFinder(0), findsNothing);
      expect(eventFinder(1), findsNothing);
      expect(eventFinder(2), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // Column keys
  // ---------------------------------------------------------------------------
  group('Column keys', () {
    testWidgets('each day column has a unique key', (tester) async {
      await pumpEventsRow(tester);

      // The week range starting from March 24 (Monday) should have 7 day columns.
      final weekRange = internalStart.startOfDay.weekRange();
      var currentDate = weekRange.start;
      while (currentDate.isBefore(weekRange.end)) {
        final key = MultiDayEventsRow.columnKey(currentDate);
        expect(find.byKey(key), findsOneWidget);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    });
  });
}
