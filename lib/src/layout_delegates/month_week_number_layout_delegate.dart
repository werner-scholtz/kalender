// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';

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
        BoxConstraints(minWidth: 0, maxWidth: size.width, minHeight: size.height, maxHeight: size.height),
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
