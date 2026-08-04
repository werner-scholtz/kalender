import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  /// Pumps a [MaterialApp] with the given [extension] and hands the inner context to [callback].
  Future<void> pumpWithTheme(
    WidgetTester tester, {
    KalenderThemeData? extension,
    required void Function(BuildContext context) callback,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [if (extension != null) extension]),
        home: Builder(
          builder: (context) {
            callback(context);
            return const SizedBox();
          },
        ),
      ),
    );
  }

  group('KalenderTheme.of', () {
    testWidgets('returns the Material 3 defaults when no extension is registered', (tester) async {
      await pumpWithTheme(
        tester,
        callback: (context) {
          final theme = KalenderTheme.of(context);
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;

          expect(theme.hourLinesStyle?.color, colorScheme.surfaceContainerHighest);
          expect(theme.hourLinesStyle?.thickness, 1);
          expect(theme.daySeparatorStyle?.color, colorScheme.surfaceContainerHighest);
          expect(theme.timeIndicatorStyle?.lineColor, colorScheme.error);
          expect(theme.timeIndicatorStyle?.circleSize, const Size(10, 10));
          expect(theme.timeIndicatorStyle?.circleColor, null);
          expect(theme.dayHeaderStyle?.textStyle, textTheme.bodySmall);
          expect(theme.dayHeaderStyle?.numberTextStyle, textTheme.bodyMedium);
          expect(theme.monthDayHeaderStyle?.numberTextStyle, textTheme.bodyMedium);
          expect(theme.monthDayHeaderStyle?.buttonSize, null);
          expect(theme.monthDayHeaderStyle?.margin, const EdgeInsets.symmetric(vertical: 2));
          expect(theme.scheduleDateStyle?.numberTextStyle, textTheme.bodyMedium);
          expect(theme.timelineStyle?.textPadding, const EdgeInsets.symmetric(horizontal: 8, vertical: 36));
          expect(theme.monthGridStyle?.thickness, 0);
          expect(theme.weekNumberStyle?.tooltip, 'Week Number');
          expect(theme.multiDayOverlayStyle?.eventPadding, const EdgeInsets.symmetric(vertical: 2));
          expect(theme.multiDayPortalOverlayButtonStyle?.textOverflow, TextOverflow.ellipsis);
        },
      );
    });

    testWidgets('extension fields overlay the defaults, field by field', (tester) async {
      const extension = KalenderThemeData(
        timeIndicatorStyle: TimeIndicatorStyle(lineColor: Color(0xFF00FF00)),
        hourLinesStyle: HourLinesStyle(thickness: 3),
      );

      await pumpWithTheme(
        tester,
        extension: extension,
        callback: (context) {
          final theme = KalenderTheme.of(context);
          final colorScheme = Theme.of(context).colorScheme;

          // Overridden fields come from the extension.
          expect(theme.timeIndicatorStyle?.lineColor, const Color(0xFF00FF00));
          expect(theme.hourLinesStyle?.thickness, 3);

          // Fields the extension leaves null keep their defaults.
          expect(theme.timeIndicatorStyle?.thickness, 1);
          expect(theme.timeIndicatorStyle?.circleSize, const Size(10, 10));
          expect(theme.hourLinesStyle?.color, colorScheme.surfaceContainerHighest);

          // Styles the extension does not mention are untouched defaults.
          expect(theme.daySeparatorStyle?.color, colorScheme.surfaceContainerHighest);
        },
      );
    });

    testWidgets('defaults follow the ambient color scheme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
          home: Builder(
            builder: (context) {
              final theme = KalenderTheme.of(context);
              expect(theme.timeIndicatorStyle?.lineColor, Theme.of(context).colorScheme.error);
              expect(theme.hourLinesStyle?.color, Theme.of(context).colorScheme.surfaceContainerHighest);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('KalenderThemeData', () {
    test('copyWith replaces only the given styles', () {
      const data = KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 1));
      final copy = data.copyWith(monthGridStyle: const MonthGridStyle(thickness: 2));
      expect(copy.monthGridStyle?.thickness, 2);
      expect(copy.hourLinesStyle, data.hourLinesStyle);
    });

    test('copyWith keeps a style it is not given', () {
      const data = KalenderThemeData(monthGridStyle: MonthGridStyle(thickness: 2));
      final copy = data.copyWith(hourLinesStyle: const HourLinesStyle(thickness: 1));
      expect(copy.monthGridStyle, data.monthGridStyle);
    });

    test('merge overlays styles field by field', () {
      const base = KalenderThemeData(
        hourLinesStyle: HourLinesStyle(color: Color(0xFF000000), thickness: 1),
        monthGridStyle: MonthGridStyle(thickness: 0),
      );
      const overlay = KalenderThemeData(
        hourLinesStyle: HourLinesStyle(thickness: 5),
        timeIndicatorStyle: TimeIndicatorStyle(lineColor: Color(0xFF0000FF)),
      );

      final merged = base.merge(overlay);
      // Overlay wins where set, base fills the rest of the shared style.
      expect(merged.hourLinesStyle?.thickness, 5);
      expect(merged.hourLinesStyle?.color, const Color(0xFF000000));
      // Styles only one side has come through as-is.
      expect(merged.monthGridStyle?.thickness, 0);
      expect(merged.timeIndicatorStyle?.lineColor, const Color(0xFF0000FF));
      // Merging null is a no-op.
      expect(base.merge(null), base);
    });

    test('lerp interpolates the sub-styles', () {
      const a = KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 1));
      const b = KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 3));
      final mid = a.lerp(b, 0.5);
      expect(mid.hourLinesStyle?.thickness, 2);
      expect(a.lerp(null, 0.5), a);
    });

    test('equality', () {
      const a = KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 1));
      const b = KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 1));
      const c = KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 2));
      expect(a, b);
      expect(a == c, false);
    });

    test('equality compares every field', () {
      // Built without const, otherwise the two are canonicalized to one instance
      // and the comparison returns on identical() without reading any field.
      // ignore: prefer_const_constructors
      final a = KalenderThemeData(hourLinesStyle: const HourLinesStyle(thickness: 1));
      // ignore: prefer_const_constructors
      final b = KalenderThemeData(hourLinesStyle: const HourLinesStyle(thickness: 1));
      expect(identical(a, b), isFalse);
      expect(a, b);

      // The last field compared, so no earlier one can short-circuit ahead of it.
      final differsLast = a.copyWith(
        multiDayPortalOverlayButtonStyle: const MultiDayPortalOverlayButtonStyle(
          textOverflow: TextOverflow.ellipsis,
        ),
      );
      expect(a == differsLast, false);
    });

    test('hashCode follows equality', () {
      // Built without const, for the same reason as the case above.
      // ignore: prefer_const_constructors
      final a = KalenderThemeData(hourLinesStyle: const HourLinesStyle(thickness: 1));
      // ignore: prefer_const_constructors
      final b = KalenderThemeData(hourLinesStyle: const HourLinesStyle(thickness: 1));
      final c = a.copyWith(
        multiDayPortalOverlayButtonStyle: const MultiDayPortalOverlayButtonStyle(
          textOverflow: TextOverflow.ellipsis,
        ),
      );
      expect(a.hashCode, b.hashCode);
      expect(a.hashCode, isNot(c.hashCode));
    });

    testWidgets('animated theme change interpolates through ThemeData.lerp', (tester) async {
      const beginStyle = KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 1));
      const endStyle = KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 3));

      KalenderThemeData? sampled;
      Widget app(KalenderThemeData data) {
        return MaterialApp(
          theme: ThemeData(extensions: [data]),
          home: Builder(
            builder: (context) {
              sampled = Theme.of(context).extension<KalenderThemeData>();
              return const SizedBox();
            },
          ),
        );
      }

      await tester.pumpWidget(app(beginStyle));
      expect(sampled?.hourLinesStyle?.thickness, 1);

      await tester.pumpWidget(app(endStyle));
      // MaterialApp animates theme changes, so halfway through the transition
      // the extension is a lerped intermediate value.
      await tester.pump(kThemeAnimationDuration ~/ 2);
      final midThickness = sampled?.hourLinesStyle?.thickness;
      expect(midThickness, greaterThan(1));
      expect(midThickness, lessThan(3));

      await tester.pumpAndSettle();
      expect(sampled?.hourLinesStyle?.thickness, 3);
    });
  });
}
