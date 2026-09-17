// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/kalender_callbacks.dart';
import 'package:kalender/src/models/kalender_date_time_range.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// Reports the gestures in [callbacks] on [child], and returns [child] unchanged when none are set.
class GestureCallbacksDetector<T extends TapDetail> extends StatelessWidget {
  const GestureCallbacksDetector({
    super.key,
    required this.callbacks,
    required this.detail,
    this.behavior = HitTestBehavior.deferToChild,
    required this.child,
  });

  final GestureCallbacks<T>? callbacks;

  /// Builds the detail passed to a callback.
  final T Function(RenderBox renderBox, Offset localOffset) detail;

  /// How the detector behaves during hit testing.
  final HitTestBehavior behavior;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final callbacks = this.callbacks;
    if (callbacks == null || !callbacks.hasAny) return child;

    void Function(Offset)? report(OnGesture<T>? callback) {
      if (callback == null) return null;
      return (localOffset) => callback(detail(context.findRenderObject()! as RenderBox, localOffset));
    }

    final onTap = report(callbacks.onTap);
    final onSecondaryTap = report(callbacks.onSecondaryTap);
    final onLongPress = report(callbacks.onLongPress);
    final onSecondaryLongPress = report(callbacks.onSecondaryLongPress);

    return MouseRegion(
      cursor: onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: behavior,
        onTapUp: onTap == null ? null : (details) => onTap(details.localPosition),
        onSecondaryTapUp: onSecondaryTap == null ? null : (details) => onSecondaryTap(details.localPosition),
        onLongPressStart: onLongPress == null ? null : (details) => onLongPress(details.localPosition),
        onSecondaryLongPressStart: onSecondaryLongPress == null
            ? null
            : (details) => onSecondaryLongPress(details.localPosition),
        child: child,
      ),
    );
  }
}

/// Reports [KalenderCallbacks.dateLabel] on [child].
class DateLabelGestures extends StatelessWidget {
  const DateLabelGestures({super.key, required this.date, required this.child});

  /// The date the label shows, in the calendar's location.
  final DateTime date;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureCallbacksDetector<DayDetail>(
      callbacks: Callbacks.maybeOf(context)?.dateLabel,
      detail: (renderBox, localOffset) => DayDetail(date: date, renderBox: renderBox, localOffset: localOffset),
      child: child,
    );
  }
}

/// Reports [KalenderCallbacks.weekNumber] on [child].
class WeekNumberGestures extends StatelessWidget {
  const WeekNumberGestures({super.key, required this.range, required this.child});

  /// The range the week number shows.
  final KalenderDateTimeRange range;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureCallbacksDetector<MultiDayDetail>(
      callbacks: Callbacks.maybeOf(context)?.weekNumber,
      detail: (renderBox, localOffset) =>
          MultiDayDetail(dateTimeRange: range, renderBox: renderBox, localOffset: localOffset),
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
