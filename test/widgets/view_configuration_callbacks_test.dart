// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Two resolvers landing in different months, so the visible range names which
/// one ran.
FloatingDateTime resolveToMarch(ViewTransitionContext transition) => FloatingDateTime(2025, 3, 10);
FloatingDateTime resolveToAugust(ViewTransitionContext transition) => FloatingDateTime(2025, 8, 20);

DateTime nowMonday() => DateTime(2025, 1, 13, 14, 30);
DateTime nowTuesday() => DateTime(2025, 1, 14, 14, 30);

void main() {
  late DefaultEventsController eventsController;
  KalenderController? kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
  });

  tearDown(() {
    kalenderController?.dispose();
    kalenderController = null;
    eventsController.dispose();
  });

  /// Pumps a calendar on [configuration], switching the controller to it after the first pump.
  Future<void> show(WidgetTester tester, ViewConfiguration configuration) async {
    kalenderController = await pumpConfiguration(
      tester,
      eventsController: eventsController,
      configuration: configuration,
      kalenderController: kalenderController,
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
    return MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange, dateResolver: dateResolver);
  }

  /// Whether the visible range covers [date]. The month grid starts on the
  /// trailing days of the previous month, so the range's own start does not
  /// name the month on screen.
  bool visibleRangeCovers(DateTime date) {
    final range = kalenderController!.visibleDateTimeRange.value!;
    return !date.isBefore(range.start) && date.isBefore(range.end);
  }

  group('dateResolver', () {
    testWidgets('a resolver swapped between switches uses the newest one', (tester) async {
      await show(tester, week());

      await show(tester, month(dateResolver: resolveToMarch));
      expect(visibleRangeCovers(DateTime(2025, 3, 10)), isTrue);

      await show(tester, week());
      await show(tester, month(dateResolver: resolveToAugust));

      expect(
        visibleRangeCovers(DateTime(2025, 8, 20)),
        isTrue,
        reason: 'the resolver is read from the incoming configuration at switch time',
      );
    });

    testWidgets('changing only the resolver, with no view switch, does nothing', (tester) async {
      await show(tester, month(dateResolver: resolveToMarch));
      final before = kalenderController!.visibleDateTimeRange.value;

      await show(tester, month(dateResolver: resolveToAugust));

      expect(kalenderController!.visibleDateTimeRange.value, equals(before));
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
      await show(tester, week(nowCallback: nowMonday));
      expect(highlightedDate(tester).day, equals(13));
    });

    testWidgets('changing only nowCallback moves the highlight', (tester) async {
      await show(tester, week(nowCallback: nowMonday));
      expect(highlightedDate(tester).day, equals(13));

      await show(tester, week(nowCallback: nowTuesday));

      expect(highlightedDate(tester).day, equals(14), reason: 'the highlight should follow the current nowCallback');
    });
  });
}
