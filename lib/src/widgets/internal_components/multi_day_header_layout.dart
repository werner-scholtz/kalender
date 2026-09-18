// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/timeline_sizer.dart';

/// The widget used for the MultiDayHeader.
///
/// It offsets the [content] by the timeline gutter width (resolved via
/// [MultiDayBodyComponents.timelineWidth]) and sizes the [leading] to that width,
/// so the header's day columns align with the body's day columns.
class MultiDayHeaderWidget extends StatelessWidget {
  final Widget content;

  final Widget leading;

  /// Overrides the resolved timeline gutter width. Intended for tests.
  final double? timelineWidthOverride;

  const MultiDayHeaderWidget({super.key, required this.content, required this.leading, this.timelineWidthOverride});

  @override
  Widget build(BuildContext context) {
    final timelineWidth = timelineWidthOverride ?? timelineWidthOf(context);

    return _MultiDayHeaderWidget(
      timelineWidth: timelineWidth,
      leading: LayoutId(id: 1, child: leading),
      content: LayoutId(id: 2, child: content),
    );
  }
}

class _MultiDayHeaderWidget extends MultiChildRenderObjectWidget {
  _MultiDayHeaderWidget({required this.timelineWidth, required this.leading, required this.content})
    : super(children: [content, leading]);

  /// The width of the timeline gutter that the content is offset by.
  final double timelineWidth;

  final Widget leading;

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

    content.layout(BoxConstraints(maxWidth: constraints.maxWidth - timelineWidth), parentUsesSize: true);
    final contentHeight = content.size.height;

    leading.layout(BoxConstraints(maxWidth: timelineWidth), parentUsesSize: true);
    final leadingHeight = leading.size.height;

    final double height;
    if (contentHeight >= leadingHeight) {
      height = contentHeight;
      leading.layout(BoxConstraints(maxHeight: height, maxWidth: timelineWidth));
    } else {
      height = leadingHeight;
      content.layout(BoxConstraints(maxHeight: height, maxWidth: constraints.maxWidth - timelineWidth));
    }

    final contentParentData = (content.parentData! as MultiChildLayoutParentData);
    contentParentData.offset = switch (textDirection!) {
      TextDirection.ltr => Offset(timelineWidth, 0),
      TextDirection.rtl => const Offset(0, 0),
    };

    final leadingParentData = (leading.parentData! as MultiChildLayoutParentData);
    leadingParentData.offset = switch (textDirection!) {
      TextDirection.ltr => const Offset(0, 0),
      TextDirection.rtl => Offset(constraints.maxWidth - timelineWidth, 0),
    };

    size = Size(constraints.maxWidth, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final content = firstChild!;
    final contentParentData = content.parentData! as MultiChildLayoutParentData;
    content.paint(context, contentParentData.offset + offset);

    final leading = childAfter(content)!;
    final leadingParentData = leading.parentData! as MultiChildLayoutParentData;
    leading.paint(context, leadingParentData.offset + offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
