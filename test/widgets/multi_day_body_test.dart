// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart' show DayEventTile;

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  late KalenderCallbacks callbacks;
  late String eventId;

  final start = DateTime(2025, 3, 24);
  final dateTimeRange = KalenderDateTimeRange(start: start, end: DateTime(2025, 3, 31));
  final singleDay = MultiDayViewConfiguration.singleDay(
    initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
    initialHeightPerMinute: 1,
    displayRange: dateTimeRange,
    initialDateTime: start,
  );

  final components = TileComponents(
    tileBuilder: (context, event, tileRange) => Container(key: ValueKey(event.id), color: Colors.red),
  );

  setUp(() {
    eventsController = DefaultEventsController();
    callbacks = KalenderCallbacks(
      onEventCreated: eventsController.addEvent,
      onEventChanged: (event, updatedEvent) => eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
    );
    eventId = eventsController.addEvent(KalenderEvent(start: start.copyWith(hour: 6), end: start.copyWith(hour: 8)));
  });

  Future<void> pumpCalendarView(
    WidgetTester tester,
    MultiDayViewConfiguration viewConfiguration, {
    KalenderInteraction? interaction,
  }) {
    kalenderController = KalenderController(viewConfiguration: viewConfiguration);
    return pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      callbacks: callbacks,
      views: [
        MultiDayViewParts(
          header: const SizedBox.shrink(),
          body: MultiDayBody(interaction: interaction, tileComponents: components),
        ),
      ],
    );
  }

  group('MultiDayBody', () {
    group('Gesture Tests', () {
      final viewConfigurations = [
        singleDay,
        MultiDayViewConfiguration.week(
          initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
        MultiDayViewConfiguration.week(
          firstDayOfWeek: DateTime.monday,
          timeOfDayRange: KalenderTimeRange(
            start: const KalenderTime(hour: 5, minute: 0),
            end: const KalenderTime(hour: 23, minute: 59),
          ),
          initialTimeOfDay: const KalenderTime(hour: 5, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: dateTimeRange,
          initialDateTime: start,
        ),
      ];

      for (final viewConfiguration in viewConfigurations) {
        testWidgets('Event resize - ${viewConfiguration.name}', (tester) async {
          await pumpCalendarView(tester, viewConfiguration, interaction: kPreciseInteraction);

          final gesture = await tester.createMouseGesture();

          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          await tester.hoverOn(dayEventTile, gesture);
          final topResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(ResizeDetector.startResizeDraggableKey(eventId)),
          );
          expect(topResizeHandle, findsOneWidget);
          final bottomResizeHandle = find.descendant(
            of: dayEventTile,
            matching: find.byKey(ResizeDetector.endResizeDraggableKey(eventId)),
          );

          final initialSize = tester.getSize(dayEventTile);
          final initialTopLeft = tester.getTopLeft(dayEventTile);
          final initialBottomRight = tester.getBottomRight(dayEventTile);

          await tester.dragFrom(tester.getCenter(bottomResizeHandle), const Offset(0, 50));
          await tester.pumpAndSettle();

          expect(tester.getSize(dayEventTile).height, greaterThan(initialSize.height));
          expect(tester.getTopLeft(dayEventTile), initialTopLeft);
          expect(tester.getBottomRight(dayEventTile).dy, greaterThan(initialBottomRight.dy));
        });

        testWidgets('Event reschedule - ${viewConfiguration.name}', (tester) async {
          await pumpCalendarView(tester, viewConfiguration, interaction: kPreciseInteraction);

          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          final rescheduleDraggable = find.descendant(
            of: dayEventTile,
            matching: find.byKey(DayEventTile.rescheduleDraggableKey(eventId)),
          );

          final initialPosition = tester.getCenter(dayEventTile);

          await tester.drag(rescheduleDraggable, const Offset(0, 50));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(tester.getCenter(dayEventTile), isNot(initialPosition));
        });

        testWidgets('New event - ${viewConfiguration.name}', (tester) async {
          await pumpCalendarView(tester, viewConfiguration, interaction: kPreciseInteraction);

          final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
          final newEventStart = tester.getBottomLeft(dayEventTile) + const Offset(0, 25);
          await tester.dragFrom(newEventStart, const Offset(0, 100));
          await tester.pumpAndSettle();

          expect(eventsController.events.length, 2);
        });
      }

      // The handle's left edge is the column boundary, so -20 crosses it unless the drag anchors to the pointer.
      testWidgets('bottom-handle resize with a small horizontal drift keeps the event on its day', (tester) async {
        // A middle day, so the event has a column on either side.
        final weekConfiguration = viewConfigurations[1];
        final id = eventsController.addEvent(
          KalenderEvent(
            start: start.copyWith(day: start.day + 2, hour: 10),
            end: start.copyWith(day: start.day + 2, hour: 12),
          ),
        );

        await pumpCalendarView(tester, weekConfiguration, interaction: kPreciseInteraction);

        final tile = find.byKey(DayEventTile.tileKey(id));
        final gesture = await tester.createMouseGesture();
        await tester.hoverOn(tile, gesture);

        final bottomHandle = find.descendant(of: tile, matching: find.byKey(ResizeDetector.endResizeDraggableKey(id)));

        final before = eventsController.events.firstWhere((event) => event.id == id).dateTimeRange;

        await tester.dragFrom(tester.getCenter(bottomHandle), const Offset(-20, 40));
        await tester.pumpAndSettle();

        final after = eventsController.events.firstWhere((event) => event.id == id).dateTimeRange;
        // Compare instants: the stored range is in UTC, so the local and UTC day differ in far-east timezones.
        expect(
          after.start.isAtSameMomentAs(before.start),
          isTrue,
          reason: 'a bottom resize leaves the start where it was; it must not flip to another day',
        );
        expect(after.end.isAfter(before.end), isTrue, reason: 'the end should extend downward');
      });
    });

    group('Imprecise Gesture Tests', () {
      final impreciseInteraction = KalenderInteraction(
        inputMode: InputMode.imprecise,
        createEventGesture: EventInteractionGesture.longPress,
        modifyEventGesture: EventInteractionGesture.longPress,
      );

      testWidgets('Event resize via selection - ${singleDay.name}', (tester) async {
        await pumpCalendarView(tester, singleDay, interaction: impreciseInteraction);

        final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));

        expect(
          find.descendant(of: dayEventTile, matching: find.byKey(ResizeDetector.endResizeDraggableKey(eventId))),
          findsNothing,
        );

        final event = eventsController.events.firstWhere((e) => e.id == eventId);
        kalenderController.selectEvent(event);
        await tester.pumpAndSettle();

        final bottomResizeHandle = find.descendant(
          of: dayEventTile,
          matching: find.byKey(ResizeDetector.endResizeDraggableKey(eventId)),
        );

        final initialBottomRight = tester.getBottomRight(dayEventTile);

        await tester.dragFrom(tester.getCenter(bottomResizeHandle), const Offset(0, 50));
        await tester.pumpAndSettle();

        expect(tester.getBottomRight(dayEventTile).dy, greaterThan(initialBottomRight.dy));
      });

      testWidgets('Event reschedule via long-press drag - ${singleDay.name}', (tester) async {
        await pumpCalendarView(tester, singleDay, interaction: impreciseInteraction);

        final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
        final initialPosition = tester.getCenter(dayEventTile);

        await tester.longPressDragWidget(dayEventTile, const Offset(0, 50));

        expect(tester.getCenter(dayEventTile), isNot(initialPosition));
      });

      testWidgets('New event via long-press drag - ${singleDay.name}', (tester) async {
        await pumpCalendarView(tester, singleDay, interaction: impreciseInteraction);

        final dayEventTile = find.byKey(DayEventTile.tileKey(eventId));
        final newEventStart = tester.getBottomLeft(dayEventTile) + const Offset(0, 25);
        await tester.longPressDrag(newEventStart, const Offset(0, 100));

        expect(eventsController.events.length, 2);
      });
    });

    group('Day Separator Tests', () {
      final viewConfigurations = [
        MultiDayViewConfiguration.singleDay(),
        MultiDayViewConfiguration.week(),
        MultiDayViewConfiguration.workWeek(),
        MultiDayViewConfiguration.freeScroll(numberOfDays: 2),
        MultiDayViewConfiguration.freeScroll(numberOfDays: 3),
      ];

      for (final viewConfiguration in viewConfigurations) {
        testWidgets('Day Separator - ${viewConfiguration.name}', (tester) async {
          await pumpCalendarView(tester, viewConfiguration);
          final expectedCount = viewConfiguration.type == MultiDayViewType.freeScroll
              ? viewConfiguration.numberOfDays
              : viewConfiguration.numberOfDays + 1;
          expect(find.byType(DaySeparator), findsNWidgets(expectedCount));
        });
      }
    });
  });
}
