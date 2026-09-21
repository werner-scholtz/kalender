// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Lays out the header above the body.
class KalenderLayoutDelegate extends MultiChildLayoutDelegate {
  final int? headerId;
  final int? bodyId;
  KalenderLayoutDelegate(this.headerId, this.bodyId);

  static const header = 0;
  static const body = 1;

  @override
  void performLayout(Size size) {
    Size? headerSize;

    if (headerId != null) {
      headerSize = layoutChild(headerId!, BoxConstraints.tightFor(width: size.width));
      positionChild(headerId!, Offset.zero);
    }

    if (bodyId != null) {
      final headerHeight = headerSize?.height ?? 0.0;
      final maxHeight = math.max(0.0, size.height - headerHeight);
      final constraints = BoxConstraints.tightFor(width: size.width).copyWith(maxHeight: maxHeight);

      layoutChild(bodyId!, constraints);
      positionChild(bodyId!, Offset(0, headerHeight));
    }
  }

  @override
  bool shouldRelayout(covariant KalenderLayoutDelegate oldDelegate) {
    return headerId != oldDelegate.headerId || bodyId != oldDelegate.bodyId;
  }
}
