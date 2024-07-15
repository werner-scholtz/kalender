import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/type_definitions.dart';

abstract class PageNavigationFunctions {
  PageNavigationFunctions();

  factory PageNavigationFunctions.singleDay(DateTimeRange dateTimeRange) {
    return DayPageFunctions(
      dateTimeRange: dateTimeRange,
    );
  }

  factory PageNavigationFunctions.week(DateTimeRange dateTimeRange, int firstDayOfWeek) {
    return WeekPageFunctions(
      dateTimeRange: dateTimeRange,
      firstDayOfWeek: firstDayOfWeek,
    );
  }

  factory PageNavigationFunctions.workWeek(
    DateTimeRange dateTimeRange,
  ) {
    return WorkWeekPageFunctions(dateTimeRange: dateTimeRange);
  }

  factory PageNavigationFunctions.custom(DateTimeRange dateTimeRange, int numberOfDays) {
    return CustomPageFunctions(
      dateTimeRange: dateTimeRange,
      numberOfDays: numberOfDays,
    );
  }

  factory PageNavigationFunctions.month(
    DateTimeRange dateTimeRange,
    int firstDayOfWeek,
  ) {
    return MonthPageFunctions(
      dateTimeRange: dateTimeRange,
      firstDayOfWeek: firstDayOfWeek,
    );
  }

  DateTimeRangeFromIndex get dateTimeRangeFromIndex;
  IndexFromDate get indexFromDate;
  int get numberOfPages;

  /// Returns the [DateTimeRange] that is displayed for the given [date].
  DateTimeRange dateTimeRangeFromDate(DateTime date) {
    final index = indexFromDate(date);
    return dateTimeRangeFromIndex(index);
  }
}

class DayPageFunctions extends PageNavigationFunctions {
  DayPageFunctions({
    required DateTimeRange dateTimeRange,
  }) {
    final start = dateTimeRange.start;
    dateTimeRangeFromIndex = (index) => start.addDays(index).dayRange;
    indexFromDate = (date) {
      final dateUtc = date.startOfDay.toUtc();
      final startDateUtc = start.startOfDay.toUtc();
      return dateUtc.difference(startDateUtc).inDays;
    };
    numberOfPages = dateTimeRange.dayDifference;
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class WeekPageFunctions extends PageNavigationFunctions {
  WeekPageFunctions({
    required DateTimeRange dateTimeRange,
    required int firstDayOfWeek,
  }) {
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
      final value = dateUtc.difference(startDateUtc).inDays / DateTime.daysPerWeek;

      return value.floor();
    };
    numberOfPages = (dateTimeRange.dayDifference / DateTime.daysPerWeek).ceil();
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class WorkWeekPageFunctions extends PageNavigationFunctions {
  WorkWeekPageFunctions({
    required DateTimeRange dateTimeRange,
  }) {
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
      final index = dateUtc.difference(startDateUtc).inDays / DateTime.daysPerWeek;
      return index.floor();
    };
    numberOfPages = (dateTimeRange.dayDifference / DateTime.daysPerWeek).ceil();
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class CustomPageFunctions extends PageNavigationFunctions {
  CustomPageFunctions({
    required DateTimeRange dateTimeRange,
    required int numberOfDays,
  }) {
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

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}

class MonthPageFunctions extends PageNavigationFunctions {
  MonthPageFunctions({
    required DateTimeRange dateTimeRange,
    required int firstDayOfWeek,
  }) {
    final start = dateTimeRange.start;
    dateTimeRangeFromIndex = (index) {
      final range = DateTime(start.year, start.month + index, 1).monthRange;
      var rangeStart = range.start.startOfWeekWithOffset(firstDayOfWeek);
      if (rangeStart.isAfter(range.start)) {
        rangeStart = rangeStart.subtractDays(7);
      }
      final rangeEnd = rangeStart.addDays(7 * 5);
      return DateTimeRange(start: rangeStart, end: rangeEnd);
    };
    indexFromDate = (date) {
      final dateTimeRange = DateTimeRange(start: start, end: date);
      return dateTimeRange.monthDifference;
    };
    numberOfPages = dateTimeRange.monthDifference;
  }

  @override
  late DateTimeRangeFromIndex dateTimeRangeFromIndex;

  @override
  late IndexFromDate indexFromDate;

  @override
  late int numberOfPages;
}


// /// Functions used by a [PageView] to navigate to different pages.
// class PageNavigationFunctions {
//   PageNavigationFunctions({
//     required this.dateTimeRangeFromIndex,
//     required this.indexFromDate,
//     required this.numberOfPages,
//   });

//   /// Creates a [PageNavigationFunctions] for a single day.
//   PageNavigationFunctions.singleDay(
//     DateTimeRange dateTimeRange,
//   ) {
//     final start = dateTimeRange.start;
//     dateTimeRangeFromIndex = (index) => start.addDays(index).dayRange;
//     indexFromDate = (date) {
//       final dateUtc = date.startOfDay.toUtc();
//       final startDateUtc = start.startOfDay.toUtc();
//       return dateUtc.difference(startDateUtc).inDays;
//     };
//     numberOfPages = dateTimeRange.dayDifference;
//   }

//   /// Creates a [PageNavigationFunctions] for a week.
//   PageNavigationFunctions.week(
//     DateTimeRange dateTimeRange,
//     int firstDayOfWeek,
//   ) {
//     final start = dateTimeRange.start;
//     dateTimeRangeFromIndex = (index) {
//       return DateTime(
//         start.year,
//         start.month,
//         start.day + (index * DateTime.daysPerWeek),
//       ).weekRangeWithOffset(firstDayOfWeek);
//     };
//     indexFromDate = (date) {
//       final dateUtc = date.startOfDay.toUtc();
//       final startDateUtc = start.startOfDay.toUtc();
//       final index =
//           dateUtc.difference(startDateUtc).inDays / DateTime.daysPerWeek;
//       return index.floor();
//     };
//     numberOfPages = (dateTimeRange.dayDifference / DateTime.daysPerWeek).ceil();
//   }

//   /// Creates a [PageNavigationFunctions] for a work week.
//   PageNavigationFunctions.workWeek(
//     DateTimeRange dateTimeRange,
//   ) {
//     final start = dateTimeRange.start;
//     dateTimeRangeFromIndex = (index) {
//       final weekRange = DateTime(
//         start.year,
//         start.month,
//         start.day + (index * DateTime.daysPerWeek),
//       ).weekRangeWithOffset(1);

//       return DateTimeRange(
//         start: weekRange.start,
//         end: weekRange.end.subtractDays(2),
//       );
//     };
//     indexFromDate = (date) {
//       final dateUtc = date.startOfDay.toUtc();
//       final startDateUtc = start.startOfDay.toUtc();
//       final index =
//           dateUtc.difference(startDateUtc).inDays / DateTime.daysPerWeek;
//       return index.floor();
//     };
//     numberOfPages = (dateTimeRange.dayDifference / DateTime.daysPerWeek).ceil();
//   }

//   /// Creates a [PageNavigationFunctions] for a custom number of days.
//   PageNavigationFunctions.custom(
//     DateTimeRange dateTimeRange,
//     int numberOfDays,
//   ) {
//     final start = dateTimeRange.start;
//     dateTimeRangeFromIndex = (index) {
//       final startDateUtc = start.startOfDay;
//       return DateTime(
//         startDateUtc.year,
//         startDateUtc.month,
//         startDateUtc.day + (index * numberOfDays),
//       ).multiDayDateTimeRange(numberOfDays);
//     };
//     indexFromDate = (date) {
//       final dateUtc = date.startOfDay.toUtc();
//       final startDateUtc = dateTimeRange.start.startOfDay.toUtc();
//       return dateUtc.difference(startDateUtc).inDays ~/ numberOfDays;
//     };
//     numberOfPages = dateTimeRange.dayDifference ~/ numberOfDays;
//   }

//   PageNavigationFunctions.month(
//     DateTimeRange dateTimeRange,
//     int firstDayOfWeek,
//   ) {
//     final start = dateTimeRange.start;
//     dateTimeRangeFromIndex = (index) {
//       final range = DateTime(start.year, start.month + index, 1).monthRange;
//       var rangeStart = range.start.startOfWeekWithOffset(firstDayOfWeek);
//       if (rangeStart.isAfter(range.start)) {
//         rangeStart = rangeStart.subtractDays(7);
//       }
//       final rangeEnd = rangeStart.addDays(7 * 5);
//       return DateTimeRange(start: rangeStart, end: rangeEnd);
//     };
//     indexFromDate = (date) {
//       final dateTimeRange = DateTimeRange(start: start, end: date);
//       return dateTimeRange.monthDifference;
//     };
//     numberOfPages = dateTimeRange.monthDifference;
//   }

//   late final DateTimeRangeFromIndex dateTimeRangeFromIndex;
//   late final IndexFromDate indexFromDate;
//   late final int numberOfPages;

//   /// Returns the [DateTimeRange] that is displayed for the given [date].
//   DateTimeRange dateTimeRangeFromDate(DateTime date) {
//     final index = indexFromDate(date);
//     return dateTimeRangeFromIndex(index);
//   }
// }

