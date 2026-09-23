// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// [ResizeHandleDetails] compares the event with the range in the calendar's location.
void main() {
  tz.initializeTimeZones();
  // Far enough from every timezone the tests run in that the events below fall on another day there.
  final kiritimati = getLocation('Pacific/Kiritimati');
  final pagoPago = getLocation('Pacific/Pago_Pago');
  final day = FloatingDateTime(2025, 1, 1).dayRange;

  ResizeHandleDetails details(KalenderEvent event, {Location? location}) => ResizeHandleDetails(
    event: event,
    interaction: KalenderInteraction(),
    range: day,
    size: const Size(100, 100),
    axis: Axis.vertical,
    isImprecise: false,
    location: location,
  );

  group('ResizeHandleDetails', () {
    final early = KalenderEvent(
      start: TZDateTime(kiritimati, 2025, 1, 1, 0, 30),
      end: TZDateTime(kiritimati, 2025, 1, 1, 2),
    );
    final late = KalenderEvent(
      start: TZDateTime(pagoPago, 2025, 1, 1, 22),
      end: TZDateTime(pagoPago, 2025, 1, 1, 23, 30),
    );

    test('uses its location', () {
      expect(details(early, location: kiritimati).continuesBefore, isFalse);
      expect(details(early, location: kiritimati).showStart, isTrue);
      expect(details(late, location: pagoPago).continuesAfter, isFalse);
      expect(details(late, location: pagoPago).showEnd, isTrue);
    });

    test('uses the device timezone without a location', () {
      expect(details(early).continuesBefore, FloatingDateTime.fromExternal(early.start).isBefore(day.start));
      expect(details(late).continuesAfter, FloatingDateTime.fromExternal(late.end).isAfter(day.end));
    });
  });

  testWidgets('a resize handle positioner receives the calendar location', (tester) async {
    final eventsController = DefaultEventsController();
    final kalenderController = KalenderController(
      location: kiritimati,
      viewConfiguration: MultiDayViewConfiguration.singleDay(
        displayRange: KalenderDateTimeRange(start: DateTime.utc(2024, 12), end: DateTime.utc(2025, 2)),
        initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        initialDateTime: TZDateTime(kiritimati, 2025, 1, 1),
      ),
    );
    addTearDown(eventsController.dispose);
    addTearDown(kalenderController.dispose);

    eventsController.addEvent(
      KalenderEvent(start: TZDateTime(kiritimati, 2025, 1, 1, 1), end: TZDateTime(kiritimati, 2025, 1, 1, 4)),
    );

    Location? received;
    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        views: [
          MultiDayViewParts(
            header: const SizedBox.shrink(),
            body: MultiDayBody(
              tileComponents: TileComponents(
                tileBuilder: (context, event, tileRange) => const SizedBox.expand(),
                resizeHandlePositioner: (context, details) {
                  received = details.location;
                  return DefaultResizeHandles(details: details);
                },
              ),
            ),
          ),
        ],
      ),
    );

    expect(received, kiritimati);
  });
}
