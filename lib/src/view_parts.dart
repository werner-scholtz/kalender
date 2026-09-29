// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// The header and body [KalenderView] shows for a kind of [ViewConfiguration].
///
/// The parts accept a configuration of type [C], and with a [name] only a configuration with that
/// [ViewConfiguration.name]. [KalenderView] picks the first named parts that accept the controller's configuration,
/// else the first unnamed ones. The order of [KalenderView.views] decides between parts that both accept it, so put
/// more specific parts before general ones or give them a [name].
///
/// {@category Views}
abstract class ViewParts<C extends ViewConfiguration> {
  const ViewParts({this.name, this.header, this.body});

  /// The [ViewConfiguration.name] these parts show, or null for any configuration of type [C].
  final String? name;

  /// The widget above the body. Null shows [builtInHeader], and [SizedBox.shrink] shows nothing.
  final Widget? header;

  /// The widget below the header. Null shows [builtInBody].
  final Widget? body;

  /// The header shown when [header] is null. Null shows none.
  Widget? get builtInHeader => null;

  /// The body shown when [body] is null. Null shows none.
  Widget? get builtInBody => null;

  /// Whether these parts show [configuration].
  bool accepts(ViewConfiguration configuration) => configuration is C && (name == null || name == configuration.name);

  /// The widths of the week number column and the timeline that the header and body share. Null for a column the
  /// view does not draw.
  ({double? weekNumber, double? timeline}) gutterWidths(BuildContext context) => (weekNumber: null, timeline: null);
}

/// The parts of a [MultiDayViewConfiguration]: a [MultiDayHeader] and a [MultiDayBody] by default.
///
/// {@category Views}
class MultiDayViewParts extends ViewParts<MultiDayViewConfiguration> {
  const MultiDayViewParts({super.name, super.header, super.body});

  @override
  Widget? get builtInHeader => const MultiDayHeader();

  @override
  Widget? get builtInBody => const MultiDayBody();

  @override
  ({double? weekNumber, double? timeline}) gutterWidths(BuildContext context) {
    final configuration = context.viewController.viewConfiguration as MultiDayViewConfiguration;
    final bodyComponents = context.components.multiDayComponents.bodyComponents;
    return (weekNumber: null, timeline: bodyComponents.buildTimelineWidth(context, configuration.timeOfDayRange));
  }
}

/// The parts of a [MonthViewConfiguration]: a [MonthHeader] and a [MonthBody] by default.
///
/// {@category Views}
class MonthViewParts extends ViewParts<MonthViewConfiguration> {
  const MonthViewParts({super.name, super.header, super.body});

  @override
  Widget? get builtInHeader => const MonthHeader();

  @override
  Widget? get builtInBody => const MonthBody();

  @override
  ({double? weekNumber, double? timeline}) gutterWidths(BuildContext context) {
    final configuration = context.viewController.viewConfiguration as MonthViewConfiguration;
    if (!configuration.showWeekNumbers) return (weekNumber: null, timeline: null);
    return (
      weekNumber: context.components.monthComponents.bodyComponents.buildWeekNumberWidth(context),
      timeline: null,
    );
  }
}

/// The parts of a [ScheduleViewConfiguration]: a [ScheduleBody] and no header by default.
///
/// {@category Views}
class ScheduleViewParts extends ViewParts<ScheduleViewConfiguration> {
  const ScheduleViewParts({super.name, super.header, super.body});

  @override
  Widget? get builtInBody => const ScheduleBody();
}
