import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        final oneEventTimeline = driver.Timeline.fromJson(data['one_event_timeline'] as Map<String, dynamic>);
        var summary = driver.TimelineSummary.summarize(oneEventTimeline);
        await summary.writeTimelineToFile('one_event_timeline', pretty: true, includeSummary: true);

        final tenEventTimeline = driver.Timeline.fromJson(data['ten_event_timeline'] as Map<String, dynamic>);
        summary = driver.TimelineSummary.summarize(tenEventTimeline);
        await summary.writeTimelineToFile('ten_event_timeline', pretty: true, includeSummary: true);
      }
    },
  );
}
