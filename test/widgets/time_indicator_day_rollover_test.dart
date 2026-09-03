import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';

import '../utilities.dart';

/// The time indicator has to move to the next day's column while the app keeps
/// running, without anything else prompting it.
///
/// The clock here is virtual. `tester.pump(duration)` advances it and fires
/// every timer due in that window, so a day passing costs no real time. What
/// this cannot cover is the operating system suspending timers on a real
/// device, so the lifecycle case below stands in for that: it asserts the
/// indicator corrects itself when the app is resumed, which is the only signal
/// the package gets after a suspension.
void main() {
  const pageWidth = 700.0;
  const dayWidth = pageWidth / 7;

  /// Pumps a week view whose clock is [now], and returns the indicator finder.
  Future<Finder> pumpWeek(WidgetTester tester, DateTime Function() now, {Key? key}) async {
    final indicatorKey = key ?? UniqueKey();
    final monday = InternalDateTime.fromDateTime(now()).startOfWeek();
    final range = InternalDateTimeRange(start: monday, end: monday.endOfWeek());

    await pumpAndSettleWithMaterialApp(
      tester,
      SizedBox(
        width: pageWidth,
        height: 100,
        child: Stack(
          children: [
            TimeIndicatorPositioner(
              viewController: MultiDayViewController(
                viewConfiguration: MultiDayViewConfiguration.week(
                  displayRange: range.forLocation(),
                  nowCallback: now,
                ),
                visibleDateTimeRange: ValueNotifier(range),
                visibleEvents: ValueNotifier(<CalendarEvent>{}),
              ),
              initialPage: 0,
              childOverride: SizedBox(key: indicatorKey),
            ),
          ],
        ),
      ),
    );

    return find.byKey(indicatorKey);
  }

  testWidgets('the indicator moves to the next column when the day rolls over', (tester) async {
    // Wednesday, so the rollover lands inside the same visible week.
    var now = DateTime(2026, 3, 4, 23, 59);
    final finder = await pumpWeek(tester, () => now);

    expect(tester.getTopLeft(finder).dx, dayWidth * 2, reason: 'Wednesday is the third column');

    now = DateTime(2026, 3, 5, 0, 1);
    await tester.pump(const Duration(minutes: 2));

    expect(tester.getTopLeft(finder).dx, dayWidth * 3, reason: 'Thursday is the fourth column');
  });

  testWidgets('a rebuild every 30 seconds does not stop the day being noticed', (tester) async {
    // The day check runs on a periodic timer that is rebuilt whenever the
    // widget updates. A calendar rebuilding faster than the timer's period
    // would restart the countdown every time and never reach it.
    var now = DateTime(2026, 3, 4, 12, 0);
    final indicatorKey = UniqueKey();
    late StateSetter rebuild;

    final monday = InternalDateTime.fromDateTime(now).startOfWeek();
    final range = InternalDateTimeRange(start: monday, end: monday.endOfWeek());

    await pumpAndSettleWithMaterialApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          rebuild = setState;
          return SizedBox(
            width: pageWidth,
            height: 100,
            child: Stack(
              children: [
                TimeIndicatorPositioner(
                  viewController: MultiDayViewController(
                    viewConfiguration: MultiDayViewConfiguration.week(
                      displayRange: range.forLocation(),
                      nowCallback: () => now,
                    ),
                    visibleDateTimeRange: ValueNotifier(range),
                    visibleEvents: ValueNotifier(<CalendarEvent>{}),
                  ),
                  initialPage: 0,
                  childOverride: SizedBox(key: indicatorKey),
                ),
              ],
            ),
          );
        },
      ),
    );

    final finder = find.byKey(indicatorKey);
    expect(tester.getTopLeft(finder).dx, dayWidth * 2);

    now = DateTime(2026, 3, 5, 12, 0);

    // Twelve hours of a parent rebuilding twice a minute.
    for (var i = 0; i < 24 * 60; i++) {
      rebuild(() {});
      await tester.pump(const Duration(seconds: 30));
    }

    expect(tester.getTopLeft(finder).dx, dayWidth * 3);
  });

  testWidgets('a full day passing moves the indicator off a page it no longer belongs to', (tester) async {
    // Sunday is the last column, so the rollover puts today on the next page
    // while the view stays where it is. The indicator belongs to the new page,
    // not this one, so it has to leave rather than stay on the last column.
    var now = DateTime(2026, 3, 8, 12, 0);
    final finder = await pumpWeek(tester, () => now);

    expect(tester.getTopLeft(finder).dx, dayWidth * 6, reason: 'Sunday is the seventh column');

    now = DateTime(2026, 3, 9, 12, 0);
    await tester.pump(const Duration(hours: 25));

    // Dropped from the tree rather than drawn off the edge, since the page it
    // belongs to is a whole page away. Navigating to that page brings it back.
    expect(finder, findsNothing);
  });

  testWidgets('resuming the app corrects the indicator after time passed', (tester) async {
    // Stands in for the operating system suspending timers while the app is in
    // the background: no timer fires, and the resume is the only signal.
    var now = DateTime(2026, 3, 4, 12, 0);
    final finder = await pumpWeek(tester, () => now);

    expect(tester.getTopLeft(finder).dx, dayWidth * 2);

    now = DateTime(2026, 3, 6, 12, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(tester.getTopLeft(finder).dx, dayWidth * 4, reason: 'Friday is the fifth column');
  });
}
