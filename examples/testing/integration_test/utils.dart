import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/test_configuration.dart';

import '../test_driver/perf_driver.dart';

/// Performs a segmented drag operation to simulate realistic user interaction.
///
/// [dragGesture] - The test gesture to perform the drag with
/// [tester] - The widget tester instance
/// [start] - Starting position of the drag
/// [end] - Ending position of the drag
/// [segmentCount] - Number of segments to split the drag into (default: 5)
/// [segmentDurationMs] - Duration between segments in milliseconds (default: 100)
/// [pumpDurationMs] - Duration to pump after each segment in milliseconds (default: 20)
Future<void> performSegmentedDrag(
  TestGesture dragGesture,
  WidgetTester tester,
  Offset start,
  Offset end, {
  int segmentCount = 10,
  int segmentDurationMs = 50,
  int pumpDurationMs = 20,
}) async {
  for (int i = 1; i <= segmentCount; i++) {
    final t = i / segmentCount;
    final intermediate = Offset.lerp(start, end, t)!;
    await dragGesture.moveTo(
      intermediate,
      timeStamp: Duration(milliseconds: segmentDurationMs * i),
    );
    await tester.pump(Duration(milliseconds: pumpDurationMs));
  }
}

extension ViewUtils on Views {
  ViewConfiguration get viewConfiguration {
    switch (this) {
      case Views.week:
        return MultiDayViewConfiguration.week(
          displayRange: TestConfiguration.testRange,
          initialDateTime: TestConfiguration.initialDateTime,
        );
      case Views.month:
        return MonthViewConfiguration.singleMonth(
          displayRange: TestConfiguration.testRange,
          initialDateTime: TestConfiguration.initialDateTime,
        );
      case Views.schedule:
        return ScheduleViewConfiguration.continuous(
          displayRange: TestConfiguration.testRange,
          initialDateTime: TestConfiguration.initialDateTime,
        );
    }
  }
}

extension ScenarioUtils on Scenario {
  List<TimeOfDayRange> get eventRanges =>
      timeOfDayRanges.take(numberOfEvents).toList();
}
