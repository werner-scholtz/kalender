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

/// A [KalenderView] mounted again, moved, or mounted twice on one [KalenderController].
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    // The resets show that a view mounted again ignores the transition settings.
    kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 3, 5),
        scrollTransition: ScrollTransition.reset,
        zoomTransition: ZoomTransition.reset,
      ),
    );
  });

  tearDown(() {
    kalenderController.dispose();
    eventsController.dispose();
  });

  Widget view({Key? key}) =>
      KalenderView(key: key, eventsController: eventsController, kalenderController: kalenderController);

  (FloatingDateTime, KalenderTime?, double?) shown() {
    final snapshot = kalenderController.viewController.snapshot();
    return (snapshot.date, snapshot.timeOfDay, snapshot.heightPerMinute);
  }

  testWidgets('a view mounted again opens where the last one was', (tester) async {
    await pumpAndSettleWithMaterialApp(tester, view());
    kalenderController.jumpToDate(DateTime(2025, 6, 11));
    await tester.pumpAndSettle();
    kalenderController.multiDayViewController.heightPerMinute.value = 1.2;
    kalenderController.multiDayViewController.scrollController.jumpTo(600);
    await tester.pumpAndSettle();
    final before = shown();
    final first = kalenderController.viewController;

    await tester.pumpWidget(const SizedBox());
    await pumpAndSettleWithMaterialApp(tester, view());

    expect(shown(), before);
    expect(kalenderController.viewController, isNot(same(first)));
  });

  testWidgets('a view moved with a GlobalKey keeps its view controller', (tester) async {
    final key = GlobalKey();
    await pumpAndSettleWithMaterialApp(
      tester,
      Column(
        children: [Expanded(child: view(key: key))],
      ),
    );
    final first = kalenderController.viewController;

    await pumpAndSettleWithMaterialApp(
      tester,
      Row(
        children: [Expanded(child: view(key: key))],
      ),
    );

    expect(kalenderController.viewController, same(first));
  });

  testWidgets('listeners above the calendar are not notified during a build', (tester) async {
    final showCalendar = ValueNotifier(true);
    addTearDown(showCalendar.dispose);
    await pumpAndSettleWithMaterialApp(
      tester,
      Column(
        children: [
          ListenableBuilder(
            listenable: kalenderController,
            builder: (context, _) => Text(kalenderController.viewConfiguration.name),
          ),
          ValueListenableBuilder(
            valueListenable: kalenderController.visibleDateTimeRange,
            builder: (context, range, _) => Text('${range?.start}'),
          ),
          ValueListenableBuilder(
            valueListenable: kalenderController.visibleTimeOfDay,
            builder: (context, time, _) => Text('$time'),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: showCalendar,
              builder: (context, show, _) => show ? view() : const SizedBox(),
            ),
          ),
        ],
      ),
    );

    kalenderController.multiDayViewController.scrollController.jumpTo(600);
    await tester.pumpAndSettle();
    showCalendar.value = false;
    await tester.pumpAndSettle();
    showCalendar.value = true;
    await tester.pumpAndSettle();

    expect(find.byType(MultiDayBody), findsOneWidget);
  });

  testWidgets('a replaced route keeps its view controller until it is gone', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: Scaffold(body: view()),
      ),
    );
    final outgoing = kalenderController.viewController;

    navigator.currentState!.pushReplacement(MaterialPageRoute<void>(builder: (context) => Scaffold(body: view())));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(KalenderView), findsNWidgets(2));
    expect(() => outgoing.floatingVisibleRange.addListener(() {}), returnsNormally);

    await tester.pumpAndSettle();
    expect(find.byType(KalenderView), findsOneWidget);
    expect(() => outgoing.floatingVisibleRange.addListener(() {}), throwsFlutterError);
  });

  testWidgets('the view below a popped route follows the controller', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: Scaffold(body: view()),
      ),
    );
    unawaited(navigator.currentState!.push(MaterialPageRoute<void>(builder: (context) => Scaffold(body: view()))));
    await tester.pumpAndSettle();

    final month = MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange);
    kalenderController.viewConfiguration = month;
    await tester.pumpAndSettle();
    kalenderController.jumpToDate(DateTime(2025, 8, 15));
    await tester.pumpAndSettle();
    final onTop = kalenderController.visibleDateTimeRange.value;

    navigator.currentState!.pop();
    await tester.pumpAndSettle();

    expect(find.byType(MonthBody), findsOneWidget);
    expect(kalenderController.visibleDateTimeRange.value, onTop);
  });

  testWidgets('an event in the view that is not active stays out of the visible events', (tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      Column(
        children: [
          Expanded(child: view()),
          Expanded(child: view()),
        ],
      ),
    );
    kalenderController.jumpToDate(DateTime(2025, 6, 11));
    await tester.pumpAndSettle();

    // Two days long, so the multi-day header of the first view, still on March, shows it.
    eventsController.addEvent(KalenderEvent(start: DateTime(2025, 3, 4), end: DateTime(2025, 3, 6)));
    await tester.pumpAndSettle();

    expect(kalenderController.visibleEvents.value, isEmpty);
  });

  group('navigation while no view is mounted moves where the next view opens', () {
    final june11 = DateTime(2025, 6, 11);
    for (final c in [
      (
        name: 'jumpToDate before the first mount',
        mountFirst: false,
        navigate: () => kalenderController.jumpToDate(june11),
        expected: (FloatingDateTime(2025, 6, 9), kDefaultInitialTimeOfDay),
      ),
      (
        name: 'jumpToDate between an unmount and a remount',
        mountFirst: true,
        navigate: () => kalenderController.jumpToDate(june11),
        expected: (FloatingDateTime(2025, 6, 9), kDefaultInitialTimeOfDay),
      ),
      (
        name: 'animateToEvent before the first mount',
        mountFirst: false,
        navigate: () => kalenderController.animateToEvent(
          KalenderEvent(start: DateTime(2025, 6, 11, 9), end: DateTime(2025, 6, 11, 10)),
        ),
        expected: (FloatingDateTime(2025, 6, 9), const KalenderTime(hour: 9, minute: 0)),
      ),
      (
        name: 'animateToNextPage before the first mount',
        mountFirst: false,
        navigate: () => kalenderController.animateToNextPage(),
        expected: (FloatingDateTime(2025, 3, 10), kDefaultInitialTimeOfDay),
      ),
    ]) {
      testWidgets(c.name, (tester) async {
        if (c.mountFirst) {
          await pumpAndSettleWithMaterialApp(tester, view());
          await tester.pumpWidget(const SizedBox());
        }

        c.navigate();
        await pumpAndSettleWithMaterialApp(tester, view());

        final snapshot = kalenderController.viewController.snapshot();
        expect((snapshot.date, snapshot.timeOfDay), c.expected);
      });
    }
  });
}
