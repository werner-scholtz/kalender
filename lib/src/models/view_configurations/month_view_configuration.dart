import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';

class MonthViewConfiguration extends ViewConfiguration {
  @override
  final MonthIndexCalculator pageIndexCalculator;

  /// The first day of the week.
  final int firstDayOfWeek;

  /// Whether week numbers should be shown in month view.
  final bool showWeekNumbers;

  MonthViewConfiguration({
    required super.name,
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    required this.firstDayOfWeek,
    required this.showWeekNumbers,
    required this.pageIndexCalculator,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be a valid week day number\n'
          'Use DateTime.monday, DateTime.tuesday, etc. to set the first day of the week',
        );

  MonthViewConfiguration.singleMonth({
    super.name = 'Month',
    super.initialDateTime,
    super.dateTransition,
    super.dateResolver,
    super.nowCallback,
    super.multiDayRule,
    KalenderDateTimeRange? displayRange,
    this.firstDayOfWeek = kDefaultFirstDayOfWeek,
    this.showWeekNumbers = false,
  }) : pageIndexCalculator = MonthIndexCalculator.fromRange(
          displayRange ?? kDefaultRange(),
          firstDayOfWeek,
        );

  MonthViewConfiguration copyWith({
    String? name,
    DateTime? selectedDate,
    DateTransition? dateTransition,
    DateResolver? dateResolver,
    NowCallback? nowCallback,
    int? firstDayOfWeek,
    bool? showWeekNumbers,
    MultiDayRule? multiDayRule,
  }) {
    return MonthViewConfiguration.singleMonth(
      name: name ?? this.name,
      initialDateTime: initialDateTime ?? initialDateTime,
      dateTransition: dateTransition ?? this.dateTransition,
      dateResolver: dateResolver ?? this.dateResolver,
      nowCallback: nowCallback ?? this.nowCallback,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      showWeekNumbers: showWeekNumbers ?? this.showWeekNumbers,
      multiDayRule: multiDayRule ?? this.multiDayRule,
      displayRange: KalenderDateTimeRange(start: pageIndexCalculator.start, end: pageIndexCalculator.end),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthViewConfiguration &&
        other.name == name &&
        other.initialDateTime == initialDateTime &&
        other.dateTransition == dateTransition &&
        other.nowCallback == nowCallback &&
        other.pageIndexCalculator == pageIndexCalculator &&
        other.firstDayOfWeek == firstDayOfWeek &&
        other.showWeekNumbers == showWeekNumbers &&
        other.multiDayRule == multiDayRule;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      initialDateTime,
      dateTransition,
      nowCallback,
      pageIndexCalculator,
      firstDayOfWeek,
      showWeekNumbers,
      multiDayRule,
    );
  }
}

class MonthBodyConfiguration extends HorizontalConfiguration {
  const MonthBodyConfiguration({
    super.multiDayLayoutStrategy,
    super.pageTriggerConfiguration,
    super.tileHeight,
    super.eventPadding,
  }) : super(showTiles: true, maximumNumberOfVerticalEvents: null, allowSingleDayEvents: true);

  @override
  MonthBodyConfiguration copyWith({
    double? tileHeight,
    bool? showTiles,
    MultiDayLayoutStrategy? multiDayLayoutStrategy,
    int? maximumNumberOfVerticalEvents,
    EdgeInsets? eventPadding,
    bool? allowSingleDayEvents,
    PageTriggerConfiguration? pageTriggerConfiguration,
  }) {
    return MonthBodyConfiguration(
      tileHeight: tileHeight ?? this.tileHeight,
      multiDayLayoutStrategy: multiDayLayoutStrategy ?? this.multiDayLayoutStrategy,
      eventPadding: eventPadding ?? this.eventPadding,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
    );
  }
}
