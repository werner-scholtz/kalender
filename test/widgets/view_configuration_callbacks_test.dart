import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Two resolvers landing in different months, so the visible range names which
/// one ran.
InternalDateTime resolveToMarch(ViewTransitionContext transition) => InternalDateTime(2025, 3, 10);
InternalDateTime resolveToAugust(ViewTransitionContext transition) => InternalDateTime(2025, 8, 20);

DateTime nowMonday() => DateTime(2025, 1, 13, 14, 30);
DateTime nowTuesday() => DateTime(2025, 1, 14, 14, 30);

void main() {
  late DefaultEventsController eventsController;
  late KalenderController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = KalenderController();
  });

  tearDown(() {
    calendarController.dispose();
    eventsController.dispose();
  });

  Widget build(ViewConfiguration configuration) {
    return KalenderView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: configuration,
      header: const KalenderHeader(),
      body: const KalenderBody(),
    );
  }

  MultiDayViewConfiguration week({NowCallback? nowCallback}) {
    return MultiDayViewConfiguration.week(
      displayRange: year2025DisplayRange,
      initialDateTime: DateTime(2025, 1, 13),
      nowCallback: nowCallback,
    );
  }

  MonthViewConfiguration month({DateResolver? dateResolver}) {
    return MonthViewConfiguration.singleMonth(
      displayRange: year2025DisplayRange,
      dateResolver: dateResolver,
    );
  }

  /// Whether the visible range covers [date]. The month grid starts on the
  /// trailing days of the previous month, so the range's own start does not
  /// name the month on screen.
  bool visibleRangeCovers(DateTime date) {
    final range = calendarController.visibleDateTimeRange.value!;
    return !date.isBefore(range.start) && date.isBefore(range.end);
  }

  group('dateResolver', () {
    testWidgets('a resolver swapped between switches uses the newest one', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, build(week()));

      await pumpAndSettleWithMaterialApp(tester, build(month(dateResolver: resolveToMarch)));
      expect(visibleRangeCovers(DateTime(2025, 3, 10)), isTrue);

      // Back to week, then to a month configuration that differs only by its
      // resolver.
      await pumpAndSettleWithMaterialApp(tester, build(week()));
      await pumpAndSettleWithMaterialApp(tester, build(month(dateResolver: resolveToAugust)));

      expect(
        visibleRangeCovers(DateTime(2025, 8, 20)),
        isTrue,
        reason: 'the resolver is read from the incoming configuration at switch time',
      );
    });

    testWidgets('changing only the resolver, with no view switch, does nothing', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, build(month(dateResolver: resolveToMarch)));
      final before = calendarController.visibleDateTimeRange.value;

      // The same configuration with a different resolver. A resolver only runs
      // at a view switch, and there is no switch here.
      await pumpAndSettleWithMaterialApp(tester, build(month(dateResolver: resolveToAugust)));

      expect(calendarController.visibleDateTimeRange.value, equals(before));
    });
  });

  group('nowCallback', () {
    /// The date whose header carries the today highlight.
    DateTime highlightedDate(WidgetTester tester) {
      final header = tester.widget<DayHeader>(
        find.ancestor(of: find.byKey(DayHeader.todayKey), matching: find.byType(DayHeader)),
      );
      return header.date;
    }

    testWidgets('the initial nowCallback decides the highlighted day', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, build(week(nowCallback: nowMonday)));
      expect(highlightedDate(tester).day, equals(13));
    });

    testWidgets('changing only nowCallback moves the highlight', (tester) async {
      await pumpAndSettleWithMaterialApp(tester, build(week(nowCallback: nowMonday)));
      expect(highlightedDate(tester).day, equals(13));

      await pumpAndSettleWithMaterialApp(tester, build(week(nowCallback: nowTuesday)));

      expect(
        highlightedDate(tester).day,
        equals(14),
        reason: 'the highlight should follow the current nowCallback',
      );
    });
  });
}
