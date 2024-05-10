import 'package:flutter/material.dart';
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
  const PageNavigationFunctions({
    required this.dateTimeRangeFromIndex,
    required this.indexFromDate,
    required this.numberOfPages,
  });
  final DateTimeRangeFromIndex dateTimeRangeFromIndex;
  final IndexFromDate indexFromDate;
  final int numberOfPages;

  DateTimeRange dateTimeRangeFromDate(DateTime date) {
    final index = indexFromDate(date);
    return dateTimeRangeFromIndex(index);
  }
}
