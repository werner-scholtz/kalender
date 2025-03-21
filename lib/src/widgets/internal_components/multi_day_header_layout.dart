import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The widget used for the MultiDayHeader.
///
/// This widget uses the [TimeLine] to determine the size of the [leadingWidget].
/// It uses the [content] and [leadingWidget] to determine the height of the [MultiDayHeaderWidget].
///
/// TODO: implement a widget test for this widget.
class MultiDayHeaderWidget<T extends Object?> extends StatelessWidget {
  /// The content that will be displayed in the [MultiDayHeaderWidget].
  final Widget content;

  /// The leading widget that will be displayed in the [MultiDayHeaderWidget].
  /// TODO: rename to leading.
  final Widget leadingWidget;

  /// Creates a MultiDayHeaderWidget.
  /// This widget is used to display the header of the MultiDayView.
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

    final timeline = bodyComponents?.prototypeTimeLine?.call(heightPerMinute, timeOfDayRange, timelineStyle) ??
        // TODO: implement a default prototypeTimeLine.
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
    // required this.maxHeight,
  }) : super(children: [page, timelineWidget, leadingWidget]);

  /// The widget that will be used to display the timeline.
  /// TODO: rename to prototypeTimeLine.
  final Widget timelineWidget;

  /// The widget that will be used to display the leading widget.
  /// TODO: rename to leading.
  final Widget leadingWidget;

  /// The widget that will be used to display the page.
  /// TODO: rename to content.
  final Widget page;

  /// TODO: this will be used when we start limiting the number of tiles that can be displayed.
  /// The maximum height of the MultiDayHeaderWidget.
  // final double maxHeight;

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

  double get maxHeight => _maxHeight;
  double _maxHeight = 0;
  set maxHeight(double value) {
    if (_maxHeight == value) {
      return;
    }
    _maxHeight = value;
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
    final content = firstChild!;
    final timeline = childAfter(content)!;
    final leading = childAfter(timeline)!;

    // Layout the timeline to get the width.
    timeline.layout(const BoxConstraints(maxHeight: 1000), parentUsesSize: true);
    final timelineWidth = timeline.size.width;

    // Layout the content to get the height.
    content.layout(constraints, parentUsesSize: true);
    final contentHeight = content.size.height;

    // Layout the leading to get the height.
    leading.layout(constraints, parentUsesSize: true);
    final leadingHeight = leading.size.height;

    // The maxHeight is the maximum height of the content and leading.
    final maxHeight = max(contentHeight, leadingHeight);

    // Relay out the content and leading with the maxHeight.
    leading.layout(BoxConstraints(maxHeight: maxHeight, maxWidth: timelineWidth));
    content.layout(BoxConstraints(maxHeight: maxHeight, maxWidth: constraints.maxWidth - timelineWidth));

    // Position the content.
    final contentParentData = (content.parentData! as MultiChildLayoutParentData);
    contentParentData.offset = switch (textDirection!) {
      TextDirection.ltr => Offset(timelineWidth, 0),
      TextDirection.rtl => const Offset(0, 0),
    };

    size = Size(constraints.maxWidth, maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint the content.
    final content = firstChild!;
    final contentParentData = content.parentData! as MultiChildLayoutParentData;
    content.paint(context, contentParentData.offset + offset);

    // Do not paint the timeline.
    final timeline = childAfter(content)!;

    // Paint the timeline.
    final leading = childAfter(timeline)!;
    final leadingParentData = leading.parentData! as MultiChildLayoutParentData;
    leading.paint(context, leadingParentData.offset + offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
