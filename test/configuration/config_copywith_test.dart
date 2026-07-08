import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

// Regression net: every view-configuration copyWith must round-trip its fields
// rather than silently dropping them. A dropped field in copyWith is a silent
// no-op bug, which is what #252 turned out to be (MonthBodyConfiguration.copyWith
// dropped eventPadding). Each type gets a "preserve untouched fields" test and an
// "update the copied field" test.
void main() {
  group('view configuration copyWith round-trips', () {
    group('MonthBodyConfiguration', () {
      const config = MonthBodyConfiguration(eventPadding: EdgeInsets.all(7), tileHeight: 40);

      test('preserves eventPadding when copying another field', () {
        expect(config.copyWith(tileHeight: 30).eventPadding, const EdgeInsets.all(7));
      });

      test('updates the copied field', () {
        expect(config.copyWith(eventPadding: const EdgeInsets.all(9)).eventPadding, const EdgeInsets.all(9));
        expect(config.copyWith(tileHeight: 30).tileHeight, 30);
      });
    });

    group('MultiDayHeaderConfiguration', () {
      const config = MultiDayHeaderConfiguration(eventPadding: EdgeInsets.all(7), tileHeight: 40);

      test('preserves eventPadding when copying another field', () {
        expect(config.copyWith(tileHeight: 30).eventPadding, const EdgeInsets.all(7));
      });

      test('updates the copied field', () {
        expect(config.copyWith(eventPadding: const EdgeInsets.all(9)).eventPadding, const EdgeInsets.all(9));
        expect(config.copyWith(tileHeight: 30).tileHeight, 30);
      });
    });

    group('MultiDayBodyConfiguration', () {
      const config = MultiDayBodyConfiguration(
        horizontalPadding: EdgeInsets.all(5),
        showMultiDayEvents: false,
        minimumTileHeight: 12,
        keepPagesAlive: true,
      );

      test('preserves untouched fields when copying another', () {
        final copy = config.copyWith(pageScrollPhysics: const BouncingScrollPhysics());
        expect(copy.horizontalPadding, const EdgeInsets.all(5));
        expect(copy.showMultiDayEvents, false);
        expect(copy.minimumTileHeight, 12);
        expect(copy.keepPagesAlive, true);
      });

      test('updates the copied field', () {
        expect(config.copyWith(horizontalPadding: const EdgeInsets.all(9)).horizontalPadding, const EdgeInsets.all(9));
        expect(config.copyWith(minimumTileHeight: 30).minimumTileHeight, 30);
        expect(config.copyWith(keepPagesAlive: false).keepPagesAlive, false);
      });

      test('keepPagesAlive defaults to false', () {
        expect(const MultiDayBodyConfiguration().keepPagesAlive, false);
      });
    });

    group('ScheduleBodyConfiguration', () {
      final config = ScheduleBodyConfiguration(leadingWidth: 80, emptyDay: EmptyDayBehavior.hide);

      test('preserves untouched fields when copying another', () {
        final copy = config.copyWith(pageScrollPhysics: const BouncingScrollPhysics());
        expect(copy.leadingWidth, 80);
        expect(copy.emptyDay, EmptyDayBehavior.hide);
      });

      test('updates the copied field', () {
        expect(config.copyWith(leadingWidth: 120).leadingWidth, 120);
      });
    });

    group('MultiDayViewConfiguration.custom', () {
      final config = MultiDayViewConfiguration.custom(numberOfDays: 3, name: 'Custom 3');

      test('preserves numberOfDays when copying another field', () {
        expect(config.copyWith(name: 'Renamed').numberOfDays, 3);
      });

      test('updates numberOfDays', () {
        expect(config.copyWith(numberOfDays: 5).numberOfDays, 5);
      });
    });
  });
}
