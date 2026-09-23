// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/internal_components/day_overlay.dart';

/// A function that returns a [MultiDayOverlayPortal].
///
/// Resolve the style with [KalenderTheme].
///
/// {@category Appearance}
typedef MultiDayOverlayPortalBuilder =
    Widget Function(
      BuildContext context, {
      required DateTime date,
      required List<KalenderEvent> events,
      required int numberOfHiddenRows,
      required double tileHeight,
      required OverlayBuilders? overlayBuilders,
    });

/// The "+N more" button of a day. It opens the day's overlay through [KalenderController.openDayOverlay].
///
/// The calendar builds the overlay. A custom [OverlayBuilders.multiDayOverlayPortalBuilder] replaces this button.
///
/// {@category Appearance}
class MultiDayOverlayPortal extends StatelessWidget {
  /// The date for which the widget is created.
  final FloatingDateTime date;

  /// The number of hidden rows.
  final int numberOfHiddenRows;

  /// The builders for the overlay.
  final OverlayBuilders? overlayBuilders;

  const MultiDayOverlayPortal({
    required this.date,
    required this.numberOfHiddenRows,
    required this.overlayBuilders,
    super.key,
  });

  /// Returns a [Key] for the overlay portal based on the date.
  static Key getKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_overlay_portal_${date.millisecondsSinceEpoch}');
  }

  @override
  Widget build(BuildContext context) {
    final portalController = DayOverlayController(
      openDayOverlay: context.kalenderController.openDayOverlay,
      date: date,
    );
    return overlayBuilders?.multiDayPortalOverlayButtonBuilder?.call(context, portalController, numberOfHiddenRows) ??
        MultiDayPortalOverlayButton(
          key: MultiDayPortalOverlayButton.getKey(date),
          portalController: portalController,
          numberOfHiddenRows: numberOfHiddenRows,
          stringBuilder: overlayBuilders?.multiDayPortalOverlayButtonStringBuilder,
        );
  }
}
