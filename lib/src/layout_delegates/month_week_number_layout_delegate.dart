import 'package:flutter/material.dart';

class MonthWeekNumberBodyLayoutDelegate extends MultiChildLayoutDelegate {
  final int? gutterId;
  final int? backgroundId;
  final int gridId;
  final int contentId;

  /// The side the gutter leads from.
  final TextDirection textDirection;

  MonthWeekNumberBodyLayoutDelegate({
    required this.gutterId,
    this.backgroundId,
    required this.gridId,
    required this.contentId,
    required this.textDirection,
  });

  @override
  void performLayout(Size size) {
    var gutterWidth = 0.0;
    final hasGutter = gutterId != null && hasChild(gutterId!);

    if (hasGutter) {
      final gutterSize = layoutChild(
        gutterId!,
        BoxConstraints(
          minWidth: 0,
          maxWidth: size.width,
          minHeight: size.height,
          maxHeight: size.height,
        ),
      );
      gutterWidth = gutterSize.width;
    }

    final contentWidth = (size.width - gutterWidth).clamp(0.0, size.width);
    // The month header lays its spacer out in a Row, which mirrors on its own.
    final rightToLeft = textDirection == TextDirection.rtl;
    final gutterOffset = rightToLeft ? Offset(contentWidth, 0) : Offset.zero;
    final contentOffset = rightToLeft ? Offset.zero : Offset(gutterWidth, 0);

    if (hasGutter) positionChild(gutterId!, gutterOffset);

    final contentConstraints = BoxConstraints.tight(Size(contentWidth, size.height));

    // The background occupies the same rect as the content but is painted first,
    // so it sits below the grid lines and the day content.
    if (backgroundId != null && hasChild(backgroundId!)) {
      layoutChild(backgroundId!, contentConstraints);
      positionChild(backgroundId!, contentOffset);
    }

    layoutChild(gridId, contentConstraints);
    positionChild(gridId, contentOffset);

    layoutChild(contentId, contentConstraints);
    positionChild(contentId, contentOffset);
  }

  @override
  bool shouldRelayout(covariant MonthWeekNumberBodyLayoutDelegate oldDelegate) {
    return gutterId != oldDelegate.gutterId ||
        backgroundId != oldDelegate.backgroundId ||
        gridId != oldDelegate.gridId ||
        contentId != oldDelegate.contentId ||
        textDirection != oldDelegate.textDirection;
  }
}

class MonthWeekNumberHeaderLayoutDelegate extends MultiChildLayoutDelegate {
  final int? probeId;
  final int contentId;

  MonthWeekNumberHeaderLayoutDelegate({
    required this.probeId,
    required this.contentId,
  });

  @override
  void performLayout(Size size) {
    var probeWidth = 0.0;

    if (probeId != null && hasChild(probeId!)) {
      final probeSize = layoutChild(
        probeId!,
        BoxConstraints(
          minWidth: 0,
          maxWidth: size.width,
          minHeight: 0,
          maxHeight: size.height,
        ),
      );
      probeWidth = probeSize.width;
      positionChild(probeId!, Offset.zero);
    }

    final contentConstraints =
        BoxConstraints.tight(Size((size.width - probeWidth).clamp(0.0, size.width), size.height));
    layoutChild(contentId, contentConstraints);
    positionChild(contentId, Offset(probeWidth, 0));
  }

  @override
  bool shouldRelayout(covariant MonthWeekNumberHeaderLayoutDelegate oldDelegate) {
    return probeId != oldDelegate.probeId || contentId != oldDelegate.contentId;
  }
}
