// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/schedule_tile.dart';

import '../utilities.dart';

/// A tap on a schedule tile or on a tile inside the multi-day overlay reports the event and the day it was tapped on.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  KalenderEvent? tapped;
  KalenderEvent? secondaryTapped;
  TapDetail? tappedDetail;
  TapDetail? secondaryTappedDetail;

  final preciseInteraction = KalenderInteraction(
    inputMode: InputMode.precise,
    createEventGesture: EventInteractionGesture.tap,
    modifyEventGesture: EventInteractionGesture.tap,
  );

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
    tapped = null;
    secondaryTapped = null;
    tappedDetail = null;
    secondaryTappedDetail = null;
  });

  KalenderCallbacks recordingCallbacks() => KalenderCallbacks(
    onEventTapped: (event) => tapped = event,
    onEventTappedWithDetail: (event, detail) => tappedDetail = detail,
    onEventSecondaryTapped: (event) => secondaryTapped = event,
    onEventSecondaryTappedWithDetail: (event, detail) => secondaryTappedDetail = detail,
  );

  void expectDayDetail(TapDetail? detail, DateTime day) {
    expect(detail, isA<MultiDayDetail>());
    final range = (detail! as MultiDayDetail).dateTimeRange;
    expect(range.start.toUtc(), DateTime(day.year, day.month, day.day).toUtc());
    expect(range.end.toUtc(), DateTime(day.year, day.month, day.day + 1).toUtc());
  }

  testWithTimeZones(
    body: (timezone, _) {
      group('Schedule tile', () {
        final day = DateTime(2025, 1, 15);

        Future<String> pumpSchedule(WidgetTester tester) async {
          final id = eventsController.addEvent(
            KalenderEvent(start: day.copyWith(hour: 10), end: day.copyWith(hour: 11)),
          );
          await pumpAndSettleWithMaterialApp(
            tester,
            KalenderView(
              eventsController: eventsController,
              kalenderController: kalenderController,
              viewConfiguration: ScheduleViewConfiguration.continuous(
                displayRange: KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 2)),
                initialDateTime: day,
              ),
              callbacks: recordingCallbacks(),
              body: KalenderBody(interaction: preciseInteraction),
            ),
          );
          return id;
        }

        testWidgets('a tap reports the event and its day', (tester) async {
          final id = await pumpSchedule(tester);

          await tester.tap(find.byKey(ScheduleEventTile.gestureDetectorKey(id)));
          await tester.pumpAndSettle();

          expect(tapped?.id, id);
          expectDayDetail(tappedDetail, day);
        });

        testWidgets('a secondary tap reports the event and its day', (tester) async {
          final id = await pumpSchedule(tester);

          await tester.tap(
            find.byKey(ScheduleEventTile.gestureDetectorKey(id)),
            buttons: kSecondaryMouseButton,
            kind: PointerDeviceKind.mouse,
          );
          await tester.pumpAndSettle();

          expect(secondaryTapped?.id, id);
          expectDayDetail(secondaryTappedDetail, day);
        });
      });

      group('Multi-day overlay tile', () {
        final monday = DateTime(2025, 6, 2);

        Future<String> openOverlay(WidgetTester tester) async {
          final id = eventsController.addEvent(KalenderEvent(start: monday, end: monday.add(const Duration(days: 2))));
          eventsController.addEvent(KalenderEvent(start: monday, end: monday.add(const Duration(days: 2))));
          await pumpAndSettleWithMaterialApp(
            tester,
            KalenderView(
              eventsController: eventsController,
              kalenderController: kalenderController,
              viewConfiguration: MultiDayViewConfiguration.week(
                displayRange: KalenderDateTimeRange(start: monday, end: monday.add(const Duration(days: 7))),
                initialDateTime: monday,
              ),
              callbacks: recordingCallbacks(),
              header: KalenderHeader(
                multiDayHeaderConfiguration: const MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1),
                interaction: preciseInteraction,
              ),
              body: KalenderBody(interaction: preciseInteraction),
            ),
          );

          final firstDay = kalenderController.floatingRange.value!.dates().first;
          await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(firstDay)));
          await tester.pumpAndSettle();

          expect(find.byKey(MultiDayOverlay.getOverlayCardKey(firstDay)), findsOneWidget);
          expect(find.byKey(MultiDayEventOverlayTile.tileKey(id)), findsOneWidget);
          return id;
        }

        testWidgets('a tap reports the event and the overlay day', (tester) async {
          final id = await openOverlay(tester);

          await tester.tap(find.byKey(MultiDayEventOverlayTile.gestureDetectorKey(id)));
          await tester.pumpAndSettle();

          expect(tapped?.id, id);
          expectDayDetail(tappedDetail, monday);
        });

        testWidgets('a secondary tap reports the event and the overlay day', (tester) async {
          final id = await openOverlay(tester);

          await tester.tap(
            find.byKey(MultiDayEventOverlayTile.gestureDetectorKey(id)),
            buttons: kSecondaryMouseButton,
            kind: PointerDeviceKind.mouse,
          );
          await tester.pumpAndSettle();

          expect(secondaryTapped?.id, id);
          expectDayDetail(secondaryTappedDetail, monday);
        });
      });
    },
  );
}
