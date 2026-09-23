// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  group('KalenderController', () {
    test('every controller gets its own id', () {
      final ids = List.generate(100, (_) => KalenderController().id);
      expect(ids.toSet().length, ids.length);
    });
  });

  group('date selection', () {
    late KalenderController controller;
    setUp(() => controller = KalenderController());
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

  group('the attached view controller', () {
    final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));
    final march = MonthViewConfiguration.singleMonth(displayRange: range, initialDateTime: DateTime(2025, 3, 15));
    final june = MonthViewConfiguration.singleMonth(displayRange: range, initialDateTime: DateTime(2025, 6, 15));
    final event = KalenderEvent(start: DateTime(2025, 3, 4, 9), end: DateTime(2025, 3, 4, 10));

    late KalenderController controller;
    late ViewController attached;
    late ViewController other;
    setUp(() {
      controller = KalenderController();
      attached = june.createViewController(controller, null);
      other = march.createViewController(controller, null);
      controller.attach(attached);
    });
    tearDown(() {
      controller.dispose();
      attached.dispose();
      other.dispose();
    });

    test('supplies the visible range and events', () {
      attached.floatingVisibleRange.value = FloatingDateTimeRange(
        start: FloatingDateTime(2025),
        end: FloatingDateTime(2025, 2),
      );
      attached.visibleEvents.value = {event};
      expect(controller.floatingVisibleRange.value, attached.floatingVisibleRange.value);
      expect(controller.visibleEvents.value, {event});
    });

    test('another view controller does not reach the controller', () {
      other.visibleEvents.value = {event};
      other.floatingVisibleRange.value = FloatingDateTimeRange(
        start: FloatingDateTime(2025),
        end: FloatingDateTime(2025, 2),
      );
      expect(controller.floatingVisibleRange.value, attached.floatingVisibleRange.value);
      expect(controller.visibleEvents.value, isEmpty);
    });

    test('a detached view controller does not reach the controller', () {
      controller.attach(other);
      attached.visibleEvents.value = {event};
      expect(controller.floatingVisibleRange.value, other.floatingVisibleRange.value);
      expect(controller.visibleEvents.value, isEmpty);
    });
  });
}
