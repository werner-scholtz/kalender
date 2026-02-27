import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/view_configurations/page_index_calculator.dart';

class MonthViewConfiguration extends ViewConfiguration {
  @override
  final MonthIndexCalculator pageIndexCalculator;

  /// The first day of the week.
  final int firstDayOfWeek;

  MonthViewConfiguration({
    required super.name,
    super.initialDateTime,
    super.initialDateSelectionStrategy,
    required this.firstDayOfWeek,
    required this.pageIndexCalculator,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be a valid week day number\n'
          'Use DateTime.monday, DateTime.tuesday, etc. to set the first day of the week',
        );

  MonthViewConfiguration.singleMonth({
    super.name = 'Month',
    super.initialDateTime,
    super.initialDateSelectionStrategy = kDefaultToMonthly,
    DateTimeRange? displayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
  }) : pageIndexCalculator = MonthIndexCalculator(
          dateTimeRange: displayRange ?? kDefaultRange(),
          firstDayOfWeek: firstDayOfWeek,
        );

  MonthViewConfiguration copyWith({
    String? name,
    DateTime? selectedDate,
    InitialDateSelectionStrategy? initialDateSelectionStrategy,
    int? firstDayOfWeek,
    EdgeInsets? eventPadding,
  }) {
    return MonthViewConfiguration.singleMonth(
      name: name ?? this.name,
      initialDateTime: initialDateTime ?? initialDateTime,
      initialDateSelectionStrategy: initialDateSelectionStrategy ?? this.initialDateSelectionStrategy,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      displayRange: pageIndexCalculator.dateTimeRange,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthViewConfiguration &&
        other.initialDateTime == initialDateTime &&
        other.pageIndexCalculator == pageIndexCalculator &&
        other.firstDayOfWeek == firstDayOfWeek;
  }

  @override
  int get hashCode {
    return Object.hash(initialDateTime, pageIndexCalculator, firstDayOfWeek);
  }
}

class MonthBodyConfiguration extends HorizontalConfiguration {
  const MonthBodyConfiguration({
    super.generateMultiDayLayoutFrame,
    super.pageTriggerConfiguration,
    super.tileHeight,
  }) : super(showTiles: true, maximumNumberOfVerticalEvents: null, allowSingleDayEvents: true);

  @override
  MonthBodyConfiguration copyWith({
    double? tileHeight,
    bool? showTiles,
    GenerateMultiDayLayoutFrame? generateMultiDayLayoutFrame,
    int? maximumNumberOfVerticalEvents,
    EdgeInsets? eventPadding,
    bool? allowSingleDayEvents,
    PageTriggerConfiguration? pageTriggerConfiguration,
  }) {
    return MonthBodyConfiguration(
      tileHeight: tileHeight ?? this.tileHeight,
      generateMultiDayLayoutFrame: generateMultiDayLayoutFrame ?? this.generateMultiDayLayoutFrame,
      pageTriggerConfiguration: pageTriggerConfiguration ?? this.pageTriggerConfiguration,
    );
  }
}
