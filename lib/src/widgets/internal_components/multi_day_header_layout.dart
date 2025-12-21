import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The widget used for the MultiDayHeader.
///
/// This widget uses the [TimeLine] to determine the size of the [leading].
/// It uses the [content] and [leading] to determine the height of the [MultiDayHeaderWidget].
///
/// TODO: implement a widget test for this widget.
class MultiDayHeaderWidget extends StatelessWidget {
  /// The content that will be displayed in the [MultiDayHeaderWidget].
  final Widget content;

  /// The leading widget that will be displayed in the [MultiDayHeaderWidget].
  final Widget leading;

  /// The prototype timeline widget that will be used to display the timeline.
  final Widget? prototypeTimelineOverride;

  /// Creates a MultiDayHeaderWidget.
  /// This widget is used to display the header of the MultiDayView.
  const MultiDayHeaderWidget({
    super.key,
    required this.content,
    required this.leading,
    this.prototypeTimelineOverride,
  });

  @override
  Widget build(BuildContext context) {
    var timeline = prototypeTimelineOverride;
    if (timeline == null) {
      // Create the timeline widget.
      final calendarComponents = context.components();
      final bodyStyles = calendarComponents.multiDayComponentStyles.bodyStyles;
      final bodyComponents = calendarComponents.multiDayComponents.bodyComponents;
      final timelineStyle = bodyStyles.timelineStyle;
      const heightPerMinute = 1.0;
      final timeOfDayRange = TimeOfDayRange.allDay();
      timeline = bodyComponents.prototypeTimeLine.call(heightPerMinute, timeOfDayRange, timelineStyle);
    }

    return _MultiDayHeaderWidget(
      prototypeTimeLine: LayoutId(id: 1, child: timeline),
      leading: LayoutId(id: 2, child: leading),
      content: LayoutId(id: 3, child: content),
    );
  }
}

class _MultiDayHeaderWidget extends MultiChildRenderObjectWidget {
  _MultiDayHeaderWidget({
    required this.prototypeTimeLine,
    required this.leading,
    required this.content,
    // required this.maxHeight,
  }) : super(children: [content, prototypeTimeLine, leading]);

  /// The widget that will be used to display the timeline.
  final Widget prototypeTimeLine;

  /// The widget that will be used to display the leading widget.
  final Widget leading;

  /// The widget that will be used to display the page.
  final Widget content;

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

  @override
  void performLayout() {
    final content = firstChild!;
    final timeline = childAfter(content)!;
    final leading = childAfter(timeline)!;

    // Layout the timeline to get the width.
    timeline.layout(const BoxConstraints(maxHeight: 10), parentUsesSize: true);
    final timelineWidth = timeline.size.width;

    // Layout the content to get the height.
    content.layout(BoxConstraints(maxWidth: constraints.maxWidth - timelineWidth), parentUsesSize: true);
    final contentHeight = content.size.height;

    // Layout the leading to get the height.
    leading.layout(BoxConstraints(maxWidth: timelineWidth), parentUsesSize: true);
    final leadingHeight = leading.size.height;

    // The maxHeight is the maximum height of the content and leading.
    final double height;
    if (contentHeight >= leadingHeight) {
      height = contentHeight;
      leading.layout(BoxConstraints(maxHeight: height, maxWidth: timelineWidth));
    } else {
      height = leadingHeight;
      content.layout(BoxConstraints(maxHeight: height, maxWidth: constraints.maxWidth - timelineWidth));
    }

    // Setup the parent data for the content.
    final contentParentData = (content.parentData! as MultiChildLayoutParentData);
    contentParentData.offset = switch (textDirection!) {
      TextDirection.ltr => Offset(timelineWidth, 0),
      TextDirection.rtl => const Offset(0, 0),
    };

    // Setup the parent data for the timeline.
    final leadingContentParentData = (leading.parentData! as MultiChildLayoutParentData);
    leadingContentParentData.offset = switch (textDirection!) {
      TextDirection.ltr => const Offset(0, 0),
      TextDirection.rtl => Offset(constraints.maxWidth - timelineWidth, 0),
    };

    size = Size(constraints.maxWidth, height);
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
