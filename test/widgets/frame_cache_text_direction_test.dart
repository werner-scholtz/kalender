import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  // 29 Jan 2025 is a Wednesday, in the last row of a five row January.
  final day = DateTime.utc(2025, 1, 29);

  late DefaultEventsController eventsController;
  late KalenderController calendarController;
  late MonthViewConfiguration configuration;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = KalenderController();
    configuration = MonthViewConfiguration.singleMonth(
      displayRange: year2025DisplayRange,
      initialDateTime: DateTime(2025, 1, 15),
    );
    for (var i = 0; i < 8; i++) {
      eventsController.addEvent(
        KalenderEvent(start: day, end: day.add(const Duration(days: 1))),
      );
    }
  });

  tearDown(() {
    calendarController.dispose();
    eventsController.dispose();
  });

  /// The same calendar, same controllers and same configuration, rendered in
  /// [textDirection]. Nothing here recreates the view controller, so its layout
  /// frame cache carries over between directions.
  Widget build(TextDirection textDirection) {
    return Directionality(
      textDirection: textDirection,
      child: KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: configuration,
        body: const KalenderBody(),
      ),
    );
  }

  Set<DateTime> overflowDates(WidgetTester tester) {
    final found = <DateTime>{};
    for (var d = 27; d <= 31; d++) {
      final date = DateTime.utc(2025, 1, d);
      if (find.byKey(MultiDayPortalOverlayButton.getKey(date)).evaluate().isNotEmpty) found.add(date);
    }
    return found;
  }

  testWidgets('flipping text direction on a live calendar keeps the overflow on the same date', (tester) async {
    final dpi = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(800 * dpi, 600 * dpi);
    addTearDown(tester.view.resetPhysicalSize);

    await pumpAndSettleWithMaterialApp(tester, build(TextDirection.ltr));
    final ltr = overflowDates(tester);
    expect(ltr, contains(day));

    // Only the direction changes. The view controller, and so its layout frame
    // cache, is the same one.
    await pumpAndSettleWithMaterialApp(tester, build(TextDirection.rtl));

    expect(
      overflowDates(tester),
      equals(ltr),
      reason: 'the cached frame is ordered by direction, so it must not be reused across a flip',
    );
  });
}
