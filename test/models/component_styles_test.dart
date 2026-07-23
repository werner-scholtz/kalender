import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Covers the copyWith/merge/lerp/equality contract shared by all component style classes.
///
/// Each class follows the same rules:
/// - copyWith replaces only the given fields.
/// - merge overlays the non-null fields of the other style onto this one.
/// - lerp interpolates lerpable fields and switches the rest at the midpoint.
/// - Styles with the same field values are equal.
void main() {
  group('DayHeaderStyle', () {
    const a = DayHeaderStyle(textStyle: TextStyle(fontSize: 10), mainAxisAlignment: MainAxisAlignment.start);
    const b = DayHeaderStyle(textStyle: TextStyle(fontSize: 20), mainAxisAlignment: MainAxisAlignment.end);

    test('copyWith', () {
      final copy = a.copyWith(numberTextStyle: const TextStyle(fontSize: 8));
      expect(copy.numberTextStyle, const TextStyle(fontSize: 8));
      expect(copy.textStyle, a.textStyle);
      expect(copy.mainAxisAlignment, a.mainAxisAlignment);
    });

    test('merge', () {
      final merged = a.merge(const DayHeaderStyle(textStyle: TextStyle(fontSize: 30)));
      expect(merged.textStyle, const TextStyle(fontSize: 30));
      expect(merged.mainAxisAlignment, a.mainAxisAlignment);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = DayHeaderStyle.lerp(a, b, 0.5)!;
      expect(mid.textStyle?.fontSize, 15);
      expect(DayHeaderStyle.lerp(a, b, 0.25)!.mainAxisAlignment, MainAxisAlignment.start);
      expect(DayHeaderStyle.lerp(a, b, 0.75)!.mainAxisAlignment, MainAxisAlignment.end);
      expect(DayHeaderStyle.lerp(null, null, 0.5), null);
      expect(DayHeaderStyle.lerp(a, a, 0.5), a);
    });

    test('equality', () {
      expect(a, const DayHeaderStyle(textStyle: TextStyle(fontSize: 10), mainAxisAlignment: MainAxisAlignment.start));
      expect(a == b, false);
    });
  });

  group('TimelineStyle', () {
    const a = TimelineStyle(width: 10, textPadding: EdgeInsets.all(4), textDirection: TextDirection.ltr);
    const b = TimelineStyle(width: 20, textPadding: EdgeInsets.all(8), textDirection: TextDirection.rtl);

    test('copyWith', () {
      final copy = a.copyWith(width: 15);
      expect(copy.width, 15);
      expect(copy.textPadding, a.textPadding);
    });

    test('merge', () {
      final merged = a.merge(const TimelineStyle(width: 30));
      expect(merged.width, 30);
      expect(merged.textPadding, a.textPadding);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = TimelineStyle.lerp(a, b, 0.5)!;
      expect(mid.width, 15);
      expect(mid.textPadding, const EdgeInsets.all(6));
      expect(TimelineStyle.lerp(a, b, 0.25)!.textDirection, TextDirection.ltr);
      expect(TimelineStyle.lerp(a, b, 0.75)!.textDirection, TextDirection.rtl);
      expect(TimelineStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const TimelineStyle(width: 10, textPadding: EdgeInsets.all(4), textDirection: TextDirection.ltr));
      expect(a == b, false);
    });
  });

  group('HourLinesStyle', () {
    const a = HourLinesStyle(color: Color(0xFF000000), thickness: 1, indent: 0);
    const b = HourLinesStyle(color: Color(0xFFFFFFFF), thickness: 3, indent: 10);

    test('copyWith', () {
      final copy = a.copyWith(thickness: 2);
      expect(copy.thickness, 2);
      expect(copy.color, a.color);
    });

    test('merge', () {
      final merged = a.merge(const HourLinesStyle(endIndent: 5));
      expect(merged.endIndent, 5);
      expect(merged.color, a.color);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = HourLinesStyle.lerp(a, b, 0.5)!;
      expect(mid.thickness, 2);
      expect(mid.indent, 5);
      expect(mid.color, Color.lerp(a.color, b.color, 0.5));
      expect(HourLinesStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const HourLinesStyle(color: Color(0xFF000000), thickness: 1, indent: 0));
      expect(a == b, false);
    });
  });

  group('DaySeparatorStyle', () {
    const a = DaySeparatorStyle(color: Color(0xFF000000), width: 1, topIndent: 0);
    const b = DaySeparatorStyle(color: Color(0xFFFFFFFF), width: 3, topIndent: 10);

    test('copyWith', () {
      final copy = a.copyWith(width: 2);
      expect(copy.width, 2);
      expect(copy.color, a.color);
    });

    test('merge', () {
      final merged = a.merge(const DaySeparatorStyle(bottomIndent: 5));
      expect(merged.bottomIndent, 5);
      expect(merged.color, a.color);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = DaySeparatorStyle.lerp(a, b, 0.5)!;
      expect(mid.width, 2);
      expect(mid.topIndent, 5);
      expect(DaySeparatorStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const DaySeparatorStyle(color: Color(0xFF000000), width: 1, topIndent: 0));
      expect(a == b, false);
    });
  });

  group('TimeIndicatorStyle', () {
    const a = TimeIndicatorStyle(lineColor: Color(0xFF000000), thickness: 1, circleSize: Size(10, 10));
    const b = TimeIndicatorStyle(lineColor: Color(0xFFFFFFFF), thickness: 3, circleSize: Size(20, 20));

    test('copyWith', () {
      final copy = a.copyWith(circleColor: const Color(0xFF00FF00));
      expect(copy.circleColor, const Color(0xFF00FF00));
      expect(copy.lineColor, a.lineColor);
    });

    test('merge', () {
      final merged = a.merge(const TimeIndicatorStyle(thickness: 4));
      expect(merged.thickness, 4);
      expect(merged.circleSize, a.circleSize);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = TimeIndicatorStyle.lerp(a, b, 0.5)!;
      expect(mid.thickness, 2);
      expect(mid.circleSize, const Size(15, 15));
      expect(TimeIndicatorStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const TimeIndicatorStyle(lineColor: Color(0xFF000000), thickness: 1, circleSize: Size(10, 10)));
      expect(a == b, false);
    });
  });

  group('WeekNumberStyle', () {
    const a = WeekNumberStyle(tooltip: 'a', padding: EdgeInsets.all(4), alignment: Alignment.topLeft);
    const b = WeekNumberStyle(tooltip: 'b', padding: EdgeInsets.all(8), alignment: Alignment.bottomRight);

    test('copyWith', () {
      final copy = a.copyWith(tooltip: 'c');
      expect(copy.tooltip, 'c');
      expect(copy.padding, a.padding);
    });

    test('merge', () {
      final merged = a.merge(const WeekNumberStyle(visualDensity: VisualDensity.comfortable));
      expect(merged.visualDensity, VisualDensity.comfortable);
      expect(merged.tooltip, a.tooltip);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = WeekNumberStyle.lerp(a, b, 0.5)!;
      expect(mid.padding, const EdgeInsets.all(6));
      expect(mid.alignment, Alignment.center);
      expect(WeekNumberStyle.lerp(a, b, 0.25)!.tooltip, 'a');
      expect(WeekNumberStyle.lerp(a, b, 0.75)!.tooltip, 'b');
      expect(WeekNumberStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const WeekNumberStyle(tooltip: 'a', padding: EdgeInsets.all(4), alignment: Alignment.topLeft));
      expect(a == b, false);
    });
  });

  group('MonthGridStyle', () {
    const a = MonthGridStyle(color: Color(0xFF000000), thickness: 1);
    const b = MonthGridStyle(color: Color(0xFFFFFFFF), thickness: 3);

    test('copyWith', () {
      final copy = a.copyWith(thickness: 2);
      expect(copy.thickness, 2);
      expect(copy.color, a.color);
    });

    test('merge', () {
      final merged = a.merge(const MonthGridStyle(thickness: 4));
      expect(merged.thickness, 4);
      expect(merged.color, a.color);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      expect(MonthGridStyle.lerp(a, b, 0.5)!.thickness, 2);
      expect(MonthGridStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const MonthGridStyle(color: Color(0xFF000000), thickness: 1));
      expect(a == b, false);
    });
  });

  group('MonthDayHeaderStyle', () {
    const a = MonthDayHeaderStyle(numberTextStyle: TextStyle(fontSize: 10), buttonSize: Size(20, 20));
    const b = MonthDayHeaderStyle(numberTextStyle: TextStyle(fontSize: 20), buttonSize: Size(40, 40));

    test('copyWith', () {
      final copy = a.copyWith(margin: const EdgeInsets.all(2));
      expect(copy.margin, const EdgeInsets.all(2));
      expect(copy.numberTextStyle, a.numberTextStyle);
      expect(copy.buttonSize, a.buttonSize);
    });

    test('merge', () {
      final merged = a.merge(const MonthDayHeaderStyle(buttonSize: Size(30, 30)));
      expect(merged.buttonSize, const Size(30, 30));
      expect(merged.numberTextStyle, a.numberTextStyle);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = MonthDayHeaderStyle.lerp(a, b, 0.5)!;
      expect(mid.numberTextStyle?.fontSize, 15);
      expect(mid.buttonSize, const Size(30, 30));
      expect(MonthDayHeaderStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const MonthDayHeaderStyle(numberTextStyle: TextStyle(fontSize: 10), buttonSize: Size(20, 20)));
      expect(a == b, false);
    });
  });

  group('WeekDayHeaderStyle', () {
    const a = WeekDayHeaderStyle(textStyle: TextStyle(fontSize: 10), padding: EdgeInsets.all(4));
    const b = WeekDayHeaderStyle(textStyle: TextStyle(fontSize: 20), padding: EdgeInsets.all(8));

    test('copyWith', () {
      final copy = a.copyWith(padding: const EdgeInsets.all(2));
      expect(copy.padding, const EdgeInsets.all(2));
      expect(copy.textStyle, a.textStyle);
    });

    test('merge', () {
      final merged = a.merge(const WeekDayHeaderStyle(padding: EdgeInsets.all(6)));
      expect(merged.padding, const EdgeInsets.all(6));
      expect(merged.textStyle, a.textStyle);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = WeekDayHeaderStyle.lerp(a, b, 0.5)!;
      expect(mid.textStyle?.fontSize, 15);
      expect(mid.padding, const EdgeInsets.all(6));
      expect(WeekDayHeaderStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const WeekDayHeaderStyle(textStyle: TextStyle(fontSize: 10), padding: EdgeInsets.all(4)));
      expect(a == b, false);
    });
  });

  group('ScheduleDateStyle', () {
    const a = ScheduleDateStyle(textStyle: TextStyle(fontSize: 10));
    const b = ScheduleDateStyle(textStyle: TextStyle(fontSize: 20));

    test('copyWith', () {
      final copy = a.copyWith(numberTextStyle: const TextStyle(fontSize: 8));
      expect(copy.numberTextStyle, const TextStyle(fontSize: 8));
      expect(copy.textStyle, a.textStyle);
    });

    test('merge', () {
      final merged = a.merge(const ScheduleDateStyle(numberTextStyle: TextStyle(fontSize: 9)));
      expect(merged.numberTextStyle, const TextStyle(fontSize: 9));
      expect(merged.textStyle, a.textStyle);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      expect(ScheduleDateStyle.lerp(a, b, 0.5)!.textStyle?.fontSize, 15);
      expect(ScheduleDateStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const ScheduleDateStyle(textStyle: TextStyle(fontSize: 10)));
      expect(a == b, false);
    });
  });

  group('ScheduleTileHighlightStyle', () {
    const a = ScheduleTileHighlightStyle(decoration: BoxDecoration(color: Color(0xFF000000)));
    const b = ScheduleTileHighlightStyle(decoration: BoxDecoration(color: Color(0xFFFFFFFF)));

    test('copyWith', () {
      final copy = a.copyWith(decoration: const BoxDecoration(color: Color(0xFF00FF00)));
      expect(copy.decoration, const BoxDecoration(color: Color(0xFF00FF00)));
    });

    test('merge', () {
      final merged = a.merge(b);
      expect(merged.decoration, b.decoration);
      expect(a.merge(null), a);
      expect(a.merge(const ScheduleTileHighlightStyle()).decoration, a.decoration);
    });

    test('lerp', () {
      final mid = ScheduleTileHighlightStyle.lerp(a, b, 0.5)!;
      expect(mid.decoration?.color, Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5));
      expect(ScheduleTileHighlightStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(a, const ScheduleTileHighlightStyle(decoration: BoxDecoration(color: Color(0xFF000000))));
      expect(a == b, false);
    });
  });

  group('MultiDayOverlayStyle', () {
    const a = MultiDayOverlayStyle(dayNameTextStyle: TextStyle(fontSize: 10), headerPadding: EdgeInsets.all(4));
    const b = MultiDayOverlayStyle(dayNameTextStyle: TextStyle(fontSize: 20), headerPadding: EdgeInsets.all(8));

    test('copyWith', () {
      final copy = a.copyWith(closeIcon: const Icon(Icons.close));
      expect(copy.closeIcon?.icon, Icons.close);
      expect(copy.dayNameTextStyle, a.dayNameTextStyle);
    });

    test('merge', () {
      final merged = a.merge(const MultiDayOverlayStyle(eventPadding: EdgeInsets.all(2)));
      expect(merged.eventPadding, const EdgeInsets.all(2));
      expect(merged.dayNameTextStyle, a.dayNameTextStyle);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = MultiDayOverlayStyle.lerp(a, b, 0.5)!;
      expect(mid.dayNameTextStyle?.fontSize, 15);
      expect(mid.headerPadding, const EdgeInsets.all(6));
      expect(MultiDayOverlayStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(
        a,
        const MultiDayOverlayStyle(dayNameTextStyle: TextStyle(fontSize: 10), headerPadding: EdgeInsets.all(4)),
      );
      expect(a == b, false);
    });

    group('card, button, barrier and size fields', () {
      const wide = MultiDayOverlayStyle(
        cardTheme: CardThemeData(color: Color(0xFF000000), elevation: 2),
        barrierColor: Color(0xFF000000),
        width: 100,
        headerHeight: 40,
      );
      const narrow = MultiDayOverlayStyle(
        cardTheme: CardThemeData(color: Color(0xFFFFFFFF), elevation: 4),
        barrierColor: Color(0xFFFFFFFF),
        width: 200,
        headerHeight: 80,
      );

      test('copyWith', () {
        final copy = wide.copyWith(width: 300, barrierColor: const Color(0xFF00FF00));
        expect(copy.width, 300);
        expect(copy.barrierColor, const Color(0xFF00FF00));
        expect(copy.headerHeight, 40, reason: 'untouched fields are kept');
        expect(copy.cardTheme, wide.cardTheme);
      });

      test('merge', () {
        final merged = wide.merge(const MultiDayOverlayStyle(width: 250));
        expect(merged.width, 250);
        expect(merged.headerHeight, 40, reason: 'the other style leaves this null, so it is kept');
        expect(merged.barrierColor, wide.barrierColor);
      });

      test('lerp', () {
        final mid = MultiDayOverlayStyle.lerp(wide, narrow, 0.5)!;
        expect(mid.width, 150);
        expect(mid.headerHeight, 60);
        expect(mid.cardTheme?.elevation, 3);
        expect(mid.barrierColor, Color.lerp(wide.barrierColor, narrow.barrierColor, 0.5));
      });

      test('lerp keeps cardTheme null when neither side sets one', () {
        final mid = MultiDayOverlayStyle.lerp(a, b, 0.5)!;
        expect(mid.cardTheme, isNull, reason: 'CardThemeData.lerp never returns null, so this has to be guarded');
      });

      test('closeButtonStyle lerps', () {
        final mid = MultiDayOverlayStyle.lerp(
          const MultiDayOverlayStyle(closeButtonStyle: ButtonStyle(elevation: WidgetStatePropertyAll(0))),
          const MultiDayOverlayStyle(closeButtonStyle: ButtonStyle(elevation: WidgetStatePropertyAll(10))),
          0.5,
        )!;
        expect(mid.closeButtonStyle?.elevation?.resolve({}), 5);
      });

      test('equality', () {
        expect(
          wide,
          const MultiDayOverlayStyle(
            cardTheme: CardThemeData(color: Color(0xFF000000), elevation: 2),
            barrierColor: Color(0xFF000000),
            width: 100,
            headerHeight: 40,
          ),
        );
        expect(wide == narrow, false);
        expect(wide == wide.copyWith(width: 999), false);
      });
    });
  });

  group('MultiDayPortalOverlayButtonStyle', () {
    const a = MultiDayPortalOverlayButtonStyle(textStyle: TextStyle(fontSize: 10), textPadding: EdgeInsets.all(4));
    const b = MultiDayPortalOverlayButtonStyle(textStyle: TextStyle(fontSize: 20), textPadding: EdgeInsets.all(8));

    test('copyWith', () {
      final copy = a.copyWith(textOverflow: TextOverflow.fade);
      expect(copy.textOverflow, TextOverflow.fade);
      expect(copy.textStyle, a.textStyle);
    });

    test('merge', () {
      final merged = a.merge(const MultiDayPortalOverlayButtonStyle(textOverflow: TextOverflow.clip));
      expect(merged.textOverflow, TextOverflow.clip);
      expect(merged.textStyle, a.textStyle);
      expect(a.merge(null), a);
    });

    test('lerp', () {
      final mid = MultiDayPortalOverlayButtonStyle.lerp(a, b, 0.5)!;
      expect(mid.textStyle?.fontSize, 15);
      expect(mid.textPadding, const EdgeInsets.all(6));
      expect(MultiDayPortalOverlayButtonStyle.lerp(null, null, 0.5), null);
    });

    test('equality', () {
      expect(
        a,
        const MultiDayPortalOverlayButtonStyle(textStyle: TextStyle(fontSize: 10), textPadding: EdgeInsets.all(4)),
      );
      expect(a == b, false);
    });
  });
}
