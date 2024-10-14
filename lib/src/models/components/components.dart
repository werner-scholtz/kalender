import 'package:kalender/kalender.dart';

class CalendarComponents {
  /// Components used by the month view.
  final MonthComponents? monthComponents;

  /// Styles used by the month view.
  final MonthComponentStyles? monthComponentStyles;

  /// Components used by the multi day view.
  final MultiDayComponents? multiDayComponents;

  /// Styles used by the multi day view.
  final MultiDayComponentStyles? multiDayComponentStyles;

  CalendarComponents({
    this.monthComponents,
    this.monthComponentStyles,
    this.multiDayComponents,
    this.multiDayComponentStyles,
  });
}
