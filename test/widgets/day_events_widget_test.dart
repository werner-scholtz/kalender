// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/events_widgets/day_events_widget.dart';

import '../utilities.dart';

void main() {
  final start = DateTime(2025, 3, 24);
  final floatingStart = FloatingDateTime.fromDateTime(start);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  late MultiDayViewController viewController;

  late List<KalenderEvent> events;

  setUp(() {
    events = [
      // 23:00 the day before to 01:00.
      KalenderEvent(
        start: start.copyWith(hour: start.hour - 1),
        end: start.copyWith(hour: start.hour + 1),
      ),
      KalenderEvent(
        start: start,
        end: start.copyWith(hour: start.hour + 2),
      ),
      KalenderEvent(
        start: start.copyWith(day: start.day + 1),
        end: start.copyWith(day: start.day + 1, hour: start.hour + 3),
      ),
    ];

    eventsController = DefaultEventsController()..addEvents(events);
    kalenderController = KalenderController();
    viewController = MultiDayViewController(
      viewConfiguration: MultiDayViewConfiguration.singleDay(),
      floatingVisibleRange: ValueNotifier(
        FloatingDateTimeRange(start: floatingStart.startOfDay, end: floatingStart.endOfDay),
      ),
      visibleEvents: ValueNotifier({}),
      initial: ViewSnapshot(date: FloatingDateTime.fromDateTime(DateTime.now())),
    );
    kalenderController.attach(viewController);
  });

  Future<void> pumpEventsRow(WidgetTester tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        TestProvider(
          kalenderController: kalenderController,
          eventsController: eventsController,
          tileComponents: TileComponents(
            tileBuilder: (context, event, tileRange) =>
                Container(key: ValueKey(event.id), child: Text(event.id.toString())),
          ),
          child: SizedBox(
            width: 700,
            child: MultiDayEventsRow(
              configuration: const MultiDayBodyConfiguration(),
              floatingRange: floatingStart.startOfDay.weekRange(),
              viewController: viewController,
              pageHeight: 0.7 * Duration.minutesPerDay,
            ),
          ),
        ),
      ),
    );
  }

  Finder eventFinder(int index) => find.byKey(ValueKey(events[index].id));

  group('Layout', () {
    testWidgets('renders all events', (tester) async {
      await pumpEventsRow(tester);

      for (var i = 0; i < events.length; i++) {
        expect(eventFinder(i), findsOneWidget);
      }
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

  group('Edge cases', () {
    testWidgets('renders with no events', (tester) async {
      eventsController.clearEvents();
      await pumpEventsRow(tester);

      expect(find.byType(MultiDayEventsRow), findsOneWidget);
    });

    final singleEvents = [
      (name: 'single event', event: KalenderEvent(start: start, end: start.copyWith(hour: 4))),
      (
        name: 'short event (15 min)',
        event: KalenderEvent(start: start.copyWith(hour: 10), end: start.copyWith(hour: 10, minute: 15)),
      ),
    ];

    for (final c in singleEvents) {
      testWidgets('renders a ${c.name}', (tester) async {
        eventsController.clearEvents();
        eventsController.addEvent(c.event);

        await pumpEventsRow(tester);

        expect(tester.getSize(find.byKey(ValueKey(c.event.id))).height, greaterThan(0));
      });
    }
  });

  group('Dynamic updates', () {
    testWidgets('adding an event updates the widget', (tester) async {
      await pumpEventsRow(tester);

      final newEvent = KalenderEvent(start: start.copyWith(hour: 5), end: start.copyWith(hour: 7));
      eventsController.addEvent(newEvent);
      events.add(newEvent);
      await tester.pump();

      expect(eventFinder(3), findsOneWidget);
    });

    testWidgets('removing an event updates the widget', (tester) async {
      await pumpEventsRow(tester);

      final eventToRemove = events[0];
      eventsController.removeEvent(eventToRemove);
      await tester.pump();

      expect(find.byKey(ValueKey(eventToRemove.id)), findsNothing);
    });

    testWidgets('clearing all events updates the widget', (tester) async {
      await pumpEventsRow(tester);

      eventsController.clearEvents();
      await tester.pump();

      for (var i = 0; i < events.length; i++) {
        expect(eventFinder(i), findsNothing);
      }
    });
  });

  group('Column keys', () {
    testWidgets('each day column has a unique key', (tester) async {
      await pumpEventsRow(tester);

      final weekRange = floatingStart.startOfDay.weekRange();
      var currentDate = weekRange.start;
      while (currentDate.isBefore(weekRange.end)) {
        final key = MultiDayEventsRow.columnKey(currentDate);
        expect(find.byKey(key), findsOneWidget);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    });
  });
}
