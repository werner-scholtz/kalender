import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// [ScheduleDate] abbreviated the day name by cutting the full name at three
/// characters, which only happens to be right in English. Every other component
/// that shows a short day name uses `DateFormat.E` through
/// [DateTimeExtensions.dayNameShortLocalized].
void main() {
  // 15 January 2025 is a Wednesday, whose abbreviation differs from the first
  // three letters of its full name in several locales.
  final wednesday = InternalDateTime(2025, 1, 15);

  Future<void> pumpScheduleDate(WidgetTester tester, dynamic locale) async {
    await initializeDateFormatting('$locale');
    await pumpAndSettleWithMaterialApp(
      tester,
      TestProvider(
        calendarController: CalendarController(),
        eventsController: DefaultEventsController(),
        tileComponents: TileComponents(tileBuilder: (event, tileRange) => const SizedBox()),
        locale: locale,
        child: ScheduleDate(date: wednesday),
      ),
    );
  }

  testWidgets('uses the locale\'s own abbreviation, not the first three letters', (tester) async {
    await pumpScheduleDate(tester, 'de');

    expect(find.text('Mi'), findsOneWidget);
    expect(find.text('Mit'), findsNothing, reason: 'Mittwoch cut at three characters is not how German abbreviates it');
  });

  testWidgets('English is unchanged, which is why this went unnoticed', (tester) async {
    await pumpScheduleDate(tester, 'en');

    expect(find.text('Wed'), findsOneWidget);
  });

  testWidgets('keeps abbreviations that are not three characters long', (tester) async {
    // Russian abbreviates Wednesday to two characters, and the cut produced three.
    await pumpScheduleDate(tester, 'ru');

    expect(find.text('ср'), findsOneWidget);
    expect(find.text('сре'), findsNothing);
  });

  testWidgets('matches what the multi-day day header shows for the same date', (tester) async {
    await initializeDateFormatting('de');
    await pumpAndSettleWithMaterialApp(
      tester,
      TestProvider(
        calendarController: CalendarController(),
        eventsController: DefaultEventsController(),
        tileComponents: TileComponents(tileBuilder: (event, tileRange) => const SizedBox()),
        locale: 'de',
        child: Column(children: [ScheduleDate(date: wednesday), DayHeader(date: wednesday)]),
      ),
    );

    expect(find.text('Mi'), findsNWidgets(2));
  });
}
