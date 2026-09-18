// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/drag_targets/vertical_drag_target.dart';

import '../utilities.dart';

/// Jan 6, 2025 is a Monday, so a week-view initialized here shows
/// Monday Jan 6 → Sunday Jan 12 in `visibleDates`, giving deterministic
/// date assertions in all cursor-position tests.
final _weekInitialDate = DateTime(2025, 1, 6);

Future<void> _pumpView(
  WidgetTester tester,
  ViewConfiguration viewConfiguration, {
  EventsController? eventsController,
  KalenderController? controller,
}) {
  return pumpAndSettleWithMaterialApp(
    tester,
    KalenderView(
      eventsController: eventsController ?? DefaultEventsController(),
      kalenderController: controller ?? KalenderController(),
      viewConfiguration: viewConfiguration,
      body: const KalenderBody(),
    ),
  );
}

Future<dynamic> _pumpWeekView(
  WidgetTester tester, {
  EventsController? eventsController,
  KalenderController? controller,
  KalenderTimeRange? timeOfDayRange,
}) async {
  await _pumpView(
    tester,
    MultiDayViewConfiguration.week(
      displayRange: year2025DisplayRange,
      initialDateTime: _weekInitialDate,
      timeOfDayRange: timeOfDayRange,
      initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
    ),
    eventsController: eventsController,
    controller: controller,
  );
  return tester.state<State>(find.byType(VerticalDragTarget)) as dynamic;
}

Future<dynamic> _pumpMonthView(
  WidgetTester tester, {
  EventsController? eventsController,
  KalenderController? controller,
}) async {
  await _pumpView(
    tester,
    MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange, initialDateTime: DateTime(2025, 1, 1)),
    eventsController: eventsController,
    controller: controller,
  );
  return tester.state<State>(find.byType(HorizontalDragTarget).first) as dynamic;
}

KalenderEvent _singleDayEvent({DateTime? start, DateTime? end}) =>
    KalenderEvent(start: start ?? DateTime(2025, 1, 6, 10, 0), end: end ?? DateTime(2025, 1, 6, 12, 0));

KalenderEvent _multiDayEvent() => KalenderEvent(start: DateTime(2025, 1, 6, 0, 0), end: DateTime(2025, 1, 7, 0, 0));

DragTargetDetails<Object?> _dragDetails(Object? data) => DragTargetDetails(data: data, offset: Offset.zero);

(int, int, int)? _cursorDate(dynamic state, Offset offset) {
  final value = state.calculateCursorDateTime(offset) as FloatingDateTime?;
  return value == null ? null : (value.year, value.month, value.day);
}

void main() {
  group('HorizontalDragTarget.onWillAcceptWithDetails', () {
    final controller = KalenderController();
    const headerConfig = MultiDayHeaderConfiguration();
    const monthConfig = MonthBodyConfiguration();

    final cases = <(String, Object?, HorizontalConfiguration, bool)>[
      ('Create with matching controller id', Create(controllerId: controller.id), headerConfig, true),
      ('Create with mismatched controller id', Create(controllerId: KalenderController().id), headerConfig, false),
      (
        'Resize right (horizontal)',
        Resize(event: _singleDayEvent(), direction: ResizeDirection.right),
        headerConfig,
        true,
      ),
      (
        'Resize left (horizontal)',
        Resize(event: _singleDayEvent(), direction: ResizeDirection.left),
        headerConfig,
        true,
      ),
      (
        'Resize bottom (vertical)',
        Resize(event: _singleDayEvent(), direction: ResizeDirection.bottom),
        headerConfig,
        false,
      ),
      (
        'Reschedule single-day event, header config (allowSingleDayEvents=false)',
        Reschedule(event: _singleDayEvent()),
        headerConfig,
        false,
      ),
      (
        'Reschedule single-day event, month body config (allowSingleDayEvents=true)',
        Reschedule(event: _singleDayEvent()),
        monthConfig,
        true,
      ),
      ('Reschedule multi-day event, header config', Reschedule(event: _multiDayEvent()), headerConfig, true),
      ('Unknown data type', 'not-a-recognized-drag-payload', headerConfig, false),
    ];

    for (final (name, payload, config, expected) in cases) {
      test('$name → $expected', () {
        expect(HorizontalDragTarget.onWillAcceptWithDetails(_dragDetails(payload), controller, config), expected);
      });
    }
  });

  group('VerticalDragTarget.onWillAcceptWithDetails', () {
    final cases = <(String, Object Function(KalenderController controller), bool)>[
      ('Create with matching controller id', (controller) => Create(controllerId: controller.id), true),
      ('Create with mismatched controller id', (_) => Create(controllerId: KalenderController().id), false),
      ('Resize bottom (vertical)', (_) => Resize(event: _singleDayEvent(), direction: ResizeDirection.bottom), true),
      ('Resize left (horizontal)', (_) => Resize(event: _singleDayEvent(), direction: ResizeDirection.left), false),
    ];

    for (final (name, payload, expected) in cases) {
      testWidgets('$name → $expected', (tester) async {
        final controller = KalenderController();
        await _pumpWeekView(tester, controller: controller);

        expect(
          VerticalDragTarget.onWillAcceptWithDetails(
            _dragDetails(payload(controller)),
            controller,
            const MultiDayBodyConfiguration(),
          ),
          expected,
        );
      });
    }

    testWidgets('Reschedule event whose duration exceeds restricted timeOfDayRange → false', (tester) async {
      // Time range 09:00–17:00 has duration = 8h 1min.
      // An event from 08:00–18:00 (10 h) exceeds that, so it should be rejected.
      final controller = KalenderController();
      await _pumpWeekView(
        tester,
        controller: controller,
        timeOfDayRange: KalenderTimeRange(
          start: const KalenderTime(hour: 9, minute: 0),
          end: const KalenderTime(hour: 17, minute: 0),
        ),
      );
      const config = MultiDayBodyConfiguration();

      final hugeEvent = KalenderEvent(start: DateTime(2025, 1, 6, 8, 0), end: DateTime(2025, 1, 6, 18, 0));

      expect(
        VerticalDragTarget.onWillAcceptWithDetails(_dragDetails(Reschedule(event: hugeEvent)), controller, config),
        isFalse,
      );
    });
  });

  group('VerticalDragTarget cursor clamping', () {
    testWidgets('negative x (over timeline) clamps to first visible day (Jan 6)', (tester) async {
      final state = await _pumpWeekView(tester);
      final origin = tester.getTopLeft(find.byType(VerticalDragTarget));

      for (final dx in [-1.0, -10.0, -50.0, -100.0, -500.0]) {
        expect(_cursorDate(state, Offset(origin.dx + dx, origin.dy + 50)), (2025, 1, 6), reason: 'dx=$dx');
      }
    });

    testWidgets('far-right x clamps to last visible day (Jan 12)', (tester) async {
      final state = await _pumpWeekView(tester);
      final origin = tester.getTopLeft(find.byType(VerticalDragTarget));

      expect(_cursorDate(state, Offset(origin.dx + 10000, origin.dy + 50)), (2025, 1, 12));
    });

    testWidgets('column-centre positions map to correct days Jan 6–12', (tester) async {
      final state = await _pumpWeekView(tester);
      final origin = tester.getTopLeft(find.byType(VerticalDragTarget));
      final dayWidth = state.dayWidth as double;

      const expectedDays = [6, 7, 8, 9, 10, 11, 12];

      for (var col = 0; col < 7; col++) {
        final cx = origin.dx + (col + 0.5) * dayWidth;
        expect(_cursorDate(state, Offset(cx, origin.dy + 50)), (2025, 1, expectedDays[col]), reason: 'col=$col');
      }
    });
  });

  group('VerticalDragTarget resizeEvent', () {
    Future<(dynamic, KalenderEvent)> pumpWithEvent(WidgetTester tester) async {
      final ec = DefaultEventsController()..addEvent(_singleDayEvent());
      final state = await _pumpWeekView(tester, eventsController: ec);
      return (state, ec.events.first);
    }

    testWidgets('ResizeDirection.bottom (vertical) extends event end → non-null', (tester) async {
      final (state, event) = await pumpWithEvent(tester);

      final cursor = FloatingDateTime(2025, 1, 6, 14, 0);
      final result = state.resizeEvent(event, ResizeDirection.bottom, cursor);

      expect(result, isNotNull);
      expect(
        result.dateTimeRange.end.isAfter(event.dateTimeRange.end),
        isTrue,
        reason: 'End should move later with bottom resize',
      );
    });

    testWidgets('ResizeDirection.top (vertical) changes event start → non-null', (tester) async {
      final (state, event) = await pumpWithEvent(tester);

      // Place cursor at 11:00 (between original start and end)
      final cursor = FloatingDateTime(2025, 1, 6, 11, 0);
      final result = state.resizeEvent(event, ResizeDirection.top, cursor);

      expect(result, isNotNull);
      expect(
        result.dateTimeRange.start.isAfter(event.dateTimeRange.start),
        isTrue,
        reason: 'Start should move later with top resize',
      );
    });

    for (final direction in [ResizeDirection.left, ResizeDirection.right]) {
      testWidgets('ResizeDirection.${direction.name} (horizontal) → null', (tester) async {
        final (state, event) = await pumpWithEvent(tester);

        expect(state.resizeEvent(event, direction, FloatingDateTime(2025, 1, 6, 14, 0)), isNull);
      });
    }
  });

  group('HorizontalDragTarget cursor clamping', () {
    testWidgets('negative x clamps to first date in week row (Dec 30, 2024)', (tester) async {
      final state = await _pumpMonthView(tester);
      final origin = tester.getTopLeft(find.byType(HorizontalDragTarget).first);

      // First visible row of Jan 2025 starts on Dec 30, 2024 (Monday)
      expect(_cursorDate(state, Offset(origin.dx - 100, origin.dy + 10)), (2024, 12, 30));
    });

    testWidgets('far-right x clamps to last date in week row (Jan 5, 2025)', (tester) async {
      final state = await _pumpMonthView(tester);
      final origin = tester.getTopLeft(find.byType(HorizontalDragTarget).first);

      expect(_cursorDate(state, Offset(origin.dx + 10000, origin.dy + 10)), (2025, 1, 5));
    });

    testWidgets('column-centre positions map to Dec 30 – Jan 5', (tester) async {
      final state = await _pumpMonthView(tester);
      final origin = tester.getTopLeft(find.byType(HorizontalDragTarget).first);
      final dayWidth = state.dayWidth as double;

      const expectedDates = [
        (2024, 12, 30),
        (2024, 12, 31),
        (2025, 1, 1),
        (2025, 1, 2),
        (2025, 1, 3),
        (2025, 1, 4),
        (2025, 1, 5),
      ];

      for (var col = 0; col < 7; col++) {
        final cx = origin.dx + (col + 0.5) * dayWidth;
        expect(_cursorDate(state, Offset(cx, origin.dy + 10)), expectedDates[col], reason: 'col=$col');
      }
    });
  });

  group('HorizontalDragTarget rescheduleEvent (month view)', () {
    final singleDayCases = [
      (
        name: 'date changes but time-of-day is preserved',
        event: _singleDayEvent(start: DateTime(2025, 1, 6, 10, 0), end: DateTime(2025, 1, 6, 12, 0)),
        cursor: FloatingDateTime(2025, 1, 9),
        expectedStart: FloatingDateTime(2025, 1, 9, 10, 0),
      ),
      (
        name: 'moved to a different week row → correct day',
        event: _singleDayEvent(start: DateTime(2025, 1, 6, 9, 30), end: DateTime(2025, 1, 6, 10, 30)),
        cursor: FloatingDateTime(2025, 1, 20),
        expectedStart: FloatingDateTime(2025, 1, 20, 9, 30),
      ),
    ];

    for (final (:name, :event, :cursor, :expectedStart) in singleDayCases) {
      testWidgets('single-day event: $name', (tester) async {
        final ec = DefaultEventsController()..addEvent(event);
        final state = await _pumpMonthView(tester, eventsController: ec);

        final result = state.rescheduleEvent(ec.events.first, cursor) as KalenderEvent?;

        expect(result?.floatingStart(), expectedStart);
      });
    }

    testWidgets('multi-day event: date changes but duration is preserved', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(_multiDayEvent());
      final state = await _pumpMonthView(tester, eventsController: ec);

      final event = ec.events.first;

      final cursor = FloatingDateTime(2025, 1, 9);
      final result = state.rescheduleEvent(event, cursor) as KalenderEvent?;

      expect(result, isNotNull);
      expect(
        result!.duration,
        equals(event.duration),
        reason: 'Duration should be preserved when moving a multi-day event',
      );
    });
  });

  group('Resize leave/re-enter restores selectedEventId (regression)', () {
    DragTarget<Object?> findDragTargetOf<T extends Widget>(WidgetTester tester) {
      return tester.widget<DragTarget<Object?>>(
        find.descendant(of: find.byType(T), matching: find.byWidgetPredicate((w) => w is DragTarget)).first,
      );
    }

    testWidgets('VerticalDragTarget: onLeave clears selectedEventId; '
        're-entry with Resize data restores it', (tester) async {
      final ec = DefaultEventsController();
      ec.addEvent(_singleDayEvent());
      final controller = KalenderController();

      final state = await _pumpWeekView(tester, eventsController: ec, controller: controller);

      final liveEvent = ec.events.first;

      controller.selectEvent(liveEvent, internal: true);
      expect(controller.selectedEventId, equals(liveEvent.id));

      state.onLeave(Resize(event: liveEvent, direction: ResizeDirection.bottom));

      expect(controller.selectedEventId, isNull, reason: 'onLeave must clear selectedEventId');

      findDragTargetOf<VerticalDragTarget>(tester).onWillAcceptWithDetails!(
        _dragDetails(Resize(event: liveEvent, direction: ResizeDirection.bottom)),
      );

      expect(controller.selectedEventId, equals(liveEvent.id), reason: 'selectedEventId must be restored on re-entry');

      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('HorizontalDragTarget: onLeave clears selectedEventId; '
        're-entry with Resize data restores it', (tester) async {
      final ec = DefaultEventsController();
      // Multi-day event so it lives in the HorizontalDragTarget (header/month).
      ec.addEvent(_multiDayEvent());
      final controller = KalenderController();

      final state = await _pumpMonthView(tester, eventsController: ec, controller: controller);

      final liveEvent = ec.events.first;

      controller.selectEvent(liveEvent, internal: true);
      expect(controller.selectedEventId, equals(liveEvent.id));

      state.onLeave(Resize(event: liveEvent, direction: ResizeDirection.right));

      expect(controller.selectedEventId, isNull, reason: 'onLeave must clear selectedEventId');

      findDragTargetOf<HorizontalDragTarget>(tester).onWillAcceptWithDetails!(
        _dragDetails(Resize(event: liveEvent, direction: ResizeDirection.right)),
      );

      expect(controller.selectedEventId, equals(liveEvent.id), reason: 'selectedEventId must be restored on re-entry');

      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
