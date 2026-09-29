// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';

import '../utilities.dart';

void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  KalenderInteraction interaction(InputMode inputMode, EventInteractionGesture gesture) => KalenderInteraction(
    allowResizing: true,
    allowRescheduling: true,
    allowEventCreation: true,
    inputMode: inputMode,
    createEventGesture: gesture,
    modifyEventGesture: gesture,
  );

  late String dayEventID;
  late String multiDayEventID;
  late String customDayEventID;
  late String customMultiDayEventID;

  setUp(() {
    eventsController = DefaultEventsController();

    dayEventID = eventsController.addEvent(KalenderEvent(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 4)));
    multiDayEventID = eventsController.addEvent(KalenderEvent(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 2)));
    customDayEventID = eventsController.addEvent(
      KalenderEvent(
        start: DateTime(2025, 1, 1, 1),
        end: DateTime(2025, 1, 1, 23),
        interaction: EventInteraction(allowEndResize: true, allowStartResize: false, allowRescheduling: false),
      ),
    );
    customMultiDayEventID = eventsController.addEvent(
      KalenderEvent(
        start: DateTime(2025, 1, 1),
        end: DateTime(2025, 1, 2),
        interaction: EventInteraction(allowEndResize: true, allowStartResize: false, allowRescheduling: false),
      ),
    );
  });

  MultiDayViewConfiguration singleDay() => MultiDayViewConfiguration.singleDay(
    displayRange: year2025DisplayRange,
    initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
    initialDateTime: DateTime(2025, 1, 1),
  );

  MonthViewConfiguration singleMonth() =>
      MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange, initialDateTime: DateTime(2025));

  Future<void> pump(WidgetTester tester, ViewConfiguration viewConfiguration, KalenderInteraction interaction) {
    kalenderController = KalenderController(viewConfiguration: viewConfiguration);
    addTearDown(kalenderController.dispose);
    return pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      interaction: interaction,
    );
  }

  void expectHandles(
    String id,
    Key Function(String) rescheduleKey, {
    bool reschedule = false,
    bool start = false,
    bool end = false,
  }) {
    Matcher shown(bool visible) => visible ? findsOneWidget : findsNothing;
    expect(find.byKey(rescheduleKey(id)), shown(reschedule));
    expect(find.byKey(ResizeDetector.startResizeDraggableKey(id)), shown(start));
    expect(find.byKey(ResizeDetector.endResizeDraggableKey(id)), shown(end));
  }

  Future<void> sendPointerHover(
    WidgetTester tester, {
    required Finder target,
    required PointerDeviceKind kind,
    int pointer = 1,
  }) async {
    final position = tester.getCenter(target);
    tester.binding.handlePointerEvent(PointerAddedEvent(pointer: pointer, position: Offset.zero, kind: kind));
    tester.binding.handlePointerEvent(PointerEnterEvent(pointer: pointer, position: position, kind: kind));
    tester.binding.handlePointerEvent(PointerHoverEvent(pointer: pointer, position: position, kind: kind));
    await tester.pumpAndSettle();
    tester.binding.handlePointerEvent(PointerRemovedEvent(pointer: pointer, position: position, kind: kind));
  }

  group('MultiDayView interaction', () {
    testWidgets('default events show all interaction handles', (tester) async {
      await pump(tester, singleDay(), interaction(InputMode.precise, EventInteractionGesture.tap));

      final gesture = await tester.createMouseGesture();

      final dayTile = find.byKey(DayEventTile.tileKey(dayEventID));
      await tester.hoverOn(dayTile, gesture);
      expectHandles(dayEventID, DayEventTile.rescheduleDraggableKey, reschedule: true, start: true, end: true);

      final multiDayTile = find.byKey(MultiDayEventTile.tileKey(multiDayEventID));
      await tester.hoverOn(multiDayTile, gesture);
      expectHandles(
        multiDayEventID,
        MultiDayEventTile.rescheduleDraggableKey,
        reschedule: true,
        start: true,
        end: true,
      );
    });

    testWidgets('custom events respect per-event interaction overrides', (tester) async {
      await pump(tester, singleDay(), interaction(InputMode.precise, EventInteractionGesture.tap));

      final gesture = await tester.createMouseGesture();

      final customDayTile = find.byKey(DayEventTile.tileKey(customDayEventID));
      await tester.hoverOn(customDayTile, gesture);
      expectHandles(customDayEventID, DayEventTile.rescheduleDraggableKey, end: true);

      final customMultiDayTile = find.byKey(MultiDayEventTile.tileKey(customMultiDayEventID));
      await tester.hoverOn(customMultiDayTile, gesture);
      expectHandles(customMultiDayEventID, MultiDayEventTile.rescheduleDraggableKey, end: true);
    });
  });

  group('MonthView interaction', () {
    testWidgets('default event shows all interaction handles', (tester) async {
      await pump(tester, singleMonth(), interaction(InputMode.precise, EventInteractionGesture.tap));

      final gesture = await tester.createMouseGesture();

      final tile = find.byKey(MultiDayEventTile.tileKey(multiDayEventID));
      await tester.hoverOn(tile, gesture);
      expectHandles(
        multiDayEventID,
        MultiDayEventTile.rescheduleDraggableKey,
        reschedule: true,
        start: true,
        end: true,
      );
    });

    testWidgets('custom event respects per-event interaction overrides', (tester) async {
      await pump(tester, singleMonth(), interaction(InputMode.precise, EventInteractionGesture.tap));

      final gesture = await tester.createMouseGesture();

      final customTile = find.byKey(MultiDayEventTile.tileKey(customMultiDayEventID));
      await tester.hoverOn(customTile, gesture);
      expectHandles(customMultiDayEventID, MultiDayEventTile.rescheduleDraggableKey, end: true);
    });
  });

  group('ScheduleView interaction', () {
    testWidgets('default event shows reschedule handle but no resize handles', (tester) async {
      await pump(
        tester,
        ScheduleViewConfiguration.continuous(displayRange: year2025DisplayRange),
        interaction(InputMode.precise, EventInteractionGesture.tap),
      );

      final gesture = await tester.createMouseGesture();

      final tile = find.byKey(ScheduleEventTile.tileKey(multiDayEventID));
      await tester.hoverOn(tile, gesture);
      expectHandles(multiDayEventID, ScheduleEventTile.rescheduleDraggableKey, reschedule: true);
    });

    testWidgets('custom event suppresses all interaction handles', (tester) async {
      await pump(
        tester,
        ScheduleViewConfiguration.continuous(displayRange: year2025DisplayRange),
        interaction(InputMode.precise, EventInteractionGesture.tap),
      );

      final gesture = await tester.createMouseGesture();

      final customTile = find.byKey(ScheduleEventTile.tileKey(customMultiDayEventID));
      await tester.hoverOn(customTile, gesture);
      expectHandles(customMultiDayEventID, ScheduleEventTile.rescheduleDraggableKey);
    });
  });

  group('MultiDayView imprecise interaction', () {
    testWidgets('default events show vertical resize handles on selection', (tester) async {
      await pump(tester, singleDay(), interaction(InputMode.imprecise, EventInteractionGesture.longPress));

      expect(find.byKey(ResizeDetector.startResizeDraggableKey(dayEventID)), findsNothing);
      expect(find.byKey(ResizeDetector.endResizeDraggableKey(dayEventID)), findsNothing);

      final dayEvent = eventsController.events.firstWhere((e) => e.id == dayEventID);
      kalenderController.selectEvent(dayEvent);
      await tester.pumpAndSettle();

      expect(find.byKey(ResizeDetector.startResizeDraggableKey(dayEventID)), findsOneWidget);
      expect(find.byKey(ResizeDetector.endResizeDraggableKey(dayEventID)), findsOneWidget);

      final multiDayEvent = eventsController.events.firstWhere((e) => e.id == multiDayEventID);
      kalenderController.selectEvent(multiDayEvent);
      await tester.pumpAndSettle();
      expect(find.byKey(ResizeDetector.startResizeDraggableKey(multiDayEventID)), findsNothing);
      expect(find.byKey(ResizeDetector.endResizeDraggableKey(multiDayEventID)), findsNothing);
    });

    testWidgets('custom events respect per-event interaction overrides on selection', (tester) async {
      await pump(tester, singleDay(), interaction(InputMode.imprecise, EventInteractionGesture.longPress));

      final customDayEvent = eventsController.events.firstWhere((e) => e.id == customDayEventID);
      kalenderController.selectEvent(customDayEvent);
      await tester.pumpAndSettle();

      expectHandles(customDayEventID, DayEventTile.rescheduleDraggableKey, end: true);
    });
  });

  group('MonthView imprecise interaction', () {
    testWidgets('horizontal resize handles are hidden in imprecise mode', (tester) async {
      await pump(tester, singleMonth(), interaction(InputMode.imprecise, EventInteractionGesture.longPress));
      expect(find.byType(MonthBody), findsOneWidget);

      final multiDayEvent = eventsController.events.firstWhere((e) => e.id == multiDayEventID);
      kalenderController.selectEvent(multiDayEvent);
      await tester.pumpAndSettle();

      expect(find.byKey(ResizeDetector.startResizeDraggableKey(multiDayEventID)), findsNothing);
      expect(find.byKey(ResizeDetector.endResizeDraggableKey(multiDayEventID)), findsNothing);
    });
  });

  group('calendar-wide interaction', () {
    final calendarWide = KalenderInteraction(allowResizing: false);
    final own = KalenderInteraction(allowRescheduling: false);
    final cases = <(String, ViewConfiguration Function(), ViewParts Function(KalenderInteraction?, TileBuilder))>[
      (
        'MultiDayBody',
        singleDay,
        (interaction, tile) => MultiDayViewParts(
          header: const SizedBox.shrink(),
          body: MultiDayBody(
            interaction: interaction,
            tileComponents: TileComponents(tileBuilder: tile),
          ),
        ),
      ),
      (
        'MultiDayHeader',
        singleDay,
        (interaction, tile) => MultiDayViewParts(
          header: MultiDayHeader(
            interaction: interaction,
            tileComponents: TileComponents(tileBuilder: tile),
          ),
          body: const SizedBox.shrink(),
        ),
      ),
      (
        'MonthBody',
        singleMonth,
        (interaction, tile) => MonthViewParts(
          header: const SizedBox.shrink(),
          body: MonthBody(
            interaction: interaction,
            tileComponents: TileComponents(tileBuilder: tile),
          ),
        ),
      ),
      (
        'ScheduleBody',
        () => ScheduleViewConfiguration.continuous(
          displayRange: year2025DisplayRange,
          initialDateTime: DateTime(2025, 1, 1),
        ),
        (interaction, tile) => ScheduleViewParts(
          body: ScheduleBody(
            interaction: interaction,
            tileComponents: ScheduleTileComponents(tileBuilder: tile),
          ),
        ),
      ),
    ];

    for (final (name, configuration, parts) in cases) {
      for (final (label, widgetInteraction, expected) in [
        ('reaches $name when it has none', null, calendarWide),
        ('loses to the one given to $name', own, own),
      ]) {
        testWidgets(label, (tester) async {
          final seen = <KalenderInteraction>{};
          kalenderController = KalenderController(viewConfiguration: configuration());
          addTearDown(kalenderController.dispose);
          await pumpKalender(
            tester,
            eventsController: eventsController,
            kalenderController: kalenderController,
            interaction: calendarWide,
            views: [
              parts(widgetInteraction, (context, event, tileRange) {
                seen.add(KalenderScope.interactionOf(context));
                return const SizedBox(height: 20);
              }),
            ],
          );

          expect(seen, {expected});
        });
      }
    }
  });

  group('MultiDayView auto interaction', () {
    testWidgets('touch hover events do not switch horizontal handles into precise mode', (tester) async {
      await pump(tester, singleDay(), interaction(InputMode.auto, EventInteractionGesture.tap));
      expect(find.byType(MultiDayBody), findsOneWidget);

      final tile = find.byKey(MultiDayEventTile.tileKey(multiDayEventID));

      await sendPointerHover(tester, target: tile, kind: PointerDeviceKind.touch);

      expect(find.byKey(ResizeDetector.startResizeDraggableKey(multiDayEventID)), findsNothing);
      expect(find.byKey(ResizeDetector.endResizeDraggableKey(multiDayEventID)), findsNothing);
    });

    testWidgets('mouse hover events still show horizontal resize handles', (tester) async {
      await pump(tester, singleDay(), interaction(InputMode.auto, EventInteractionGesture.tap));
      expect(find.byType(MultiDayBody), findsOneWidget);

      final tile = find.byKey(MultiDayEventTile.tileKey(multiDayEventID));

      await sendPointerHover(tester, target: tile, kind: PointerDeviceKind.mouse);

      expect(find.byKey(ResizeDetector.startResizeDraggableKey(multiDayEventID)), findsOneWidget);
      expect(find.byKey(ResizeDetector.endResizeDraggableKey(multiDayEventID)), findsOneWidget);
    });
  });
}
