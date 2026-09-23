// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('the calendar renders without the bridge', (tester) async {
    await tester.pumpWidget(_app(bridge: false));
    expect(tester.takeException(), isNull);
    expect(find.byType(MultiDayBody), findsOneWidget);
  });

  testWidgets('with the bridge the calendar renders', (tester) async {
    await tester.pumpWidget(_app(bridge: true));
    expect(tester.takeException(), isNull);
    expect(find.byType(MultiDayBody), findsOneWidget);
  });
}

Widget _app({required bool bridge}) {
  return MaterialApp(
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    builder: bridge
        // ignore: deprecated_member_use
        ? (context, child) => MaterialUiCompatibilityBridge(child: child!)
        : null,
    home: Scaffold(body: _Calendar()),
  );
}

class _Calendar extends StatefulWidget {
  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  final eventsController = DefaultEventsController();
  final kalenderController = KalenderController(
    viewConfiguration: MultiDayViewConfiguration.week(
      displayRange: KalenderDateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now().add(const Duration(days: 7)),
      ),
    ),
  );

  @override
  void dispose() {
    eventsController.dispose();
    kalenderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KalenderView(
      eventsController: eventsController,
      kalenderController: kalenderController,
      views: const [MultiDayViewParts(header: SizedBox.shrink())],
    );
  }
}
