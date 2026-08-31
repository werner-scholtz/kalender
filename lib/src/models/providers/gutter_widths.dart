import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The measured widths of the calendar's gutters.
///
/// The month week number column and the multi-day timeline are each drawn in the
/// body and reserved again as a spacer in the header, so their day columns line
/// up only while the two agree. [CalendarView] measures each once and publishes
/// the number here, which is what both halves read.
///
/// Only the width is shared. Everything that paints a gutter resolves its style
/// from the nearest [KalenderTheme], the way every other style is resolved.
class GutterWidths extends InheritedWidget {
  /// The width of the month week number column.
  final double weekNumber;

  /// The width of the multi-day timeline column.
  final double timeline;

  /// Creates a [GutterWidths] with the given measurements.
  const GutterWidths({
    super.key,
    required this.weekNumber,
    required this.timeline,
    required super.child,
  });

  /// The [GutterWidths] above [context], or null when there is none.
  ///
  /// Null where a component widget is built outside a [CalendarView], which the
  /// tests and the doc snippets do.
  static GutterWidths? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GutterWidths>();
  }

  @override
  bool updateShouldNotify(covariant GutterWidths oldWidget) {
    return weekNumber != oldWidget.weekNumber || timeline != oldWidget.timeline;
  }
}
