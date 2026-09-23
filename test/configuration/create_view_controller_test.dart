// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

import '../utilities.dart';

class _Week extends MultiDayViewConfiguration {
  _Week() : super.week();
}

class _Day extends MultiDayViewConfiguration {
  _Day() : super.singleDay();
}

class _MonthView extends MonthViewConfiguration {
  _MonthView() : super.singleMonth();
}

class _Schedule extends ScheduleViewConfiguration {
  _Schedule() : super.continuous();
}

/// [ViewConfiguration.createViewController] picks the view controller and resolves the date, scroll and zoom it opens
/// on.
void main() {
  initializeTimeZones();
  final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));

  late KalenderController controller;
  setUp(() => controller = KalenderController(viewConfiguration: MultiDayViewConfiguration.singleDay()));
  tearDown(() => controller.dispose());

  ViewController create(ViewConfiguration configuration, [ViewTransitionContext? transition]) {
    final viewController = configuration.createViewController(controller, transition);
    addTearDown(viewController.dispose);
    return viewController;
  }

  group('the view controller type', () {
    for (final (configuration, type) in [
      (MultiDayViewConfiguration.week(displayRange: range), MultiDayViewController),
      (MonthViewConfiguration.singleMonth(displayRange: range), MonthViewController),
      (ScheduleViewConfiguration.continuous(displayRange: range), ContinuousScheduleViewController),
      (ScheduleViewConfiguration.paginated(displayRange: range), PaginatedScheduleViewController),
    ]) {
      test(configuration.name, () => expect(create(configuration).runtimeType, type));
    }
  });

  for (final configuration in [_Week(), _Day(), _MonthView(), _Schedule()]) {
    testWidgets('a subclass of a built-in configuration builds (${configuration.runtimeType})', (tester) async {
      final eventsController = DefaultEventsController();
      addTearDown(eventsController.dispose);
      final kalenderController = KalenderController(viewConfiguration: configuration);
      addTearDown(kalenderController.dispose);
      await pumpKalender(
        tester,
        eventsController: eventsController,
        kalenderController: kalenderController,
        header: const KalenderHeader(),
        body: const KalenderBody(),
      );
    });
  }

  group('the first build', () {
    test('opens on initialDateTime', () {
      final day = MultiDayViewConfiguration.singleDay(displayRange: range, initialDateTime: DateTime(2025, 3, 5, 12));
      expect(create(day).floatingVisibleRange.value!.start, FloatingDateTime(2025, 3, 5));
    });

    test('opens on today in the location without initialDateTime', () {
      final kiritimati = getLocation('Pacific/Kiritimati');
      controller.location = kiritimati;
      FloatingDateTime today() => FloatingDateTime.fromDateTime(TZDateTime.now(kiritimati)).startOfDay;
      final before = today();
      final start = create(MultiDayViewConfiguration.singleDay()).floatingVisibleRange.value!.start;
      expect(start, anyOf(before, today()));
    });

    test('opens on the location of the controller', () {
      final kiritimati = getLocation('Pacific/Kiritimati');
      controller.location = kiritimati;
      expect(create(MultiDayViewConfiguration.singleDay()).location, kiritimati);
    });
  });

  group('a transition', () {
    // A week opened on Wednesday 5 March starts on Monday 3 March.
    final week = MultiDayViewConfiguration.week(displayRange: range, initialDateTime: DateTime(2025, 3, 5));
    final monday = FloatingDateTime(2025, 3, 3);
    final restoredDate = FloatingDateTime(2025, 6, 10);
    final preserved = (timeOfDay: const KalenderTime(hour: 10, minute: 0), heightPerMinute: 1.5);
    final restored = (timeOfDay: const KalenderTime(hour: 14, minute: 0), heightPerMinute: 2.5);

    ViewTransitionContext transition(ViewConfiguration next, {bool withHistory = true}) {
      return ViewTransitionContext(
        oldViewController: create(week),
        newViewConfiguration: next,
        byView: {
          if (withHistory)
            next.name: ViewSnapshot(
              date: restoredDate,
              timeOfDay: restored.timeOfDay,
              heightPerMinute: restored.heightPerMinute,
            ),
        },
        lastMultiDay: ViewSnapshot(
          date: monday,
          timeOfDay: preserved.timeOfDay,
          heightPerMinute: preserved.heightPerMinute,
        ),
      );
    }

    (FloatingDateTime, KalenderTime?, double?) opened(MultiDayViewConfiguration next, {bool withHistory = true}) {
      final snapshot = create(next, transition(next, withHistory: withHistory)).snapshot();
      return (snapshot.date, snapshot.timeOfDay, snapshot.heightPerMinute);
    }

    const initial = (timeOfDay: kDefaultInitialTimeOfDay, heightPerMinute: kDefaultHeightPerMinute);

    for (final c in [
      (
        name: 'carryFocus, preserve, preserve',
        date: DateTransition.carryFocus,
        scroll: ScrollTransition.preserve,
        zoom: ZoomTransition.preserve,
        withHistory: true,
        expected: (monday, preserved.timeOfDay, preserved.heightPerMinute),
      ),
      (
        name: 'carryFocus, reset, reset',
        date: DateTransition.carryFocus,
        scroll: ScrollTransition.reset,
        zoom: ZoomTransition.reset,
        withHistory: true,
        expected: (monday, initial.timeOfDay, initial.heightPerMinute),
      ),
      (
        name: 'restorePerView with history',
        date: DateTransition.restorePerView,
        scroll: ScrollTransition.restorePerView,
        zoom: ZoomTransition.restorePerView,
        withHistory: true,
        expected: (restoredDate, restored.timeOfDay, restored.heightPerMinute),
      ),
      (
        name: 'restorePerView without history',
        date: DateTransition.restorePerView,
        scroll: ScrollTransition.restorePerView,
        zoom: ZoomTransition.restorePerView,
        withHistory: false,
        expected: (monday, preserved.timeOfDay, preserved.heightPerMinute),
      ),
    ]) {
      test(c.name, () {
        final day = MultiDayViewConfiguration.singleDay(
          displayRange: range,
          dateTransition: c.date,
          scrollTransition: c.scroll,
          zoomTransition: c.zoom,
        );
        expect(opened(day, withHistory: c.withHistory), c.expected);
      });
    }

    test('resolvers win over the transitions', () {
      final resolvedDate = FloatingDateTime(2025, 8, 1);
      const resolvedTime = KalenderTime(hour: 7, minute: 0);
      final day = MultiDayViewConfiguration.singleDay(
        displayRange: range,
        dateTransition: DateTransition.restorePerView,
        scrollTransition: ScrollTransition.restorePerView,
        zoomTransition: ZoomTransition.restorePerView,
        dateResolver: (_) => resolvedDate,
        scrollResolver: (_) => resolvedTime,
        zoomResolver: (_) => 3,
      );
      expect(opened(day), (resolvedDate, resolvedTime, 3.0));
    });
  });
}
