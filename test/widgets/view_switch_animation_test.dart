// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/view_switch_area.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// [KalenderView.switchAnimation]: which views are on screen while a switch animates, and when the old one goes.
void main() {
  tz.initializeTimeZones();
  final week = MultiDayViewConfiguration.week(displayRange: year2025DisplayRange);
  final month = MonthViewConfiguration.singleMonth(displayRange: year2025DisplayRange);
  final schedule = ScheduleViewConfiguration.continuous(displayRange: year2025DisplayRange);
  const fade = KalenderViewAnimation.fade(duration: Duration(milliseconds: 200));
  const zoom = KalenderViewAnimation.zoom(duration: Duration(milliseconds: 200));

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController(viewConfiguration: week);
  });

  tearDown(() {
    eventsController.dispose();
    kalenderController.dispose();
  });

  Widget view({
    KalenderViewAnimation? switchAnimation,
    bool disableAnimations = false,
    KalenderCallbacks? callbacks,
    List<ViewParts> views = KalenderView.defaultViews,
  }) {
    return MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        switchAnimation: switchAnimation,
        callbacks: callbacks,
        views: views,
      ),
    );
  }

  Future<void> pumpView(
    WidgetTester tester, {
    KalenderViewAnimation? switchAnimation,
    bool disableAnimations = false,
    KalenderCallbacks? callbacks,
    List<ViewParts> views = KalenderView.defaultViews,
  }) {
    return pumpAndSettleWithMaterialApp(
      tester,
      view(switchAnimation: switchAnimation, disableAnimations: disableAnimations, callbacks: callbacks, views: views),
    );
  }

  /// Views whose month parts draw nothing, so a tap or a semantics lookup reaches the outgoing week view.
  final weekOverEmptyMonth = <ViewParts>[
    MultiDayViewParts(
      header: Semantics(label: 'week header', child: const SizedBox(height: 40)),
    ),
    const MonthViewParts(header: SizedBox.shrink(), body: SizedBox.shrink()),
  ];

  (int, int, int) bodies() => (
    find.byType(MultiDayBody).evaluate().length,
    find.byType(MonthBody).evaluate().length,
    find.byType(ScheduleBody).evaluate().length,
  );

  final cases = [
    (name: 'without an animation', animation: null, disableAnimations: false, during: (0, 1, 0)),
    (name: 'with a fade', animation: fade, disableAnimations: false, during: (1, 1, 0)),
    (name: 'with a zoom', animation: zoom, disableAnimations: false, during: (1, 1, 0)),
    (name: 'with reduced motion', animation: fade, disableAnimations: true, during: (0, 1, 0)),
  ];
  for (final c in cases) {
    testWidgets('a switch ${c.name} shows ${c.during} bodies during the animation', (tester) async {
      await pumpView(tester, switchAnimation: c.animation, disableAnimations: c.disableAnimations);

      kalenderController.viewConfiguration = month;
      await tester.pump();
      final during = bodies();
      await tester.pumpAndSettle();

      expect((during, bodies()), (c.during, (0, 1, 0)));
    });
  }

  testWidgets('the outgoing view takes no taps', (tester) async {
    var taps = 0;
    await pumpView(
      tester,
      switchAnimation: fade,
      callbacks: KalenderCallbacks(onTapped: (_) => taps++),
      views: weekOverEmptyMonth,
    );
    final center = tester.getCenter(find.byType(MultiDayBody));
    await tester.tapAt(center);
    await tester.pumpAndSettle();
    final before = taps;

    kalenderController.viewConfiguration = month;
    await tester.pump();
    await tester.tapAt(center);
    await tester.pump();

    expect((before, taps), (1, 1));
  });

  testWidgets('the outgoing view has no semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpView(tester, switchAnimation: fade, views: weekOverEmptyMonth);
    final before = find.semantics.byLabel('week header').evaluate().length;

    kalenderController.viewConfiguration = month;
    await tester.pump();

    expect((before, find.semantics.byLabel('week header').evaluate().length), (1, 0));
    semantics.dispose();
  });

  testWidgets('the outgoing view keeps its state when the animation starts', (tester) async {
    await pumpView(tester, switchAnimation: fade);
    final before = tester.element(find.byType(MultiDayBody));

    kalenderController.viewConfiguration = month;
    await tester.pump();

    expect(identical(tester.element(find.byType(MultiDayBody)), before), isTrue);
  });

  testWidgets('a switch during an animation drops the outgoing view at once', (tester) async {
    await pumpView(tester, switchAnimation: fade);

    kalenderController.viewConfiguration = month;
    await tester.pump(const Duration(milliseconds: 50));
    kalenderController.viewConfiguration = schedule;
    await tester.pump();

    expect(bodies(), (0, 1, 1));
  });

  testWidgets('the incoming view keeps its state when the animation ends', (tester) async {
    await pumpView(tester, switchAnimation: fade);

    kalenderController.viewConfiguration = month;
    await tester.pump();
    final during = tester.element(find.byType(MonthBody));
    await tester.pumpAndSettle();

    expect(identical(tester.element(find.byType(MonthBody)), during), isTrue);
  });

  testWidgets('the old view controller is disposed when the animation ends', (tester) async {
    await pumpView(tester, switchAnimation: fade);
    final old = kalenderController.viewController;

    kalenderController.viewConfiguration = month;
    await tester.pump(const Duration(milliseconds: 100));
    final during = isDisposed(old);
    await tester.pumpAndSettle();

    expect((during, isDisposed(old)), (false, true));
  });

  testWidgets('a switch between multi-day views moves the day columns of both views until it ends', (tester) async {
    await pumpView(tester, switchAnimation: zoom);
    List<ColumnTransform> columns() => [
      for (final scope in tester.widgetList<ViewSwitchAreaScope>(find.byType(ViewSwitchAreaScope)))
        scope.holder!.columns.value,
    ];

    kalenderController.viewConfiguration = MultiDayViewConfiguration.custom(
      displayRange: year2025DisplayRange,
      numberOfDays: 3,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final during = columns();
    await tester.pumpAndSettle();

    expect(
      (during.length, during.contains(ColumnTransform.identity), columns().single),
      (2, false, ColumnTransform.identity),
    );
  });

  testWidgets('a switch between multi-day views lays the moving header and body columns out at their width', (
    tester,
  ) async {
    await pumpView(tester, switchAnimation: zoom);

    kalenderController.viewConfiguration = MultiDayViewConfiguration.custom(
      displayRange: year2025DisplayRange,
      numberOfDays: 3,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final mismatches = <String>[];
    for (final element in find.byType(ViewSwitchColumns).evaluate()) {
      final columns = element.renderObject! as RenderViewSwitchColumns;
      final scope = element.findAncestorWidgetOfExactType<ViewSwitchAreaScope>()!;
      final scale = scope.holder!.columns.value.scale;
      final ratio = columns.child!.size.width / columns.size.width;
      if ((ratio - scale).abs() > 1e-6) mismatches.add('$ratio != $scale');
    }
    expect((find.byType(ViewSwitchColumns).evaluate().length, mismatches.join(', ')), (4, ''));
  });

  testWidgets('a switch animates the incoming body and not its header', (tester) async {
    await pumpView(tester, switchAnimation: fade);
    int fadesAbove(Type type) => find
        .ancestor(
          of: find.byType(type),
          matching: find.descendant(of: find.byType(KalenderView), matching: find.byType(FadeTransition)),
        )
        .evaluate()
        .length;

    kalenderController.viewConfiguration = month;
    await tester.pump();

    expect((fadesAbove(MonthHeader), fadesAbove(MonthBody)), (0, 1));
  });

  testWidgets('a configuration with the same name does not animate', (tester) async {
    await pumpView(tester, switchAnimation: fade);

    kalenderController.viewConfiguration = week.copyWith(firstDayOfWeek: DateTime.sunday);
    await tester.pump();

    expect(bodies(), (1, 0, 0));
  });

  testWidgets('a location change does not animate', (tester) async {
    await pumpView(tester, switchAnimation: fade);

    kalenderController.location = getLocation('Asia/Tokyo');
    await tester.pump();

    expect(bodies(), (1, 0, 0));
  });

  testWidgets('removing the animation during one drops the outgoing view', (tester) async {
    await pumpView(tester, switchAnimation: fade);

    kalenderController.viewConfiguration = month;
    await tester.pump();
    await tester.pumpWidget(wrapWithMaterialApp(view()));

    expect(bodies(), (0, 1, 0));
  });

  test('== compares the kind, duration and curve', () {
    const pairs = [
      (KalenderViewAnimation.fade(), KalenderViewAnimation.fade(), true),
      (KalenderViewAnimation.fade(), KalenderViewAnimation.zoom(), false),
      (KalenderViewAnimation.fade(), KalenderViewAnimation.fade(duration: Duration(seconds: 1)), false),
      (KalenderViewAnimation.fade(), KalenderViewAnimation.fade(curve: Curves.linear), false),
    ];
    expect(
      [for (final (a, b, _) in pairs) (a == b, a.hashCode == b.hashCode)],
      [for (final (_, _, equal) in pairs) (equal, equal)],
    );
  });
}

bool isDisposed(ViewController viewController) {
  try {
    viewController.floatingVisibleRange.addListener(() {});
    return false;
  } on FlutterError {
    return true;
  }
}
