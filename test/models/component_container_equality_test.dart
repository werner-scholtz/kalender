import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// Exercises `==` / `hashCode` on the containers reached through
/// [CalendarComponents], and the rebuild behaviour that depends on them.
void main() {
  group('CalendarComponents equality', () {
    test('containers built with the same arguments are equal', () {
      expect(const CalendarComponents(), equals(const CalendarComponents()));
      expect(const CalendarComponents().hashCode, equals(const CalendarComponents().hashCode));
    });

    test('equality reads the fields rather than the identity', () {
      // Built without const, so the comparison cannot return on identical().
      // ignore: prefer_const_constructors
      final a = CalendarComponents(monthComponents: const MonthComponents());
      // ignore: prefer_const_constructors
      final b = CalendarComponents(monthComponents: const MonthComponents());
      expect(identical(a, b), isFalse);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    for (final entry in <String, CalendarComponents>{
      'overlayBuilders': const CalendarComponents(
        overlayBuilders: OverlayBuilders(multiDayPortalOverlayButtonStringBuilder: _hiddenEventCount),
      ),
      'multiDayComponents': const CalendarComponents(
        multiDayComponents: MultiDayComponents(
          headerComponents: MultiDayHeaderComponents(dayHeaderStringBuilder: _dateLabel),
        ),
      ),
      'monthComponents': const CalendarComponents(
        monthComponents: MonthComponents(
          headerComponents: MonthHeaderComponents(weekDayHeaderStringBuilder: _dateLabel),
        ),
      ),
      'scheduleComponents': const CalendarComponents(
        scheduleComponents: ScheduleComponents(leadingDateStringBuilder: _dateLabel),
      ),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(const CalendarComponents())));
      });
    }

    test('a builder held as a top-level function stays equal across instances', () {
      const a = CalendarComponents(
        scheduleComponents: ScheduleComponents(leadingDateStringBuilder: _dateLabel),
      );
      // Built without const so this is a separate instance, which is what a
      // consumer constructing their components inside build() ends up with.
      // ignore: prefer_const_constructors
      final b = CalendarComponents(
        scheduleComponents: const ScheduleComponents(leadingDateStringBuilder: _dateLabel),
      );
      expect(a, equals(b));
    });
  });

  group('TileComponents equality', () {
    test('the default components are one canonical instance', () {
      expect(TileComponents.defaultComponents(), same(TileComponents.defaultComponents()));
    });

    test('components built with the same builders are equal', () {
      // ignore: prefer_const_constructors
      final a = TileComponents(tileBuilder: _tile);
      // ignore: prefer_const_constructors
      final b = TileComponents(tileBuilder: _tile);
      expect(identical(a, b), isFalse);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('a builder written as a closure is never equal', () {
      final a = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());
      final b = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());
      expect(a, isNot(equals(b)));
    });

    test('differing a builder breaks equality', () {
      expect(
        const TileComponents(tileBuilder: _tile, dropTargetTile: _dropTarget),
        isNot(equals(const TileComponents(tileBuilder: _tile))),
      );
    });

    test('a schedule restriction is not equal to the base with the same builder', () {
      expect(
        const ScheduleTileComponents(tileBuilder: _tile),
        isNot(equals(const TileComponents(tileBuilder: _tile))),
      );
    });
  });

  group('Components rebuilds', () {
    /// Counts how often the components actually change for a dependent.
    ///
    /// [State.didChangeDependencies] runs only when an inherited dependency
    /// reports a change, so it separates a real notification from the ordinary
    /// rebuild that follows a parent rebuilding.
    testWidgets('rebuilding the calendar does not report new components', (tester) async {
      _DependentState.notifications = 0;
      late StateSetter rebuild;

      Widget build() {
        return MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return CalendarView(
                eventsController: DefaultEventsController(),
                calendarController: CalendarController(),
                viewConfiguration: MultiDayViewConfiguration.week(),
                body: const _Dependent(),
              );
            },
          ),
        );
      }

      await tester.pumpWidget(build());
      expect(_DependentState.notifications, 1, reason: 'the first build always reads the components');

      rebuild(() {});
      await tester.pump();
      rebuild(() {});
      await tester.pump();

      expect(_DependentState.notifications, 1);
    });
  });
}

/// Reads the components and records every time they are reported as changed.
class _Dependent extends StatefulWidget {
  const _Dependent();

  @override
  State<_Dependent> createState() => _DependentState();
}

class _DependentState extends State<_Dependent> {
  static int notifications = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Components.of(context);
    notifications++;
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

String _dateLabel(BuildContext context, DateTime date) => '';

String _hiddenEventCount(BuildContext context, int numberOfHiddenEvents) => '';

Widget _tile(BuildContext context, CalendarEvent event, DateTimeRange tileRange) => const SizedBox();

Widget _dropTarget(BuildContext context, CalendarEvent event) => const SizedBox();
