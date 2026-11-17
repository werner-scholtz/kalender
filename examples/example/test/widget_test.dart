// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:example/main.dart';
import 'package:example/working_hours_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

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
