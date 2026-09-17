// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';

void main() {
  KalenderEvent makeEvent({String id = 'e1'}) =>
      KalenderEvent(id: id, start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 10));

  group('ResizeDirection', () {
    test('top and bottom are vertical, not horizontal', () {
      for (final direction in [ResizeDirection.top, ResizeDirection.bottom]) {
        expect(direction.vertical, isTrue, reason: '$direction should be vertical');
        expect(direction.horizontal, isFalse, reason: '$direction should not be horizontal');
      }
    });

    test('left and right are horizontal, not vertical', () {
      for (final direction in [ResizeDirection.left, ResizeDirection.right]) {
        expect(direction.horizontal, isTrue, reason: '$direction should be horizontal');
        expect(direction.vertical, isFalse, reason: '$direction should not be vertical');
      }
    });
  });

  group('Create / Reschedule', () {
    test('Create carries the controller id', () {
      expect(Create(controllerId: 7).controllerId, equals(7));
    });

    test('Reschedule carries the event', () {
      final event = makeEvent();
      expect(Reschedule(event: event).event, same(event));
    });
  });
}
