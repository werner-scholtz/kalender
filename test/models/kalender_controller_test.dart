// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

import '../utilities.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();

  group('KalenderController', () {
    test('every controller gets its own id', () {
      final ids = List.generate(100, (_) => KalenderController(viewConfiguration: MultiDayViewConfiguration.week()).id);
      expect(ids.toSet().length, ids.length);
    });
  });

  group('date selection', () {
    late KalenderController controller;
    setUp(() => controller = KalenderController(viewConfiguration: MultiDayViewConfiguration.week()));
    tearDown(() => controller.dispose());

    test('selectDate selects the whole day', () {
      controller.selectDate(DateTime(2025, 3, 15, 14, 30));
      expect(
        controller.selectedRange.value,
        FloatingDateTimeRange(start: DateTime.utc(2025, 3, 15), end: DateTime.utc(2025, 3, 16)),
      );
    });

    group('selectRange covers every day the range touches', () {
      FloatingDateTimeRange days(int first, int endDay) =>
          FloatingDateTimeRange(start: DateTime.utc(2025, 3, first), end: DateTime.utc(2025, 3, endDay));

      test('an end at midnight does not include that day', () {
        controller.selectRange(KalenderDateTimeRange(start: DateTime(2025, 3, 15), end: DateTime(2025, 3, 18)));
        expect(controller.selectedRange.value, days(15, 18));
      });

      test('an end during a day includes that day', () {
        controller.selectRange(KalenderDateTimeRange(start: DateTime(2025, 3, 15, 14), end: DateTime(2025, 3, 17, 10)));
        expect(controller.selectedRange.value, days(15, 18));
      });

      test('an empty range selects its day', () {
        controller.selectRange(KalenderDateTimeRange(start: DateTime(2025, 3, 15), end: DateTime(2025, 3, 15)));
        expect(controller.selectedRange.value, days(15, 16));
      });

      test('the selected range round-trips', () {
        controller.selectRange(KalenderDateTimeRange(start: DateTime(2025, 3, 15), end: DateTime(2025, 3, 18)));
        final selected = controller.selectedRange.value!;
        controller.selectRange(selected.forLocation());
        expect(controller.selectedRange.value, selected);
      });
    });

    test('isDateSelected and deselectRange', () {
      controller.selectRange(KalenderDateTimeRange(start: DateTime(2025, 3, 15), end: DateTime(2025, 3, 17)));
      expect(controller.isDateSelected(DateTime(2025, 3, 14, 23, 59)), isFalse);
      expect(controller.isDateSelected(DateTime(2025, 3, 15)), isTrue);
      expect(controller.isDateSelected(DateTime(2025, 3, 16, 23, 59)), isTrue);
      expect(controller.isDateSelected(DateTime(2025, 3, 17)), isFalse);

      controller.deselectRange();
      expect(controller.selectedRange.value, isNull);
      expect(controller.isDateSelected(DateTime(2025, 3, 15)), isFalse);
    });
  });

  group('the view controller', () {
    final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));
    final march = MonthViewConfiguration.singleMonth(displayRange: range, initialDateTime: DateTime(2025, 3, 15));
    final june = MonthViewConfiguration.singleMonth(displayRange: range, initialDateTime: DateTime(2025, 6, 15));
    final event = KalenderEvent(start: DateTime(2025, 3, 4, 9), end: DateTime(2025, 3, 4, 10));

    late KalenderController controller;
    late ViewController first;
    late ViewController other;
    setUp(() {
      controller = KalenderController(viewConfiguration: june);
      first = controller.viewController;
      other = march.createViewController(controller, null);
    });
    tearDown(() {
      controller.dispose();
      other.dispose();
    });

    test('supplies the visible range and events', () {
      first.floatingVisibleRange.value = FloatingDateTimeRange(
        start: FloatingDateTime(2025),
        end: FloatingDateTime(2025, 2),
      );
      first.visibleEvents.value = {event};
      expect(controller.floatingVisibleRange.value, first.floatingVisibleRange.value);
      expect(controller.visibleEvents.value, {event});
    });

    test('another view controller does not reach the controller', () {
      other.visibleEvents.value = {event};
      other.floatingVisibleRange.value = FloatingDateTimeRange(
        start: FloatingDateTime(2025),
        end: FloatingDateTime(2025, 2),
      );
      expect(controller.floatingVisibleRange.value, first.floatingVisibleRange.value);
      expect(controller.visibleEvents.value, isEmpty);
    });

    test('a replaced view controller does not reach the controller', () {
      final view = Object();
      controller.attachView(view);
      controller.viewConfiguration = march;
      first.visibleEvents.value = {event};
      expect(controller.floatingVisibleRange.value, controller.viewController.floatingVisibleRange.value);
      expect(controller.visibleEvents.value, isEmpty);
      controller.releaseView(view, first);
    });
  });

  group('the view configuration and location', () {
    final week = MultiDayViewConfiguration.week(
      displayRange: year2025DisplayRange,
      initialDateTime: DateTime(2025, 3, 5),
    );
    final month = MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange);

    late KalenderController controller;
    late int notifications;
    setUp(() {
      controller = KalenderController(viewConfiguration: week);
      notifications = 0;
      controller.addListener(() => notifications++);
    });
    tearDown(() => controller.dispose());

    test('the constructor creates the view controller and supplies its range', () {
      expect(
        (controller.viewController.runtimeType, controller.visibleDateTimeRange.value),
        (MultiDayViewController, controller.viewController.floatingVisibleRange.value!.forLocation()),
      );
    });

    test('an equal configuration changes nothing', () {
      final viewController = controller.viewController;
      controller.viewConfiguration = MultiDayViewConfiguration.week(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 3, 5),
      );
      expect((identical(controller.viewController, viewController), notifications), (true, 0));
    });

    test('another configuration switches the view and carries the date', () {
      controller.viewConfiguration = month;
      expect(
        (controller.viewController.runtimeType, controller.viewController.snapshot().date, notifications),
        (MonthViewController, FloatingDateTime(2025, 3), 1),
      );
    });

    test('another location recreates the view controller in it', () {
      final tokyo = getLocation('Asia/Tokyo');
      final viewController = controller.viewController;
      controller.location = tokyo;
      expect(
        (controller.viewController.location, controller.viewController == viewController, notifications),
        (tokyo, false, 1),
      );
      expect(
        controller.visibleDateTimeRange.value,
        controller.viewController.floatingVisibleRange.value!.forLocation(location: tokyo),
      );
    });

    test('dispose disposes the view controller', () {
      final other = KalenderController(viewConfiguration: week);
      final viewController = other.viewController;
      other.dispose();
      expect(() => viewController.floatingVisibleRange.addListener(() {}), throwsFlutterError);
    });
  });
}
