import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Exercises `==` and `hashCode` on [ScheduleViewConfiguration] and [ScheduleBodyConfiguration].
void main() {
  final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 6));
  ScheduleViewConfiguration continuous() => ScheduleViewConfiguration.continuous(displayRange: range);

  group('ScheduleViewConfiguration equality', () {
    test('identical configurations are equal with matching hashCodes', () {
      expect(continuous(), equals(continuous()));
      expect(continuous().hashCode, equals(continuous().hashCode));
    });

    test('identical() short-circuits to true', () {
      final configuration = continuous();
      expect(configuration == configuration, isTrue);
    });

    test('the unnamed constructor equals the named constructor it matches', () {
      final unnamed = ScheduleViewConfiguration(
        name: 'Schedule (continuous)',
        viewType: ScheduleViewType.continuous,
        pageIndexCalculator: PageIndexCalculator.scheduleContinuous(range),
      );
      expect(unnamed, equals(continuous()));
      expect(unnamed.hashCode, equals(continuous().hashCode));
    });

    for (final entry in <String, ScheduleViewConfiguration>{
      'name': ScheduleViewConfiguration.continuous(name: 'Agenda', displayRange: range),
      'initialDateTime': ScheduleViewConfiguration.continuous(initialDateTime: DateTime(2025, 2), displayRange: range),
      'dateTransition':
          ScheduleViewConfiguration.continuous(dateTransition: DateTransition.restorePerView, displayRange: range),
      'nowCallback': ScheduleViewConfiguration.continuous(nowCallback: _now, displayRange: range),
      'multiDayRule':
          ScheduleViewConfiguration.continuous(multiDayRule: const MultiDayRule.calendarDays(), displayRange: range),
      'viewType': ScheduleViewConfiguration(
        name: 'Schedule (continuous)',
        viewType: ScheduleViewType.paginated,
        pageIndexCalculator: PageIndexCalculator.scheduleContinuous(range),
      ),
      'pageIndexCalculator': ScheduleViewConfiguration.continuous(
        displayRange: KalenderDateTimeRange(start: DateTime(2024), end: DateTime(2025, 6)),
      ),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(continuous())));
      });
    }

    test('dateResolver is not compared', () {
      final withResolver = ScheduleViewConfiguration.continuous(dateResolver: _resolver, displayRange: range);
      expect(withResolver, equals(continuous()));
      expect(withResolver.hashCode, equals(continuous().hashCode));
    });
  });

  group('ScheduleBodyConfiguration equality', () {
    test('default configurations are equal with matching hashCodes', () {
      expect(ScheduleBodyConfiguration(), equals(ScheduleBodyConfiguration()));
      expect(ScheduleBodyConfiguration().hashCode, equals(ScheduleBodyConfiguration().hashCode));
    });

    test('identical() short-circuits to true', () {
      final configuration = ScheduleBodyConfiguration();
      expect(configuration == configuration, isTrue);
    });

    for (final entry in <String, ScheduleBodyConfiguration>{
      'emptyDay': ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.show),
      'leadingWidth': ScheduleBodyConfiguration(leadingWidth: 80),
      'pageTriggerConfiguration': ScheduleBodyConfiguration(
        pageTriggerConfiguration: PageTriggerConfiguration(triggerDelay: const Duration(seconds: 2)),
      ),
      'scrollTriggerConfiguration': ScheduleBodyConfiguration(
        scrollTriggerConfiguration: ScrollTriggerConfiguration(triggerDelay: const Duration(seconds: 2)),
      ),
      'scrollPhysics': ScheduleBodyConfiguration(scrollPhysics: const BouncingScrollPhysics()),
      'pageScrollPhysics': ScheduleBodyConfiguration(pageScrollPhysics: const NeverScrollableScrollPhysics()),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(ScheduleBodyConfiguration())));
      });
    }
  });
}

DateTime _now() => DateTime(2025, 3, 1);

FloatingDateTime _resolver(ViewTransitionContext transition) => FloatingDateTime(2025);
