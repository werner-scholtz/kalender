import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The widget used for the MultiDayHeader.
///
/// This widget uses the [TimeLine] to determine the size of the [leadingWidget].
/// It uses the [content] to determine the height of the [MultiDayHeaderWidget].
class MultiDayHeaderWidget<T extends Object?> extends StatelessWidget {
  final Widget content;
  final Widget leadingWidget;
  const MultiDayHeaderWidget({
    super.key,
    required this.content,
    required this.leadingWidget,
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

    return _MultiDayHeaderWidget(
      timelineWidget: LayoutId(id: 1, child: timeline),
      leadingWidget: LayoutId(id: 2, child: leadingWidget),
      page: LayoutId(id: 3, child: content),
    );
  }
}

class _MultiDayHeaderWidget extends MultiChildRenderObjectWidget {
  _MultiDayHeaderWidget({
    required this.timelineWidget,
    required this.leadingWidget,
    required this.page,
  }) : super(children: [page, timelineWidget, leadingWidget]);

  final Widget timelineWidget;
  final Widget leadingWidget;
  final Widget page;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMultiDayHeaderWidget(Directionality.maybeOf(context));
  }

  @override
  void updateRenderObject(context, covariant _RenderMultiDayHeaderWidget renderObject) {
    renderObject.textDirection = Directionality.maybeOf(context);
  }
}

class _RenderMultiDayHeaderWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  _RenderMultiDayHeaderWidget(TextDirection? textDirection) : _textDirection = textDirection;

  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  static Size _layoutTimeline(RenderBox timeline) {
    // layout the timeline the height constraint here is arbitrary as this does not affect the size.
    timeline.layout(const BoxConstraints(maxHeight: 1440), parentUsesSize: true);
    return timeline.size;
  }

  static Size _layoutContent(
    RenderBox content,
    double timelineWidth,
    BoxConstraints constraints,
    TextDirection textDirection,
  ) {
    // layout the page, the width of the page is affected by the timeline width.
    content.layout(
      BoxConstraints(maxWidth: constraints.maxWidth - timelineWidth),
      parentUsesSize: true,
    );

    // Setup the page offset
    final contentParentData = (content.parentData! as MultiChildLayoutParentData);
    contentParentData.offset = switch (textDirection) {
      TextDirection.ltr => Offset(timelineWidth, 0),
      TextDirection.rtl => const Offset(0, 0),
    };

    return content.size;
  }

  void _layoutLeading(
    RenderBox leading,
    double timelineWidth,
    double contentHeight,
    BoxConstraints constraints,
    TextDirection textDirection,
  ) {
    // Layout the weekNumber, this constraints are determined from the timelineWidth and the pageHeight.
    leading.layout(BoxConstraints.tightFor(width: timelineWidth), parentUsesSize: true);

    final leadingParentData = (leading.parentData! as MultiChildLayoutParentData);
    leadingParentData.offset = switch (textDirection) {
      TextDirection.ltr => const Offset(0, 0),
      TextDirection.rtl => Offset(constraints.maxWidth - timelineWidth, 0),
    };
  }

  @override
  void performLayout() {
    final content = firstChild!;
    final timeline = childAfter(content)!;
    final leading = childAfter(timeline)!;

    final timelineSize = _layoutTimeline(timeline);
    final contentSize = _layoutContent(content, timelineSize.width, constraints, textDirection!);
    _layoutLeading(leading, timelineSize.width, contentSize.height, constraints, textDirection!);

    final height = max(contentSize.height, leading.size.height);
    size = Size(constraints.maxWidth, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final content = firstChild!;
    final contentParentData = content.parentData! as MultiChildLayoutParentData;
    content.paint(context, contentParentData.offset + offset);

    final timeline = childAfter(content)!;

    final leading = childAfter(timeline)!;
    final leadingParentData = leading.parentData! as MultiChildLayoutParentData;
    leading.paint(context, leadingParentData.offset + offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
