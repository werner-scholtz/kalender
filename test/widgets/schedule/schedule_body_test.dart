import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';

import '../../utilities.dart';

/// Regression coverage for the continuous schedule view:
///
///   * Row alignment — every event tile shares one leading (date) column width,
///     so first-of-day rows (which show the date) line up with the rows below
///     them (which don't). Previously the date widget's intrinsic width and a
///     hardcoded `SizedBox(width: 32)` placeholder disagreed.
///   * #253 — when today has no events, `initialScrollIndex` /
///     `animateToDateTime(now)` landed on the first item instead of today / the
///     nearest day, and `initialScrollIndex` polluted the date→index map.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  // A one-hour event at [hour] on [day].
  CalendarEvent eventAt(DateTime day, int hour) => CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(day.year, day.month, day.day, hour),
          end: DateTime(day.year, day.month, day.day, hour + 1),
        ),
      );

  CalendarView buildSchedule({
    EmptyDayBehavior emptyDay = EmptyDayBehavior.showOnlyToday,
    double leadingWidth = kDefaultScheduleLeadingWidth,
    NowCallback? nowCallback,
    DateTime? initialDate,
    Location? location,
  }) {
    return CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      location: location,
      viewConfiguration: ScheduleViewConfiguration.continuous(
        displayRange: DateTimeRange(start: DateTime(2025), end: DateTime(2026)),
        initialDateTime: initialDate,
        nowCallback: nowCallback,
      ),
      body: CalendarBody(
        scheduleBodyConfiguration: ScheduleBodyConfiguration(emptyDay: emptyDay, leadingWidth: leadingWidth),
      ),
    );
  }

  ScheduleViewController schedule() => calendarController.viewController as ScheduleViewController;

  double tileLeft(WidgetTester tester, String id) =>
      tester.getTopLeft(find.byKey(ScheduleEventTile.tileKey(id))).dx;

  group('Row alignment', () {
    testWidgets('event tiles on the same day share one left edge', (tester) async {
      final ids = eventsController.addEvents([
        eventAt(DateTime(2025, 1, 15), 9),
        eventAt(DateTime(2025, 1, 15), 11),
        eventAt(DateTime(2025, 1, 15), 13),
      ]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(initialDate: DateTime(2025, 1, 15), nowCallback: () => DateTime(2025, 1, 15, 10)),
      );

      // The first row shows the date, the rest don't — they must still line up.
      final first = tileLeft(tester, ids[0]);
      expect(tileLeft(tester, ids[1]), moreOrLessEquals(first, epsilon: 0.5));
      expect(tileLeft(tester, ids[2]), moreOrLessEquals(first, epsilon: 0.5));
    });

    testWidgets('leadingWidth widens the leading column by exactly its delta', (tester) async {
      final ids = eventsController.addEvents([eventAt(DateTime(2025, 1, 15), 9)]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(initialDate: DateTime(2025, 1, 15), nowCallback: () => DateTime(2025, 1, 15, 10), leadingWidth: 56),
      );
      final narrow = tileLeft(tester, ids.first);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(initialDate: DateTime(2025, 1, 15), nowCallback: () => DateTime(2025, 1, 15, 10), leadingWidth: 120),
      );
      final wide = tileLeft(tester, ids.first);

      expect(wide - narrow, moreOrLessEquals(64, epsilon: 1));
    });
  });

  group('No events today (#253)', () {
    testWidgets('showOnlyToday indexes today, so it is the scroll target', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 1, 10), 9), eventAt(DateTime(2025, 1, 20), 9)]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(
          emptyDay: EmptyDayBehavior.showOnlyToday,
          initialDate: DateTime(2025, 1, 15),
          nowCallback: () => DateTime(2025, 1, 15, 10),
        ),
      );

      final controller = schedule();
      final todayIndex = controller.indexFromDateTime(DateTime(2025, 1, 15));
      expect(todayIndex, isNotNull, reason: "today's empty row must be indexed");
      expect(controller.item(todayIndex!), isA<EmptyItem>());
      expect(controller.dateTimeFromIndex(todayIndex)!.isSameDay(InternalDateTime(2025, 1, 15)), isTrue);
      expect(controller.initialScrollIndex(DateTime(2025, 1, 15)), todayIndex);

      // Only today is shown among empty days.
      expect(controller.indexFromDateTime(DateTime(2025, 1, 11)), isNull);
    });

    testWidgets('hide: closest picks the nearer past day, not the earliest', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 1, 14), 9), eventAt(DateTime(2025, 1, 18), 9)]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(
          emptyDay: EmptyDayBehavior.hide,
          initialDate: DateTime(2025, 1, 15),
          nowCallback: () => DateTime(2025, 1, 15, 10),
        ),
      );

      final controller = schedule();
      final index = controller.closestIndex(DateTime(2025, 1, 15));
      expect(
        controller.dateTimeFromIndex(index)!.isSameDay(InternalDateTime(2025, 1, 14)),
        isTrue,
        reason: 'Jan 14 is 1 day away, Jan 18 is 3 — the nearer one wins',
      );
    });

    testWidgets('hide: closest picks the nearer future day', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 1, 12), 9), eventAt(DateTime(2025, 1, 16), 9)]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(
          emptyDay: EmptyDayBehavior.hide,
          initialDate: DateTime(2025, 1, 15),
          nowCallback: () => DateTime(2025, 1, 15, 10),
        ),
      );

      final controller = schedule();
      final index = controller.closestIndex(DateTime(2025, 1, 15));
      expect(
        controller.dateTimeFromIndex(index)!.isSameDay(InternalDateTime(2025, 1, 16)),
        isTrue,
        reason: 'Jan 16 is 1 day away, Jan 12 is 3 — the nearer one wins',
      );
    });

    testWidgets('closest clamps to the first/last day for out-of-range targets', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 6, 10), 9), eventAt(DateTime(2025, 6, 20), 9)]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(emptyDay: EmptyDayBehavior.hide, initialDate: DateTime(2025, 6, 15)),
      );

      final controller = schedule();
      final earliest = controller.closestIndex(DateTime(2025, 1, 1));
      expect(controller.dateTimeFromIndex(earliest)!.isSameDay(InternalDateTime(2025, 6, 10)), isTrue);

      final latest = controller.closestIndex(DateTime(2025, 12, 31));
      expect(controller.dateTimeFromIndex(latest)!.isSameDay(InternalDateTime(2025, 6, 20)), isTrue);
    });

    testWidgets('initialScrollIndex does not pollute the date→index map', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 1, 10), 9), eventAt(DateTime(2025, 1, 20), 9)]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(
          emptyDay: EmptyDayBehavior.hide,
          initialDate: DateTime(2025, 1, 15),
          nowCallback: () => DateTime(2025, 1, 15, 10),
        ),
      );

      final controller = schedule();
      // The build already resolved initialScrollIndex(Jan 15); it must not have
      // written a fallback index back into the authoritative map.
      expect(controller.indexFromDateTime(DateTime(2025, 1, 15)), isNull);
      controller.initialScrollIndex(DateTime(2025, 1, 15));
      expect(controller.indexFromDateTime(DateTime(2025, 1, 15)), isNull);
    });
  });
}
