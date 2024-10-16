import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class MultiDayHeaderWidget<T extends Object?> extends StatelessWidget {
  final Widget page;
  final Widget leadingWidget;
  const MultiDayHeaderWidget({
    super.key,
    required this.page,
    required this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final provider = CalendarProvider.of<T>(context);
    final calendarComponents = provider.components;
    final bodyStyles = calendarComponents?.multiDayComponentStyles?.bodyStyles;
    final bodyComponents = calendarComponents?.multiDayComponents?.components;
    final timelineStyle = bodyStyles?.timelineStyle;
    const heightPerMinute = 1.0;
    final timeOfDayRange = TimeOfDayRange.allDay();
    final dateTimeRange = DateTimeRange(start: DateTime(2024), end: DateTime(2024, 1, 2));
    final selectedEvent = CalendarEvent<T>(dateTimeRange: dateTimeRange);

    final timeline = bodyComponents?.timeline?.call(0.7, timeOfDayRange, timelineStyle) ??
        TimeLine(
          timeOfDayRange: timeOfDayRange,
          heightPerMinute: heightPerMinute,
          style: timelineStyle,
          eventBeingDragged: ValueNotifier(selectedEvent),
          visibleDateTimeRange: ValueNotifier(dateTimeRange),
        );

    return _MultiDayHeaderWidget(
      timelineWidget: LayoutId(id: 1, child: timeline),
      weekNumberWidget: LayoutId(id: 2, child: leadingWidget),
      page: LayoutId(id: 3, child: page),
    );
  }
}

/// This is just messed up truly xD
class _MultiDayHeaderWidget extends MultiChildRenderObjectWidget {
  _MultiDayHeaderWidget({
    required this.timelineWidget,
    required this.weekNumberWidget,
    required this.page,
  }) : super(children: [page, timelineWidget, weekNumberWidget]);

  final Widget timelineWidget;
  final Widget weekNumberWidget;
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

  // TODO: Directionality should be taken into consideration.
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

  @override
  void performLayout() {
    final page = firstChild!;
    final pageParentData = (page.parentData! as MultiChildLayoutParentData);
    final timeline = childAfter(page)!;
    final weekNumber = childAfter(timeline)!;
    final weekNumberParentData = (page.parentData! as MultiChildLayoutParentData);

    // layout the timeline the constraint height here is arbitrary as this does not affect the size.
    timeline.layout(const BoxConstraints(maxHeight: 50), parentUsesSize: true);
    final timelineWidth = timeline.size.width;

    // layout the page, the width of the page is affected by the timeline width.
    pageParentData.offset = Offset(timelineWidth, 0);
    page.layout(
      BoxConstraints(maxWidth: constraints.maxWidth - timelineWidth),
      parentUsesSize: true,
    );
    final pageHeight = page.size.height;

    // Layout the weekNumber, this size is determined from the timelineWidth and the pageHeight.
    weekNumberParentData.offset = Offset.zero;
    weekNumber.layout(BoxConstraints.tightFor(width: timelineWidth, height: pageHeight));

    size = Size(constraints.maxWidth, pageHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final page = firstChild!;
    final pageParentData = (page.parentData! as MultiChildLayoutParentData);
    page.paint(context, offset + pageParentData.offset);

    final timeline = childAfter(page)!;
    final weekNumber = childAfter(timeline)!;
    weekNumber.paint(context, offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
