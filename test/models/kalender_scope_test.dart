// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// [KalenderScope] reads the state of the calendar a widget is built inside.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: year2025DisplayRange),
    );
  });

  tearDown(() {
    eventsController.dispose();
    kalenderController.dispose();
  });

  /// Pumps a calendar whose day header runs [read] and renders what it returns.
  Future<void> pumpReading(WidgetTester tester, String Function(BuildContext context) read) {
    final tiles = TileComponents(tileBuilder: (context, event, range) => const SizedBox());
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        locale: const Locale('de'),
        components: KalenderComponents(
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(dayHeaderStringBuilder: (context, date) => read(context)),
          ),
        ),
        views: [
          MultiDayViewParts(
            header: MultiDayHeader(tileComponents: tiles),
            body: MultiDayBody(tileComponents: tiles),
          ),
        ],
      ),
    );
  }

  testWidgets('reads the controllers the calendar was given', (tester) async {
    await pumpReading(tester, (context) {
      final events = KalenderScope.eventsControllerOf(context);
      final calendar = KalenderScope.kalenderControllerOf(context);
      return '${identical(events, eventsController)}/${identical(calendar, kalenderController)}';
    });
    expect(find.text('true/true'), findsWidgets);
  });

  testWidgets('reads the locale the calendar was given', (tester) async {
    await pumpReading(tester, (context) => '${KalenderScope.localeOf(context)}');
    expect(find.text('de'), findsWidgets);
  });

  testWidgets('reads the nearest interaction rather than the calendar-wide one', (tester) async {
    final tiles = TileComponents(tileBuilder: (context, event, range) => const SizedBox());
    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        components: KalenderComponents(
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(
              dayHeaderStringBuilder: (context, date) => '${KalenderScope.interactionOf(context).allowResizing}',
            ),
          ),
        ),
        views: [
          MultiDayViewParts(
            header: MultiDayHeader(tileComponents: tiles, interaction: KalenderInteraction(allowResizing: false)),
            body: MultiDayBody(tileComponents: tiles, interaction: KalenderInteraction(allowResizing: true)),
          ),
        ],
      ),
    );

    // true is the default, so false is the only value that proves which one was read.
    expect(
      find.text('false'),
      findsWidgets,
      reason: 'the day header reads the header interaction, not the body or the default',
    );
  });

  testWidgets('reads the view controller its own view shows', (tester) async {
    final controller = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.singleDay(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 3, 5),
      ),
    );
    addTearDown(controller.dispose);
    final navigator = GlobalKey<NavigatorState>();
    Widget route(String label) => Scaffold(
      body: KalenderView(
        eventsController: eventsController,
        kalenderController: controller,
        views: [MultiDayViewParts(header: _ShownRange(label))],
      ),
    );
    BuildContext labelled(String label) => tester.element(
      find.byWidgetPredicate((widget) => widget is _ShownRange && widget.label == label, skipOffstage: false),
    );
    bool showsActive(String label) =>
        identical(KalenderScope.viewControllerOf(labelled(label)), controller.viewController);

    await tester.pumpWidget(MaterialApp(navigatorKey: navigator, home: route('lower')));
    unawaited(navigator.currentState!.push(MaterialPageRoute<void>(builder: (context) => route('upper'))));
    await tester.pumpAndSettle();
    expect((showsActive('lower'), showsActive('upper')), (false, true));

    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    unawaited(controller.animateToNextPage());
    await tester.pumpAndSettle();

    expect(showsActive('lower'), isTrue);
    expect(find.text('lower ${FloatingDateTime(2025, 3, 6)}'), findsOneWidget);
  });

  testWidgets('the maybe form returns null outside a calendar', (tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      Builder(
        builder: (context) => Text(
          '${KalenderScope.maybeEventsControllerOf(context)}/${KalenderScope.maybeKalenderControllerOf(context)}/'
          '${KalenderScope.maybeViewControllerOf(context)}',
          textDirection: TextDirection.ltr,
        ),
      ),
    );
    expect(find.text('null/null/null'), findsOneWidget);
  });
}

/// Shows [label] and the start of the range of the view controller [KalenderScope.viewControllerOf] returns.
class _ShownRange extends StatelessWidget {
  const _ShownRange(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: KalenderScope.viewControllerOf(context).floatingVisibleRange,
      builder: (context, range, _) => Text('$label ${range?.start}'),
    );
  }
}
