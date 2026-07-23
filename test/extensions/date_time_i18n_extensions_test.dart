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
      expect(testDate.dayNameLocalized('en'), equals('Monday'));
    });

    test('dayNameLocalized with French locale', () {
      expect(testDate.dayNameLocalized('fr'), equals('lundi'));
    });

    test('dayNameShortLocalized with English locale', () {
      expect(testDate.dayNameShortLocalized('en'), equals('Mon'));
    });

    test('monthNameLocalized with English locale', () {
      expect(testDate.monthNameLocalized('en'), equals('January'));
    });

    test('monthNameLocalized with French locale', () {
      expect(testDate.monthNameLocalized('fr'), equals('janvier'));
    });

    test('monthNameShortLocalized with English locale', () {
      expect(testDate.monthNameShortLocalized('en'), equals('Jan'));
    });

    test('different weekdays in different locales', () {
      final tuesday = DateTime(2024, 1, 16); // Tuesday
      expect(tuesday.dayNameLocalized('en'), equals('Tuesday'));
      expect(tuesday.dayNameLocalized('fr'), equals('mardi'));
      expect(tuesday.dayNameLocalized('es'), equals('martes'));
    });

    test('different months in different locales', () {
      final february = DateTime(2024, 2, 15); // February
      expect(february.monthNameLocalized('en'), equals('February'));
      expect(february.monthNameLocalized('fr'), equals('février'));
      expect(february.monthNameLocalized('es'), equals('febrero'));
    });

    test('monthNameLocalized covers every month in English', () {
      const expected = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      for (var month = 1; month <= 12; month++) {
        expect(DateTime(2024, month, 15).monthNameLocalized('en'), equals(expected[month - 1]));
      }
    });

    test('dayNameLocalized covers every weekday in English', () {
      // 2024-01-15 is a Monday, so the week runs Mon..Sun over Jan 15..21.
      const expected = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      for (var i = 0; i < 7; i++) {
        final date = DateTime(2024, 1, 15 + i);
        expect(date.weekday, equals(i + 1));
        expect(date.dayNameLocalized('en'), equals(expected[i]));
      }
    });
  });
}
