import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Regression coverage for #472: the timeline labels are positioned by the
/// segments before them, not by a multiple of their own height.
///
/// [TimeOfDayRange.splitIntoSegments] gives the last segment whatever is left of
/// the range, so it is shorter than the rest unless the range divides evenly.
/// [TimeOfDayRange.allDay] is one that does, which is why the default range was
/// unaffected.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  Future<void> pumpDay(WidgetTester tester, TimeOfDayRange timeOfDayRange) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(
          displayRange: year2025DisplayRange,
          timeOfDayRange: timeOfDayRange,
          initialTimeOfDay: timeOfDayRange.start,
          initialDateTime: DateTime(2025),
        ),
        body: CalendarBody(
          multiDayTileComponents: TileComponents(tileBuilder: (context, event, range) => const SizedBox()),
        ),
      ),
    );
  }

  /// The vertical position of every timeline label, in the order it is drawn.
  List<double> labelPositions(WidgetTester tester) {
    final positions = <double>[];
    for (var hour = 0; hour < TimeOfDay.hoursPerDay; hour++) {
      for (var minute = 0; minute < TimeOfDay.minutesPerHour; minute += 5) {
        final finder = find.byKey(TimeLine.getTimeKey(hour, minute));
        if (finder.evaluate().isEmpty) continue;
        positions.add(tester.getTopLeft(finder).dy);
      }
    }
    return positions;
  }

  /// Asserts the labels run down the timeline in order, evenly spaced.
  void expectEvenlySpaced(WidgetTester tester) {
    final positions = labelPositions(tester);
    expect(positions.length, greaterThan(2), reason: 'the range should show several labels');

    final spacing = positions[1] - positions[0];
    expect(spacing, greaterThan(0), reason: 'the labels run down the timeline');
    for (var i = 1; i < positions.length; i++) {
      expect(
        positions[i] - positions[i - 1],
        moreOrLessEquals(spacing, epsilon: 0.5),
        reason: 'label $i sits one segment below the one before it',
      );
    }
  }

  testWidgets('the all day range labels are evenly spaced', (tester) async {
    await pumpDay(tester, TimeOfDayRange.allDay());
    expectEvenlySpaced(tester);
  });

  testWidgets('a range ending on a segment boundary labels its last segment in place', (tester) async {
    // 09:00 to 18:00 leaves a one minute segment at the end, whose label used to
    // land at the top of the timeline.
    await pumpDay(
      tester,
      TimeOfDayRange(start: const TimeOfDay(hour: 9, minute: 0), end: const TimeOfDay(hour: 18, minute: 0)),
    );
    expectEvenlySpaced(tester);
  });

  testWidgets('a range ending part way through a segment labels its last segment in place', (tester) async {
    // 09:00 to 17:30 leaves a 31 minute segment at the end, so it is affected
    // without producing the one minute segment above.
    await pumpDay(
      tester,
      TimeOfDayRange(start: const TimeOfDay(hour: 9, minute: 0), end: const TimeOfDay(hour: 17, minute: 30)),
    );
    expectEvenlySpaced(tester);
  });

  testWidgets('the labels line up with the hour lines', (tester) async {
    final range = TimeOfDayRange(
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
    );
    await pumpDay(tester, range);

    final content = tester.getRect(find.byType(HourLines));
    final positions = labelPositions(tester);
    final spacing = positions[1] - positions[0];

    // The last label marks the end of the range, one segment below the one
    // before it and within the drawn area.
    expect(positions.last - positions[positions.length - 2], moreOrLessEquals(spacing, epsilon: 0.5));
    expect(positions.last, lessThan(content.bottom));
  });
}
