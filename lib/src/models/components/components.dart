import 'package:kalender/kalender.dart';

/// A styling class used by the [CalendarView].
///
/// Change the style the default widgets with [multiDayComponentStyles] and [monthComponentStyles].
/// Provide your own widgets with [multiDayComponents] and [monthComponents].
class CalendarComponents {
  /// Components used to override the default month components
  final MonthComponents? monthComponents;

  /// Styles used by the month view.
  final MonthComponentStyles? monthComponentStyles;

  /// Components used to override the default multi day components.
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
