import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The styles that decide how wide the calendar's gutters are.
///
/// The month week number column and the multi-day timeline are each measured
/// twice: once where they are drawn in the body, and once as an invisible spacer
/// in the header that reserves the same width so the day columns of the two line
/// up. [CalendarView] resolves these once above both, so a [KalenderTheme]
/// placed inside the header or the body cannot move one without the other.
///
/// A scoped theme that sets one of these is reported by
/// [debugCheckGutterStyleReaches] rather than silently ignored.
class GutterStyles extends InheritedWidget {
  /// The week number style the month gutter and its header spacer measure with.
  final WeekNumberStyle? weekNumberStyle;

  /// The timeline style the multi-day body and its header measure with.
  final TimelineStyle? timelineStyle;

  /// Creates a [GutterStyles] with the given resolved styles.
  const GutterStyles({
    super.key,
    required this.weekNumberStyle,
    required this.timelineStyle,
    required super.child,
  });

  /// Gets the [GutterStyles] from the context.
  static GutterStyles of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No GutterStyles found.');
    return result!;
  }

  /// The timeline style the multi-day gutter is measured from.
  ///
  /// Falls back to [KalenderTheme] where there is no [GutterStyles], which is
  /// the case outside a [CalendarView].
  static TimelineStyle timelineStyleOf(BuildContext context) {
    return maybeOf(context)?.timelineStyle ?? KalenderTheme.of(context).timelineStyle ?? const TimelineStyle();
  }

  /// The [GutterStyles] above [context], or null when there is none.
  ///
  /// Null where a component widget is built outside a [CalendarView], which the
  /// tests and the doc snippets do.
  static GutterStyles? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GutterStyles>();
  }

  @override
  bool updateShouldNotify(covariant GutterStyles oldWidget) {
    return weekNumberStyle != oldWidget.weekNumberStyle || timelineStyle != oldWidget.timelineStyle;
  }
}

/// The mismatches already reported, so each is named once rather than on every
/// frame that rebuilds the gutter.
final Set<String> _reported = <String>{};

/// Resets the record of reported mismatches. For tests.
@visibleForTesting
void debugResetGutterStyleWarnings() => _reported.clear();

/// Reports a [field] that a [KalenderTheme] below the calendar sets and the
/// shared gutter measurement ignores.
///
/// Always returns true, so it can be called from an `assert`. Pass both values
/// from outside the assert: reading an inherited widget inside one would make
/// the widget depend on it in debug builds and not in release builds.
bool debugCheckGutterStyleReaches({
  required String field,
  required Object? shared,
  required Object? scoped,
}) {
  if (shared == scoped) return true;
  if (!_reported.add(field)) return true;

  debugPrint(
    'kalender: a KalenderTheme below the CalendarView sets $field, which is ignored.\n'
    'The gutter it sizes is drawn in the body and reserved again in the header, so '
    'the calendar measures it once above both. A theme scoped to only one of them '
    'would move the two apart.\n'
    'Set $field on a KalenderTheme above the CalendarView, or on the '
    'KalenderThemeData registered on ThemeData.extensions.',
  );
  return true;
}
