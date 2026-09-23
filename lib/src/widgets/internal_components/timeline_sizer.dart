// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/gutter_widths.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// The timeline gutter width the calendar measured, or, outside a [KalenderView], the width for the attached view's
/// time of day range.
double timelineWidthOf(BuildContext context) {
  final measured = GutterWidths.maybeOf(context)?.timeline;
  if (measured != null) return measured;
  final configuration = context.kalenderController.viewController.viewConfiguration;
  final timeOfDayRange = configuration is MultiDayViewConfiguration
      ? configuration.timeOfDayRange
      : KalenderTimeRange.allDay();
  return context.components.multiDayComponents.bodyComponents.buildTimelineWidth(context, timeOfDayRange);
}

/// Sizes the width of [child] to [timelineWidthOf].
class TimelineSizer extends StatelessWidget {
  final Widget child;
  const TimelineSizer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SizedBox(width: timelineWidthOf(context), child: child);
}
