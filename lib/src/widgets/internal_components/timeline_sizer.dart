import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/providers/gutter_widths.dart';

/// A widget that sizes the width of [child] to the timeline gutter width.
///
/// It reads the width the calendar measured, so the drag overlay stays aligned
/// with the day columns.
class TimelineSizer extends StatelessWidget {
  final Widget child;
  const TimelineSizer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bodyComponents = context.components.multiDayComponents.bodyComponents;
    final width =
        GutterWidths.maybeOf(context)?.timeline ?? bodyComponents.buildTimelineWidth(context, TimeOfDayRange.allDay());

    return SizedBox(width: width, child: child);
  }
}
