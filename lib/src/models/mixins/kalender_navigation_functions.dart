// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';

mixin KalenderNavigationFunctions {
  /// Jump to the given [page].
  void jumpToPage(int page);

  /// Jump to the given [DateTime].
  void jumpToDate(DateTime date);

  /// Animate to the next page.
  Future<void> animateToNextPage({Duration? duration, Curve? curve});

  /// Animate to the previous page.
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve});

  /// Animate to the date part of the given [DateTime].
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve});

  /// Animate to the date and time parts of the given [DateTime].
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  });

  /// Animate to the given [KalenderEvent].
  Future<void> animateToEvent(
    KalenderEvent event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  });
}
