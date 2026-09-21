// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// #252
void main() {
  group('MonthBodyConfiguration eventPadding (#252)', () {
    test('defaults to kDefaultMultiDayEventPadding', () {
      expect(const MonthBodyConfiguration().eventPadding, kDefaultMultiDayEventPadding);
    });

    test('copyWith updates eventPadding', () {
      const updated = EdgeInsets.all(9);
      final config = const MonthBodyConfiguration(eventPadding: EdgeInsets.all(1)).copyWith(eventPadding: updated);
      expect(config.eventPadding, updated);
    });

    test('copyWith preserves eventPadding when it is not passed', () {
      const padding = EdgeInsets.all(4);
      final config = const MonthBodyConfiguration(eventPadding: padding).copyWith(tileHeight: 30);
      expect(config.eventPadding, padding);
    });

    testWidgets('applies the configured eventPadding to month event tiles', (tester) async {
      const padding = EdgeInsets.fromLTRB(11, 12, 13, 14);
      final eventsController = DefaultEventsController();
      final kalenderController = KalenderController();

      eventsController.addEvent(KalenderEvent(start: DateTime(2025, 1, 15, 9), end: DateTime(2025, 1, 15, 10)));

      await pumpAndSettleWithMaterialApp(
        tester,
        KalenderView(
          eventsController: eventsController,
          kalenderController: kalenderController,
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: KalenderDateTimeRange(start: DateTime(2024, 12), end: DateTime(2025, 3)),
            initialDateTime: DateTime(2025, 1),
          ),
          body: const KalenderBody(monthBodyConfiguration: MonthBodyConfiguration(eventPadding: padding)),
        ),
      );

      expect(
        find.ancestor(
          of: find.byType(MultiDayEventTile),
          matching: find.byWidgetPredicate((widget) => widget is Padding && widget.padding == padding),
        ),
        findsWidgets,
      );
    });
  });
}
