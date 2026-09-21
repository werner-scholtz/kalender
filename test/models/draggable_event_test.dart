// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';

void main() {
  group('ResizeDirection', () {
    for (final (direction, vertical) in [
      (ResizeDirection.top, true),
      (ResizeDirection.bottom, true),
      (ResizeDirection.left, false),
      (ResizeDirection.right, false),
    ]) {
      test('$direction is ${vertical ? 'vertical' : 'horizontal'} only', () {
        expect((direction.vertical, direction.horizontal), (vertical, !vertical));
      });
    }
  });

  group('Create / Reschedule', () {
    test('Create carries the controller id', () {
      expect(Create(controllerId: 7).controllerId, 7);
    });

    test('Reschedule carries the event', () {
      final event = KalenderEvent(start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 10));
      expect(Reschedule(event: event).event, same(event));
    });
  });
}
