// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Every overlay builder takes a [BuildContext] and resolves its own styles.
/// The overlay itself is built into an [Overlay] rather than below the calendar,
/// so its builder's context has to reach a [KalenderTheme] across that boundary.
void main() {
  final day = DateTime.utc(2025, 1, 15);

  for (final (name, scoped, matcher) in <(String, KalenderThemeData?, Matcher)>[
    // The Material defaults populate the style even when the app sets nothing.
    ('a custom portal builder resolves the overlay styles from its context', null, isNotNull),
    (
      'a scoped theme reaches the custom portal builder',
      const KalenderThemeData(multiDayOverlayStyle: MultiDayOverlayStyle(width: 321)),
      isA<MultiDayOverlayStyle>().having((style) => style.width, 'width', 321),
    ),
  ]) {
    testWidgets(name, (tester) async {
      MultiDayOverlayStyle? received;

      await pumpOverflowingMonth(
        tester,
        day: day,
        scoped: scoped,
        components: KalenderComponents(
          overlayBuilders: OverlayBuilders(
            multiDayOverlayPortalBuilder:
                (
                  context, {
                  required date,
                  required events,
                  required numberOfHiddenRows,
                  required tileHeight,
                  required overlayBuilders,
                }) {
                  received = KalenderTheme.of(context).multiDayOverlayStyle;
                  return const SizedBox();
                },
          ),
        ),
      );

      expect(received, matcher);
    });
  }

  testWidgets('a custom overflow button builder resolves its style from its context', (tester) async {
    MultiDayPortalOverlayButtonStyle? received;

    await pumpOverflowingMonth(
      tester,
      day: day,
      scoped: const KalenderThemeData(
        multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle(textStyle: TextStyle(fontSize: 21)),
      ),
      components: KalenderComponents(
        overlayBuilders: OverlayBuilders(
          multiDayPortalOverlayButtonBuilder: (context, controller, numberOfHiddenRows) {
            received = KalenderTheme.of(context).multiDayPortalOverlayButtonStyle;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(received?.textStyle?.fontSize, equals(21));
  });

  testWidgets('a custom overlay builder resolves its style across the Overlay boundary', (tester) async {
    MultiDayOverlayStyle? received;

    await pumpOverflowingMonth(
      tester,
      day: day,
      scoped: const KalenderThemeData(multiDayOverlayStyle: MultiDayOverlayStyle(width: 321)),
      components: KalenderComponents(
        overlayBuilders: OverlayBuilders(
          multiDayOverlayBuilder:
              (
                context, {
                required date,
                required events,
                required tileHeight,
                required portalController,
                required overlayTileBuilder,
                required getMultiDayEventLayoutRenderBox,
                required getOverlayPortalRenderBox,
              }) {
                received = KalenderTheme.of(context).multiDayOverlayStyle;
                return const SizedBox();
              },
        ),
      ),
    );

    await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(day)));
    await tester.pumpAndSettle();

    expect(received?.width, equals(321));
  });

  testWidgets('the built-in overlay still follows a scoped theme with nothing passed to it', (tester) async {
    await pumpOverflowingMonth(
      tester,
      day: day,
      scoped: const KalenderThemeData(multiDayOverlayStyle: MultiDayOverlayStyle(width: 321)),
      components: const KalenderComponents(overlayBuilders: OverlayBuilders()),
    );

    final card = tester.getSize(await tester.openOverflowOverlay(day));
    expect(card.width, moreOrLessEquals(321, epsilon: 0.5));
  });
}
