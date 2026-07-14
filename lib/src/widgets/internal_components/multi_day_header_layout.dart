import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The widget used for the MultiDayHeader.
///
/// It offsets the [content] by the timeline gutter width (resolved via
/// [MultiDayBodyComponents.timelineWidth]) and sizes the [leading] to that width,
/// so the header's day columns align with the body's day columns.
class MultiDayHeaderWidget extends StatelessWidget {
  /// The content that will be displayed in the [MultiDayHeaderWidget].
  final Widget content;

  /// The leading widget that will be displayed in the [MultiDayHeaderWidget].
  final Widget leading;

  /// Overrides the resolved timeline gutter width. Intended for tests.
  final double? timelineWidthOverride;

  /// Creates a MultiDayHeaderWidget.
  /// This widget is used to display the header of the MultiDayView.
  const MultiDayHeaderWidget({
    super.key,
    required this.content,
    required this.leading,
    this.timelineWidthOverride,
  });

  @override
  Widget build(BuildContext context) {
    final double timelineWidth;
    final override = timelineWidthOverride;
    if (override != null) {
      timelineWidth = override;
    } else {
      final calendarComponents = context.components;
      final bodyStyles = calendarComponents.multiDayComponentStyles.bodyStyles;
      final bodyComponents = calendarComponents.multiDayComponents.bodyComponents;
      final timelineStyle =
          (KalenderTheme.of(context).timelineStyle ?? const TimelineStyle()).merge(bodyStyles.timelineStyle);
      timelineWidth = bodyComponents.timelineWidth(context, TimeOfDayRange.allDay(), timelineStyle);
    }

    return _MultiDayHeaderWidget(
      timelineWidth: timelineWidth,
      leading: LayoutId(id: 1, child: leading),
      content: LayoutId(id: 2, child: content),
    );
  }
}

class _MultiDayHeaderWidget extends MultiChildRenderObjectWidget {
  _MultiDayHeaderWidget({
    required this.timelineWidth,
    required this.leading,
    required this.content,
  }) : super(children: [content, leading]);

  /// The width of the timeline gutter that the content is offset by.
  final double timelineWidth;

  /// The widget that will be used to display the leading widget.
  final Widget leading;

  /// The widget that will be used to display the page.
  final Widget content;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMultiDayHeaderWidget(Directionality.maybeOf(context), timelineWidth);
  }

  @override
  void updateRenderObject(context, covariant _RenderMultiDayHeaderWidget renderObject) {
    renderObject
      ..textDirection = Directionality.maybeOf(context)
      ..timelineWidth = timelineWidth;
  }
}

class _RenderMultiDayHeaderWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  _RenderMultiDayHeaderWidget(TextDirection? textDirection, double timelineWidth)
      : _textDirection = textDirection,
        _timelineWidth = timelineWidth;

  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  double get timelineWidth => _timelineWidth;
  double _timelineWidth;
  set timelineWidth(double value) {
    if (_timelineWidth == value) {
      return;
    }
    _timelineWidth = value;
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
    final leading = childAfter(content)!;
    final timelineWidth = this.timelineWidth;

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

    // Setup the parent data for the leading.
    final leadingParentData = (leading.parentData! as MultiChildLayoutParentData);
    leadingParentData.offset = switch (textDirection!) {
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

    // Paint the leading.
    final leading = childAfter(content)!;
    final leadingParentData = leading.parentData! as MultiChildLayoutParentData;
    leading.paint(context, leadingParentData.offset + offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
