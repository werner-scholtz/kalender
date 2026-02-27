import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';

import '../utilities.dart';

void main() {
  group('TimeIndicatorPositioner', () {
    final key = UniqueKey();
    final now = InternalDateTime.fromDateTime(DateTime.now()).startOfWeek();
    final range = InternalDateTimeRange(start: now, end: now.endOfWeek());
    final viewConfiguration = MultiDayViewConfiguration.week(displayRange: range);

    for (final (index, date) in range.dates().map(InternalDateTime.fromDateTime).indexed) {
      testWidgets('for date index: ($index)', (tester) async {
        await pumpAndSettleWithMaterialApp(
          tester,
          SizedBox(
            width: 700,
            height: 100,
            child: Stack(
              children: [
                PositionedTimeIndicator(
                  viewController: MultiDayViewController(
                    viewConfiguration: viewConfiguration,
                    visibleDateTimeRange: ValueNotifier(InternalDateTimeRange.fromDateTimeRange(range)),
                    visibleEvents: ValueNotifier(<CalendarEvent>{}),
                  ),
                  initialPage: 0,
                  dateOverride: date,
                  childOverride: SizedBox(key: key),
                ),
              ],
            ),
          ),
        );
        final finder = find.byKey(key);
        expect(finder, findsOneWidget);
        expect(tester.getTopLeft(finder).dx, index * 100.0);
      });
    }
  });
}
