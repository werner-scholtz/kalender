import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart';

import '../utilities.dart';

/// Changing [KalenderView.location] keeps the page on screen. `initialDateTime` only applies when the calendar is
/// first built.
void main() {
  tz.initializeTimeZones();
  final newYork = getLocation('America/New_York');
  final tokyo = getLocation('Asia/Tokyo');
  final displayRange = KalenderDateTimeRange(start: DateTime.utc(2026), end: DateTime.utc(2027));

  // Monday in Tokyo, Sunday in New York, so the two locations open on different weeks.
  final initialDateTime = DateTime.utc(2026, 4, 19, 20);
  final june = DateTime.utc(2026, 6, 10, 12);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
  });

  Future<void> pumpView(WidgetTester tester, ViewConfiguration config, Location location) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        location: location,
        viewConfiguration: config,
        body: const KalenderBody(),
      ),
    );
  }

  FloatingDateTime visibleStart() => kalenderController.floatingRange.value!.start;

  testWithTimeZones(
    body: (timezone, _) {
      group('Changing the location', () {
        testWidgets('keeps the page on screen when initialDateTime is set', (tester) async {
          final config = MultiDayViewConfiguration.week(displayRange: displayRange, initialDateTime: initialDateTime);
          await pumpView(tester, config, tokyo);
          final beforeSwitch = visibleStart();

          await pumpView(tester, config, newYork);

          expect(visibleStart(), beforeSwitch);
        });

        testWidgets('keeps a navigated page rather than returning to initialDateTime', (tester) async {
          final config = MultiDayViewConfiguration.week(displayRange: displayRange, initialDateTime: initialDateTime);
          await pumpView(tester, config, newYork);
          kalenderController.jumpToDate(june);
          await tester.pumpAndSettle();
          final beforeSwitch = visibleStart();

          await pumpView(tester, config, tokyo);

          expect(visibleStart(), beforeSwitch);
        });

        testWidgets('keeps a navigated page when initialDateTime is not set', (tester) async {
          final config = MultiDayViewConfiguration.week(displayRange: displayRange);
          await pumpView(tester, config, newYork);
          kalenderController.jumpToDate(june);
          await tester.pumpAndSettle();
          final beforeSwitch = visibleStart();

          await pumpView(tester, config, tokyo);

          expect(visibleStart(), beforeSwitch);
        });

        testWidgets('keeps a navigated page in the month view', (tester) async {
          final config =
              MonthViewConfiguration.singleMonth(displayRange: displayRange, initialDateTime: initialDateTime);
          await pumpView(tester, config, newYork);
          kalenderController.jumpToDate(june);
          await tester.pumpAndSettle();
          final beforeSwitch = visibleStart();

          await pumpView(tester, config, tokyo);

          expect(visibleStart(), beforeSwitch);
        });

        testWidgets('the schedule files each event under its day in the new location', (tester) async {
          // 14 January in New York, 15 January in Tokyo.
          eventsController.addEvent(
            KalenderEvent(start: DateTime.utc(2025, 1, 14, 20), end: DateTime.utc(2025, 1, 14, 21)),
          );

          final emptyDays = <int>{};
          final config = ScheduleViewConfiguration.continuous(
            displayRange: KalenderDateTimeRange(start: DateTime.utc(2025, 1, 12), end: DateTime.utc(2025, 1, 18)),
            initialDateTime: DateTime.utc(2025, 1, 14, 12),
          );
          final components = KalenderComponents(
            scheduleComponents: ScheduleComponents(
              emptyItemBuilder: (context, tileRange) {
                emptyDays.add(tileRange.start.day);
                return const SizedBox(height: 24);
              },
            ),
          );

          Future<void> pumpSchedule(Location location) {
            return pumpAndSettleWithMaterialApp(
              tester,
              KalenderView(
                eventsController: eventsController,
                kalenderController: kalenderController,
                location: location,
                components: components,
                viewConfiguration: config,
                body:
                    KalenderBody(scheduleBodyConfiguration: ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.show)),
              ),
            );
          }

          await pumpSchedule(newYork);
          expect(emptyDays, isNot(contains(14)));
          expect(emptyDays, contains(15));

          emptyDays.clear();
          await pumpSchedule(tokyo);
          expect(emptyDays, isNot(contains(15)));
          expect(emptyDays, contains(14));
        });
      });
    },
  );
}
