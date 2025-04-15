import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout_delegate.dart';
import 'package:kalender/src/models/view_configurations/page_navigation_functions.dart';

class MonthViewConfiguration<T extends Object?> extends ViewConfiguration {
  @override
  final MonthPageFunctions pageNavigationFunctions;

  /// The first day of the week.
  final int firstDayOfWeek;

  /// The layout strategy used by the [MultiDayHeader] to layout events.
  @Deprecated('''
This method is deprecated and will be removed in a future release. 
Please use the `generateFrame` method in the `MonthBodyConfiguration` configuration instead.
''')
  final MultiDayEventLayoutStrategy<T>? eventLayoutStrategy;

  MonthViewConfiguration({
    required super.name,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
    required this.eventLayoutStrategy,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be a valid week day number\n'
          'Use DateTime.monday, DateTime.tuesday, etc. to set the first day of the week',
        );

  MonthViewConfiguration.singleMonth({
    super.name = 'Month',
    DateTimeRange? displayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
    this.eventLayoutStrategy,
  }) : pageNavigationFunctions = MonthPageFunctions(
          originalRange: displayRange ?? DateTime.now().yearRange,
          firstDayOfWeek: firstDayOfWeek,
        );

  MonthViewConfiguration copyWith({
    String? name,
    int? firstDayOfWeek,
    EdgeInsets? eventPadding,
  }) {
    return MonthViewConfiguration.singleMonth(
      name: name ?? this.name,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      eventLayoutStrategy: null,
      displayRange: pageNavigationFunctions.originalRange,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthViewConfiguration &&
        other.pageNavigationFunctions == pageNavigationFunctions &&
        other.firstDayOfWeek == firstDayOfWeek;
  }

  @override
  int get hashCode {
    return Object.hash(pageNavigationFunctions, firstDayOfWeek);
  }
}

class MonthBodyConfiguration<T extends Object?> extends MultiDayHeaderConfiguration<T> {
  MonthBodyConfiguration({
    super.generateMultiDayLayoutFrame,
    super.pageTriggerConfiguration,
    super.scrollTriggerConfiguration,
    super.tileHeight,
  }) : super(showTiles: true, maximumNumberOfVerticalEvents: null);
}
