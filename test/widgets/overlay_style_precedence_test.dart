// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// Overlay builders resolve most-specific-first, and the theme styles the overflow button in both views.
void main() {
  KalenderThemeData themeColoured(Color color) => KalenderThemeData(
    multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle(textStyle: TextStyle(color: color)),
  );

  // Leaves out the hidden-event count, which varies with the cell height.
  OverlayBuilders buildersLabelled(String label) =>
      OverlayBuilders(multiDayPortalOverlayButtonStringBuilder: (context, numberOfHiddenEvents) => label);

  Set<Color?> buttonColors(WidgetTester tester) => overflowButtonTexts(tester).map((text) => text.style?.color).toSet();

  group('Month body overlay resolution', () {
    Future<void> pumpMonthView(WidgetTester tester, {KalenderComponents? components, KalenderThemeData? theme}) {
      // 29 Jan 2025 sits in the last row of a 5-row January.
      return pumpOverflowingMonth(tester, day: DateTime.utc(2025, 1, 29), components: components, scoped: theme);
    }

    testWidgets('the theme styles the overflow button', (tester) async {
      await pumpMonthView(tester, theme: themeColoured(Colors.green));

      expect(buttonColors(tester), {Colors.green});
    });

    testWidgets('the month body builders win over the global builders', (tester) async {
      await pumpMonthView(
        tester,
        components: KalenderComponents(
          overlayBuilders: buildersLabelled('global'),
          monthComponents: MonthComponents(
            bodyComponents: MonthBodyComponents(overlayBuilders: buildersLabelled('specific')),
          ),
        ),
      );

      expect(overflowButtonLabels(tester), {'specific'}, reason: 'the more specific month body builder should win');
    });

    testWidgets('the global builders are used when the month body sets none', (tester) async {
      await pumpMonthView(tester, components: KalenderComponents(overlayBuilders: buildersLabelled('global')));

      expect(overflowButtonLabels(tester), {'global'}, reason: 'the global builder should still apply as a fallback');
    });
  });

  group('Multi-day header overlay resolution', () {
    Future<void> pumpWeekView(WidgetTester tester, {KalenderComponents? components, KalenderThemeData? theme}) {
      final day = DateTime.utc(2025, 1, 15);
      final view = KalenderView(
        eventsController: controllerWithOverflowOn(day),
        kalenderController: KalenderController(
          viewConfiguration: MultiDayViewConfiguration.week(displayRange: year2025DisplayRange, initialDateTime: day),
        ),
        components: components,
        header: const KalenderHeader(
          multiDayHeaderConfiguration: MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1),
        ),
      );

      return pumpAndSettleWithMaterialApp(tester, theme == null ? view : KalenderTheme(data: theme, child: view));
    }

    testWidgets('the theme styles the overflow button', (tester) async {
      await pumpWeekView(tester, theme: themeColoured(Colors.green));

      expect(buttonColors(tester), {Colors.green});
    });

    testWidgets('the header builders win over the global builders', (tester) async {
      await pumpWeekView(
        tester,
        components: KalenderComponents(
          overlayBuilders: buildersLabelled('global'),
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(overlayBuilders: buildersLabelled('specific')),
          ),
        ),
      );

      expect(overflowButtonLabels(tester), {'specific'}, reason: 'the more specific header builder should win');
    });
  });
}
