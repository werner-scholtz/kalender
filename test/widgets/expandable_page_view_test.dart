// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart';
import 'package:linked_pageview/linked_pageview.dart';

void main() {
  Future<double> pumpPageView(WidgetTester tester, {double viewportFraction = 1, bool intrinsic = false}) async {
    final controller = LinkedPageControllerGroup().create(viewportFraction: viewportFraction, initialPage: 3);
    final Widget pageView = ExpandablePageView(
      controller: controller,
      itemCount: 10,
      itemBuilder: (context, index) => SizedBox(height: 30.0 + 10 * index),
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: intrinsic ? IntrinsicHeight(child: pageView) : pageView,
        ),
      ),
    );
    return tester.getSize(find.byType(ExpandablePageView)).height;
  }

  testWidgets('two visible pages take the taller height from the first frame', (tester) async {
    expect(await pumpPageView(tester, viewportFraction: 0.5), 70);
  });

  testWidgets('an intrinsic height query takes the current height', (tester) async {
    await pumpPageView(tester, intrinsic: true);
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(ExpandablePageView)).height, 60);
  });
}
