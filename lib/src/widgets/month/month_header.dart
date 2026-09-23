// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/internal_components/month_week_number_gutter.dart';

/// The month header is a simple widget that just displays the day names.
///
/// {@category Views}
class MonthHeader extends StatelessWidget {
  /// See [KalenderView.callbacks].
  final KalenderCallbacks? callbacks;

  const MonthHeader({super.key, this.callbacks});

  @override
  Widget build(BuildContext context) {
    final callbacks = this.callbacks;
    if (callbacks == null) return const _MonthHeader();
    return Callbacks(callbacks: callbacks, child: const _MonthHeader());
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader();

  @override
  Widget build(BuildContext context) {
    assert(
      context.viewController is MonthViewController,
      'The KalenderController\'s $ViewController needs to be a $MonthViewController',
    );

    final viewController = context.viewController as MonthViewController;
    final viewConfiguration = viewController.viewConfiguration;
    final calendarComponents = context.components;
    final components = calendarComponents.monthComponents.headerComponents;

    return ValueListenableBuilder(
      valueListenable: viewController.floatingVisibleRange,
      builder: (context, visibleRange, child) {
        if (visibleRange == null) return const SizedBox.shrink();
        final visibleDateTimeRange = visibleRange.forLocation(location: context.location);
        final showWeekNumbers = viewConfiguration.showWeekNumbers;

        return Row(
          children: [
            if (showWeekNumbers) const MonthWeekNumberSpacer(),
            Expanded(
              child: Row(
                children: List<Widget>.generate(7, (index) {
                  final date = visibleDateTimeRange.start.add(Duration(days: index));
                  return Expanded(child: components.buildWeekDayHeader(context, date));
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
