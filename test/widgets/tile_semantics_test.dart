// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// How the widgets inside an event tile appear to a screen reader.
void main() {
  final monday = DateTime(2025, 3, 24);

  for (final mergeSemantics in [true, false]) {
    testWidgets(
      'mergeSemantics $mergeSemantics ${mergeSemantics ? 'merges a button into' : 'keeps a button apart from'} its tile',
      (tester) async {
        final semantics = tester.ensureSemantics();
        final eventsController = DefaultEventsController()
          ..addEvent(KalenderEvent(start: monday.copyWith(hour: 9), end: monday.copyWith(hour: 10)));
        final kalenderController = KalenderController(
          viewConfiguration: MultiDayViewConfiguration.singleDay(
            displayRange: KalenderDateTimeRange(start: monday, end: DateTime(2025, 3, 31)),
            initialDateTime: monday,
            initialTimeOfDay: const KalenderTime(hour: 8, minute: 0),
            initialHeightPerMinute: 2,
          ),
        );

        await pumpKalender(
          tester,
          eventsController: eventsController,
          kalenderController: kalenderController,
          views: [
            MultiDayViewParts(
              body: MultiDayBody(
                tileComponents: TileComponents(
                  tileBuilder: (context, event, tileRange) => Column(
                    children: [
                      const Text('Standup'),
                      TextButton(onPressed: () {}, child: const Text('Join')),
                    ],
                  ),
                  mergeSemantics: mergeSemantics,
                ),
              ),
            ),
          ],
        );

        expect(
          identical(tester.getSemantics(find.text('Standup')), tester.getSemantics(find.text('Join'))),
          mergeSemantics,
        );
        semantics.dispose();
      },
    );
  }
}
