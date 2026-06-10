import 'package:flutter/material.dart';

class MonthWeekNumberBodyLayoutDelegate extends MultiChildLayoutDelegate {
  final int? gutterId;
  final int gridId;
  final int contentId;

  MonthWeekNumberBodyLayoutDelegate({
    required this.gutterId,
    required this.gridId,
    required this.contentId,
  });

  @override
  void performLayout(Size size) {
    var gutterWidth = 0.0;

    if (gutterId != null && hasChild(gutterId!)) {
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
      positionChild(gutterId!, Offset.zero);
    }

    final contentConstraints =
        BoxConstraints.tight(Size((size.width - gutterWidth).clamp(0.0, size.width), size.height));

    layoutChild(gridId, contentConstraints);
    positionChild(gridId, Offset(gutterWidth, 0));

    layoutChild(contentId, contentConstraints);
    positionChild(contentId, Offset(gutterWidth, 0));
  }

  @override
  bool shouldRelayout(covariant MonthWeekNumberBodyLayoutDelegate oldDelegate) {
    return gutterId != oldDelegate.gutterId || gridId != oldDelegate.gridId || contentId != oldDelegate.contentId;
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
