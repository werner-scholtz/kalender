import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';

import 'utilities.dart';

void main() {
  group('CalendarView Configuration Changes', () {
    final key = UniqueKey();
    final now = DateTime.now().asUtc.startOfWeek();
    final range = DateTimeRange(start: now, end: now.endOfWeek());

    for (final (index, date) in range.dates().indexed) {
      testWidgets('TimeIndicatorPositioner for date index: ($index)', (tester) async {
        await tester.pumpWidget(
          wrapWithMaterialApp(
            SizedBox(
              width: 700,
              height: 100,
              child: Stack(
                children: [
                  TimeIndicatorPositioner(
                    viewController: MultiDayViewController(
                      viewConfiguration: MultiDayViewConfiguration.week(displayRange: range),
                      visibleDateTimeRange: ValueNotifier(range),
                      visibleEvents: ValueNotifier(<CalendarEvent>{}),
                    ),
                    dayWidth: 100,
                    pageWidth: 700,
                    initialPage: 0,
                    dateOverride: date,
                    child: SizedBox(key: key),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        final finder = find.byKey(key);
        expect(finder, findsOneWidget);
        expect(tester.getTopLeft(finder).dx, index * 100.0);
      });
    }
  });
}
