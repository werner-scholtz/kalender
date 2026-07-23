import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// The string builders used to live on the component style classes, which put
/// formatting inside the themeable KalenderThemeData and gave custom builders no
/// way to see the calendar's locale. They now live on the *Components classes and
/// receive a BuildContext. The style fields stay until 0.24.0 as a fallback.
void main() {
  final tiles = TileComponents(tileBuilder: (event, tileRange) => const SizedBox());
  final scheduleTiles = ScheduleTileComponents(tileBuilder: (event, tileRange) => const SizedBox());
  final day = DateTime.utc(2025, 1, 15);

  Future<void> pumpView(
    WidgetTester tester, {
    required ViewConfiguration viewConfiguration,
    CalendarComponents? components,
    EventsController? eventsController,
    Widget? header,
    Widget? body,
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      CalendarView(
        eventsController: eventsController ?? DefaultEventsController(),
        calendarController: CalendarController(),
        viewConfiguration: viewConfiguration,
        components: components,
        header: header,
        body: body,
      ),
    );
  }

  Future<void> pumpWeek(WidgetTester tester, CalendarComponents components) {
    return pumpView(
      tester,
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: year2025DisplayRange,
        initialDateTime: day,
      ),
      components: components,
      header: CalendarHeader(multiDayTileComponents: tiles),
      body: CalendarBody(multiDayTileComponents: tiles),
    );
  }

  Future<void> pumpMonth(WidgetTester tester, CalendarComponents components) {
    return pumpView(
      tester,
      viewConfiguration: MonthViewConfiguration.singleMonth(
        displayRange: year2025DisplayRange,
        initialDateTime: day,
      ),
      components: components,
      header: CalendarHeader(multiDayTileComponents: tiles),
      body: CalendarBody(multiDayTileComponents: tiles),
    );
  }

  group('DayHeader', () {
    testWidgets('the components string builders replace the day name and the day number', (tester) async {
      await pumpWeek(
        tester,
        CalendarComponents(
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

      await pumpWeek(
        tester,
        CalendarComponents(
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
      expect(numberDates, nameDates, reason: 'the two builders used to be handed different DateTime flavours');
    });
  });

  group('WeekDayHeader', () {
    testWidgets('the components string builder replaces the day name', (tester) async {
      await pumpMonth(
        tester,
        CalendarComponents(
          monthComponents: MonthComponents(
            headerComponents: MonthHeaderComponents(weekDayHeaderStringBuilder: (context, date) => 'wd'),
          ),
        ),
      );

      expect(find.text('wd'), findsWidgets);
    });

  });

  group('MonthDayHeader', () {
    // MonthDayHeaderStyle.stringBuilder was declared but never called, so setting
    // it did nothing. The replacement is wired up.
    testWidgets('the components string builder replaces the day number', (tester) async {
      await pumpMonth(
        tester,
        CalendarComponents(
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
        ..addEvent(CalendarEvent(dateTimeRange: DateTimeRange(start: day, end: day.add(const Duration(hours: 1)))));

      await pumpView(
        tester,
        viewConfiguration: ScheduleViewConfiguration.continuous(
          displayRange: year2025DisplayRange,
          initialDateTime: day,
        ),
        eventsController: eventsController,
        components: CalendarComponents(
          scheduleComponents: ScheduleComponents(leadingDateStringBuilder: (context, date) => 'sd'),
        ),
        body: CalendarBody(scheduleTileComponents: scheduleTiles),
      );

      expect(find.text('sd'), findsWidgets);
    });
  });

  group('Overflow button label', () {
    /// Adds enough events on [day] to overflow the cell and show the button.
    DefaultEventsController controllerWithOverflowOn(DateTime day) {
      final eventsController = DefaultEventsController();
      for (var i = 0; i < 8; i++) {
        eventsController.addEvent(
          CalendarEvent(dateTimeRange: DateTimeRange(start: day, end: day.add(const Duration(days: 1)))),
        );
      }
      return eventsController;
    }

    Future<void> pumpOverflowingWeek(
      WidgetTester tester, {
      CalendarComponents? components,
      TextDirection textDirection = TextDirection.ltr,
    }) {
      return pumpAndSettleWithMaterialApp(
        tester,
        Directionality(
          textDirection: textDirection,
          child: CalendarView(
            eventsController: controllerWithOverflowOn(day),
            calendarController: CalendarController(),
            viewConfiguration: MultiDayViewConfiguration.week(
              displayRange: year2025DisplayRange,
              initialDateTime: day,
            ),
            components: components,
            header: const CalendarHeader(
              multiDayHeaderConfiguration: MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 1),
            ),
          ),
        ),
      );
    }

    Set<String> labels(WidgetTester tester) {
      final texts = tester.widgetList<Text>(find.byKey(MultiDayPortalOverlayButton.textKey));
      expect(texts, isNotEmpty, reason: 'the day should overflow and show an overflow button');
      return texts.map((text) => text.data!).toSet();
    }

    // The default used to be the English '$n more'. It is now a plus sign and the
    // count, which needs no translation.
    testWidgets('defaults to a plus sign and the count', (tester) async {
      await pumpOverflowingWeek(tester);

      expect(labels(tester), everyElement(matches(RegExp(r'^\+\d+$'))));
    });

    testWidgets('keeps the plus in front of the count in right-to-left', (tester) async {
      await pumpOverflowingWeek(tester, textDirection: TextDirection.rtl);

      expect(labels(tester), everyElement(matches(RegExp(r'^\+\d+$'))));
    });

  });
}
