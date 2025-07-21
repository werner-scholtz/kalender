import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

enum Scenario {
  scenario1(10);
  // scenario2(20);

  const Scenario(this.numberOfEvents);
  final int numberOfEvents;

  String getReportKey(Views view, ReportKeys key) =>
      '${name.toLowerCase()}-${view.name}-${key.name}';
}

enum ReportKeys { loadingEvents, navigation, scrolling }

enum Views { week, month, schedule }

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        final keys = [
          for (final scenario in Scenario.values)
            for (var view in Views.values)
              for (var key in ReportKeys.values) scenario.getReportKey(view, key),
        ];

        for (final key in keys) {
          if (!data.containsKey(key)) continue;

          final timeline = driver.Timeline.fromJson(data[key] as Map<String, dynamic>);

          // Convert the Timeline into a TimelineSummary that's easier to
          // read and understand.
          final summary = driver.TimelineSummary.summarize(timeline);

          // Then, write the entire timeline to disk in a json format.
          // This file can be opened in the Chrome browser's tracing tools
          // found by navigating to chrome://tracing.
          // Optionally, save the summary to disk by setting includeSummary
          // to true
          await summary.writeTimelineToFile(key, pretty: true, includeSummary: true);
        }
      }
    },
  );
}
