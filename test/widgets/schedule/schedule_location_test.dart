import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

import '../../utilities.dart';

/// The schedule view reports its ranges in the calendar's location, matching the
/// multi-day and month views.
///
/// `onPageChanged`, `monthItemBuilder` and `emptyItemBuilder` each handed out an
/// unconverted internal value, so every range an app received was off by the
/// location's UTC offset.
void main() {
  initializeTimeZones();

  // UTC+9 all year, so no DST transition can mask an unconverted value.
  final tokyo = getLocation('Asia/Tokyo');

  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  CalendarEvent eventAt(DateTime day, int hour) => CalendarEvent(
        dateTimeRange: KalenderDateTimeRange(
          start: TZDateTime(tokyo, day.year, day.month, day.day, hour),
          end: TZDateTime(tokyo, day.year, day.month, day.day, hour + 1),
        ),
      );

  KalenderView buildSchedule({
    required ScheduleViewConfiguration configuration,
    EmptyDayBehavior emptyDay = EmptyDayBehavior.hide,
    CalendarComponents? components,
    CalendarCallbacks? callbacks,
  }) {
    return KalenderView(
      eventsController: eventsController,
      calendarController: calendarController,
      location: tokyo,
      components: components,
      callbacks: callbacks,
      viewConfiguration: configuration,
      body: CalendarBody(
        scheduleBodyConfiguration: ScheduleBodyConfiguration(emptyDay: emptyDay),
      ),
    );
  }

  ScheduleViewConfiguration continuous({DateTime? initialDate, DateTime Function()? nowCallback}) {
    return ScheduleViewConfiguration.continuous(
      displayRange: KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 2)),
      initialDateTime: initialDate,
      nowCallback: nowCallback,
    );
  }

  testWidgets('monthItemBuilder receives the month range in the calendar location', (tester) async {
    eventsController.addEvents([eventAt(DateTime(2025, 1, 15), 9)]);

    final ranges = <KalenderDateTimeRange>[];

    await pumpAndSettleWithMaterialApp(
      tester,
      buildSchedule(
        configuration: continuous(initialDate: DateTime(2025, 1, 15)),
        components: CalendarComponents(
          scheduleComponents: ScheduleComponents(
            monthItemBuilder: (context, monthRange) {
              ranges.add(monthRange);
              return const SizedBox(height: 24);
            },
          ),
        ),
      ),
    );

    expect(ranges, isNotEmpty, reason: 'the month heading must render for January');

    // January 2025 in Tokyo starts at 2025-01-01 00:00+09:00, which is
    // 2024-12-31 15:00Z. An unconverted internal value reads 2025-01-01 00:00Z.
    expect(ranges.first.start.toUtc(), DateTime.utc(2024, 12, 31, 15));
    expect(ranges.first.end.toUtc(), DateTime.utc(2025, 1, 31, 15));
  });

  testWidgets('emptyItemBuilder receives the day range in the calendar location', (tester) async {
    // No events, so the day the nowCallback names is the empty row.
    final ranges = <KalenderDateTimeRange>[];

    await pumpAndSettleWithMaterialApp(
      tester,
      buildSchedule(
        emptyDay: EmptyDayBehavior.showOnlyToday,
        configuration: continuous(
          initialDate: DateTime(2025, 1, 15),
          nowCallback: () => TZDateTime(tokyo, 2025, 1, 15, 10),
        ),
        components: CalendarComponents(
          scheduleComponents: ScheduleComponents(
            emptyItemBuilder: (context, tileRange) {
              ranges.add(tileRange);
              return const SizedBox(height: 24);
            },
          ),
        ),
      ),
    );

    expect(ranges, isNotEmpty, reason: "today's empty row must render");

    // 2025-01-15 00:00+09:00 is 2025-01-14 15:00Z.
    expect(ranges.first.start.toUtc(), DateTime.utc(2025, 1, 14, 15));
    expect(ranges.first.end.toUtc(), DateTime.utc(2025, 1, 15, 15));
  });

  testWidgets('onPageChanged reports the page range in the calendar location', (tester) async {
    eventsController.addEvents([eventAt(DateTime(2025, 1, 15), 9)]);

    KalenderDateTimeRange? changedRange;

    await pumpAndSettleWithMaterialApp(
      tester,
      buildSchedule(
        configuration: ScheduleViewConfiguration.paginated(
          displayRange: KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 4)),
          initialDateTime: DateTime(2025, 1, 15),
        ),
        callbacks: CalendarCallbacks(onPageChanged: (range) => changedRange = range),
      ),
    );

    calendarController.jumpToDate(DateTime(2025, 2, 10));
    await tester.pumpAndSettle();

    expect(changedRange, isNotNull);

    // A paginated schedule pages by month, so February 2025 in Tokyo starts at
    // 2025-02-01 00:00+09:00, which is 2025-01-31 15:00Z.
    expect(changedRange!.start.toUtc(), DateTime.utc(2025, 1, 31, 15));
    expect(changedRange!.end.toUtc(), DateTime.utc(2025, 2, 28, 15));
  });
}
