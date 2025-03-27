import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout_delegate.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_event_layout_widget.dart';

class MonthViewConfiguration extends ViewConfiguration {
  @override
  final MonthPageFunctions pageNavigationFunctions;

  /// The layout strategy used by the [MultiDayHeader] to layout events.
  /// TODO: More detail in the depricated message.
  @Deprecated('This has been deprecated use generateFrame instead')
  final MultiDayEventLayoutStrategy eventLayoutStrategy;

  /// The generate frame function used by the [MultiDayEventLayoutWidget].
  /// TODO: docs
  final MultiDayGenerateLayoutFrame? generateFrame;

  /// The first day of the week.
  final int firstDayOfWeek;

  MonthViewConfiguration({
    required super.name,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
    required this.eventLayoutStrategy,
    this.generateFrame,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be between 1 and 7 (inclusive)\n'
          'Use DateTime.monday ~ DateTime.sunday if unsure.',
        );

  MonthViewConfiguration.singleMonth({
    super.name = 'Month',
    DateTimeRange? displayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
    this.eventLayoutStrategy = defaultMultiDayEventLayoutStrategy,
    this.generateFrame,
  }) : pageNavigationFunctions = MonthPageFunctions(
          dateTimeRange: displayRange ?? DateTime.now().yearRange,
          shift: firstDayOfWeek,
        );
}

class MonthBodyConfiguration extends MultiDayHeaderConfiguration {
  MonthBodyConfiguration({
    super.generateFrame,
    super.pageTriggerConfiguration,
    super.scrollTriggerConfiguration,
    super.showTiles,
    super.tileHeight,
  });
}
