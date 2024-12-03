import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// A Widget that sizes the width of the [child] based on the [TimeLine].
class TimelineSizer<T extends Object?> extends StatelessWidget {
  final Widget child;
  const TimelineSizer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Create the timeline widget.
    final provider = CalendarProvider.of<T>(context);
    final calendarComponents = provider.components;
    final bodyStyles = calendarComponents?.multiDayComponentStyles?.bodyStyles;
    final bodyComponents = calendarComponents?.multiDayComponents?.bodyComponents;
    final timelineStyle = bodyStyles?.timelineStyle;
    const heightPerMinute = 1.0;
    final timeOfDayRange = TimeOfDayRange.allDay();
    final dateTimeRange = DateTimeRange(start: DateTime(2024), end: DateTime(2024, 1, 2));
    final selectedEvent = CalendarEvent<T>(dateTimeRange: dateTimeRange);

    final timeline = bodyComponents?.timeline?.call(heightPerMinute, timeOfDayRange, timelineStyle) ??
        TimeLine(
          timeOfDayRange: timeOfDayRange,
          heightPerMinute: heightPerMinute,
          style: timelineStyle,
          eventBeingDragged: ValueNotifier(selectedEvent),
          visibleDateTimeRange: ValueNotifier(dateTimeRange),
        );

    return _TimelineSizer(
      timelineWidget: LayoutId(id: 1, child: timeline),
      child: LayoutId(id: 2, child: child),
    );
  }
}

class _TimelineSizer extends MultiChildRenderObjectWidget {
  _TimelineSizer({
    required this.timelineWidget,
    required this.child,
  }) : super(children: [timelineWidget, child]);

  final Widget timelineWidget;
  final Widget child;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderTimelineSizer();
  }

  @override
  void updateRenderObject(context, covariant renderObject) {}
}

class _RenderTimelineSizer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void performLayout() {
    final timeline = firstChild!;
    timeline.layout(const BoxConstraints(maxHeight: 1440), parentUsesSize: true);

    final child = childAfter(timeline)!;
    child.layout(constraints, parentUsesSize: true);

    size = Size(timeline.size.width, child.size.height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final timeline = firstChild!;
    final child = childAfter(timeline)!;
    child.paint(context, offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
