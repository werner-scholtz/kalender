// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Exercises the `==` / `hashCode` defined on the abstract [VerticalConfiguration]
/// and [HorizontalConfiguration] base classes, through the concrete subclasses
/// that reach them ([MultiDayBodyConfiguration] / [MultiDayHeaderConfiguration]),
/// and the runtime type check that keeps two subclasses of one base apart.
void main() {
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
      'pageTriggerConfiguration': MultiDayBodyConfiguration(
        pageTriggerConfiguration: PageTriggerConfiguration(triggerDelay: const Duration(seconds: 2)),
      ),
      'keepPagesAlive': const MultiDayBodyConfiguration(keepPagesAlive: true),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(const MultiDayBodyConfiguration())));
        expect(entry.value.hashCode, isNot(equals(const MultiDayBodyConfiguration().hashCode)));
      });
    }
  });

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
      'allowSingleDayEvents': const MultiDayHeaderConfiguration(allowSingleDayEvents: true),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(const MultiDayHeaderConfiguration())));
        expect(entry.value.hashCode, isNot(equals(const MultiDayHeaderConfiguration().hashCode)));
      });
    }
  });

  group('Configuration types stay distinct', () {
    test('MonthBodyConfiguration is not a MultiDayHeaderConfiguration', () {
      const month = MonthBodyConfiguration();
      const header = MultiDayHeaderConfiguration();
      expect(month, isNot(equals(header)));
      expect(header, isNot(equals(month)));
    });

    test('each still equals its own type', () {
      expect(const MonthBodyConfiguration(), equals(const MonthBodyConfiguration()));
      expect(const MultiDayHeaderConfiguration(), equals(const MultiDayHeaderConfiguration()));
      expect(const MultiDayBodyConfiguration(), equals(const MultiDayBodyConfiguration()));
    });
  });
}
