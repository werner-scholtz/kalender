import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// `CalendarView` is the previous name of [KalenderView], kept as a typedef so
/// existing code keeps compiling and keeps building the same widget.
void main() {
  testWidgets('the old name builds the new widget', (tester) async {
    final eventsController = DefaultEventsController();
    final calendarController = CalendarController();
    addTearDown(() {
      eventsController.dispose();
      calendarController.dispose();
    });

    // ignore: deprecated_member_use_from_same_package
    final view = CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: year2025DisplayRange),
      body: CalendarBody(
        multiDayTileComponents: TileComponents(tileBuilder: (context, event, range) => const SizedBox()),
      ),
    );

    expect(view, isA<KalenderView>());
    await pumpAndSettleWithMaterialApp(tester, view);
    expect(find.byType(KalenderView), findsOneWidget);
  });
}
