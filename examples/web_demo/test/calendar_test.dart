// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/main.dart';
import 'package:web_demo/models/demo_configuration.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/timezone/standalone.dart';
import 'package:web_demo/widgets/calendar/detail_card.dart';
import 'package:web_demo/widgets/calendar/event_tiles.dart';

/// Pumps the demo on a surface tall enough to show the whole configuration panel.
Future<void> _pumpDemo(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1400, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

BuildContext _calendarContext(WidgetTester tester) => tester.element(find.byType(KalenderView));
KalenderController _controller(WidgetTester tester) => DemoScope.controllerOf(_calendarContext(tester));
DemoConfiguration _configuration(WidgetTester tester) => DemoScope.configurationOf(_calendarContext(tester));

void main() {
  setUpAll(() async {
    await initializeTimeZonePackage();
  });

  testWidgets('the show header switch hides the view header', (tester) async {
    await _pumpDemo(tester);
    expect(find.byType(MultiDayHeader), findsOneWidget);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Show Header'));
    await tester.pumpAndSettle();

    expect(find.byType(MultiDayHeader), findsNothing);
  });

  testWidgets('the detail card shows times in the location picked after the calendar was built', (tester) async {
    // The test font's glyphs are too wide for the card's date and time row.
    tester.platformDispatcher.textScaleFactorTestValue = 0.8;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _pumpDemo(tester);
    final tile = find.byType(EventTile).hitTestable().first;
    final event = tester.widget<EventTile>(tile).event;
    final location = ['Asia/Shanghai', 'America/New_York']
        .map(getLocation)
        .firstWhere((location) => event.floatingStart(location: location).hour != event.floatingStart().hour);

    _controller(tester).location = location;
    await tester.pumpAndSettle();
    final movedTile = find.byWidgetPredicate((widget) => widget is EventTile && widget.event == event).hitTestable();
    await tester.tap(movedTile.first);
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(EventDetailCard));
    final start = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(event.floatingStart(location: location)),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    expect(find.descendant(of: find.byType(EventDetailCard), matching: find.text(start)), findsOneWidget);
  });

  testWidgets('the schedule body follows the empty day setting', (tester) async {
    await _pumpDemo(tester);
    final configuration = _configuration(tester);
    _controller(tester).viewConfiguration =
        configuration.viewConfigurations.firstWhere((view) => view is ScheduleViewConfiguration);
    await tester.pumpAndSettle();

    for (final behavior in EmptyDayBehavior.values) {
      configuration.scheduleBodyConfiguration = configuration.scheduleBodyConfiguration.copyWith(emptyDay: behavior);
      await tester.pumpAndSettle();
      expect(tester.widget<ScheduleBody>(find.byType(ScheduleBody)).configuration?.emptyDay, behavior);
    }
  });

  testWidgets('the empty day options have readable names', (tester) async {
    await _pumpDemo(tester);
    final configuration = _configuration(tester);
    _controller(tester).viewConfiguration =
        configuration.viewConfigurations.firstWhere((view) => view is ScheduleViewConfiguration);
    await tester.pumpAndSettle();

    final menu = tester.widget<DropdownMenu<EmptyDayBehavior>>(find.byType(DropdownMenu<EmptyDayBehavior>));
    expect(menu.dropdownMenuEntries.map((entry) => entry.label), ['Show', 'Show only today', 'Hide']);
  });
}
