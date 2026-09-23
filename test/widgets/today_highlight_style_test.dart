// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// The today highlight defaults to the ColorScheme and follows DayNumberStyle from the theme.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
  });

  final now = DateTime(2025, 3, 24, 12);

  Future<void> pumpMonth(WidgetTester tester, {KalenderThemeData? theme}) {
    kalenderController = KalenderController(
      viewConfiguration: MonthViewConfiguration.singleMonth(
        displayRange: KalenderDateTimeRange(start: DateTime(2025, 2), end: DateTime(2025, 5)),
        initialDateTime: now,
        nowCallback: () => now,
      ),
    );
    final view = KalenderView(
      eventsController: eventsController,
      kalenderController: kalenderController,
      body: const KalenderBody(),
    );
    return pumpAndSettleWithMaterialApp(tester, theme == null ? view : KalenderTheme(data: theme, child: view));
  }

  /// The colors the today button resolves for its disabled (always) state.
  (Color?, Color?) todayColors(WidgetTester tester) {
    final button = tester.widget<IconButton>(find.byKey(MonthDayHeader.todayKey));
    const states = <WidgetState>{WidgetState.disabled};
    return (button.style?.backgroundColor?.resolve(states), button.style?.foregroundColor?.resolve(states));
  }

  testWidgets('defaults to the secondary container pair', (tester) async {
    await pumpMonth(tester);

    final scheme = ThemeData(brightness: Brightness.light).colorScheme;
    expect(todayColors(tester), (scheme.secondaryContainer, scheme.onSecondaryContainer));
  });

  testWidgets('the theme can change the today highlight', (tester) async {
    const background = Color(0xFF123456);
    const foreground = Color(0xFF654321);

    await pumpMonth(
      tester,
      theme: const KalenderThemeData(
        dayNumberStyle: DayNumberStyle(todayBackgroundColor: background, todayForegroundColor: foreground),
      ),
    );

    expect(todayColors(tester), (background, foreground));
    final number = find.descendant(of: find.byKey(MonthDayHeader.todayKey), matching: find.byType(Text));
    expect(tester.widget<Text>(number).style?.color, foreground, reason: 'the number text sets its own color');
  });
}
