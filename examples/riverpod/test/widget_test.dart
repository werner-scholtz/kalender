// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:riverpod_example/main.dart';

void main() {
  testWidgets('renders the calendar with a view switcher', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.byType(KalenderView), findsOneWidget);
    expect(find.byType(DropdownMenu<ViewConfiguration>), findsOneWidget);
  });

  test('selecting a view updates the controller', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final configs = container.read(viewConfigurationsProvider);
    final controller = container.read(calendarControllerProvider);
    expect(controller.viewConfiguration, configs.first, reason: 'defaults to the first configuration');

    controller.viewConfiguration = configs.last;
    expect(controller.viewConfiguration, configs.last, reason: 'selecting updates the controller');
  });
}
