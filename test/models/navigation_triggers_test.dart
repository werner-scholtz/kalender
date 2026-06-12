import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  // ─── PageTriggerConfiguration ────────────────────────────────────────────────

  group('PageTriggerConfiguration', () {
    test('defaultConfiguration uses the documented defaults', () {
      const config = PageTriggerConfiguration.defaultConfiguration();
      expect(config.triggerDelay, equals(const Duration(milliseconds: 750)));
      expect(config.animationDuration, equals(const Duration(milliseconds: 300)));
      expect(config.animationCurve, equals(Curves.easeInOut));
    });

    test('asserts the animation duration does not exceed the trigger delay', () {
      expect(
        () => PageTriggerConfiguration(
          triggerDelay: const Duration(milliseconds: 100),
          animationDuration: const Duration(milliseconds: 200),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('allows an animation duration equal to the trigger delay', () {
      expect(
        () => PageTriggerConfiguration(
          triggerDelay: const Duration(milliseconds: 200),
          animationDuration: const Duration(milliseconds: 200),
        ),
        returnsNormally,
      );
    });

    test('copyWith replaces only the provided fields', () {
      final original = PageTriggerConfiguration(
        triggerDelay: const Duration(milliseconds: 800),
        animationDuration: const Duration(milliseconds: 250),
        animationCurve: Curves.linear,
      );
      final copy = original.copyWith(animationCurve: Curves.bounceIn);
      expect(copy.triggerDelay, equals(const Duration(milliseconds: 800)));
      expect(copy.animationDuration, equals(const Duration(milliseconds: 250)));
      expect(copy.animationCurve, equals(Curves.bounceIn));
    });

    test('equality and hashCode reflect the compared fields', () {
      final a = PageTriggerConfiguration(animationCurve: Curves.linear);
      final b = PageTriggerConfiguration(animationCurve: Curves.linear);
      final c = PageTriggerConfiguration(animationCurve: Curves.bounceIn);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
      expect(identical(a, a), isTrue);
      expect(a == a, isTrue);
    });
  });

  // ─── ScrollTriggerConfiguration ──────────────────────────────────────────────

  group('ScrollTriggerConfiguration', () {
    test('defaultConfiguration uses the documented defaults', () {
      const config = ScrollTriggerConfiguration.defaultConfiguration();
      expect(config.triggerDelay, equals(const Duration(milliseconds: 750)));
      expect(config.animationDuration, equals(const Duration(milliseconds: 200)));
      expect(config.animationCurve, equals(Curves.easeInOut));
      expect(config.triggerHeight, isNull);
      expect(config.scrollAmount, isNull);
    });

    test('asserts the animation duration does not exceed the trigger delay', () {
      expect(
        () => ScrollTriggerConfiguration(
          triggerDelay: const Duration(milliseconds: 100),
          animationDuration: const Duration(milliseconds: 200),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('copyWith replaces only the provided fields', () {
      double height(double pageHeight) => pageHeight / 4;
      final original = ScrollTriggerConfiguration(
        triggerDelay: const Duration(milliseconds: 900),
        triggerHeight: height,
      );
      final copy = original.copyWith(animationCurve: Curves.linear);
      expect(copy.triggerDelay, equals(const Duration(milliseconds: 900)));
      expect(copy.animationCurve, equals(Curves.linear));
      expect(copy.triggerHeight, same(height));
    });

    test('copyWith preserves scrollAmount when it is not overridden', () {
      double amount(double pageHeight) => pageHeight / 3;
      final original = ScrollTriggerConfiguration(scrollAmount: amount);
      // Regression: copyWith previously dropped scrollAmount, resetting it to null.
      final copy = original.copyWith(triggerDelay: const Duration(milliseconds: 800));
      expect(copy.scrollAmount, same(amount));
    });

    test('copyWith can override scrollAmount', () {
      double a(double h) => h / 3;
      double b(double h) => h / 2;
      final copy = ScrollTriggerConfiguration(scrollAmount: a).copyWith(scrollAmount: b);
      expect(copy.scrollAmount, same(b));
    });

    test('equality and hashCode reflect the compared fields', () {
      double height(double pageHeight) => pageHeight / 4;
      final a = ScrollTriggerConfiguration(triggerHeight: height);
      final b = ScrollTriggerConfiguration(triggerHeight: height);
      final c = ScrollTriggerConfiguration(animationCurve: Curves.bounceIn);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
      expect(a == a, isTrue);
    });
  });
}
