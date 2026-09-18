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

import '../utilities.dart';

class _View {
  const _View({
    required this.name,
    required this.configuration,
    required this.body,
    required this.dragOffset,
    required this.detail,
    required this.tappedDate,
    required this.eventStart,
    required this.eventEnd,
    required this.tileKey,
    required this.gestureDetectorKey,
    required this.tapEvent,
    required this.eventTapDetail,
    required this.nextPage,
  });

  final String name;
  final ViewConfiguration configuration;
  final Finder body;
  final Offset dragOffset;
  final Matcher detail;
  final Matcher tappedDate;
  final DateTime eventStart;
  final DateTime eventEnd;
  final Key Function(String id) tileKey;
  final Key Function(String id) gestureDetectorKey;
  final Future<void> Function(WidgetTester tester, Finder gestureDetector) tapEvent;
  final Matcher eventTapDetail;
  final DateTime nextPage;
}

void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  final preciseInteraction = KalenderInteraction(
    allowResizing: true,
    allowRescheduling: true,
    allowEventCreation: true,
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );
  final impreciseInteraction = KalenderInteraction(
    allowResizing: true,
    allowRescheduling: true,
    allowEventCreation: true,
    inputMode: InputMode.imprecise,
    createEventGesture: EventInteractionGesture.longPress,
    modifyEventGesture: EventInteractionGesture.longPress,
  );

  final views = [
    _View(
      name: 'MultiDayView',
      configuration: MultiDayViewConfiguration.singleDay(
        displayRange: year2025DisplayRange,
        initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        initialDateTime: DateTime(2025, 1, 1),
      ),
      body: find.byType(MultiDayBody),
      dragOffset: const Offset(0, 100),
      detail: isA<DayDetail>(),
      tappedDate: equals(DateTime(2025, 1, 1, 6, 30)),
      eventStart: DateTime(2025, 1, 1, 1),
      eventEnd: DateTime(2025, 1, 1, 12),
      tileKey: DayEventTile.tileKey,
      gestureDetectorKey: DayEventTile.gestureDetectorKey,
      tapEvent: (tester, gestureDetector) => tester.tapAt(tester.getTopLeft(gestureDetector) + const Offset(0, 60)),
      eventTapDetail: isA<DayDetail>().having(
        (detail) => detail.date,
        'date',
        predicate<DateTime>(
          (date) => date.isAfter(DateTime(2025, 1, 1, 1)) && date.isBefore(DateTime(2025, 1, 1, 12)),
          'inside the event',
        ),
      ),
      nextPage: DateTime(2025, 1, 2),
    ),
    _View(
      name: 'MonthView',
      configuration: MonthViewConfiguration.singleMonth(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 1, 1),
      ),
      body: find.byType(MonthBody),
      dragOffset: const Offset(100, 0),
      detail: isA<MultiDayDetail>(),
      tappedDate: isNotNull,
      eventStart: DateTime(2025, 1, 1),
      eventEnd: DateTime(2025, 1, 1, 1),
      tileKey: MultiDayEventTile.tileKey,
      gestureDetectorKey: MultiDayEventTile.gestureDetectorKey,
      tapEvent: (tester, gestureDetector) => tester.tap(gestureDetector),
      eventTapDetail: isA<MultiDayDetail>(),
      nextPage: DateTime(2025, 2, 1),
    ),
  ];

  final taps = [
    (
      name: 'onTapped',
      buttons: kPrimaryButton,
      callbacks: (OnTapped onDate, OnTappedWithDetail onDetail) =>
          KalenderCallbacks(onTapped: onDate, onTappedWithDetail: onDetail),
    ),
    (
      name: 'onSecondaryTapped',
      buttons: kSecondaryButton,
      callbacks: (OnTapped onDate, OnTappedWithDetail onDetail) =>
          KalenderCallbacks(onSecondaryTapped: onDate, onSecondaryTappedWithDetail: onDetail),
    ),
  ];

  final longPresses = [
    (
      name: 'onLongPressed',
      buttons: kPrimaryButton,
      callbacks: (OnLongPressed onDate, OnLongPressedWithDetail onDetail) =>
          KalenderCallbacks(onLongPressed: onDate, onLongPressedWithDetail: onDetail),
    ),
    (
      name: 'onSecondaryLongPressed',
      buttons: kSecondaryButton,
      callbacks: (OnLongPressed onDate, OnLongPressedWithDetail onDetail) =>
          KalenderCallbacks(onSecondaryLongPressed: onDate, onSecondaryLongPressedWithDetail: onDetail),
    ),
  ];

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
  });

  Future<void> pumpView(
    WidgetTester tester,
    _View view, {
    required KalenderCallbacks callbacks,
    KalenderInteraction? interaction,
  }) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: view.configuration,
        callbacks: callbacks,
        header: KalenderHeader(interaction: interaction ?? preciseInteraction),
        body: KalenderBody(interaction: interaction ?? preciseInteraction),
      ),
    );
  }

  Future<String> addEvent(WidgetTester tester, _View view) async {
    final id = eventsController.addEvent(KalenderEvent(start: view.eventStart, end: view.eventEnd));
    await tester.pumpAndSettle();
    return id;
  }

  for (final view in views) {
    group('${view.name} Callbacks', () {
      for (final tap in taps) {
        testWidgets('${tap.name} fires with correct date', (tester) async {
          DateTime? tappedDate;
          TapDetail? tappedDetail;

          await pumpView(
            tester,
            view,
            callbacks: tap.callbacks((date) => tappedDate = date, (detail) => tappedDetail = detail),
          );

          expect(tappedDate, isNull);
          expect(tappedDetail, isNull);

          await tester.tapAt(tester.getCenter(view.body), buttons: tap.buttons);

          expect(tappedDate, view.tappedDate);
          expect(tappedDetail, view.detail);
          expect(tappedDetail!.localOffset.dx, greaterThan(0));
          expect(tappedDetail!.localOffset.dy, greaterThan(0));
          expect(tappedDetail!.renderBox.localToGlobal(Offset.zero).dx, greaterThanOrEqualTo(0));
          expect(tappedDetail!.renderBox.localToGlobal(Offset.zero).dy, greaterThanOrEqualTo(0));
        });
      }

      for (final longPress in longPresses) {
        testWidgets('${longPress.name} fires', (tester) async {
          DateTime? longPressedDate;
          TapDetail? longPressedDetail;

          await pumpView(
            tester,
            view,
            callbacks: longPress.callbacks((date) => longPressedDate = date, (detail) => longPressedDetail = detail),
          );

          expect(longPressedDate, isNull);
          expect(longPressedDetail, isNull);

          await tester.longPressAt(tester.getCenter(view.body), buttons: longPress.buttons);

          expect(longPressedDate, isNotNull);
          expect(longPressedDetail, view.detail);
        });
      }

      testWidgets('drag-to-create fires onEventCreate and onEventCreated, not onEventChange/onEventChanged', (
        tester,
      ) async {
        KalenderEvent? createdEvent;
        KalenderEvent? createdConfirmed;
        KalenderEvent? changedBefore;
        KalenderEvent? changedAfter;

        await pumpView(
          tester,
          view,
          callbacks: KalenderCallbacks(
            onEventCreate: (event) {
              createdEvent = event;
              return event;
            },
            onEventCreated: (event) => createdConfirmed = event,
            onEventChange: (event) => changedBefore = event,
            onEventChanged: (_, updated) => changedAfter = updated,
          ),
        );

        expect(createdEvent, isNull);
        expect(createdConfirmed, isNull);

        await tester.dragFrom(tester.getCenter(view.body), view.dragOffset);

        expect(createdEvent, isNotNull);
        expect(createdConfirmed, isNotNull);
        expect(changedBefore, isNull);
        expect(changedAfter, isNull);
      });

      testWidgets('drag-to-reschedule fires onEventChange and onEventChanged', (tester) async {
        KalenderEvent? changedBefore;
        KalenderEvent? changedAfter;

        await pumpView(
          tester,
          view,
          callbacks: KalenderCallbacks(
            onEventChange: (event) => changedBefore = event,
            onEventChanged: (_, updated) => changedAfter = updated,
          ),
        );
        final id = await addEvent(tester, view);

        expect(changedBefore, isNull);
        expect(changedAfter, isNull);

        await tester.drag(find.byKey(view.tileKey(id)), view.dragOffset);

        expect(changedBefore, isNotNull);
        expect(changedAfter, isNotNull);
      });

      testWidgets('onEventTapped fires when tapping an event', (tester) async {
        KalenderEvent? tappedEvent;
        TapDetail? tappedDetail;

        await pumpView(
          tester,
          view,
          callbacks: KalenderCallbacks(
            onEventTapped: (event) => tappedEvent = event,
            onEventTappedWithDetail: (event, detail) => tappedDetail = detail,
          ),
        );
        final id = await addEvent(tester, view);

        expect(tappedEvent, isNull);
        expect(tappedDetail, isNull);

        await view.tapEvent(tester, find.byKey(view.gestureDetectorKey(id)));
        await tester.pumpAndSettle();

        expect(tappedEvent?.id, id);
        expect(tappedDetail?.renderBox.hasSize, isTrue);
        expect(tappedDetail, view.eventTapDetail);
      });

      testWidgets('onPageChanged fires when navigating pages', (tester) async {
        KalenderDateTimeRange? changedRange;

        await pumpView(tester, view, callbacks: KalenderCallbacks(onPageChanged: (range) => changedRange = range));

        expect(changedRange, isNull);

        // Use jumpToDate instead of animateToNextPage to avoid animation that never settles.
        kalenderController.jumpToDate(view.nextPage);
        await tester.pumpAndSettle();

        expect(changedRange, isNotNull);
      });

      testWidgets('onEventCreate returning null falls back to default event', (tester) async {
        KalenderEvent? createdConfirmed;

        await pumpView(
          tester,
          view,
          callbacks: KalenderCallbacks(
            onEventCreate: (event) => null,
            onEventCreated: (event) => createdConfirmed = event,
          ),
        );

        await tester.dragFrom(tester.getCenter(view.body), view.dragOffset);

        expect(createdConfirmed, isNotNull);
      });
    });

    group('${view.name} Imprecise Callbacks', () {
      testWidgets('long-press drag-to-create fires onEventCreate and onEventCreated', (tester) async {
        KalenderEvent? createdEvent;
        KalenderEvent? createdConfirmed;

        await pumpView(
          tester,
          view,
          interaction: impreciseInteraction,
          callbacks: KalenderCallbacks(
            onEventCreate: (event) {
              createdEvent = event;
              return event;
            },
            onEventCreated: (event) => createdConfirmed = event,
          ),
        );

        expect(createdEvent, isNull);
        expect(createdConfirmed, isNull);

        await tester.longPressDrag(tester.getCenter(view.body), view.dragOffset);

        expect(createdEvent, isNotNull);
        expect(createdConfirmed, isNotNull);
      });

      testWidgets('long-press drag-to-reschedule fires onEventChange and onEventChanged', (tester) async {
        KalenderEvent? changedBefore;
        KalenderEvent? changedAfter;

        await pumpView(
          tester,
          view,
          interaction: impreciseInteraction,
          callbacks: KalenderCallbacks(
            onEventChange: (event) => changedBefore = event,
            onEventChanged: (_, updated) => changedAfter = updated,
          ),
        );
        final id = await addEvent(tester, view);

        expect(changedBefore, isNull);
        expect(changedAfter, isNull);

        await tester.longPressDragWidget(find.byKey(view.tileKey(id)), view.dragOffset);

        expect(changedBefore, isNotNull);
        expect(changedAfter, isNotNull);
      });
    });
  }

  group('Empty Callbacks (negative tests)', () {
    for (final view in views) {
      testWidgets('${view.name} renders and responds without callbacks', (tester) async {
        await pumpView(tester, view, callbacks: const KalenderCallbacks());

        await tester.tapAt(tester.getCenter(view.body));
        await tester.longPressAt(tester.getCenter(view.body));
        await tester.dragFrom(tester.getCenter(view.body), view.dragOffset);
      });
    }
  });
}
