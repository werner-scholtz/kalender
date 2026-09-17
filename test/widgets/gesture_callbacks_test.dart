// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/gestures.dart' show kSecondaryButton;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  final now = DateTime(2026, 9, 16, 12);
  final range = KalenderDateTimeRange(start: DateTime(2026, 8), end: DateTime(2026, 11));

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;
  late List<String> calls;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
    calls = [];
  });

  String day(DateTime date) => '${date.year}-${date.month}-${date.day}';

  GestureCallbacks<DayDetail> dateLabel() => GestureCallbacks(
    onTap: (detail) => calls.add('tap ${day(detail.date)}'),
    onSecondaryTap: (detail) => calls.add('secondary ${day(detail.date)}'),
    onLongPress: (detail) => calls.add('long ${day(detail.date)}'),
  );

  Future<void> pump(
    WidgetTester tester,
    ViewConfiguration configuration, {
    GestureCallbacks<DayDetail>? dateLabel,
    GestureCallbacks<MultiDayDetail>? weekNumber,
    KalenderComponents? components,
    MultiDayHeaderConfiguration? headerConfiguration,
    ScheduleBodyConfiguration? scheduleConfiguration,
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: configuration,
        components: components,
        callbacks: KalenderCallbacks(
          onTapped: (date) => calls.add('onTapped ${day(date)}'),
          onTappedWithDetail: (detail) =>
              calls.add('onTappedWithDetail ${day((detail as MultiDayDetail).dateTimeRange.start)}'),
          dateLabel: dateLabel,
          weekNumber: weekNumber,
        ),
        header: KalenderHeader(multiDayHeaderConfiguration: headerConfiguration),
        body: KalenderBody(scheduleBodyConfiguration: scheduleConfiguration),
      ),
    );
  }

  final month = MonthViewConfiguration.singleMonth(
    displayRange: range,
    initialDateTime: now,
    nowCallback: () => now,
    showWeekNumbers: true,
  );
  final week = MultiDayViewConfiguration.week(
    displayRange: range,
    initialDateTime: now,
    nowCallback: () => now,
    firstDayOfWeek: DateTime.monday,
  );
  final schedule = ScheduleViewConfiguration.continuous(
    displayRange: range,
    initialDateTime: now,
    nowCallback: () => now,
  );

  group('date label', () {
    testWidgets('the month day number reports the date instead of the cell tap', (tester) async {
      await pump(tester, month, dateLabel: dateLabel());
      await tester.tap(find.byKey(MonthDayHeader.todayKey));
      expect(calls, ['tap 2026-9-16']);
    });

    testWidgets('without a date label callback the month day number tap reaches the cell', (tester) async {
      await pump(tester, month);
      await tester.tap(find.byKey(MonthDayHeader.todayKey), warnIfMissed: false);
      expect(calls, ['onTapped 2026-9-16', 'onTappedWithDetail 2026-9-16']);
    });

    testWidgets('the single-day header reports the date in the calendar location', (tester) async {
      final dates = <DateTime>[];
      await pump(
        tester,
        MultiDayViewConfiguration.singleDay(displayRange: range, initialDateTime: now, nowCallback: () => now),
        dateLabel: GestureCallbacks(onTap: (detail) => dates.add(detail.date)),
      );
      await tester.tap(find.byKey(DayHeader.todayKey));
      expect(dates, [DateTime(2026, 9, 16)]);
      expect(dates.single.isUtc, isFalse);
    });

    testWidgets('the whole day header reports, including the day name', (tester) async {
      await pump(tester, week, dateLabel: dateLabel());
      await tester.tap(find.byKey(DayHeader.todayKey));
      await tester.tap(find.text('Wed'), buttons: kSecondaryButton);
      await tester.longPress(find.text('Wed'));
      expect(calls, ['tap 2026-9-16', 'secondary 2026-9-16', 'long 2026-9-16']);
    });

    testWidgets('a label from a custom builder still reports', (tester) async {
      await pump(
        tester,
        week,
        dateLabel: dateLabel(),
        components: KalenderComponents(
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(dayHeaderBuilder: (context, date) => Text('custom ${date.day}')),
          ),
        ),
      );
      await tester.tap(find.text('custom 17'));
      expect(calls, ['tap 2026-9-17']);
    });

    testWidgets('the schedule date reports', (tester) async {
      eventsController.addEvent(KalenderEvent(start: DateTime(2026, 9, 16, 9), end: DateTime(2026, 9, 16, 10)));
      await pump(tester, schedule, dateLabel: dateLabel());
      await tester.tap(find.byKey(ScheduleDate.todayKey));
      expect(calls, ['tap 2026-9-16']);
    });

    testWidgets('the overlay date reports', (tester) async {
      final start = DateTime(2026, 9, 14);
      eventsController.addEvents([
        KalenderEvent(start: start, end: start.add(const Duration(days: 2))),
        KalenderEvent(start: start, end: start.add(const Duration(days: 2))),
      ]);
      await pump(
        tester,
        week,
        dateLabel: dateLabel(),
        headerConfiguration: const MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1),
      );

      await tester.tap(find.byKey(MultiDayPortalOverlayButton.getKey(FloatingDateTime.fromDateTime(start))));
      await tester.pumpAndSettle();
      final overlay = find.byType(MultiDayOverlay);
      expect(overlay, findsOneWidget);

      await tester.tap(find.descendant(of: overlay, matching: find.text('14')));
      expect(calls, ['tap 2026-9-14']);
    });
  });

  group('week number', () {
    testWidgets('the multi-day header week number reports the visible range', (tester) async {
      final ranges = <KalenderDateTimeRange>[];
      await pump(
        tester,
        week,
        weekNumber: GestureCallbacks(
          onTap: (detail) => ranges.add(detail.dateTimeRange),
          onLongPress: (detail) => ranges.add(detail.dateTimeRange),
        ),
      );
      await tester.tap(find.byType(WeekNumber));
      await tester.longPress(find.byType(WeekNumber));
      final visible = kalenderController.visibleDateTimeRange.value;
      expect(ranges, [visible, visible], reason: 'the long press is not taken by the tooltip');
    });

    testWidgets('any week number callback makes the tooltip hover only', (tester) async {
      Future<Tooltip> tooltip(GestureCallbacks<MultiDayDetail>? weekNumber) async {
        await pumpAndSettleWithMaterialApp(
          tester,
          TestProvider(
            kalenderController: kalenderController,
            eventsController: eventsController,
            tileComponents: TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox()),
            callbacks: KalenderCallbacks(weekNumber: weekNumber),
            child: KalenderTheme(
              data: const KalenderThemeData(weekNumberStyle: WeekNumberStyle(tooltip: 'Week')),
              child: WeekNumber(
                visibleDateTimeRange: KalenderDateTimeRange(start: now, end: now),
              ),
            ),
          ),
        );
        return tester.widget<Tooltip>(find.byType(Tooltip));
      }

      expect((await tooltip(null)).triggerMode, isNull);
      expect((await tooltip(GestureCallbacks(onTap: (_) {}))).triggerMode, TooltipTriggerMode.manual);
    });

    testWidgets('a month week number reports its row', (tester) async {
      final ranges = <KalenderDateTimeRange>[];
      await pump(tester, month, weekNumber: GestureCallbacks(onTap: (detail) => ranges.add(detail.dateTimeRange)));
      await tester.tap(find.descendant(of: find.byType(WeekNumber).at(2), matching: find.byType(IconButton)));
      expect(ranges.single.start, DateTime(2026, 9, 14));
      expect(ranges.single.end, DateTime(2026, 9, 21));
    });
  });

  testWidgets('an empty schedule day reports the onTapped callbacks', (tester) async {
    await pump(tester, schedule, scheduleConfiguration: ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.show));
    await tester.tap(find.byKey(ScheduleDate.todayKey), warnIfMissed: false);
    expect(calls, ['onTapped 2026-9-16', 'onTappedWithDetail 2026-9-16']);
  });

  test('copyWith keeps the gesture groups', () {
    final callbacks = KalenderCallbacks(dateLabel: dateLabel(), weekNumber: const GestureCallbacks());
    final copy = callbacks.copyWith(onTapped: (_) {});
    expect(copy.dateLabel, same(callbacks.dateLabel));
    expect(copy.weekNumber, same(callbacks.weekNumber));
  });
}
