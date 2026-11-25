// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/view_switch_area.dart';
import 'package:material_ui/material_ui.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// [KalenderView.switchAnimation]: which views are on screen while a switch animates, and when the old one goes.
void main() {
  tz.initializeTimeZones();
  // A switch from the week of 10 March 2025 to the three-day view shows 8 to 10 March, so the pages share 10 March.
  final week = MultiDayViewConfiguration.week(
    displayRange: year2025DisplayRange,
    initialDateTime: DateTime(2025, 3, 12),
  );
  final threeDays = MultiDayViewConfiguration.custom(
    displayRange: year2025DisplayRange,
    initialDateTime: DateTime(2025, 3, 12),
    numberOfDays: 3,
  );
  final freeScroll = MultiDayViewConfiguration.freeScroll(
    displayRange: year2025DisplayRange,
    initialDateTime: DateTime(2025, 3, 12),
    numberOfDays: 3,
  );
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

  List<ColumnTransform> columns(WidgetTester tester) => [
    for (final scope in tester.widgetList<ViewSwitchAreaScope>(find.byType(ViewSwitchAreaScope)))
      scope.holder!.columns.value,
  ];

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

    kalenderController.viewConfiguration = threeDays;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final during = columns(tester);
    await tester.pumpAndSettle();

    expect(
      (during.length, during.contains(ColumnTransform.identity), columns(tester).single),
      (2, false, ColumnTransform.identity),
    );
  });

  testWidgets('a switch between multi-day views lays the moving header and body columns out at their width', (
    tester,
  ) async {
    await pumpView(tester, switchAnimation: zoom);

    kalenderController.viewConfiguration = threeDays;
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

  /// The opacities of the fades inside the calendar above the widgets of [type].
  List<double> opacitiesAbove(WidgetTester tester, Type type) => [
    for (final element
        in find
            .ancestor(
              of: find.byType(type),
              matching: find.descendant(of: find.byType(KalenderView), matching: find.byType(FadeTransition)),
            )
            .evaluate())
      (element.widget as FadeTransition).opacity.value,
  ];

  testWidgets('a switch animates the incoming body and not its header', (tester) async {
    await pumpView(tester, switchAnimation: fade);

    kalenderController.viewConfiguration = month;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect((opacitiesAbove(tester, MonthHeader).single, opacitiesAbove(tester, MonthBody).single < 1), (1.0, true));
  });

  /// The opacities of the fades inside the view of [viewController].
  List<double> opacitiesIn(WidgetTester tester, ViewController viewController) => [
    for (final element
        in find.descendant(of: find.byKey(ObjectKey(viewController)), matching: find.byType(FadeTransition)).evaluate())
      (element.widget as FadeTransition).opacity.value,
  ];

  testWidgets('a switch between multi-day views fades the outgoing header and body', (tester) async {
    await pumpView(tester, switchAnimation: fade);
    final outgoing = kalenderController.viewController;

    kalenderController.viewConfiguration = threeDays;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(opacitiesIn(tester, outgoing).where((opacity) => opacity < 1).length, 2);
  });

  testWidgets('a curve that overshoots does not break the column layout', (tester) async {
    for (final curve in [Curves.elasticIn, Curves.elasticOut]) {
      kalenderController.viewConfiguration = week;
      await pumpView(tester, switchAnimation: KalenderViewAnimation.fade(curve: curve));

      kalenderController.viewConfiguration = MultiDayViewConfiguration.singleDay(
        displayRange: year2025DisplayRange,
        initialDateTime: DateTime(2025, 3, 12),
      );
      await tester.pumpAndSettle();
    }

    expect(tester.takeException(), isNull);
  });

  final noMorphCases = [
    (name: 'to a free-scrolling view', to: freeScroll),
    (
      name: 'to pages that share no day',
      to: MultiDayViewConfiguration.custom(
        displayRange: year2025DisplayRange,
        numberOfDays: 3,
        dateResolver: (_) => FloatingDateTime(2025, 6, 2),
      ),
    ),
  ];
  for (final c in noMorphCases) {
    testWidgets('a switch ${c.name} fades the bodies and moves no columns', (tester) async {
      await pumpView(tester, switchAnimation: fade);

      kalenderController.viewConfiguration = c.to;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final bodies = opacitiesAbove(tester, MultiDayBody);
      expect(
        (
          columns(tester).every((value) => value == ColumnTransform.identity),
          bodies.length,
          bodies.every((o) => o < 1),
        ),
        (true, 2, true),
      );
    });
  }

  testWidgets('a switch during a column movement resets the columns of the view that was coming in', (tester) async {
    await pumpView(tester, switchAnimation: fade);

    kalenderController.viewConfiguration = threeDays;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final interrupted = kalenderController.viewController;
    kalenderController.viewConfiguration = month;
    await tester.pump();

    final scope = tester.widget<ViewSwitchAreaScope>(
      find.descendant(of: find.byKey(ObjectKey(interrupted)), matching: find.byType(ViewSwitchAreaScope)),
    );
    expect(scope.holder!.columns.value, ColumnTransform.identity);
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

  testWidgets('a configuration with the same name during a column movement ends the movement', (tester) async {
    await pumpView(tester, switchAnimation: fade);

    kalenderController.viewConfiguration = threeDays;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    kalenderController.viewConfiguration = threeDays.copyWith(numberOfDays: 5);
    await tester.pump();

    expect((bodies(), columns(tester).single), ((1, 0, 0), ColumnTransform.identity));
  });

  for (final textDirection in TextDirection.values) {
    testWidgets('a column movement keeps a shared date in place, $textDirection', (tester) async {
      await pumpAndSettleWithMaterialApp(
        tester,
        Directionality(
          textDirection: textDirection,
          child: view(switchAnimation: fade),
        ),
      );
      final shared = find.byWidgetPredicate(
        (widget) => widget is DayHeader && (widget.date.month, widget.date.day) == (3, 10),
      );
      double left(Element element) => (element.renderObject! as RenderBox).localToGlobal(Offset.zero).dx;

      kalenderController.viewConfiguration = threeDays;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final positions = shared.evaluate().map(left).toList();
      expect(positions, [positions.first, moreOrLessEquals(positions.first)]);
    });
  }

  testWidgets('adding or removing the animation keeps the page and the scroll position', (tester) async {
    await pumpView(tester);
    kalenderController.jumpToDate(DateTime(2025, 6, 18));
    await tester.pumpAndSettle();
    final scrollable = tester.state<ScrollableState>(
      find.byWidgetPredicate((widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down).first,
    );
    scrollable.position.jumpTo(300);
    await tester.pumpAndSettle();
    (DateTime, DateTime, int) shown() {
      final headers = tester.widgetList<DayHeader>(find.byType(DayHeader)).map((header) => header.date).toList();
      final current = tester.state<ScrollableState>(
        find.byWidgetPredicate((widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down).first,
      );
      return (
        headers.first,
        kalenderController.visibleDateTimeRange.value.start.toLocal(),
        current.position.pixels.round(),
      );
    }

    final before = shown();
    await tester.pumpWidget(wrapWithMaterialApp(view(switchAnimation: fade)));
    await tester.pumpAndSettle();
    final withAnimation = shown();
    await tester.pumpWidget(wrapWithMaterialApp(view()));
    await tester.pumpAndSettle();

    expect((withAnimation, shown()), (before, before));
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
