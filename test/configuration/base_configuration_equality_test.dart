import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Exercises the `==` / `hashCode` defined on the abstract [VerticalConfiguration]
/// and [HorizontalConfiguration] base classes, through concrete subclasses that
/// do not override them ([MultiDayBodyConfiguration] / [MultiDayHeaderConfiguration]).
void main() {
  // ─── VerticalConfiguration (via MultiDayBodyConfiguration) ───────────────────

  group('VerticalConfiguration equality', () {
    test('identical configurations are equal with matching hashCodes', () {
      expect(const MultiDayBodyConfiguration(), equals(const MultiDayBodyConfiguration()));
      expect(const MultiDayBodyConfiguration().hashCode, equals(const MultiDayBodyConfiguration().hashCode));
    });

    test('identical() short-circuits to true', () {
      const config = MultiDayBodyConfiguration();
      // ignore: prefer_const_constructors
      expect(config == config, isTrue);
    });

    for (final entry in <String, MultiDayBodyConfiguration>{
      'showMultiDayEvents': const MultiDayBodyConfiguration(showMultiDayEvents: true),
      'horizontalPadding': const MultiDayBodyConfiguration(horizontalPadding: EdgeInsets.all(8)),
      'minimumTileHeight': const MultiDayBodyConfiguration(minimumTileHeight: 40),
      'scrollPhysics': const MultiDayBodyConfiguration(scrollPhysics: BouncingScrollPhysics()),
      'pageScrollPhysics': const MultiDayBodyConfiguration(pageScrollPhysics: NeverScrollableScrollPhysics()),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(const MultiDayBodyConfiguration())));
      });
    }

    test('differing pageTriggerConfiguration breaks equality', () {
      final a = const MultiDayBodyConfiguration();
      final b = MultiDayBodyConfiguration(
        pageTriggerConfiguration: PageTriggerConfiguration(triggerDelay: const Duration(seconds: 2)),
      );
      expect(a, isNot(equals(b)));
    });
  });

  // ─── HorizontalConfiguration (via MultiDayHeaderConfiguration) ───────────────

  group('HorizontalConfiguration equality', () {
    test('identical configurations are equal with matching hashCodes', () {
      expect(const MultiDayHeaderConfiguration(), equals(const MultiDayHeaderConfiguration()));
      expect(const MultiDayHeaderConfiguration().hashCode, equals(const MultiDayHeaderConfiguration().hashCode));
    });

    for (final entry in <String, MultiDayHeaderConfiguration>{
      'tileHeight': const MultiDayHeaderConfiguration(tileHeight: 99),
      'showTiles': const MultiDayHeaderConfiguration(showTiles: false),
      'maximumNumberOfVerticalEvents': const MultiDayHeaderConfiguration(maximumNumberOfVerticalEvents: 3),
      'eventPadding': const MultiDayHeaderConfiguration(eventPadding: EdgeInsets.all(8)),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(const MultiDayHeaderConfiguration())));
      });
    }

    test('differing allowSingleDayEvents breaks equality', () {
      const a = MultiDayHeaderConfiguration(allowSingleDayEvents: false);
      const b = MultiDayHeaderConfiguration(allowSingleDayEvents: true);
      expect(a, isNot(equals(b)));
      expect(a.hashCode, isNot(equals(b.hashCode)));
    });
  });
}
