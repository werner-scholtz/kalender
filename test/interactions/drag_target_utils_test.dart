// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';
import 'package:timezone/data/latest_10y.dart';

class _HarnessWidget extends StatefulWidget {
  const _HarnessWidget();

  @override
  State<_HarnessWidget> createState() => _DragUtilsHarness();
}

/// A minimal [DragTargetUtilities] host used to exercise the mixin's pure
/// range-math helpers. It is never pumped, so [State.context] throws and
/// [State.mounted] is false. Only the helpers that touch neither may be called
/// against this harness.
class _DragUtilsHarness extends State<_HarnessWidget> with DragTargetUtilities<_HarnessWidget> {
  @override
  final KalenderController controller = KalenderController(viewConfiguration: MultiDayViewConfiguration.week());

  @override
  EventsController get eventsController => throw UnimplementedError();

  @override
  KalenderCallbacks? get callbacks => null;

  @override
  double get dayWidth => 0;

  @override
  List<DateTime> get visibleDates => const [];

  @override
  bool get multiDayDragTarget => false;

  @override
  KalenderEvent? rescheduleEvent(KalenderEvent event, FloatingDateTime cursorDateTime) => throw UnimplementedError();

  @override
  KalenderEvent? resizeEvent(KalenderEvent event, ResizeDirection direction, FloatingDateTime cursorDateTime) =>
      throw UnimplementedError();

  @override
  FloatingDateTime? calculateCursorDateTime(Offset offset, {Offset feedbackWidgetOffset = Offset.zero}) =>
      throw UnimplementedError();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  initializeTimeZones();

  final harness = _DragUtilsHarness();
  DateTime at(int hour) => DateTime.utc(2024, 1, 15, hour);
  FloatingDateTimeRange hours(int start, int end) => FloatingDateTimeRange(start: at(start), end: at(end));
  final range = hours(10, 12);

  KalenderEvent eventWithId(String id) {
    return KalenderEvent(id: id, start: DateTime.utc(2024, 1, 15, 9), end: DateTime.utc(2024, 1, 15, 10));
  }

  for (final (method, calculate, cases) in [
    (
      'calculateRangeFromStart',
      harness.calculateRangeFromStart,
      [
        ('new start before end keeps the end and moves the start', 9, hours(9, 12)),
        ('new start equal to end returns the original range', 12, range),
        ('new start after end swaps the boundaries', 13, hours(12, 13)),
      ],
    ),
    (
      'calculateRangeFromEnd',
      harness.calculateRangeFromEnd,
      [
        ('new end after start keeps the start and moves the end', 13, hours(10, 13)),
        ('new end equal to start returns the original range', 10, range),
        ('new end before start swaps the boundaries', 9, hours(9, 10)),
      ],
    ),
  ]) {
    group(method, () {
      for (final (name, hour, expected) in cases) {
        test(name, () => expect(calculate(range, at(hour)), expected));
      }
    });
  }

  group('handleDragDetails', () {
    String dispatch(Object? data, {KalenderEvent Function(KalenderEvent)? resolveEvent}) {
      return DragTargetUtilities.handleDragDetails<String, Object?>(
        DragTargetDetails(data: data, offset: Offset.zero),
        onCreate: (controllerId) => 'create:$controllerId',
        onResize: (event, direction) => 'resize:${event.id}:${direction.name}',
        onReschedule: (event) => 'reschedule:${event.id}',
        onOther: () => 'other',
        resolveEvent: resolveEvent,
      );
    }

    test('routes Create data to onCreate with the controller id', () {
      expect(dispatch(Create(controllerId: 42)), equals('create:42'));
    });

    test('routes Resize data to onResize with the event and direction', () {
      final data = Resize(event: eventWithId('e1'), direction: ResizeDirection.bottom);
      expect(dispatch(data), equals('resize:e1:bottom'));
    });

    test('routes Reschedule data to onReschedule with the payload event when resolveEvent is null', () {
      expect(dispatch(Reschedule(event: eventWithId('e2'))), equals('reschedule:e2'));
    });

    test('routes unknown data to onOther', () {
      expect(dispatch('not-a-drag-payload'), equals('other'));
      expect(dispatch(null), equals('other'));
    });

    test('applies resolveEvent to the latest event for Resize/Reschedule', () {
      final live = eventWithId('live');
      KalenderEvent resolve(KalenderEvent _) => live;

      expect(
        dispatch(
          Resize(event: eventWithId('stale'), direction: ResizeDirection.top),
          resolveEvent: resolve,
        ),
        equals('resize:live:top'),
      );
      expect(dispatch(Reschedule(event: eventWithId('stale')), resolveEvent: resolve), equals('reschedule:live'));
    });
  });

  // calculateCursorDateTime throws in this harness, so the guard must return before reaching it.
  group('Create guard ignores a foreign controller id', () {
    test('onAcceptWithDetails returns normally for a foreign create', () {
      final host = _DragUtilsHarness();
      final foreign = Create(controllerId: host.controller.id + 1);
      expect(() => host.onAcceptWithDetails(DragTargetDetails(data: foreign, offset: Offset.zero)), returnsNormally);
    });
  });
}
