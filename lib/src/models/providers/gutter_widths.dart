// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';

/// The measured widths of the week number column and the timeline, read by the header and the body so their day
/// columns align. Null where the view draws no such gutter.
class GutterWidths extends InheritedWidget {
  /// The width of the month week number column, or null where none is drawn.
  final double? weekNumber;

  /// The width of the multi-day timeline column, or null where none is drawn.
  final double? timeline;

  const GutterWidths({super.key, required this.weekNumber, required this.timeline, required super.child});

  /// The [GutterWidths] above [context], or null when there is none.
  static GutterWidths? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GutterWidths>();
  }

  @override
  bool updateShouldNotify(covariant GutterWidths oldWidget) {
    return weekNumber != oldWidget.weekNumber || timeline != oldWidget.timeline;
  }
}
