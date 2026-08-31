import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart';

import '../../utilities.dart';

/// Rescheduling in the schedule view, which is a list of day rows rather than a
/// grid, so a drop carries a day and no time of day.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  final displayRange = DateTimeRange(start: DateTime(2025, 6), end: DateTime(2025, 7));

  final interaction = CalendarInteraction(
    allowRescheduling: true,
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  String addEvent(DateTime start, Duration duration) {
    return eventsController
        .addEvent(CalendarEvent(dateTimeRange: DateTimeRange(start: start, end: start.add(duration))));
  }

  Future<void> pumpSchedule(
    WidgetTester tester, {
    CalendarCallbacks? callbacks,
    bool paginated = false,
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        callbacks: callbacks,
        viewConfiguration: paginated
            ? ScheduleViewConfiguration.paginated(displayRange: displayRange, initialDateTime: DateTime(2025, 6, 2))
            : ScheduleViewConfiguration.continuous(displayRange: displayRange, initialDateTime: DateTime(2025, 6, 2)),
        body: CalendarBody(
          interaction: interaction,
          scheduleBodyConfiguration: ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.show),
        ),
      ),
    );
  }

  ScheduleViewController schedule() => calendarController.viewController! as ScheduleViewController;

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

    final preview = calendarController.selectedEvent.value;
    expect(preview, isNotNull, reason: 'the schedule should preview a reschedule while the drag is held');
    expect(preview!.start.isAfter(original.start), isTrue, reason: 'the preview should follow the cursor down');

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the highlighted range follows the drag and clears on drop', (tester) async {
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
    await pumpSchedule(tester);

    expect(schedule().highlightedDateTimeRange.value, isNull, reason: 'nothing is highlighted before a drag');

    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
    final highlighted = schedule().highlightedDateTimeRange.value;
    expect(highlighted, isNotNull, reason: 'the row under the cursor should be highlighted');
    expect(highlighted!.duration, equals(const Duration(hours: 1)), reason: 'the highlight spans the event duration');

    await gesture.up();
    await tester.pumpAndSettle();
    expect(schedule().highlightedDateTimeRange.value, isNull, reason: 'the drop should clear the highlight');
  });

  testWidgets('dropping commits the new date', (tester) async {
    CalendarEvent? changed;
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
    await pumpSchedule(tester, callbacks: CalendarCallbacks(onEventChanged: (_, updated) => changed = updated));

    final originalStart = eventsController.byId(id)!.start;
    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(changed, isNotNull, reason: 'releasing over a day row should commit, not snap back');
    expect(changed!.start.isAfter(originalStart), isTrue, reason: 'a downward drag moves the event forward');
  });

  testWidgets('a drop keeps the time of day of the event', (tester) async {
    // The schedule view has no time axis, so a drop carries only a date. The
    // event takes that date and keeps 09:00, the way the multi-day header does.
    CalendarEvent? changed;
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
    await pumpSchedule(tester, callbacks: CalendarCallbacks(onEventChanged: (_, updated) => changed = updated));

    final original = eventsController.byId(id)!;
    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
    await gesture.up();
    await tester.pumpAndSettle();

    final start = changed!.start.toLocal();
    final originalStart = original.start.toLocal();
    expect(start.hour, originalStart.hour, reason: 'the hour is kept');
    expect(start.minute, originalStart.minute, reason: 'the minute is kept');
    expect(start.isAfter(originalStart), isTrue, reason: 'the drag moved the event to a later day');
    expect(changed!.duration, equals(const Duration(hours: 1)), reason: 'the duration is kept');
  });

  testWidgets('a multi-day event keeps its duration across a drop', (tester) async {
    CalendarEvent? changed;
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(days: 2));
    await pumpSchedule(tester, callbacks: CalendarCallbacks(onEventChanged: (_, updated) => changed = updated));

    final original = eventsController.byId(id)!;
    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)).first, 120);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(changed, isNotNull);
    expect(changed!.duration, equals(original.duration), reason: 'a multi-day event should not be resized by a move');
  });

  testWidgets('dragging away from the schedule clears the highlighted range', (tester) async {
    final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
    await pumpSchedule(tester);

    final gesture = await dragDownBy(tester, find.byKey(ScheduleEventTile.tileKey(id)), 120);
    expect(schedule().highlightedDateTimeRange.value, isNotNull);

    // Off the drag target entirely, which is a leave rather than a drop.
    await gesture.moveTo(const Offset(-50, -50));
    await tester.pumpAndSettle();
    expect(schedule().highlightedDateTimeRange.value, isNull, reason: 'leaving should clear the highlight');

    await gesture.up();
    await tester.pumpAndSettle();
  });

  group('navigation triggers', () {
    /// Drags [tile] to [target] in steps, so the trigger registers a drag-enter
    /// and starts its timer, then holds long enough for it to fire.
    Future<TestGesture> holdAt(WidgetTester tester, Finder tile, Offset target) async {
      final center = tester.getCenter(tile);
      final gesture = await tester.startGesture(center);
      await tester.pump();
      await gesture.moveTo(Offset(center.dx, (center.dy + target.dy) / 2));
      await tester.pump();
      await gesture.moveTo(target);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pump(const Duration(milliseconds: 250));
      return gesture;
    }

    int firstVisibleIndex() => schedule().itemPositionsListener!.itemPositions.value.map((p) => p.index).reduce(min);

    testWidgets('holding a drag at the bottom edge scrolls the schedule down', (tester) async {
      final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
      await pumpSchedule(tester);

      final before = firstVisibleIndex();
      final size = tester.getSize(find.byType(KalenderView));
      final gesture = await holdAt(
        tester,
        find.byKey(ScheduleEventTile.tileKey(id)),
        Offset(size.width / 2, size.height - 4),
      );

      expect(firstVisibleIndex(), greaterThan(before), reason: 'the bottom edge should scroll the list on');

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('holding a drag at the top edge scrolls the schedule back', (tester) async {
      addEvent(DateTime(2025, 6, 15, 9), const Duration(hours: 1));
      // Two rows below the top of the viewport, so the drag starts outside the
      // trigger band and entering it registers.
      final id = addEvent(DateTime(2025, 6, 17, 9), const Duration(hours: 1));
      await pumpSchedule(tester);
      calendarController.jumpToDate(DateTime(2025, 6, 15));
      await tester.pumpAndSettle();

      final before = firstVisibleIndex();
      final gesture = await holdAt(
        tester,
        find.byKey(ScheduleEventTile.tileKey(id)),
        Offset(tester.getSize(find.byType(KalenderView)).width / 2, 4),
      );

      expect(firstVisibleIndex(), lessThan(before), reason: 'the top edge should scroll the list back');

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('the paginated schedule offers page triggers while dragging', (tester) async {
      final id = addEvent(DateTime(2025, 6, 2, 9), const Duration(hours: 1));
      await pumpSchedule(tester, paginated: true);

      expect(find.byType(CursorNavigationTrigger), findsNothing, reason: 'no triggers before a drag starts');

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
