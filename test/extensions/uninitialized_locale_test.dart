import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender_extensions.dart';

/// This file must never call `initializeDateFormatting`. Locale data is global
/// to the isolate, so loading it here would make every assertion below pass for
/// the wrong reason.
void main() {
  final date = DateTime(2026, 7, 29);

  group('uninitialized locale data', () {
    test('reports the missing setup call instead of intl\'s bare exception', () {
      FlutterError? thrown;
      try {
        date.dayNameLocalized('de');
      } on FlutterError catch (error) {
        thrown = error;
      }

      expect(thrown, isNotNull, reason: 'an uninitialized locale should throw');
      final message = thrown.toString();
      expect(message, contains('initializeDateFormatting()'));
      expect(message, contains('package:intl/date_symbol_data_local.dart'));
      expect(message, contains('"de"'));
    });

    test('covers every localized name builder', () {
      expect(() => date.dayNameLocalized('fr'), throwsA(isA<FlutterError>()));
      expect(() => date.dayNameShortLocalized('fr'), throwsA(isA<FlutterError>()));
      expect(() => date.monthNameLocalized('fr'), throwsA(isA<FlutterError>()));
      expect(() => date.monthNameShortLocalized('fr'), throwsA(isA<FlutterError>()));
    });

    test('"en" needs the call even though "en_US" does not', () {
      // intl compiles in en_US only, so the bare language tag is not covered.
      expect(() => date.dayNameLocalized('en'), throwsA(isA<FlutterError>()));
      expect(date.dayNameLocalized('en_US'), 'Wednesday');
    });

    test('the default locale still works without any setup', () {
      expect(date.dayNameLocalized(), 'Wednesday');
      expect(date.monthNameLocalized(), 'July');
    });
  });
}
