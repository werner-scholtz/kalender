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

    test('backwards compatibility - dayNameEnglish still works', () {
      // ignore: deprecated_member_use_from_same_package
      expect(testDate.dayNameEnglish, equals('Monday'));
    });

    test('backwards compatibility - monthNameEnglish still works', () {
      // ignore: deprecated_member_use_from_same_package
      expect(testDate.monthNameEnglish, equals('January'));
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
  });
}
