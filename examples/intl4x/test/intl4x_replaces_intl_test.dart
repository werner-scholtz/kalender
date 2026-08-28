import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl4x_example/main.dart';
import 'package:kalender/kalender.dart';

/// Proves the builders replace intl rather than sitting alongside it.
///
/// `initializeDateFormatting()` is never called here. Without it intl throws for
/// any locale other than `en_US`, so a calendar that renders in `de` is one
/// whose day and month names did not come from intl.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    // The schedule draws a month heading and a day row only where events exist.
    eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 6, 9), end: DateTime(2025, 1, 6, 10)),
      ),
    );
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  Widget schedule({CalendarComponents? components}) {
    final tiles = ScheduleTileComponents(tileBuilder: (context, event, range) => const SizedBox());
    return MaterialApp(
      home: Scaffold(
        body: CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          locale: 'de',
          components: components,
          viewConfiguration: ScheduleViewConfiguration.continuous(
            displayRange: DateTimeRange(start: DateTime(2025), end: DateTime(2025, 3)),
            initialDateTime: DateTime(2025),
          ),
          body: CalendarBody(scheduleTileComponents: tiles),
        ),
      ),
    );
  }

  testWidgets('the default builders need intl locale data', (tester) async {
    await tester.pumpWidget(schedule());
    await tester.pump();
    expect(
      tester.takeException(),
      isNotNull,
      reason: 'intl throws for "de" until initializeDateFormatting has run',
    );
  });

  testWidgets('the intl4x builders render without it', (tester) async {
    // intl4x returns a placeholder inside a test unless the zone opts in. See
    // `isInTest` in its `test_checker.dart`.
    await runZoned(
      () async {
        await tester.pumpWidget(schedule(components: intl4xComponents()));
        await tester.pumpAndSettle();
      },
      zoneValues: {#test.allowFormatting: true},
    );

    expect(tester.takeException(), isNull, reason: 'nothing reached intl');
    expect(find.text('Januar'), findsOneWidget, reason: 'the month heading came from intl4x');
  });
}
