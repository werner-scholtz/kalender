import 'package:flutter/material.dart';

/// The calendar header when in use should be able to throw a drop shadow on the body.
/// Ideally a [Column] widget would be used with the children as [body, header].
///
/// However there is an issue with the [Column] widget
/// https://github.com/flutter/flutter/issues/12206 which prevents this from working correctly.
///
class CalendarLayoutDelegate extends MultiChildLayoutDelegate {
  final int? headerId;
  final int? bodyId;
  CalendarLayoutDelegate(this.headerId, this.bodyId);

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
