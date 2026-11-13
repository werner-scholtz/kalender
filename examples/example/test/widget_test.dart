// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:example/main.dart';
import 'package:example/working_hours_cell.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders the calendar and toolbar', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(KalenderView), findsOneWidget);
    expect(find.byIcon(Icons.today), findsOneWidget);
  });

  testWidgets('draws a working hours cell for each day of the week', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(WorkingHoursCell), findsNWidgets(7));
  });

  group('WorkingHoursCell shades', () {
    final monday = DateTime(2026, 11, 16);
    final saturday = DateTime(2026, 11, 21);
    final sixToTen = KalenderTimeRange(
      start: const KalenderTime(hour: 6, minute: 0),
      end: const KalenderTime(hour: 21, minute: 59),
    );
    final tenToNoon = KalenderTimeRange(
      start: const KalenderTime(hour: 10, minute: 0),
      end: const KalenderTime(hour: 11, minute: 59),
    );

    // A quarter pixel per minute in a column 100 wide.
    final cases = [
      (
        name: 'the hours before 09:00 and after 17:00 on a weekday',
        date: monday,
        isToday: false,
        range: sixToTen,
        rects: const [Rect.fromLTRB(0, 0, 100, 45), Rect.fromLTRB(0, 165, 100, 240)],
      ),
      (
        name: 'the whole column on a Saturday',
        date: saturday,
        isToday: false,
        range: sixToTen,
        rects: const [Rect.fromLTRB(0, 0, 100, 240)],
      ),
      (
        name: 'the whole column under the hours on today',
        date: monday,
        isToday: true,
        range: sixToTen,
        rects: const [
          Rect.fromLTRB(0, 0, 100, 240),
          Rect.fromLTRB(0, 0, 100, 45),
          Rect.fromLTRB(0, 165, 100, 240),
        ],
      ),
      (
        name: 'nothing inside a range within working hours',
        date: monday,
        isToday: false,
        range: tenToNoon,
        rects: const [Rect.fromLTRB(0, 0, 100, 0), Rect.fromLTRB(0, 30, 100, 30)],
      ),
    ];

    for (final c in cases) {
      testWidgets(c.name, (tester) async {
        final details = DayCellDetails(
          date: c.date,
          isToday: c.isToday,
          isSelected: false,
          timeOfDayRange: c.range,
          heightPerMinute: 0.25,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: c.range.duration.inMinutes * 0.25,
                child: WorkingHoursCell(details),
              ),
            ),
          ),
        );

        final boxes = find.descendant(of: find.byType(WorkingHoursCell), matching: find.byType(ColoredBox));
        final rects = [for (var i = 0; i < boxes.evaluate().length; i++) tester.getRect(boxes.at(i))];
        expect(rects, c.rects);
      });
    }
  });

  testWidgets('unmounts without error', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Replacing the tree disposes the calendar, which catches dispose() paths
    // that touch a deactivated context.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
