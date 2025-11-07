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
    super.selectedDate,
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
    super.selectedDate,
    super.initialDateSelectionStrategy = kDefaultToMonthly,
    DateTimeRange? displayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
  }) : pageIndexCalculator = MonthIndexCalculator(
          dateTimeRange: displayRange ?? DateTime.now().yearRange,
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
      selectedDate: selectedDate ?? this.selectedDate,
      initialDateSelectionStrategy: initialDateSelectionStrategy ?? this.initialDateSelectionStrategy,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      displayRange: pageIndexCalculator.dateTimeRange,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthViewConfiguration &&
        other.selectedDate == selectedDate &&
        other.pageIndexCalculator == pageIndexCalculator &&
        other.firstDayOfWeek == firstDayOfWeek;
  }

  @override
  int get hashCode {
    return Object.hash(selectedDate, pageIndexCalculator, firstDayOfWeek);
  }
}

class MonthBodyConfiguration<T extends Object?> extends HorizontalConfiguration<T> {
  MonthBodyConfiguration({
    super.generateMultiDayLayoutFrame,
    super.pageTriggerConfiguration,
    super.tileHeight,
  }) : super(showTiles: true, maximumNumberOfVerticalEvents: null, allowSingleDayEvents: true);
}
