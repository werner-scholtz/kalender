import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/src/extensions/date_time.dart';

void main() {
  group('DateTime Internationalization Extensions', () {
    final testDate = DateTime(2024, 1, 15); // Monday, January 15, 2024

    setUpAll(() async {
      // Initialize locale data for the locales we want to test
      await initializeDateFormatting('en');
      await initializeDateFormatting('fr');
      await initializeDateFormatting('es');
    });

    test('dayNameLocalized with English locale', () {
      expect(testDate.dayNameLocalized(const Locale('en')), equals('Monday'));
    });

    test('dayNameLocalized with French locale', () {
      expect(testDate.dayNameLocalized(const Locale('fr')), equals('lundi'));
    });

    test('dayNameShortLocalized with English locale', () {
      expect(testDate.dayNameShortLocalized(const Locale('en')), equals('Mon'));
    });

    test('monthNameLocalized with English locale', () {
      expect(testDate.monthNameLocalized(const Locale('en')), equals('January'));
    });

    test('monthNameLocalized with French locale', () {
      expect(testDate.monthNameLocalized(const Locale('fr')), equals('janvier'));
    });

    test('monthNameShortLocalized with English locale', () {
      expect(testDate.monthNameShortLocalized(const Locale('en')), equals('Jan'));
    });

    test('different weekdays in different locales', () {
      final tuesday = DateTime(2024, 1, 16); // Tuesday
      expect(tuesday.dayNameLocalized(const Locale('en')), equals('Tuesday'));
      expect(tuesday.dayNameLocalized(const Locale('fr')), equals('mardi'));
      expect(tuesday.dayNameLocalized(const Locale('es')), equals('martes'));
    });

    test('different months in different locales', () {
      final february = DateTime(2024, 2, 15); // February
      expect(february.monthNameLocalized(const Locale('en')), equals('February'));
      expect(february.monthNameLocalized(const Locale('fr')), equals('février'));
      expect(february.monthNameLocalized(const Locale('es')), equals('febrero'));
    });

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
        expect(date.weekday, equals(i + 1));
        expect(date.dayNameLocalized(const Locale('en')), equals(expected[i]));
      }
    });
  });
}
