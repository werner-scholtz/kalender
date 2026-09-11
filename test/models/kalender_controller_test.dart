import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  group('KalenderController', () {
    test('every controller gets its own id', () {
      final ids = List.generate(100, (_) => KalenderController().id);
      expect(ids.toSet().length, ids.length);
    });

    test('two controllers built together do not share an id', () {
      final a = KalenderController();
      final b = KalenderController();
      expect(a.id, isNot(b.id));
    });
  });
}
