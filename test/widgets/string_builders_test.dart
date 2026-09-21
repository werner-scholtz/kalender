// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// The string builders on the components classes replace the built-in labels.
void main() {
  final tiles = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());
  final scheduleTiles = ScheduleTileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());
  final day = DateTime.utc(2025, 1, 15);

  Future<void> pumpView(
    WidgetTester tester, {
    required ViewConfiguration viewConfiguration,
    KalenderComponents? components,
    EventsController? eventsController,
    Widget? header,
    Widget? body,
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController ?? DefaultEventsController(),
        kalenderController: KalenderController(),
        viewConfiguration: viewConfiguration,
        components: components,
        header: header,
        body: body,
      ),
    );
  }

  final week = MultiDayViewConfiguration.week(displayRange: year2025DisplayRange, initialDateTime: day);
  final month = MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange, initialDateTime: day);

  Future<void> pumpWithTiles(WidgetTester tester, ViewConfiguration viewConfiguration, KalenderComponents components) {
    return pumpView(
      tester,
      viewConfiguration: viewConfiguration,
      components: components,
      header: KalenderHeader(multiDayTileComponents: tiles),
      body: KalenderBody(multiDayTileComponents: tiles),
    );
  }

  group('DayHeader', () {
    testWidgets('the components string builders replace the day name and the day number', (tester) async {
      await pumpWithTiles(
        tester,
        week,
        KalenderComponents(
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(
              dayHeaderStringBuilder: (context, date) => 'name',
              dayHeaderNumberStringBuilder: (context, date) => 'number',
            ),
          ),
        ),
      );

      expect(find.text('name'), findsWidgets);
      expect(find.text('number'), findsWidgets);
    });

    testWidgets('both builders receive the same date', (tester) async {
      final nameDates = <DateTime>[];
      final numberDates = <DateTime>[];

      await pumpWithTiles(
        tester,
        week,
        KalenderComponents(
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(
              dayHeaderStringBuilder: (context, date) {
                nameDates.add(date);
                return '';
              },
              dayHeaderNumberStringBuilder: (context, date) {
                numberDates.add(date);
                return '';
              },
            ),
          ),
        ),
      );

      expect(nameDates, isNotEmpty);
      expect(numberDates, nameDates);
    });
  });

  group('WeekDayHeader', () {
    testWidgets('the components string builder replaces the day name', (tester) async {
      await pumpWithTiles(
        tester,
        month,
        KalenderComponents(
          monthComponents: MonthComponents(
            headerComponents: MonthHeaderComponents(weekDayHeaderStringBuilder: (context, date) => 'wd'),
          ),
        ),
      );

      expect(find.text('wd'), findsWidgets);
    });
  });

  group('MonthDayHeader', () {
    testWidgets('the components string builder replaces the day number', (tester) async {
      await pumpWithTiles(
        tester,
        month,
        KalenderComponents(
          monthComponents: MonthComponents(
            bodyComponents: MonthBodyComponents(monthDayHeaderStringBuilder: (context, date) => 'md'),
          ),
        ),
      );

      expect(find.text('md'), findsWidgets);
      expect(find.text('15'), findsNothing, reason: 'the day number should be replaced, not appended');
    });
  });

  group('ScheduleDate', () {
    testWidgets('the components string builder replaces the day name', (tester) async {
      final eventsController = DefaultEventsController()
        ..addEvent(KalenderEvent(start: day, end: day.add(const Duration(hours: 1))));

      await pumpView(
        tester,
        viewConfiguration: ScheduleViewConfiguration.continuous(
          displayRange: year2025DisplayRange,
          initialDateTime: day,
        ),
        eventsController: eventsController,
        components: KalenderComponents(
          scheduleComponents: ScheduleComponents(leadingDateStringBuilder: (context, date) => 'sd'),
        ),
        body: KalenderBody(scheduleTileComponents: scheduleTiles),
      );

      expect(find.text('sd'), findsWidgets);
    });
  });

  group('Overflow button label', () {
    Future<void> pumpOverflowingWeek(WidgetTester tester, TextDirection textDirection) {
      return pumpAndSettleWithMaterialApp(
        tester,
        Directionality(
          textDirection: textDirection,
          child: KalenderView(
            eventsController: controllerWithOverflowOn(day),
            kalenderController: KalenderController(),
            viewConfiguration: week,
            header: const KalenderHeader(
              multiDayHeaderConfiguration: MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1),
            ),
          ),
        ),
      );
    }

    for (final textDirection in TextDirection.values) {
      testWidgets('defaults to a plus sign in front of the count in ${textDirection.name}', (tester) async {
        await pumpOverflowingWeek(tester, textDirection);

        expect(overflowButtonLabels(tester), everyElement(matches(RegExp(r'^\+\d+$'))));
      });
    }
  });
}
