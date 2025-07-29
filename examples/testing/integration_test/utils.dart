import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/test_configuration.dart';

import '../test_driver/perf_driver.dart';

/// Extensions for [WidgetTester] to provide desktop-compatible scrolling utilities.
extension Test on WidgetTester {
  Future<void> profile({
    required IntegrationTestWidgetsFlutterBinding binding,
    required Future<void> Function() test,
    required String reportKey,
  }) {
    return binding.traceAction(
      () async => await test.call(),
      reportKey: reportKey,
    );
  }
}

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
          selectedDate: TestConfiguration.selectedDate,
        );
      case Views.month:
        return MonthViewConfiguration.singleMonth(
          displayRange: TestConfiguration.testRange,
          selectedDate: TestConfiguration.selectedDate,
        );
      case Views.schedule:
        return ScheduleViewConfiguration.continuous(
          displayRange: TestConfiguration.testRange,
          selectedDate: TestConfiguration.selectedDate,
        );
    }
  }
}

extension ScenarioUtils on Scenario {
  List<TimeOfDayRange> get eventRanges =>
      timeOfDayRanges.take(numberOfEvents).toList();
}
