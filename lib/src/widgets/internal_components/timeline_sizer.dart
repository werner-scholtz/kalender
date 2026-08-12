import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/providers/gutter_styles.dart';

/// A widget that sizes the width of [child] to the timeline gutter width.
///
/// It measures with [MultiDayBodyComponents.timelineWidth] from the [GutterStyles]
/// the body and the header measure with, so the drag overlay stays aligned with
/// the day columns.
class TimelineSizer extends StatelessWidget {
  final Widget child;
  const TimelineSizer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final calendarComponents = context.components;
    final bodyComponents = calendarComponents.multiDayComponents.bodyComponents;
    final timelineStyle = GutterStyles.of(context).timelineStyle ?? const TimelineStyle();
    final width = bodyComponents.timelineWidth(context, TimeOfDayRange.allDay(), timelineStyle);

    return SizedBox(width: width, child: child);
  }
}
