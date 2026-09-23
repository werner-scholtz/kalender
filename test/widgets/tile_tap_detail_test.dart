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
  late _Taps taps;

  setUp(() {
    eventsController = DefaultEventsController();
    taps = _Taps();
  });

  KalenderCallbacks recordingCallbacks() => KalenderCallbacks(
    onEventTapped: (event) => taps.tapped = event,
    onEventTappedWithDetail: (event, detail) => taps.tappedDetail = detail,
    onEventSecondaryTapped: (event) => taps.secondaryTapped = event,
    onEventSecondaryTappedWithDetail: (event, detail) => taps.secondaryTappedDetail = detail,
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
          kalenderController = KalenderController(
            viewConfiguration: ScheduleViewConfiguration.continuous(
              displayRange: KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 2)),
              initialDateTime: day,
            ),
          );
          await pumpKalender(
            tester,
            eventsController: eventsController,
            kalenderController: kalenderController,
            callbacks: recordingCallbacks(),
            body: KalenderBody(interaction: kPreciseInteraction),
          );
          return id;
        }

        testWidgets('a tap reports the event and its day', (tester) async {
          final id = await pumpSchedule(tester);

          await tester.tap(find.byKey(ScheduleEventTile.gestureDetectorKey(id)));
          await tester.pumpAndSettle();

          expect(taps.tapped?.id, id);
          expectDayDetail(taps.tappedDetail, day);
        });

        testWidgets('a secondary tap reports the event and its day', (tester) async {
          final id = await pumpSchedule(tester);

          await tester.tap(
            find.byKey(ScheduleEventTile.gestureDetectorKey(id)),
            buttons: kSecondaryMouseButton,
            kind: PointerDeviceKind.mouse,
          );
          await tester.pumpAndSettle();

          expect(taps.secondaryTapped?.id, id);
          expectDayDetail(taps.secondaryTappedDetail, day);
        });
      });

      group('Multi-day overlay tile', () {
        final monday = DateTime(2025, 6, 2);

        Future<String> openOverlay(WidgetTester tester) async {
          final id = eventsController.addEvent(KalenderEvent(start: monday, end: monday.add(const Duration(days: 2))));
          eventsController.addEvent(KalenderEvent(start: monday, end: monday.add(const Duration(days: 2))));
          kalenderController = KalenderController(
            viewConfiguration: MultiDayViewConfiguration.week(
              displayRange: KalenderDateTimeRange(start: monday, end: monday.add(const Duration(days: 7))),
              initialDateTime: monday,
            ),
          );
          await pumpKalender(
            tester,
            eventsController: eventsController,
            kalenderController: kalenderController,
            callbacks: recordingCallbacks(),
            header: KalenderHeader(
              multiDayHeaderConfiguration: const MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1),
              interaction: kPreciseInteraction,
            ),
            body: KalenderBody(interaction: kPreciseInteraction),
          );

          final firstDay = kalenderController.floatingVisibleRange.value!.dates().first;
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

          expect(taps.tapped?.id, id);
          expectDayDetail(taps.tappedDetail, monday);
        });

        testWidgets('a secondary tap reports the event and the overlay day', (tester) async {
          final id = await openOverlay(tester);

          await tester.tap(
            find.byKey(MultiDayEventOverlayTile.gestureDetectorKey(id)),
            buttons: kSecondaryMouseButton,
            kind: PointerDeviceKind.mouse,
          );
          await tester.pumpAndSettle();

          expect(taps.secondaryTapped?.id, id);
          expectDayDetail(taps.secondaryTappedDetail, monday);
        });
      });
    },
  );
}

class _Taps {
  KalenderEvent? tapped;
  TapDetail? tappedDetail;
  KalenderEvent? secondaryTapped;
  TapDetail? secondaryTappedDetail;
}
