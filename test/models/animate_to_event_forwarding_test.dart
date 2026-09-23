// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// Records what [KalenderController.animateToEvent] passes down.
class _RecordingViewController extends MultiDayViewController {
  _RecordingViewController({
    required super.viewConfiguration,
    required super.floatingVisibleRange,
    required super.visibleEvents,
    required super.initial,
  });

  Duration? pageDuration;
  Curve? pageCurve;
  Duration? scrollDuration;
  Curve? scrollCurve;
  bool? centerEvent;

  @override
  Future<void> animateToEvent(
    KalenderEvent event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) async {
    this.pageDuration = pageDuration;
    this.pageCurve = pageCurve;
    this.scrollDuration = scrollDuration;
    this.scrollCurve = scrollCurve;
    this.centerEvent = centerEvent;
  }
}

void main() {
  test('animateToEvent passes its durations and curves to the view controller', () async {
    final controller = KalenderController();
    final viewController = _RecordingViewController(
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026)),
      ),
      floatingVisibleRange: controller.floatingVisibleRange,
      visibleEvents: controller.visibleEvents,
      initial: todaySnapshot(),
    );
    controller.attach(viewController);

    await controller.animateToEvent(
      KalenderEvent(start: DateTime.utc(2025, 3, 24, 9), end: DateTime.utc(2025, 3, 24, 10)),
      pageDuration: const Duration(milliseconds: 111),
      pageCurve: Curves.bounceIn,
      scrollDuration: const Duration(milliseconds: 222),
      scrollCurve: Curves.easeOutBack,
      centerEvent: false,
    );

    expect(viewController.pageDuration, const Duration(milliseconds: 111));
    expect(viewController.pageCurve, Curves.bounceIn);
    expect(viewController.scrollDuration, const Duration(milliseconds: 222));
    expect(viewController.scrollCurve, Curves.easeOutBack);
    expect(viewController.centerEvent, isFalse);
  });
}
