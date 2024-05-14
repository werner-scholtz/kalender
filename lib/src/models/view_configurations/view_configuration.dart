import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/type_definitions.dart';

/// The base class for all [ViewConfiguration]s.
///
/// [ViewConfiguration]s are used to configure the view of the calendar.
abstract class ViewConfiguration {
  const ViewConfiguration({required this.name});

  /// The name of the [ViewConfiguration].
  final String name;
}

/// Navigation functions used by [PageView]s.
class PageNavigationFunctions {
  PageNavigationFunctions({
    required this.dateTimeRangeFromIndex,
    required this.indexFromDate,
    required this.numberOfPages,
  });

  /// Creates a [PageNavigationFunctions] for a single day.
  PageNavigationFunctions.singleDay(
    DateTimeRange dateTimeRange,
  ) {
    final start = dateTimeRange.start;

    dateTimeRangeFromIndex = (index) => start.addDays(index).dayRange;

    indexFromDate = (date) {
      final dateUtc = date.startOfDay.toUtc();
      final startDateUtc = start.startOfDay.toUtc();
      return dateUtc.difference(startDateUtc).inDays;
    };
    numberOfPages = dateTimeRange.dayDifference;
  }

  /// Creates a [PageNavigationFunctions] for a week.
  PageNavigationFunctions.week(
    DateTimeRange dateTimeRange,
    int firstDayOfWeek,
  ) {
    final start = dateTimeRange.start;

    dateTimeRangeFromIndex = (index) {
      return DateTime(
        start.year,
        start.month,
        start.day + (index * DateTime.daysPerWeek),
      ).weekRangeWithOffset(firstDayOfWeek);
    };

    indexFromDate = (date) {
      final dateUtc = date.startOfDay.toUtc();
      final startDateUtc = start.startOfDay.toUtc();
      final index =
          dateUtc.difference(startDateUtc).inDays / DateTime.daysPerWeek;
      return index.floor();
    };

    numberOfPages = (dateTimeRange.dayDifference / DateTime.daysPerWeek).ceil();
  }

  /// Creates a [PageNavigationFunctions] for a work week.
  PageNavigationFunctions.workWeek(
    DateTimeRange dateTimeRange,
  ) {
    final start = dateTimeRange.start;

    dateTimeRangeFromIndex = (index) {
      final weekRange = DateTime(
        start.year,
        start.month,
        start.day + (index * DateTime.daysPerWeek),
      ).weekRangeWithOffset(1);

      return DateTimeRange(
        start: weekRange.start,
        end: weekRange.end.subtractDays(2),
      );
    };

    indexFromDate = (date) {
      final dateUtc = date.startOfDay.toUtc();
      final startDateUtc = start.startOfDay.toUtc();
      final index =
          dateUtc.difference(startDateUtc).inDays / DateTime.daysPerWeek;
      return index.floor();
    };

    numberOfPages = (dateTimeRange.dayDifference / DateTime.daysPerWeek).ceil();
  }

  /// Creates a [PageNavigationFunctions] for a custom number of days.
  PageNavigationFunctions.custom(
    DateTimeRange dateTimeRange,
    int numberOfDays,
  ) {
    final start = dateTimeRange.start;

    dateTimeRangeFromIndex = (index) {
      final startDateUtc = start.startOfDay;
      return DateTime(
        startDateUtc.year,
        startDateUtc.month,
        startDateUtc.day + (index * numberOfDays),
      ).multiDayDateTimeRange(numberOfDays);
    };

    indexFromDate = (date) {
      final dateUtc = date.startOfDay.toUtc();
      final startDateUtc = dateTimeRange.start.startOfDay.toUtc();
      return dateUtc.difference(startDateUtc).inDays ~/ numberOfDays;
    };

    numberOfPages = dateTimeRange.dayDifference ~/ numberOfDays;
  }

  late final DateTimeRangeFromIndex dateTimeRangeFromIndex;
  late final IndexFromDate indexFromDate;
  late final int numberOfPages;

  DateTimeRange dateTimeRangeFromDate(DateTime date) {
    final index = indexFromDate(date);
    return dateTimeRangeFromIndex(index);
  }
}
