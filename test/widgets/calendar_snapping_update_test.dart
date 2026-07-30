import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

import '../utilities.dart';

/// A strategy that snaps nothing, so it is distinguishable from
/// [defaultSnapStrategy] by behavior rather than by identity alone.
InternalDateTime noSnapStrategy(
  InternalDateTime cursorDate,
  InternalDateTime startOfDay,
  int snapIntervalMinutes,
) {
  return cursorDate;
}

void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  tearDown(() {
    calendarController.dispose();
    eventsController.dispose();
  });

  Widget buildCalendar(CalendarSnapping snapping) {
    return CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 1, 1),
      ),
      body: CalendarBody(snapping: snapping),
    );
  }

  /// The snapping the calendar's widget tree is actually reading.
  CalendarSnapping resolvedSnapping(WidgetTester tester) {
    return tester.widget<Snapping>(find.byType(Snapping)).notifier!.value;
  }

  /// 00:08 with a 15 minute interval. [defaultSnapStrategy] moves it to 00:15,
  /// [noSnapStrategy] leaves it alone, so the result names the strategy in use.
  InternalDateTime applyStrategy(CalendarSnapping snapping) {
    return snapping.eventSnapStrategy(
      InternalDateTime(2025, 1, 1, 0, 8),
      InternalDateTime(2025, 1, 1),
      15,
    );
  }

  testWidgets('the initial eventSnapStrategy reaches the widget tree', (tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      buildCalendar(const CalendarSnapping(eventSnapStrategy: noSnapStrategy)),
    );

    expect(applyStrategy(resolvedSnapping(tester)), equals(InternalDateTime(2025, 1, 1, 0, 8)));
  });

  testWidgets('changing only eventSnapStrategy updates the widget tree', (tester) async {
    await pumpAndSettleWithMaterialApp(tester, buildCalendar(const CalendarSnapping()));

    // The default strategy rounds 00:08 up to 00:15.
    expect(applyStrategy(resolvedSnapping(tester)), equals(InternalDateTime(2025, 1, 1, 0, 15)));

    // Rebuild with a snapping that differs only by its strategy.
    await pumpAndSettleWithMaterialApp(
      tester,
      buildCalendar(const CalendarSnapping(eventSnapStrategy: noSnapStrategy)),
    );

    expect(
      applyStrategy(resolvedSnapping(tester)),
      equals(InternalDateTime(2025, 1, 1, 0, 8)),
      reason: 'the new strategy should be in effect, so 00:08 is left alone',
    );
  });

  testWidgets('changing eventSnapStrategy alongside another field updates the widget tree', (tester) async {
    await pumpAndSettleWithMaterialApp(tester, buildCalendar(const CalendarSnapping()));

    await pumpAndSettleWithMaterialApp(
      tester,
      buildCalendar(const CalendarSnapping(snapIntervalMinutes: 30, eventSnapStrategy: noSnapStrategy)),
    );

    final snapping = resolvedSnapping(tester);
    expect(snapping.snapIntervalMinutes, equals(30));
    expect(applyStrategy(snapping), equals(InternalDateTime(2025, 1, 1, 0, 8)));
  });
}
