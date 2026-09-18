// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/src/extensions/date_time.dart';

void main() {
  group('DateTime Internationalization Extensions', () {
    setUpAll(() async {
      await initializeDateFormatting('en');
      await initializeDateFormatting('fr');
      await initializeDateFormatting('es');
    });

    final methods = <String, String Function(DateTime date, Locale locale)>{
      'dayNameLocalized': (date, locale) => date.dayNameLocalized(locale),
      'dayNameShortLocalized': (date, locale) => date.dayNameShortLocalized(locale),
      'monthNameLocalized': (date, locale) => date.monthNameLocalized(locale),
      'monthNameShortLocalized': (date, locale) => date.monthNameShortLocalized(locale),
    };

    for (final (method, date, locale, expected) in [
      ('dayNameLocalized', DateTime(2024, 1, 15), 'en', 'Monday'),
      ('dayNameLocalized', DateTime(2024, 1, 15), 'fr', 'lundi'),
      ('dayNameShortLocalized', DateTime(2024, 1, 15), 'en', 'Mon'),
      ('monthNameLocalized', DateTime(2024, 1, 15), 'en', 'January'),
      ('monthNameLocalized', DateTime(2024, 1, 15), 'fr', 'janvier'),
      ('monthNameShortLocalized', DateTime(2024, 1, 15), 'en', 'Jan'),
      ('dayNameLocalized', DateTime(2024, 1, 16), 'en', 'Tuesday'),
      ('dayNameLocalized', DateTime(2024, 1, 16), 'fr', 'mardi'),
      ('dayNameLocalized', DateTime(2024, 1, 16), 'es', 'martes'),
      ('monthNameLocalized', DateTime(2024, 2, 15), 'en', 'February'),
      ('monthNameLocalized', DateTime(2024, 2, 15), 'fr', 'février'),
      ('monthNameLocalized', DateTime(2024, 2, 15), 'es', 'febrero'),
    ]) {
      test('$method with $locale locale returns $expected', () {
        expect(methods[method]!(date, Locale(locale)), equals(expected));
      });
    }

    test('monthNameLocalized covers every month in English', () {
      const expected = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      for (var month = 1; month <= 12; month++) {
        expect(DateTime(2024, month, 15).monthNameLocalized(const Locale('en')), equals(expected[month - 1]));
      }
    });

    test('dayNameLocalized covers every weekday in English', () {
      // 2024-01-15 is a Monday, so the week runs Mon..Sun over Jan 15..21.
      const expected = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      for (var i = 0; i < 7; i++) {
        final date = DateTime(2024, 1, 15 + i);
        expect(date.dayNameLocalized(const Locale('en')), equals(expected[i]));
      }
    });
  });
}
