import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// A widget that sizes the width of [child] to the timeline gutter width.
///
/// It resolves the width via [MultiDayBodyComponents.timelineWidth] — the same
/// source the body and header use — so the drag overlay stays aligned with them.
class TimelineSizer extends StatelessWidget {
  final Widget child;
  const TimelineSizer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final calendarComponents = context.components;
    final bodyStyles = calendarComponents.multiDayComponentStyles.bodyStyles;
    final bodyComponents = calendarComponents.multiDayComponents.bodyComponents;
    final width = bodyComponents.timelineWidth(context, TimeOfDayRange.allDay(), bodyStyles.timelineStyle);

    return SizedBox(width: width, child: child);
  }
}
