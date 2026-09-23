// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart';

import '../../utilities.dart';

/// Rescheduling in the schedule view, which is a list of day rows rather than a
/// grid, so a drop carries a day and no time of day.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  final displayRange = KalenderDateTimeRange(start: DateTime(2025, 6), end: DateTime(2025, 7));

  setUp(() {
    eventsController = DefaultEventsController();
  });

  String addEvent(DateTime start, Duration duration) {
    return eventsController.addEvent(KalenderEvent(start: start, end: start.add(duration)));
  }

  Future<void> pumpSchedule(WidgetTester tester, {KalenderCallbacks? callbacks, bool paginated = false}) {
    kalenderController = KalenderController(
      viewConfiguration: paginated
          ? ScheduleViewConfiguration.paginated(displayRange: displayRange, initialDateTime: DateTime(2025, 6, 2))
          : ScheduleViewConfiguration.continuous(displayRange: displayRange, initialDateTime: DateTime(2025, 6, 2)),
    );
    return pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      callbacks: callbacks,
      body: KalenderBody(
        interaction: kPreciseInteraction,
        scheduleBodyConfiguration: ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.show),
      ),
    );
  }

  ScheduleViewController schedule() => kalenderController.viewController as ScheduleViewController;

  /// Picks [tile] up and moves it down by [dy] without releasing.
  Future<TestGesture> dragDownBy(WidgetTester tester, Finder tile, double dy) async {
    final gesture = await tester.startGesture(tester.getCenter(tile));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveBy(Offset(0, dy));
    await tester.pumpAndSettle();
    return gesture;
  }

  testWidgets('dragging a tile onto a later day previews the move', (tester) async {
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
    addEvent(DateTime(2025, 6, 5, 9), const Duration(hours: 1));
    await pumpSchedule(tester);

    final original = eventsController.byId(id)!;
    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);

    final preview = kalenderController.selectedEvent.value;
    expect(preview, isNotNull);
    expect(preview!.start.isAfter(original.start), isTrue);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the highlighted range follows the drag and clears on drop', (tester) async {
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
    await pumpSchedule(tester);

    expect(schedule().highlightedRange.value, isNull);

    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
    final highlighted = schedule().highlightedRange.value;
    expect(highlighted, isNotNull);
    expect(highlighted!.duration, equals(const Duration(hours: 1)));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(schedule().highlightedRange.value, isNull);
  });

  testWidgets('a drop commits the new date and keeps the time of day of the event', (tester) async {
    // The schedule view has no time axis, so a drop carries only a date. The
    // event takes that date and keeps 09:00, the way the multi-day header does.
    KalenderEvent? changed;
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
    await pumpSchedule(tester, callbacks: KalenderCallbacks(onEventChanged: (_, updated) => changed = updated));

    final original = eventsController.byId(id)!;
    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
    await gesture.up();
    await tester.pumpAndSettle();

    final start = changed!.start.toLocal();
    final originalStart = original.start.toLocal();
    expect(start.hour, originalStart.hour, reason: 'the hour is kept');
    expect(start.minute, originalStart.minute, reason: 'the minute is kept');
    expect(start.isAfter(originalStart), isTrue);
    expect(changed!.duration, equals(const Duration(hours: 1)));
  });

  testWidgets('a multi-day event keeps its duration across a drop', (tester) async {
    KalenderEvent? changed;
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(days: 2));
    await pumpSchedule(tester, callbacks: KalenderCallbacks(onEventChanged: (_, updated) => changed = updated));

    final original = eventsController.byId(id)!;
    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)).first, 120);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(changed, isNotNull);
    expect(changed!.duration, equals(original.duration));
  });

  testWidgets('dragging away from the schedule clears the highlighted range', (tester) async {
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
    await pumpSchedule(tester);

    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
    expect(schedule().highlightedRange.value, isNotNull);

    // Off the drag target entirely, which is a leave rather than a drop.
    await gesture.moveTo(const Offset(-50, -50));
    await tester.pumpAndSettle();
    expect(schedule().highlightedRange.value, isNull);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  group('navigation triggers', () {
    int firstVisibleIndex() => schedule().itemPositionsListener!.itemPositions.value.map((p) => p.index).reduce(min);

    testWidgets('holding a drag at the bottom edge scrolls the schedule down', (tester) async {
      final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
      await pumpSchedule(tester);

      final before = firstVisibleIndex();
      final size = tester.getSize(find.byType(KalenderView));
      final gesture = await tester.holdDragAt(
        find.byKey(ScheduleEventTile.tileKey(id)),
        Offset(size.width / 2, size.height - 4),
      );

      expect(firstVisibleIndex(), greaterThan(before));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('holding a drag at the top edge scrolls the schedule back', (tester) async {
      addEvent(DateTime(2025, 6, 15, 9), const Duration(hours: 1));
      // Two rows below the top of the viewport, so the drag starts outside the
      // trigger band and entering it registers.
      final id = addEvent(DateTime(2025, 6, 17, 9), const Duration(hours: 1));
      await pumpSchedule(tester);
      kalenderController.jumpToDate(DateTime(2025, 6, 15));
      await tester.pumpAndSettle();

      final before = firstVisibleIndex();
      final gesture = await tester.holdDragAt(
        find.byKey(ScheduleEventTile.tileKey(id)),
        Offset(tester.getSize(find.byType(KalenderView)).width / 2, 4),
      );

      expect(firstVisibleIndex(), lessThan(before));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('the paginated schedule offers page triggers while dragging', (tester) async {
      final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
      await pumpSchedule(tester, paginated: true);

      expect(find.byType(CursorNavigationTrigger), findsNothing);

      final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
      // Two scroll triggers and two page triggers.
      expect(find.byType(CursorNavigationTrigger), findsNWidgets(4));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('the continuous schedule offers only scroll triggers', (tester) async {
      final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
      await pumpSchedule(tester);

      final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
      // A continuous schedule is not paginated, so the two page triggers are
      // not built and only the top and bottom scroll triggers remain.
      expect(find.byType(CursorNavigationTrigger), findsNWidgets(2));

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
