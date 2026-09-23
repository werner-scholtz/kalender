// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// [ViewController.dispose] disposes every notifier the view controller creates.
void main() {
  final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));

  for (final c in [
    (
      configuration: MultiDayViewConfiguration.week(displayRange: range),
      notifiers: (ViewController v) {
        v as MultiDayViewController;
        return <ChangeNotifier>[
          v.pageController,
          v.headerController,
          v.scrollController,
          v.heightPerMinute,
          v.pageOffset,
          v.visibleTimeOfDay,
        ];
      },
    ),
    (
      configuration: MonthViewConfiguration.singleMonth(displayRange: range),
      notifiers: (ViewController v) => <ChangeNotifier>[(v as MonthViewController).pageController],
    ),
    (
      configuration: ScheduleViewConfiguration.continuous(displayRange: range),
      notifiers: (ViewController v) => <ChangeNotifier>[(v as ScheduleViewController).highlightedRange],
    ),
    (
      configuration: ScheduleViewConfiguration.paginated(displayRange: range),
      notifiers: (ViewController v) {
        v as PaginatedScheduleViewController;
        return <ChangeNotifier>[v.highlightedRange, v.pageController];
      },
    ),
  ]) {
    test(c.configuration.name, () {
      final controller = KalenderController();
      addTearDown(controller.dispose);
      final viewController = c.configuration.createViewController(controller, null);
      final notifiers = [
        viewController.floatingVisibleRange,
        viewController.visibleEvents,
        ...c.notifiers(viewController),
      ];

      viewController.dispose();

      for (final notifier in notifiers) {
        expect(() => notifier.addListener(() {}), throwsFlutterError, reason: '$notifier');
      }
    });
  }

  testWidgets('a KalenderView disposes its view controller when it leaves the tree', (tester) async {
    final eventsController = DefaultEventsController();
    final controller = KalenderController();
    addTearDown(eventsController.dispose);
    addTearDown(controller.dispose);
    await pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: controller,
      viewConfiguration: MonthViewConfiguration.singleMonth(displayRange: range),
      body: const KalenderBody(),
    );
    final viewController = controller.viewController! as MonthViewController;

    await tester.pumpWidget(const SizedBox());

    expect(() => viewController.pageController.addListener(() {}), throwsFlutterError);
  });
}
