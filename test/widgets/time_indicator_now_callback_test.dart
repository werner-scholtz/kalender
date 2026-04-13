import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/positioned_time_indicator.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

import '../utilities.dart';

void main() {
  group('nowCallback', () {
    group('Page-based PositionedTimeIndicator', () {
      final key = UniqueKey();
      final now = InternalDateTime.fromDateTime(DateTime.now()).startOfWeek();
      final range = InternalDateTimeRange(start: now, end: now.endOfWeek());

      group('positions indicator using callback wall-clock values', () {
        for (final (index, date) in range.dates().map(InternalDateTime.fromDateTime).indexed) {
          testWidgets('day index $index', (tester) async {
            final viewConfiguration = MultiDayViewConfiguration.week(
              displayRange: range,
              nowCallback: () => date,
            );

            await pumpAndSettleWithMaterialApp(
              tester,
              SizedBox(
                width: 700,
                height: 100,
                child: Stack(
                  children: [
                    TimeIndicatorPositioner(
                      viewController: MultiDayViewController(
                        viewConfiguration: viewConfiguration,
                        visibleDateTimeRange: ValueNotifier(InternalDateTimeRange.fromDateTimeRange(range)),
                        visibleEvents: ValueNotifier(<CalendarEvent>{}),
                      ),
                      initialPage: 0,
                      childOverride: SizedBox(key: key),
                    ),
                  ],
                ),
              ),
            );
            final finder = find.byKey(key);
            expect(finder, findsOneWidget);
            expect(tester.getTopLeft(finder).dx, index * 100.0);
          });
        }
      });

      testWidgets('dateOverride takes precedence over nowCallback', (tester) async {
        // The callback points to day index 3 (Thursday), but dateOverride points to day index 0 (Monday).
        final thursday = InternalDateTime.fromDateTime(range.dates()[3]);
        final monday = InternalDateTime.fromDateTime(range.dates()[0]);

        final viewConfiguration = MultiDayViewConfiguration.week(
          displayRange: range,
          nowCallback: () => thursday,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          SizedBox(
            width: 700,
            height: 100,
            child: Stack(
              children: [
                TimeIndicatorPositioner(
                  viewController: MultiDayViewController(
                    viewConfiguration: viewConfiguration,
                    visibleDateTimeRange: ValueNotifier(InternalDateTimeRange.fromDateTimeRange(range)),
                    visibleEvents: ValueNotifier(<CalendarEvent>{}),
                  ),
                  initialPage: 0,
                  dateOverride: monday,
                  childOverride: SizedBox(key: key),
                ),
              ],
            ),
          ),
        );
        final finder = find.byKey(key);
        expect(finder, findsOneWidget);
        // Should be at Monday's position (index 0), not Thursday's.
        expect(tester.getTopLeft(finder).dx, 0.0);
      });

      testWidgets('null callback preserves location-based behavior', (tester) async {
        // With no callback, the indicator uses DateTime.now() which is "today".
        final today = InternalDateTime.fromDateTime(DateTime.now());
        final todayWeekStart = today.startOfWeek();
        final todayRange = InternalDateTimeRange(start: todayWeekStart, end: todayWeekStart.endOfWeek());
        final todayIndex = todayRange.dates().map(InternalDateTime.fromDateTime).toList().indexWhere(
              (d) => d.isSameDay(today.startOfDay),
            );

        final viewConfiguration = MultiDayViewConfiguration.week(
          displayRange: todayRange,
          // No nowCallback — null by default
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          SizedBox(
            width: 700,
            height: 100,
            child: Stack(
              children: [
                TimeIndicatorPositioner(
                  viewController: MultiDayViewController(
                    viewConfiguration: viewConfiguration,
                    visibleDateTimeRange: ValueNotifier(InternalDateTimeRange.fromDateTimeRange(todayRange)),
                    visibleEvents: ValueNotifier(<CalendarEvent>{}),
                  ),
                  initialPage: 0,
                  childOverride: SizedBox(key: key),
                ),
              ],
            ),
          ),
        );
        final finder = find.byKey(key);
        expect(finder, findsOneWidget);
        expect(tester.getTopLeft(finder).dx, todayIndex * 100.0);
      });

      testWidgets('singleDay config with callback', (tester) async {
        // For a single-day view, the indicator should always be at index 0 (the only column).
        final monday = InternalDateTime.fromDateTime(range.dates()[0]);
        final viewConfiguration = MultiDayViewConfiguration.singleDay(
          displayRange: range,
          nowCallback: () => monday,
        );

        await pumpAndSettleWithMaterialApp(
          tester,
          SizedBox(
            width: 700,
            height: 100,
            child: Stack(
              children: [
                TimeIndicatorPositioner(
                  viewController: MultiDayViewController(
                    viewConfiguration: viewConfiguration,
                    visibleDateTimeRange: ValueNotifier(InternalDateTimeRange.fromDateTimeRange(range)),
                    visibleEvents: ValueNotifier(<CalendarEvent>{}),
                    initialDate: monday,
                  ),
                  initialPage: 0,
                  childOverride: SizedBox(key: key),
                ),
              ],
            ),
          ),
        );
        final finder = find.byKey(key);
        expect(finder, findsOneWidget);
        expect(tester.getTopLeft(finder).dx, 0.0);
      });
    });

    group('Visibility-based PositionedTimeIndicator', () {
      final now = InternalDateTime.fromDateTime(DateTime.now());
      final start = now.startOfWeek();
      final end = now.endOfWeek();
      final range = InternalDateTimeRange(start: start, end: end);
      final visibleDates = range.dates();

      for (var weekday = 0; weekday < 7; weekday++) {
        final day = visibleDates[weekday];

        testWidgets('nowCallback positions at weekday $weekday', (tester) async {
          const dayWidth = 50.0;
          await pumpAndSettleWithMaterialApp(
            tester,
            Stack(
              children: [
                const SizedBox(width: dayWidth * 7),
                PositionedTimeIndicator(
                  visibleDates: visibleDates,
                  dayWidth: dayWidth,
                  nowCallback: () => DateTime(day.year, day.month, day.day, 12, 0),
                  child: const SizedBox(
                    width: dayWidth,
                    key: ValueKey('child'),
                  ),
                ),
              ],
            ),
          );

          final child = find.byKey(const ValueKey('child'));
          expect(child, findsOneWidget);
          expect(
            tester.getTopLeft(child),
            Offset(weekday * dayWidth, 0),
            reason: 'Child should be positioned at weekday $weekday',
          );
        });
      }

      testWidgets('nowOverride takes precedence over nowCallback', (tester) async {
        const dayWidth = 50.0;
        final mondayOverride = InternalDateTime.fromDateTime(visibleDates[0]);
        // Callback returns Thursday, but nowOverride points to Monday.
        await pumpAndSettleWithMaterialApp(
          tester,
          Stack(
            children: [
              const SizedBox(width: dayWidth * 7),
              PositionedTimeIndicator(
                visibleDates: visibleDates,
                dayWidth: dayWidth,
                nowOverride: mondayOverride,
                nowCallback: () => DateTime(visibleDates[3].year, visibleDates[3].month, visibleDates[3].day),
                child: const SizedBox(
                  width: dayWidth,
                  key: ValueKey('child'),
                ),
              ),
            ],
          ),
        );

        final child = find.byKey(const ValueKey('child'));
        expect(child, findsOneWidget);
        expect(
          tester.getTopLeft(child),
          const Offset(0, 0),
          reason: 'nowOverride (Monday) should take precedence over nowCallback (Thursday)',
        );
      });
    });

    group('ViewConfiguration copyWith preserves nowCallback', () {
      test('MultiDayViewConfiguration.week copyWith', () {
        DateTime callback() => DateTime(2026, 4, 13, 14, 0);
        final config = MultiDayViewConfiguration.week(nowCallback: callback);
        final copy = config.copyWith(name: 'Modified');
        expect(copy.nowCallback, same(callback));
      });

      test('MultiDayViewConfiguration.singleDay copyWith', () {
        DateTime callback() => DateTime(2026, 4, 13, 14, 0);
        final config = MultiDayViewConfiguration.singleDay(nowCallback: callback);
        final copy = config.copyWith(name: 'Modified');
        expect(copy.nowCallback, same(callback));
      });

      test('MultiDayViewConfiguration.workWeek copyWith', () {
        DateTime callback() => DateTime(2026, 4, 13, 14, 0);
        final config = MultiDayViewConfiguration.workWeek(nowCallback: callback);
        final copy = config.copyWith(name: 'Modified');
        expect(copy.nowCallback, same(callback));
      });

      test('MultiDayViewConfiguration.custom copyWith', () {
        DateTime callback() => DateTime(2026, 4, 13, 14, 0);
        final config = MultiDayViewConfiguration.custom(numberOfDays: 3, nowCallback: callback);
        final copy = config.copyWith(name: 'Modified');
        expect(copy.nowCallback, same(callback));
      });

      test('MultiDayViewConfiguration.freeScroll copyWith', () {
        DateTime callback() => DateTime(2026, 4, 13, 14, 0);
        final config = MultiDayViewConfiguration.freeScroll(numberOfDays: 3, nowCallback: callback);
        final copy = config.copyWith(name: 'Modified');
        expect(copy.nowCallback, same(callback));
      });

      test('copyWith can override nowCallback', () {
        DateTime original() => DateTime(2026, 4, 13, 14, 0);
        DateTime replacement() => DateTime(2026, 4, 13, 9, 0);
        final config = MultiDayViewConfiguration.week(nowCallback: original);
        final copy = config.copyWith(nowCallback: replacement);
        expect(copy.nowCallback, same(replacement));
      });

      test('null by default', () {
        final config = MultiDayViewConfiguration.week();
        expect(config.nowCallback, isNull);
      });
    });

    group('NowCallback typedef', () {
      test('DateTime.now satisfies the typedef', () {
        final callback = DateTime.now;
        final result = callback();
        expect(result, isA<DateTime>());
      });

      test('TZDateTime.now satisfies the typedef via wrapper', () {
        tz.initializeTimeZones();
        final utc = getLocation('Etc/UTC');
        DateTime callback() => TZDateTime.now(utc);
        final result = callback();
        expect(result, isA<TZDateTime>());
      });
    });
  });
}
