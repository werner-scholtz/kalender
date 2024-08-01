import 'package:flutter/material.dart';


/// TODO: document this and why it exisits.
class CalendarLayoutDelegate extends MultiChildLayoutDelegate {
  CalendarLayoutDelegate(this.headerId, this.bodyId);
  final int? headerId;
  final int? bodyId;

  @override
  void performLayout(Size size) {
    Size? headerSize;

    if (headerId != null) {
      final width = size.width;

      final constrains = BoxConstraints(
        minWidth: width,
        maxWidth: width,
        minHeight: 0.0,
      );

      headerSize = layoutChild(
        headerId!,
        constrains,
      );

      positionChild(headerId!, Offset.zero);
    }

    if (bodyId != null) {
      final width = size.width;
      final height = size.height;
      final headerHeight = headerSize?.height ?? 0.0;
      final maxHeight = height - headerHeight;

      final constraints = BoxConstraints(
        minWidth: width,
        maxWidth: width,
        maxHeight: maxHeight,
        minHeight: 0.0,
      );

      layoutChild(
        bodyId!,
        constraints,
      );

      positionChild(bodyId!, Offset(0, headerHeight));
    }
  }

  @override
  bool shouldRelayout(covariant CalendarLayoutDelegate oldDelegate) {
    return false;
  }
}
