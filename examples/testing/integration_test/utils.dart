import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/test_configuration.dart';

import '../test_driver/perf_driver.dart';

/// Extensions for [WidgetTester] to provide desktop-compatible scrolling utilities.
extension Test on WidgetTester {
  /// Scrolls a scrollable widget using desktop mouse wheel events until the target widget becomes visible.
  ///
  /// This method uses [TestPointer] with [PointerDeviceKind.mouse] to simulate
  /// mouse wheel scrolling, which is more appropriate for desktop testing than
  /// touch-based drag gestures.
  ///
  /// The [target] parameter specifies the widget to scroll to.
  /// The [scrollable] parameter specifies the scrollable widget to scroll within.
  /// The [scrollStep] parameter defines the scroll delta for each iteration.
  /// The [maxIteration] parameter limits the number of scroll attempts (defaults to 100).
  /// The [duration] parameter sets the delay between scroll events (defaults to 10ms).
  ///
  /// Throws a [StateError] if the target widget is not found after [maxIteration] scrolls.
  ///
  /// Example:
  /// ```dart
  /// await tester.desktopScrollUntilVisible(
  ///   target: find.text('My Target'),
  ///   scrollable: find.byType(ListView),
  ///   scrollStep: const Offset(0, -100),
  /// );
  /// ```
  Future<void> desktopScrollUntilVisible({
    required Finder target,
    required Finder scrollable,
    required Offset scrollStep,
    int maxIteration = 100,
    Duration duration = const Duration(milliseconds: 50),
  }) async {
    final testPointer = TestPointer(1, PointerDeviceKind.mouse);
    testPointer.hover(getCenter(scrollable));

    int iteration = 0;
    while (iteration < maxIteration && target.evaluate().isEmpty) {
      await sendEventToBinding(testPointer.scroll(scrollStep));
      await pump(duration);
      iteration++;
    }

    if (target.evaluate().isNotEmpty) {
      await Scrollable.ensureVisible(element(target));
    } else {
      throw StateError('Target widget not found after $iteration scrolls.');
    }
  }

  /// Scrolls up to find the start target, then scrolls down to find the end target.
  ///
  /// This method is useful for testing scrolling behavior in both directions
  /// within a scrollable widget using desktop-compatible mouse wheel events.
  ///
  /// The [startTarget] parameter specifies the widget to scroll to first (upward).
  /// The [endTarget] parameter specifies the widget to scroll to second (downward).
  /// The [scrollable] parameter specifies the scrollable widget to scroll within.
  /// The [scrollStep] parameter defines the scroll distance for each iteration.
  /// The [maxIteration] parameter limits the number of scroll attempts per direction (defaults to 100).
  /// The [duration] parameter sets the delay between scroll events (defaults to 50ms).
  ///
  /// Example:
  /// ```dart
  /// await tester.scrollUpAndDown(
  ///   startTarget: find.text('Top Item'),
  ///   endTarget: find.text('Bottom Item'),
  ///   scrollable: find.byType(ListView),
  ///   scrollStep: 100.0,
  /// );
  /// ```
  Future<void> scrollUpAndDown({
    required Finder startTarget,
    required Finder endTarget,
    required Finder scrollable,
    required double scrollStep,
    int maxIteration = 100,
    Duration duration = const Duration(milliseconds: 50),
  }) async {
    await desktopScrollUntilVisible(
      target: startTarget,
      scrollable: scrollable,
      scrollStep: Offset(0, -scrollStep),
      maxIteration: maxIteration,
      duration: duration,
    );

    await pumpAndSettle(Duration(milliseconds: 500));

    await desktopScrollUntilVisible(
      target: endTarget,
      scrollable: scrollable,
      scrollStep: Offset(0, scrollStep),
      maxIteration: maxIteration,
      duration: duration,
    );
  }

  Future<void> profile({
    required IntegrationTestWidgetsFlutterBinding binding,
    required Future<void> Function() test,
    required String reportKey,
  }) {
    return binding.traceAction(() async => await test.call(), reportKey: reportKey);
  }
}

final timeOfDayRanges = [
  TimeOfDayRange(
    start: const TimeOfDay(hour: 5, minute: 0),
    end: const TimeOfDay(hour: 6, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 5, minute: 30),
    end: const TimeOfDay(hour: 6, minute: 15),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 6, minute: 0),
    end: const TimeOfDay(hour: 8, minute: 15),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 0),
    end: const TimeOfDay(hour: 9, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 30),
    end: const TimeOfDay(hour: 10, minute: 0),
  ),

  /// 5
  TimeOfDayRange(
    start: const TimeOfDay(hour: 9, minute: 0),
    end: const TimeOfDay(hour: 10, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 10, minute: 0),
    end: const TimeOfDay(hour: 11, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 12, minute: 0),
    end: const TimeOfDay(hour: 13, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 13, minute: 0),
    end: const TimeOfDay(hour: 14, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 0),
    end: const TimeOfDay(hour: 14, minute: 0),
  ),

  /// 5
  TimeOfDayRange(
    start: const TimeOfDay(hour: 14, minute: 0),
    end: const TimeOfDay(hour: 15, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 14, minute: 30),
    end: const TimeOfDay(hour: 15, minute: 30),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 15, minute: 0),
    end: const TimeOfDay(hour: 16, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 16, minute: 0),
    end: const TimeOfDay(hour: 17, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 0),
    end: const TimeOfDay(hour: 17, minute: 0),
  ),

  /// 5
  TimeOfDayRange(
    start: const TimeOfDay(hour: 17, minute: 0),
    end: const TimeOfDay(hour: 18, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 17, minute: 30),
    end: const TimeOfDay(hour: 18, minute: 30),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 18, minute: 0),
    end: const TimeOfDay(hour: 19, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 19, minute: 0),
    end: const TimeOfDay(hour: 20, minute: 0),
  ),
  TimeOfDayRange(
    start: const TimeOfDay(hour: 20, minute: 0),
    end: const TimeOfDay(hour: 21, minute: 0),
  ),
];


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
  List<TimeOfDayRange> get eventRanges => timeOfDayRanges.take(numberOfEvents).toList();
}
