// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/internal_components/day_number.dart';

// DayNumber: a non-interactive day number with the tonal today and selected highlights.
void main() {
  const todayKey = ValueKey('test.today');
  final date = FloatingDateTime(2025, 3, 15);

  late KalenderController controller;
  setUp(() => controller = KalenderController());
  tearDown(() => controller.dispose());

  Future<ColorScheme> pump(WidgetTester tester, {required bool isToday, Size? size, DayNumberStyle? style}) async {
    late ColorScheme colorScheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: Scaffold(
          body: KalenderControllerProvider(
            notifier: controller,
            child: Builder(
              builder: (context) {
                colorScheme = Theme.of(context).colorScheme;
                final number = DayNumber(date: date, text: '15', isToday: isToday, todayKey: todayKey, size: size);
                if (style == null) return number;
                return KalenderTheme(
                  data: KalenderThemeData(dayNumberStyle: style),
                  child: number,
                );
              },
            ),
          ),
        ),
      ),
    );
    return colorScheme;
  }

  IconButton button(WidgetTester tester) => tester.widget<IconButton>(find.byType(IconButton));

  testWidgets('is never interactive', (tester) async {
    await pump(tester, isToday: false);
    expect(button(tester).onPressed, isNull);

    await pump(tester, isToday: true);
    expect(button(tester).onPressed, isNull, reason: 'the highlight is a label too');
  });

  testWidgets('applies the today key only when it is today', (tester) async {
    await pump(tester, isToday: true);
    expect(find.byKey(todayKey), findsOne);

    await pump(tester, isToday: false);
    expect(find.byKey(todayKey), findsNothing);
    expect(find.text('15'), findsOne, reason: 'the number still renders, just unhighlighted');
  });

  testWidgets('today keeps the tonal colors rather than the disabled greys', (tester) async {
    final colorScheme = await pump(tester, isToday: true);
    final style = button(tester).style;

    expect(
      style?.backgroundColor?.resolve({WidgetState.disabled}),
      colorScheme.secondaryContainer,
      reason: 'a disabled button would otherwise paint onSurface at 12% opacity',
    );
    expect(style?.foregroundColor?.resolve({WidgetState.disabled}), colorScheme.onSecondaryContainer);
    expect(tester.widget<Text>(find.text('15')).style?.color, colorScheme.onSecondaryContainer);
  });

  testWidgets('a day that is not today is not given a background', (tester) async {
    await pump(tester, isToday: false);
    expect(button(tester).style, isNull);
  });

  testWidgets('size tightens the button, null keeps its natural size', (tester) async {
    // IconButton keeps its own tap target around the size, so assert what is passed down.
    await pump(tester, isToday: true, size: const Size(28, 28));
    expect(button(tester).constraints, BoxConstraints.tight(const Size(28, 28)));
    expect(button(tester).padding, EdgeInsets.zero, reason: 'the padding would fight a tight size');

    await pump(tester, isToday: true);
    expect(button(tester).constraints, isNull, reason: 'no size means the button decides');
    expect(button(tester).padding, isNull);
  });

  group('selection', () {
    const states = <WidgetState>{WidgetState.disabled};
    const today = DayNumberStyle(todayBackgroundColor: Color(0xFF000001), todayForegroundColor: Color(0xFF000002));
    const side = BorderSide(color: Color(0xFF000003), width: 2);

    group('with the date selected', () {
      setUp(() => controller.selectDate(DateTime(2025, 3, 15)));

      testWidgets('a selected day that is not today gets the selected values', (tester) async {
        await pump(
          tester,
          isToday: false,
          style: today.copyWith(selectedBackgroundColor: const Color(0xFF000004), selectedBorder: side),
        );

        final style = button(tester).style!;
        expect(style.backgroundColor?.resolve(states), const Color(0xFF000004));
        expect(style.side?.resolve(states), side);
        expect(find.byKey(todayKey), findsNothing);
      });

      testWidgets('a day both today and selected falls back to the today colors', (tester) async {
        await pump(tester, isToday: true, style: today.copyWith(selectedBorder: side));

        final style = button(tester).style!;
        expect(style.backgroundColor?.resolve(states), const Color(0xFF000001));
        expect(style.foregroundColor?.resolve(states), const Color(0xFF000002));
        expect(style.side?.resolve(states), side, reason: 'today sets no border, so the selected one shows');
        expect(find.byKey(todayKey), findsOne);
      });

      testWidgets('a day both today and selected takes the selected colors and the today border', (tester) async {
        const todayBorder = BorderSide(color: Color(0xFF000006));
        await pump(
          tester,
          isToday: true,
          style: today.copyWith(
            todayBorder: todayBorder,
            selectedBackgroundColor: const Color(0xFF000004),
            selectedBorder: side,
          ),
        );

        final style = button(tester).style!;
        expect(style.backgroundColor?.resolve(states), const Color(0xFF000004));
        expect(style.side?.resolve(states), todayBorder);
      });

      testWidgets('the number text takes the foreground color', (tester) async {
        await pump(tester, isToday: true, style: today.copyWith(selectedForegroundColor: const Color(0xFF000005)));
        expect(tester.widget<Text>(find.text('15')).style?.color, const Color(0xFF000005));

        controller.deselectRange();
        await tester.pump();
        expect(tester.widget<Text>(find.text('15')).style?.color, const Color(0xFF000002));
      });
    });

    testWidgets('follows the controller', (tester) async {
      await pump(tester, isToday: false, style: const DayNumberStyle(selectedBorder: side));
      expect(button(tester).style, isNull);

      controller.selectRange(KalenderDateTimeRange(start: DateTime(2025, 3, 14), end: DateTime(2025, 3, 17)));
      await tester.pump();
      expect(button(tester).style?.side?.resolve(states), side);

      controller.selectDate(DateTime(2025, 3, 16));
      await tester.pump();
      expect(button(tester).style, isNull);

      controller.deselectRange();
      await tester.pump();
      expect(button(tester).style, isNull);
    });
  });
}
