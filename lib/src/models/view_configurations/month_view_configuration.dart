import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout_delegate.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';

class MonthViewConfiguration extends ViewConfiguration {
  @override
  final MonthPageFunctions pageNavigationFunctions;

  /// The first day of the week.
  final int firstDayOfWeek;

  /// The padding used around events.
  final EdgeInsets eventPadding;

  /// The layout strategy used by the [MultiDayHeader] to layout events.
  @Deprecated('''
This method is deprecated and will be removed in a future release. 
Please use the `generateFrame` method in the `MonthBodyConfiguration` configuration instead.
''')
  final MultiDayEventLayoutStrategy? eventLayoutStrategy;

  MonthViewConfiguration({
    required super.name,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
    required this.eventLayoutStrategy,
    this.eventPadding = kDefaultMultiDayEventPadding,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be between 1 and 7 (inclusive)\n'
          'Use DateTime.monday ~ DateTime.sunday if unsure.',
        );

  MonthViewConfiguration.singleMonth({
    super.name = 'Month',
    DateTimeRange? displayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
    this.eventLayoutStrategy,
    this.eventPadding = kDefaultMultiDayEventPadding,
  }) : pageNavigationFunctions = MonthPageFunctions(
          dateTimeRange: displayRange ?? DateTime.now().yearRange,
          shift: firstDayOfWeek,
        );

  MonthViewConfiguration copyWith({
    String? name,
    MonthPageFunctions? pageNavigationFunctions,
    int? firstDayOfWeek,
    EdgeInsets? eventPadding,
  }) {
    return MonthViewConfiguration(
      name: name ?? this.name,
      pageNavigationFunctions: pageNavigationFunctions ?? this.pageNavigationFunctions,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      eventPadding: eventPadding ?? this.eventPadding,
      eventLayoutStrategy: null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthViewConfiguration &&
        other.pageNavigationFunctions == pageNavigationFunctions &&
        other.firstDayOfWeek == firstDayOfWeek &&
        other.eventPadding == eventPadding;
  }

  @override
  int get hashCode {
    return Object.hash(pageNavigationFunctions, firstDayOfWeek, eventPadding);
  }
}

class MonthBodyConfiguration extends MultiDayHeaderConfiguration {
  MonthBodyConfiguration({
    super.generateMultiDayLayoutFrame,
    super.pageTriggerConfiguration,
    super.scrollTriggerConfiguration,
    super.showTiles,
    super.tileHeight,
  });
}
