// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  bool vertical(
    DragTargetDetails<Object?> details,
    KalenderController controller,
    VerticalConfiguration configuration,
  ) {
    return true;
  }

  bool horizontal(
    DragTargetDetails<Object?> details,
    KalenderController controller,
    HorizontalConfiguration configuration,
  ) {
    return true;
  }

  test('copyWith keeps the drag accept callbacks it is not given', () {
    final callbacks = KalenderCallbacks(
      onWillAcceptWithDetailsVertical: vertical,
      onWillAcceptWithDetailsHorizontal: horizontal,
    );

    final copy = callbacks.copyWith(onTapped: (date) {});

    expect(copy.onWillAcceptWithDetailsVertical, vertical);
    expect(copy.onWillAcceptWithDetailsHorizontal, horizontal);
  });

  test('copyWith replaces the drag accept callbacks it is given', () {
    const callbacks = KalenderCallbacks();

    final copy = callbacks.copyWith(
      onWillAcceptWithDetailsVertical: vertical,
      onWillAcceptWithDetailsHorizontal: horizontal,
    );

    expect(copy.onWillAcceptWithDetailsVertical, vertical);
    expect(copy.onWillAcceptWithDetailsHorizontal, horizontal);
  });
}
