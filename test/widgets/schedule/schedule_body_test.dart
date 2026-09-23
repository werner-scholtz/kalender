// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/schedule_map.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';

import '../../utilities.dart';

/// Row alignment and the scroll target when today has no events (#253) in the continuous schedule view.
void main() {
  late DefaultEventsController eventsController;
  KalenderController? kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = null;
  });

  // A one-hour event at [hour] on [day].
  KalenderEvent eventAt(DateTime day, int hour) => KalenderEvent(
    start: DateTime(day.year, day.month, day.day, hour),
    end: DateTime(day.year, day.month, day.day, hour + 1),
  );

  KalenderView buildSchedule({
    EmptyDayBehavior emptyDay = EmptyDayBehavior.showOnlyToday,
    double leadingWidth = kDefaultScheduleLeadingWidth,
    NowCallback? nowCallback,
    DateTime? initialDate,
    KalenderComponents? components,
  }) {
    final configuration = ScheduleViewConfiguration.continuous(
      displayRange: KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026)),
      initialDateTime: initialDate ?? DateTime(2025, 1, 15),
      nowCallback: nowCallback ?? () => DateTime(2025, 1, 15, 10),
    );
    final controller = kalenderController ??= KalenderController(viewConfiguration: configuration);
    controller.viewConfiguration = configuration;
    return KalenderView(
      eventsController: eventsController,
      kalenderController: controller,
      components: components,
      views: [
        ScheduleViewParts(
          body: ScheduleBody(
            configuration: ScheduleBodyConfiguration(emptyDay: emptyDay, leadingWidth: leadingWidth),
          ),
        ),
      ],
    );
  }

  ScheduleViewController schedule() => kalenderController!.viewController as ScheduleViewController;

  double tileLeft(WidgetTester tester, String id) => tester.getTopLeft(find.byKey(ScheduleEventTile.tileKey(id))).dx;

  group('Row alignment', () {
    testWidgets('event tiles on the same day share one left edge', (tester) async {
      final ids = eventsController.addEvents([
        eventAt(DateTime(2025, 1, 15), 9),
        eventAt(DateTime(2025, 1, 15), 11),
        eventAt(DateTime(2025, 1, 15), 13),
      ]);

      await pumpAndSettleWithMaterialApp(tester, buildSchedule());

      final first = tileLeft(tester, ids[0]);
      expect(tileLeft(tester, ids[1]), moreOrLessEquals(first, epsilon: 0.5));
      expect(tileLeft(tester, ids[2]), moreOrLessEquals(first, epsilon: 0.5));
    });

    testWidgets('leadingWidth widens the leading column by exactly its delta', (tester) async {
      final ids = eventsController.addEvents([eventAt(DateTime(2025, 1, 15), 9)]);

      await pumpAndSettleWithMaterialApp(tester, buildSchedule(leadingWidth: 56));
      final narrow = tileLeft(tester, ids.first);

      await pumpAndSettleWithMaterialApp(tester, buildSchedule(leadingWidth: 120));
      final wide = tileLeft(tester, ids.first);

      expect(wide - narrow, moreOrLessEquals(64, epsilon: 1));
    });
  });

  group('No events today (#253)', () {
    testWidgets('showOnlyToday indexes today, so it is the scroll target', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 1, 10), 9), eventAt(DateTime(2025, 1, 20), 9)]);

      await pumpAndSettleWithMaterialApp(tester, buildSchedule(emptyDay: EmptyDayBehavior.showOnlyToday));

      final controller = schedule();
      final todayIndex = controller.indexFromDateTime(DateTime(2025, 1, 15));
      expect(todayIndex, isNotNull, reason: "today's empty row must be indexed");
      expect(controller.indexItem(controller.currentPage)[todayIndex!], isA<EmptyItem>());
      expect(controller.dateTimeFromIndex(todayIndex)!.isSameDay(FloatingDateTime(2025, 1, 15)), isTrue);
      expect(controller.closestIndex(DateTime(2025, 1, 15)), todayIndex);

      expect(controller.indexFromDateTime(DateTime(2025, 1, 11)), isNull);
    });

    for (final (name, eventDays, expected) in [
      ('hide: closest picks the nearer past day, not the earliest', [14, 18], 14),
      ('hide: closest picks the nearer future day', [12, 16], 16),
    ]) {
      testWidgets(name, (tester) async {
        eventsController.addEvents([for (final day in eventDays) eventAt(DateTime(2025, 1, day), 9)]);

        await pumpAndSettleWithMaterialApp(tester, buildSchedule(emptyDay: EmptyDayBehavior.hide));

        final controller = schedule();
        final index = controller.closestIndex(DateTime(2025, 1, 15));
        expect(controller.dateTimeFromIndex(index)!.isSameDay(FloatingDateTime(2025, 1, expected)), isTrue);
      });
    }

    testWidgets('closest clamps to the first/last day for out-of-range targets', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 6, 10), 9), eventAt(DateTime(2025, 6, 20), 9)]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(emptyDay: EmptyDayBehavior.hide, initialDate: DateTime(2025, 6, 15)),
      );

      final controller = schedule();
      final earliest = controller.closestIndex(DateTime(2025, 1, 1));
      expect(controller.dateTimeFromIndex(earliest)!.isSameDay(FloatingDateTime(2025, 6, 10)), isTrue);

      final latest = controller.closestIndex(DateTime(2025, 12, 31));
      expect(controller.dateTimeFromIndex(latest)!.isSameDay(FloatingDateTime(2025, 6, 20)), isTrue);
    });

    testWidgets('closestIndex does not pollute the date→index map', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 1, 10), 9), eventAt(DateTime(2025, 1, 20), 9)]);

      await pumpAndSettleWithMaterialApp(tester, buildSchedule(emptyDay: EmptyDayBehavior.hide));

      final controller = schedule();
      expect(controller.indexFromDateTime(DateTime(2025, 1, 15)), isNull);
      controller.closestIndex(DateTime(2025, 1, 15));
      expect(controller.indexFromDateTime(DateTime(2025, 1, 15)), isNull);
    });
  });

  group('ScheduleComponents builders', () {
    testWidgets('monthItemBuilder replaces the default month header', (tester) async {
      eventsController.addEvents([eventAt(DateTime(2025, 1, 15), 9)]);

      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(
          emptyDay: EmptyDayBehavior.hide,
          components: const KalenderComponents(
            scheduleComponents: ScheduleComponents(monthItemBuilder: _customMonthItem),
          ),
        ),
      );

      expect(find.text('custom month'), findsWidgets);
      expect(find.text('January'), findsNothing);
    });

    testWidgets('emptyItemBuilder replaces the default empty day row', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        buildSchedule(
          emptyDay: EmptyDayBehavior.showOnlyToday,
          components: const KalenderComponents(
            scheduleComponents: ScheduleComponents(emptyItemBuilder: _customEmptyItem),
          ),
        ),
      );

      expect(find.text('custom empty'), findsOneWidget);
    });
  });

  group('Item map', () {
    testWidgets('is built once when the view first appears', (tester) async {
      final counting = _CountingEventsController();
      eventsController = counting;
      await pumpAndSettleWithMaterialApp(tester, buildSchedule());
      final callsOnMount = counting.eventsInRangeCalls;

      counting.addEvent(eventAt(DateTime(2025, 1, 15), 9));
      await tester.pumpAndSettle();
      final callsPerBuild = counting.eventsInRangeCalls - callsOnMount;

      expect(callsPerBuild, isPositive);
      expect(callsOnMount, callsPerBuild);
    });

    testWidgets('a replaced events controller is no longer listened to', (tester) async {
      final first = DefaultEventsController();
      eventsController = first;
      await pumpAndSettleWithMaterialApp(tester, buildSchedule());

      eventsController = DefaultEventsController();
      await pumpAndSettleWithMaterialApp(tester, buildSchedule());
      await tester.pumpWidget(const SizedBox());

      first.addEvent(eventAt(DateTime(2025, 1, 15), 9));
      expect(tester.takeException(), isNull);
    });
  });
}

class _CountingEventsController extends DefaultEventsController {
  int eventsInRangeCalls = 0;

  @override
  Iterable<KalenderEvent> eventsInRange(
    FloatingDateTimeRange range, {
    required MultiDayRule multiDayRule,
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    Location? location,
  }) {
    eventsInRangeCalls++;
    return super.eventsInRange(
      range,
      multiDayRule: multiDayRule,
      includeMultiDayEvents: includeMultiDayEvents,
      includeDayEvents: includeDayEvents,
      location: location,
    );
  }
}

Widget _customMonthItem(BuildContext context, KalenderDateTimeRange monthRange) => const Text('custom month');

Widget _customEmptyItem(BuildContext context, KalenderDateTimeRange tileRange) => const Text('custom empty');
